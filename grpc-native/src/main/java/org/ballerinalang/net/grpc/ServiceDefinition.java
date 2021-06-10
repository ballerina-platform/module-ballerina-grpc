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
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.TypeTags;
import io.ballerina.runtime.api.types.ErrorType;
import io.ballerina.runtime.api.types.MethodType;
import io.ballerina.runtime.api.types.NullType;
import io.ballerina.runtime.api.types.ObjectType;
import io.ballerina.runtime.api.types.RecordType;
import io.ballerina.runtime.api.types.StreamType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.types.UnionType;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import org.ballerinalang.net.grpc.exception.GrpcClientException;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import static org.ballerinalang.net.grpc.MessageUtils.isContextRecordByType;
import static org.ballerinalang.net.grpc.MessageUtils.setNestedMessages;
import static org.ballerinalang.net.grpc.MethodDescriptor.generateFullMethodName;
import static org.ballerinalang.net.grpc.ServicesBuilderUtils.getBallerinaValueType;
import static org.ballerinalang.net.grpc.ServicesBuilderUtils.hexStringToByteArray;

/**
 * This class contains proto descriptors of the service.
 *
 * @since 0.980.0
 */
public final class ServiceDefinition {

    private String rootDescriptor;
    private BMap<BString, Object> descriptorMap;
    private Descriptors.FileDescriptor fileDescriptor;

    public ServiceDefinition(String rootDescriptor, BMap<BString, Object> descriptorMap) {

        this.rootDescriptor = rootDescriptor;
        this.descriptorMap = descriptorMap;
    }

    /**
     * Returns file descriptor of the gRPC service.
     *
     * @return file descriptor of the service.
     * @throws GrpcClientException if an error occur while generating service descriptor.
     */
    public Descriptors.FileDescriptor getDescriptor() throws GrpcClientException {

        if (fileDescriptor != null) {
            return fileDescriptor;
        }
        try {
            return fileDescriptor = getFileDescriptor(rootDescriptor, descriptorMap);
        } catch (IOException | Descriptors.DescriptorValidationException e) {
            throw new GrpcClientException("Error while generating service descriptor : " + e.getMessage(), e);
        }
    }

    private Descriptors.FileDescriptor getFileDescriptor(String rootDescriptor, BMap<BString, Object> descriptorMap)
            throws InvalidProtocolBufferException, Descriptors.DescriptorValidationException, GrpcClientException {

        byte[] descriptor = hexStringToByteArray(rootDescriptor);
        if (descriptor.length == 0) {
            throw new GrpcClientException("Error while reading the service proto descriptor. input descriptor " +
                    "string is null.");
        }
        DescriptorProtos.FileDescriptorProto descriptorProto = DescriptorProtos.FileDescriptorProto.parseFrom
                (descriptor);
        if (descriptorProto == null) {
            throw new GrpcClientException("Error while reading the service proto descriptor. File proto descriptor" +
                    " is null.");
        }
        Descriptors.FileDescriptor[] fileDescriptors = new Descriptors.FileDescriptor[descriptorProto
                .getDependencyList().size()];
        int i = 0;
        for (ByteString dependency : descriptorProto.getDependencyList().asByteStringList()) {
            if (descriptorMap.containsKey(StringUtils.fromString(dependency.toStringUtf8()))) {
                BString bRootDescriptor = (BString) descriptorMap
                        .get(StringUtils.fromString(dependency.toString(StandardCharsets.UTF_8)));
                fileDescriptors[i++] =
                        getFileDescriptor(bRootDescriptor.getValue(), descriptorMap);
            }
        }
        if (fileDescriptors.length > 0 && i == 0) {
            throw new GrpcClientException("Error while reading the service proto descriptor. Couldn't find any " +
                    "dependent descriptors.");
        }
        return Descriptors.FileDescriptor.buildFrom(descriptorProto, fileDescriptors);
    }

    private Descriptors.ServiceDescriptor getServiceDescriptor(String clientTypeName) throws GrpcClientException {

        Descriptors.FileDescriptor descriptor = getDescriptor();

        if (descriptor.getFile().getServices().isEmpty()) {
            throw new GrpcClientException("No service found in proto definition file");
        }

        Descriptors.ServiceDescriptor serviceDescriptor = null;
        String serviceName = null;
        if (clientTypeName != null) {
            if (clientTypeName.endsWith("BlockingClient")) {
                serviceName = clientTypeName.substring(0, clientTypeName.length() - 14);
            } else if (clientTypeName.endsWith("Client")) {
                serviceName = clientTypeName.substring(0, clientTypeName.length() - 6);
            }
        }
        if (serviceName != null) {
            serviceDescriptor = descriptor.findServiceByName(serviceName);
        }
        if (serviceDescriptor == null) {
            if (descriptor.getFile().getServices().size() == 1) {
                serviceDescriptor = descriptor.getFile().getServices().get(0);
            } else {
                throw new GrpcClientException("Couldn't find service descriptor for client endpoint in the proto " +
                        "definition. Please check client endpoint type name with the service name in the proto " +
                        "definition.");
            }
        }
        return serviceDescriptor;
    }

    public Map<String, MethodDescriptor> getMethodDescriptors(ObjectType clientEndpointType)
            throws GrpcClientException {

        Map<String, MethodDescriptor> descriptorMap = new HashMap<>();
        Descriptors.ServiceDescriptor serviceDescriptor = getServiceDescriptor(clientEndpointType.getName());
        MethodType[] attachedFunctions = clientEndpointType.getMethods();
        for (MethodType attachedFunction : attachedFunctions) {
            String methodName = attachedFunction.getName();
            if (methodName.endsWith("Context")) {
                continue;
            }
            Descriptors.MethodDescriptor methodDescriptor = serviceDescriptor.findMethodByName(methodName);
            if (methodDescriptor == null) {
                throw new GrpcClientException("Error while initializing client stub. Couldn't find method descriptor " +
                        "for remote function: " + methodName);
            }
            Descriptors.Descriptor reqMessage = methodDescriptor.getInputType();
            Descriptors.Descriptor resMessage = methodDescriptor.getOutputType();
            MessageRegistry messageRegistry = MessageRegistry.getInstance();
            // update request message descriptors.
            messageRegistry.addMessageDescriptor(reqMessage.getName(), reqMessage);
            setNestedMessages(reqMessage, messageRegistry);
            // update response message descriptors
            messageRegistry.addMessageDescriptor(resMessage.getName(), resMessage);
            setNestedMessages(resMessage, messageRegistry);
            String fullMethodName = generateFullMethodName(serviceDescriptor.getFullName(), methodName);
            Type requestType = getInputParameterType(methodDescriptor, attachedFunction);
            Type responseType = getReturnParameterType(methodDescriptor, attachedFunction);
            if (responseType == null) {
                responseType = getStreamDataType(methodDescriptor, attachedFunction, resMessage.getName());
            }
            MethodDescriptor descriptor =
                    MethodDescriptor.newBuilder()
                            .setType(MessageUtils.getMethodType(methodDescriptor.toProto()))
                            .setFullMethodName(fullMethodName)
                            .setRequestMarshaller(ProtoUtils.marshaller(new MessageParser(reqMessage.getName(),
                                    requestType)))
                            .setResponseMarshaller(ProtoUtils.marshaller(new MessageParser(resMessage.getName(),
                                    responseType == null ?
                                            getBallerinaValueType(clientEndpointType.getPackage(),
                                                    resMessage.getName()) : responseType)))
                            .setSchemaDescriptor(methodDescriptor)
                            .build();
            descriptorMap.put(fullMethodName, descriptor);
        }
        return Collections.unmodifiableMap(descriptorMap);
    }

    private Type getStreamDataType(Descriptors.MethodDescriptor methodDescriptor, MethodType attachedFunction,
                                   String typeOfStream) {

        Type functionReturnType = attachedFunction.getType().getReturnParameterType();
        UnionType unionReturnType = (UnionType) functionReturnType;
        Type streamParameterType = unionReturnType.getMemberTypes().get(0);
        if (streamParameterType instanceof ErrorType && unionReturnType.getMemberTypes().size() > 1) {
            streamParameterType = unionReturnType.getMemberTypes().get(1);
        }

        if (methodDescriptor.isClientStreaming() && methodDescriptor.isServerStreaming()
                && streamParameterType instanceof ObjectType) {
            return getStreamDataTypeFromBidirectionalStream((ObjectType) streamParameterType);
        }

        if (streamParameterType instanceof StreamType) {
            Type streamType = ((StreamType) streamParameterType).getConstrainedType();
            if (streamType.getName().equals(typeOfStream)) {
                return streamType;
            }
        }
        return null;
    }

    private Type getStreamDataTypeFromBidirectionalStream(ObjectType streamingClient) {

        MethodType[] methodTypes = streamingClient.getMethods();
        for (MethodType methodType : methodTypes) {
            if (methodType.getName().contains(GrpcConstants.RECEIVE_ENTRY)
                    && !methodType.getName().toLowerCase(Locale.ROOT).contains(GrpcConstants.CONTEXT_ENTRY)) {

                List<Type> returnTypes = ((UnionType) methodType.getType().getReturnType()).getMemberTypes();
                for (Type returnType : returnTypes) {
                    if (!(returnType instanceof ErrorType) && !(returnType instanceof NullType)) {
                        return returnType;
                    }
                }
            }
        }
        return null;
    }

    private Type getReturnParameterType(Descriptors.MethodDescriptor methodDescriptor, MethodType attachedFunction) {

        if (methodDescriptor.isClientStreaming() || methodDescriptor.isServerStreaming()) {
            // For all streaming patterns, we can't derive the type from the function.
            return null;
        }
        Type functionReturnType = attachedFunction.getType().getReturnParameterType();
        if (functionReturnType.getTag() == TypeTags.UNION_TAG) {
            UnionType unionReturnType = (UnionType) functionReturnType;
            Type firstParamType = unionReturnType.getMemberTypes().get(0);
            if (isContextRecordByType(firstParamType)) {
                RecordType recordParamType = (RecordType) firstParamType;
                return recordParamType.getFields().get("content").getFieldType();
            }
            return firstParamType;
        }
        return null;
    }

    private Type getInputParameterType(Descriptors.MethodDescriptor methodDescriptor, MethodType attachedFunction) {

        if (methodDescriptor.isClientStreaming()) {
            // For client streaming and bidirectional streaming, we can't derive the type from the function.
            return null;
        }
        Type[] inputParams = attachedFunction.getParameterTypes();
        if (inputParams.length > 0) {
            Type inputType = inputParams[0];
            if (inputType.getTag() == TypeTags.UNION_TAG) {
                UnionType unionInputType = (UnionType) inputType;
                for (Type paramType : unionInputType.getMemberTypes()) {
                    if (!isContextRecordByType(paramType)) {
                        return paramType;
                    }
                }
            }
        }
        return PredefinedTypes.TYPE_NULL;
    }
}
