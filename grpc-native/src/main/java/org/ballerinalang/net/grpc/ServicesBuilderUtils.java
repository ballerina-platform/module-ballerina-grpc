/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package org.ballerinalang.net.grpc;

import com.google.protobuf.ByteString;
import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.Descriptors;
import com.google.protobuf.InvalidProtocolBufferException;
import io.ballerina.runtime.api.Module;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.Runtime;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.flags.TypeFlags;
import io.ballerina.runtime.api.types.MethodType;
import io.ballerina.runtime.api.types.RecordType;
import io.ballerina.runtime.api.types.StreamType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import org.ballerinalang.net.grpc.exception.GrpcServerException;
import org.ballerinalang.net.grpc.listener.ServerCallHandler;
import org.ballerinalang.net.grpc.listener.StreamingServerCallHandler;
import org.ballerinalang.net.grpc.listener.UnaryServerCallHandler;

import java.io.IOException;

import static org.ballerinalang.net.grpc.GrpcConstants.EMPTY_DATATYPE_NAME;
import static org.ballerinalang.net.grpc.GrpcConstants.PROTOCOL_PACKAGE_GRPC;
import static org.ballerinalang.net.grpc.GrpcConstants.WRAPPER_BOOL_MESSAGE;
import static org.ballerinalang.net.grpc.GrpcConstants.WRAPPER_BYTES_MESSAGE;
import static org.ballerinalang.net.grpc.GrpcConstants.WRAPPER_DOUBLE_MESSAGE;
import static org.ballerinalang.net.grpc.GrpcConstants.WRAPPER_FLOAT_MESSAGE;
import static org.ballerinalang.net.grpc.GrpcConstants.WRAPPER_INT32_MESSAGE;
import static org.ballerinalang.net.grpc.GrpcConstants.WRAPPER_INT64_MESSAGE;
import static org.ballerinalang.net.grpc.GrpcConstants.WRAPPER_STRING_MESSAGE;
import static org.ballerinalang.net.grpc.GrpcConstants.WRAPPER_UINT32_MESSAGE;
import static org.ballerinalang.net.grpc.GrpcConstants.WRAPPER_UINT64_MESSAGE;
import static org.ballerinalang.net.grpc.MessageUtils.setNestedMessages;

/**
 * This is the gRPC server implementation for registering service and start/stop server.
 *
 * @since 0.980.0
 */
public class ServicesBuilderUtils {

    public static ServerServiceDefinition getServiceDefinition(Runtime runtime, BObject service, Object servicePath,
                                                               Object annotationData) throws GrpcServerException {

        Descriptors.FileDescriptor fileDescriptor = getDescriptor(annotationData);
        if (fileDescriptor == null) {
            fileDescriptor = getDescriptorFromService(service);
        }
        if (fileDescriptor == null) {
            throw new GrpcServerException("Couldn't find the service descriptor.");
        }
        String serviceName = getServiceName(servicePath);
        Descriptors.ServiceDescriptor serviceDescriptor = fileDescriptor.findServiceByName(serviceName);
        if (serviceDescriptor == null) {
            throw new GrpcServerException("Couldn't find the service descriptor for the service: " + serviceName);
        }
        return getServiceDefinition(runtime, service, serviceDescriptor);
    }

    private static String getServiceName(Object servicePath) throws GrpcServerException {

        String serviceName;
        if (servicePath == null) {
            throw new GrpcServerException("Invalid service path. Service path cannot be nil");
        }
        if (servicePath instanceof BArray) {
            BArray servicePathArray = (BArray) servicePath;
            if (servicePathArray.getLength() == 1) {
                serviceName = ((BString) servicePathArray.get(0)).getValue();
            } else {
                throw new GrpcServerException("Invalid service path. Service path should not be hierarchical path");
            }
        } else if (servicePath instanceof BString) {
            serviceName = ((BString) servicePath).getValue();
        } else {
            throw new GrpcServerException("Invalid service path. Couldn't derive the service path");
        }
        return serviceName;
    }

    private static ServerServiceDefinition getServiceDefinition(Runtime runtime, BObject service,
                                                                Descriptors.ServiceDescriptor serviceDescriptor)
            throws GrpcServerException {
        // Get full service name for the service definition. <package>.<service>
        final String serviceName = serviceDescriptor.getFullName();
        // Server Definition Builder for the service.
        ServerServiceDefinition.Builder serviceDefBuilder = ServerServiceDefinition.builder(serviceName);

        for (Descriptors.MethodDescriptor methodDescriptor : serviceDescriptor.getMethods()) {
            final String methodName = serviceName + "/" + methodDescriptor.getName();
            Descriptors.Descriptor requestDescriptor = methodDescriptor.getInputType();
            Descriptors.Descriptor responseDescriptor = methodDescriptor.getOutputType();
            MessageRegistry messageRegistry = MessageRegistry.getInstance();
            // update request message descriptors.
            messageRegistry.addMessageDescriptor(requestDescriptor.getName(), requestDescriptor);
            setNestedMessages(requestDescriptor, messageRegistry);
            // update response message descriptors.
            messageRegistry.addMessageDescriptor(responseDescriptor.getName(), responseDescriptor);
            setNestedMessages(responseDescriptor, messageRegistry);

            MethodDescriptor.MethodType methodType;
            ServerCallHandler serverCallHandler;
            MethodDescriptor.Marshaller reqMarshaller = null;
            ServiceResource mappedResource = null;

            for (MethodType function : service.getType().getMethods()) {
                if (methodDescriptor.getName().equals(function.getName())) {
                    mappedResource = new ServiceResource(runtime, service, serviceDescriptor.getName(), function,
                            methodDescriptor);
                    reqMarshaller = ProtoUtils.marshaller(new MessageParser(requestDescriptor.getName(),
                            getRemoteInputParameterType(function)));
                }
            }
            if (methodDescriptor.toProto().getServerStreaming() && methodDescriptor.toProto().getClientStreaming()) {
                methodType = MethodDescriptor.MethodType.BIDI_STREAMING;
                serverCallHandler = new StreamingServerCallHandler(methodDescriptor, mappedResource,
                        getBallerinaValueType(service.getType().getPackage(), requestDescriptor.getName()));
            } else if (methodDescriptor.toProto().getClientStreaming()) {
                methodType = MethodDescriptor.MethodType.CLIENT_STREAMING;
                serverCallHandler = new StreamingServerCallHandler(methodDescriptor, mappedResource,
                        getBallerinaValueType(service.getType().getPackage(), requestDescriptor.getName()));
            } else if (methodDescriptor.toProto().getServerStreaming()) {
                methodType = MethodDescriptor.MethodType.SERVER_STREAMING;
                serverCallHandler = new UnaryServerCallHandler(methodDescriptor, mappedResource);
            } else {
                methodType = MethodDescriptor.MethodType.UNARY;
                serverCallHandler = new UnaryServerCallHandler(methodDescriptor, mappedResource);
            }
            if (reqMarshaller == null) {
                reqMarshaller = ProtoUtils.marshaller(new MessageParser(requestDescriptor
                        .getName(), getBallerinaValueType(service.getType().getPackage(),
                        requestDescriptor.getName())));
            }
            MethodDescriptor.Marshaller resMarshaller = ProtoUtils.marshaller(new MessageParser(responseDescriptor
                    .getName(), getBallerinaValueType(service.getType().getPackage(), responseDescriptor.getName())));
            MethodDescriptor.Builder methodBuilder = MethodDescriptor.newBuilder();
            MethodDescriptor grpcMethodDescriptor = methodBuilder.setType(methodType)
                    .setFullMethodName(methodName)
                    .setRequestMarshaller(reqMarshaller)
                    .setResponseMarshaller(resMarshaller)
                    .setSchemaDescriptor(methodDescriptor).build();
            serviceDefBuilder.addMethod(grpcMethodDescriptor, serverCallHandler);
        }
        return serviceDefBuilder.build();
    }

    private ServicesBuilderUtils() {

    }

    /**
     * Returns file descriptor for the service.
     * Reads file descriptor from internal annotation attached to the service at compile time.
     *
     * @param annotationData gRPC service annotation.
     * @return File Descriptor of the service.
     * @throws GrpcServerException cannot read service descriptor
     */
    @SuppressWarnings("unchecked")
    private static com.google.protobuf.Descriptors.FileDescriptor getDescriptor(Object annotationData)
            throws GrpcServerException {

        if (annotationData == null) {
            return null;
        }

        try {
            BMap<BString, Object> annotationMap = (BMap) annotationData;
            BString descriptorData = annotationMap.getStringValue(StringUtils.fromString("descriptor"));
            BMap<BString, BString> descMap = (BMap<BString, BString>) annotationMap.getMapValue(
                    StringUtils.fromString("descMap"));
            return getFileDescriptor(descriptorData, descMap);
        } catch (IOException | Descriptors.DescriptorValidationException e) {
            throw new GrpcServerException("Error while reading the service proto descriptor. check the service " +
                    "implementation. ", e);
        }
    }

    private static com.google.protobuf.Descriptors.FileDescriptor getDescriptorFromService(BObject service)
            throws GrpcServerException {
        try {
            BString descriptorData = null;
            if (service.getType().getFields().containsKey("descriptor")) {
                descriptorData = service.getStringValue(StringUtils.fromString("descriptor"));
            }
            BMap<BString, BString> descMap = null;
            if (service.getType().getFields().containsKey("descMap")) {
                descMap = (BMap<BString, BString>) service.getMapValue(
                        StringUtils.fromString("descMap"));
            }
            if (descriptorData == null || descMap == null) {
                return null;
            }
            return getFileDescriptor(descriptorData, descMap);
        } catch (IOException | Descriptors.DescriptorValidationException e) {
            throw new GrpcServerException("Error while reading the service proto descriptor. check the service " +
                    "implementation. ", e);
        }

    }

    private static Descriptors.FileDescriptor getFileDescriptor(
            BString descriptorData, BMap<BString, BString> descMap)
            throws InvalidProtocolBufferException, Descriptors.DescriptorValidationException, GrpcServerException {

        byte[] descriptor = hexStringToByteArray(descriptorData.getValue());
        if (descriptor.length == 0) {
            throw new GrpcServerException("Error while reading the service proto descriptor. input descriptor string " +
                    "is null.");
        }
        DescriptorProtos.FileDescriptorProto descriptorProto = DescriptorProtos.FileDescriptorProto.parseFrom
                (descriptor);
        if (descriptorProto == null) {
            throw new GrpcServerException("Error while reading the service proto descriptor. File proto descriptor is" +
                    " null.");
        }
        Descriptors.FileDescriptor[] fileDescriptors = new Descriptors.FileDescriptor[descriptorProto
                .getDependencyList().size()];
        int i = 0;
        for (ByteString dependency : descriptorProto.getDependencyList().asByteStringList()) {
            String dependencyKey = dependency.toStringUtf8();
            if (descMap.containsKey(StringUtils.fromString(dependencyKey))) {
                fileDescriptors[i++] = getFileDescriptor(descMap.get(StringUtils.fromString(dependencyKey)), descMap);
            } else if (descMap.size() == 0) {
                Descriptors.FileDescriptor dependentDescriptor = StandardDescriptorBuilder.getFileDescriptor
                        (dependencyKey);
                if (dependentDescriptor != null) {
                    fileDescriptors[i++] = dependentDescriptor;
                }
            }
        }
        if (fileDescriptors.length > 0 && i == 0) {
            throw new GrpcServerException("Error while reading the service proto descriptor. Couldn't find any " +
                    "dependent descriptors.");
        }
        return Descriptors.FileDescriptor.buildFrom(descriptorProto, fileDescriptors);
    }

    /**
     * Convert Hex string value to byte array.
     *
     * @param sDescriptor hexadecimal string value
     * @return Byte array
     */
    static byte[] hexStringToByteArray(String sDescriptor) {

        if (sDescriptor == null) {
            return new byte[0];
        }
        int len = sDescriptor.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(sDescriptor.charAt(i), 16) << 4)
                    + Character.digit(sDescriptor.charAt(i + 1), 16));
        }
        return data;
    }

    /**
     * Returns corresponding Ballerina type for the proto buffer type.
     *
     * @param protoType Protocol buffer type
     * @return Mapping BType of the proto type.
     */
    static Type getBallerinaValueType(Module module, String protoType) {

        if (protoType.equalsIgnoreCase(WRAPPER_DOUBLE_MESSAGE) || protoType
                .equalsIgnoreCase(WRAPPER_FLOAT_MESSAGE)) {
            return PredefinedTypes.TYPE_FLOAT;
        } else if (protoType.equalsIgnoreCase(WRAPPER_INT32_MESSAGE) || protoType
                .equalsIgnoreCase(WRAPPER_INT64_MESSAGE) || protoType
                .equalsIgnoreCase(WRAPPER_UINT32_MESSAGE) || protoType
                .equalsIgnoreCase(WRAPPER_UINT64_MESSAGE)) {
            return PredefinedTypes.TYPE_INT;
        } else if (protoType.equalsIgnoreCase(WRAPPER_BOOL_MESSAGE)) {
            return PredefinedTypes.TYPE_BOOLEAN;
        } else if (protoType.equalsIgnoreCase(WRAPPER_STRING_MESSAGE)) {
            return PredefinedTypes.TYPE_STRING;
        } else if (protoType.equalsIgnoreCase(EMPTY_DATATYPE_NAME)) {
            return PredefinedTypes.TYPE_NULL;
        } else if (protoType.equalsIgnoreCase(WRAPPER_BYTES_MESSAGE)) {
            return TypeCreator.createArrayType(PredefinedTypes.TYPE_BYTE);
        } else {
            return TypeCreator.createRecordType(protoType, module, 0, true,
                    TypeFlags.asMask(TypeFlags.ANYDATA, TypeFlags.PURETYPE));
        }
    }

    private static Type getRemoteInputParameterType(MethodType attachedFunction) {

        Type[] inputParams = attachedFunction.getType().getParameterTypes();
        Type inputType;

        // length == 1 when remote function returns a value HelloWorld100ResponseCaller
        // length == 2 when remote function uses a caller
        if (inputParams.length == 1) {
            inputType = inputParams[0];
        } else if (inputParams.length >= 2) {
            inputType = inputParams[1];
        } else {
            return PredefinedTypes.TYPE_NULL;
        }

        if (inputType != null && "Headers".equals(inputType.getName()) &&
                inputType.getPackage() != null && PROTOCOL_PACKAGE_GRPC.equals(inputType.getPackage().getName())) {
            return PredefinedTypes.TYPE_NULL;
        } else if (inputType instanceof StreamType) {
            return ((StreamType) inputType).getConstrainedType();
        } else if (inputType instanceof RecordType && inputType.getName().startsWith("Context") &&
                ((RecordType) inputType).getFields().size() == 2) {
            Type contentType = ((RecordType) inputType).getFields().get("content").getFieldType();

            if (contentType instanceof StreamType) {
                return ((StreamType) contentType).getConstrainedType();
            }
            return contentType;
        } else {
            return inputType;
        }
    }

}
