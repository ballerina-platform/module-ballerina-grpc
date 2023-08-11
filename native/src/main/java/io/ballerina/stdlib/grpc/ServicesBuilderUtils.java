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
package io.ballerina.stdlib.grpc;

import com.google.protobuf.ByteString;
import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.Descriptors;
import com.google.protobuf.InvalidProtocolBufferException;
import io.ballerina.runtime.api.Module;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.Runtime;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.MethodType;
import io.ballerina.runtime.api.types.NullType;
import io.ballerina.runtime.api.types.ObjectType;
import io.ballerina.runtime.api.types.Parameter;
import io.ballerina.runtime.api.types.RecordType;
import io.ballerina.runtime.api.types.StreamType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.types.UnionType;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BValue;
import io.ballerina.stdlib.grpc.exception.GrpcServerException;
import io.ballerina.stdlib.grpc.listener.ServerCallHandler;
import io.ballerina.stdlib.grpc.listener.StreamingServerCallHandler;
import io.ballerina.stdlib.grpc.listener.UnaryServerCallHandler;
import io.ballerina.stdlib.protobuf.nativeimpl.ProtoTypesUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

import static io.ballerina.stdlib.grpc.GrpcConstants.ANN_PROTOBUF_DESCRIPTOR;
import static io.ballerina.stdlib.grpc.GrpcConstants.ANY_MESSAGE;
import static io.ballerina.stdlib.grpc.GrpcConstants.CONTENT_FIELD;
import static io.ballerina.stdlib.grpc.GrpcConstants.DURATION_MESSAGE;
import static io.ballerina.stdlib.grpc.GrpcConstants.EMPTY_DATATYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.HEADERS;
import static io.ballerina.stdlib.grpc.GrpcConstants.PROTOCOL_PACKAGE_GRPC;
import static io.ballerina.stdlib.grpc.GrpcConstants.STRUCT_MESSAGE;
import static io.ballerina.stdlib.grpc.GrpcConstants.TIMESTAMP_MESSAGE;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_BOOL_MESSAGE;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_BYTES_MESSAGE;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_DOUBLE_MESSAGE;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_FLOAT_MESSAGE;

/**
 * This is the gRPC server implementation for registering service and start/stop server.
 *
 * @since 0.980.0
 */
public class ServicesBuilderUtils {

    public static HashMap<String, Descriptors.FileDescriptor> fileDescriptorHashMapBySymbol = new HashMap<>();
    public static HashMap<String, Descriptors.FileDescriptor> fileDescriptorHashMapByFilename = new HashMap<>();

    public static ServerServiceDefinition getServiceDefinition(Runtime runtime, BObject service, Object servicePath,
                                                               Object annotationData) throws GrpcServerException {

        Descriptors.FileDescriptor fileDescriptor = getDescriptor(annotationData);
        MessageRegistry.getInstance().setFileDescriptor(fileDescriptor);
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
        fileDescriptorHashMapBySymbol.put(serviceName, serviceDescriptor.getFile());
        // Server Definition Builder for the service.
        ServerServiceDefinition.Builder serviceDefBuilder = ServerServiceDefinition.builder(serviceName);

        for (Descriptors.MethodDescriptor methodDescriptor : serviceDescriptor.getMethods()) {
            fileDescriptorHashMapBySymbol.put(methodDescriptor.getFullName(), serviceDescriptor.getFile());
            final String methodName = serviceName + "/" + methodDescriptor.getName();
            Descriptors.Descriptor requestDescriptor = methodDescriptor.getInputType();
            Descriptors.Descriptor responseDescriptor = methodDescriptor.getOutputType();
            MessageRegistry messageRegistry = MessageRegistry.getInstance();
            // update request message descriptors.
            messageRegistry.addMessageDescriptor(requestDescriptor.getFullName(), requestDescriptor);
            MessageUtils.setNestedMessages(requestDescriptor, messageRegistry);
            // update response message descriptors.
            messageRegistry.addMessageDescriptor(responseDescriptor.getFullName(), responseDescriptor);
            MessageUtils.setNestedMessages(responseDescriptor, messageRegistry);

            MethodDescriptor.MethodType methodType;
            ServerCallHandler serverCallHandler;
            MethodDescriptor.Marshaller reqMarshaller = null;
            ServiceResource mappedResource = null;
            Module inputParameterPackage = TypeUtils.getType(service).getPackage();
            ObjectType serviceType = (ObjectType) TypeUtils.getReferredType(TypeUtils.getType(service));

            for (MethodType function : serviceType.getMethods()) {
                if (methodDescriptor.getName().equals(function.getName())) {
                    Type inputParameterType = getRemoteInputParameterType(function);
                    if (inputParameterType instanceof RecordType) {
                        Object annotation = ((RecordType) inputParameterType).getAnnotation(ANN_PROTOBUF_DESCRIPTOR);
                        if (annotation != null) {
                            Descriptors.FileDescriptor fileDescriptor = getDescriptor(annotation);
                            fileDescriptorHashMapByFilename.put(fileDescriptor.getFullName(), fileDescriptor);
                            fileDescriptorHashMapBySymbol.put(fileDescriptor.findMessageTypeByName(inputParameterType
                                    .getName()).getFullName(), fileDescriptor);
                        }
                    }
                    mappedResource = new ServiceResource(runtime, service, serviceDescriptor.getName(), function,
                            methodDescriptor);
                    reqMarshaller = ProtoUtils.marshaller(new MessageParser(requestDescriptor.getFullName(),
                            inputParameterType));
                    inputParameterPackage = inputParameterType.getPackage();
                    break;
                }
            }
            if (methodDescriptor.toProto().getServerStreaming() && methodDescriptor.toProto().getClientStreaming()) {
                methodType = MethodDescriptor.MethodType.BIDI_STREAMING;
                serverCallHandler = new StreamingServerCallHandler(methodDescriptor, mappedResource,
                        getBallerinaValueType(inputParameterPackage, requestDescriptor.getName()));
            } else if (methodDescriptor.toProto().getClientStreaming()) {
                methodType = MethodDescriptor.MethodType.CLIENT_STREAMING;
                serverCallHandler = new StreamingServerCallHandler(methodDescriptor, mappedResource,
                        getBallerinaValueType(inputParameterPackage, requestDescriptor.getName()));
            } else if (methodDescriptor.toProto().getServerStreaming()) {
                methodType = MethodDescriptor.MethodType.SERVER_STREAMING;
                serverCallHandler = new UnaryServerCallHandler(methodDescriptor, mappedResource);
            } else {
                methodType = MethodDescriptor.MethodType.UNARY;
                serverCallHandler = new UnaryServerCallHandler(methodDescriptor, mappedResource);
            }
            if (reqMarshaller == null) {
                reqMarshaller = ProtoUtils.marshaller(new MessageParser(requestDescriptor
                        .getFullName(), getBallerinaValueType(TypeUtils.getType(service).getPackage(),
                        requestDescriptor.getName())));
            }

            MethodDescriptor.Marshaller resMarshaller = ProtoUtils.marshaller(
                    new MessageParser(responseDescriptor.getFullName(), getBallerinaValueType(
                    getOutputPackage(service, methodDescriptor.getName()), responseDescriptor.getName())));
            Type valueType = getBallerinaValueType(getOutputPackage(service, methodDescriptor.getName()),
                    responseDescriptor.getName());
            if (valueType instanceof RecordType) {
                Object annotation = ((RecordType) valueType).getAnnotation(ANN_PROTOBUF_DESCRIPTOR);
                if (annotation != null) {
                    Descriptors.FileDescriptor fileDescriptor = getDescriptor(annotation);
                    fileDescriptorHashMapByFilename.put(fileDescriptor.getFullName(), fileDescriptor);
                    fileDescriptorHashMapBySymbol.put(fileDescriptor.findMessageTypeByName(valueType.getName())
                            .getFullName(), fileDescriptor);
                }
            }
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
            BString descriptorData = annotationMap.getStringValue(StringUtils.fromString("value"));
            if (descriptorData == null) {
                descriptorData = annotationMap.getStringValue(StringUtils.fromString("descriptor"));
            }
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
            ObjectType type = (ObjectType) TypeUtils.getReferredType(((BValue) service).getType());
            if (type.getFields().containsKey("descriptor")) {
                descriptorData = service.getStringValue(StringUtils.fromString("descriptor"));
            } else if (type.getFields().containsKey("value")) {
                descriptorData = service.getStringValue(StringUtils.fromString("value"));
            }
            BMap<BString, BString> descMap = null;
            if (type.getFields().containsKey("descMap")) {
                descMap = (BMap<BString, BString>) service.getMapValue(StringUtils.fromString("descMap"));
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
        List<Descriptors.FileDescriptor> fileDescriptors = new ArrayList<>();
        for (ByteString dependency : descriptorProto.getDependencyList().asByteStringList()) {
            String dependencyKey = dependency.toStringUtf8();
            if (descMap == null || descMap.size() == 0) {
                Descriptors.FileDescriptor dependentDescriptor = StandardDescriptorBuilder.getFileDescriptor
                        (dependencyKey);
                if (dependentDescriptor != null) {
                    fileDescriptors.add(dependentDescriptor);
                }
            } else if (descMap.containsKey(StringUtils.fromString(dependencyKey))) {
                fileDescriptors.add(getFileDescriptor(descMap.get(StringUtils.fromString(dependencyKey)), descMap));
            }
        }
        return Descriptors.FileDescriptor.buildFrom(descriptorProto,
                fileDescriptors.toArray(Descriptors.FileDescriptor[]::new), true);
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
     * Retrieve the module (or submodule) of the input type.
     *
     * @param service service definition
     * @param remoteFunctionName name of the relevant remote function
     * @return module of the input type
     */
    static Module getInputPackage(BObject service, String remoteFunctionName) {

        ObjectType serviceType = (ObjectType) TypeUtils.getReferredType(TypeUtils.getType(service));
        Optional<MethodType> remoteCallType = Arrays.stream(serviceType.getMethods())
                .filter(methodType -> methodType.getName().equals(remoteFunctionName)).findFirst();

        if (remoteCallType.isPresent()) {
            Parameter[] parameters = remoteCallType.get().getParameters();
            int noOfParams = parameters.length;
            if (noOfParams > 0) {
                Type inputType = TypeUtils.getReferredType(parameters[noOfParams - 1].type);
                if (inputType instanceof StreamType) {
                    return ((StreamType) inputType).getConstrainedType().getPackage();
                } else {
                    return inputType.getPackage();
                }
            }
        }
        return serviceType.getPackage();
    }

    /**
     * Retrieve the module (or submodule) of the output type.
     *
     * @param service service definition
     * @param remoteFunctionName name of the relevant remote function
     * @return module of the output type
     */
    static Module getOutputPackage(BObject service, String remoteFunctionName) {

        ObjectType serviceType = (ObjectType) TypeUtils.getReferredType(TypeUtils.getType(service));
        Optional<MethodType> remoteCallType = Arrays.stream(serviceType.getMethods())
                .filter(methodType -> methodType.getName().equals(remoteFunctionName)).findFirst();

        if (remoteCallType.isPresent()) {
            Type returnType = remoteCallType.get().getType().getReturnType();
            if (returnType instanceof UnionType) {
                UnionType returnTypeAsUnion = (UnionType) returnType;
                Optional<Type> returnDataType = returnTypeAsUnion.getOriginalMemberTypes().stream()
                        .filter(type -> isStreamOrRecordType(type)).findFirst();
                if (returnDataType.isPresent()) {
                    Type outputType = TypeUtils.getReferredType(returnDataType.get());
                    if (outputType instanceof StreamType) {
                        return ((StreamType) outputType).getConstrainedType().getPackage();
                    } else {
                        return outputType.getPackage();
                    }
                }
            } else if (returnType != null && !(returnType instanceof NullType) && returnType.getPackage() != null) {
                return returnType.getPackage();
            }
        }
        return serviceType.getPackage();
    }

    private static boolean isStreamOrRecordType(Type type) {
        Type referredType = TypeUtils.getReferredType(type);
        return referredType instanceof RecordType || referredType instanceof StreamType;
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
        } else if (protoType.equalsIgnoreCase(GrpcConstants.WRAPPER_INT32_MESSAGE) || protoType
                .equalsIgnoreCase(GrpcConstants.WRAPPER_INT64_MESSAGE) || protoType
                .equalsIgnoreCase(GrpcConstants.WRAPPER_UINT32_MESSAGE) || protoType
                .equalsIgnoreCase(GrpcConstants.WRAPPER_UINT64_MESSAGE)) {
            return PredefinedTypes.TYPE_INT;
        } else if (protoType.equalsIgnoreCase(WRAPPER_BOOL_MESSAGE)) {
            return PredefinedTypes.TYPE_BOOLEAN;
        } else if (protoType.equalsIgnoreCase(GrpcConstants.WRAPPER_STRING_MESSAGE)) {
            return PredefinedTypes.TYPE_STRING;
        } else if (protoType.equalsIgnoreCase(EMPTY_DATATYPE_NAME)) {
            return PredefinedTypes.TYPE_NULL;
        } else if (protoType.equalsIgnoreCase(WRAPPER_BYTES_MESSAGE)) {
            return TypeCreator.createArrayType(PredefinedTypes.TYPE_BYTE);
        } else if (protoType.equals(TIMESTAMP_MESSAGE)) {
            Type tupleType = TypeCreator.createTupleType(Arrays.asList(PredefinedTypes.TYPE_INT,
                    PredefinedTypes.TYPE_DECIMAL));
            return tupleType;
        } else if (protoType.equals(DURATION_MESSAGE)) {
            return PredefinedTypes.TYPE_DECIMAL;
        } else if (protoType.equals(STRUCT_MESSAGE)) {
            return PredefinedTypes.TYPE_MAP;
        } else if (protoType.equals(ANY_MESSAGE)) {
            return ValueCreator.createRecordValue(ProtoTypesUtils.getProtoTypesAnyModule(), "Any")
            .getType();
        } else {
            return ValueCreator.createRecordValue(module, protoType).getType();
        }
    }

    private static Type getRemoteInputParameterType(MethodType attachedFunction) {

        Type[] inputParams = getParameterTypesFromParameters(attachedFunction.getType().getParameters());
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

        if (inputType != null && HEADERS.equals(inputType.getName()) &&
                inputType.getPackage() != null && PROTOCOL_PACKAGE_GRPC.equals(inputType.getPackage().getName())) {
            return PredefinedTypes.TYPE_NULL;
        } else if (inputType instanceof StreamType) {
            return ((StreamType) inputType).getConstrainedType();
        } else if (inputType instanceof RecordType && inputType.getName().startsWith("Context") &&
                ((RecordType) inputType).getFields().size() == 2) {
            Type contentType =
                    TypeUtils.getReferredType(((RecordType) inputType).getFields().get(CONTENT_FIELD).getFieldType());
            if (contentType instanceof StreamType) {
                return ((StreamType) contentType).getConstrainedType();
            }
            return contentType;
        } else {
            return inputType;
        }
    }

    static Type[] getParameterTypesFromParameters(Parameter[] parameters) {
        Type[] paramTypes = new Type[parameters.length];
        for (int i = 0; i < parameters.length; i++) {
            paramTypes[i] = TypeUtils.getReferredType(parameters[i].type);
        }
        return paramTypes;
    }
}
