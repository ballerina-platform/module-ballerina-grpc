/*
 *  Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package io.ballerina.stdlib.grpc.nativeimpl.client;

import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.types.ObjectType;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.stdlib.grpc.DataContext;
import io.ballerina.stdlib.grpc.Message;
import io.ballerina.stdlib.grpc.MessageRegistry;
import io.ballerina.stdlib.grpc.MessageUtils;
import io.ballerina.stdlib.grpc.MethodDescriptor;
import io.ballerina.stdlib.grpc.ServiceDefinition;
import io.ballerina.stdlib.grpc.Status;
import io.ballerina.stdlib.grpc.exception.GrpcClientException;
import io.ballerina.stdlib.grpc.exception.StatusRuntimeException;
import io.ballerina.stdlib.grpc.stubs.Stub;
import io.ballerina.stdlib.http.api.HttpConnectionManager;
import io.ballerina.stdlib.http.api.HttpConstants;
import io.ballerina.stdlib.http.api.HttpUtil;
import io.ballerina.stdlib.http.transport.contract.Constants;
import io.ballerina.stdlib.http.transport.contract.HttpClientConnector;
import io.ballerina.stdlib.http.transport.contract.config.SenderConfiguration;
import io.ballerina.stdlib.http.transport.contractimpl.sender.channel.pool.ConnectionManager;
import io.ballerina.stdlib.http.transport.contractimpl.sender.channel.pool.PoolConfiguration;
import io.ballerina.stdlib.http.transport.message.HttpConnectorUtil;
import io.netty.handler.codec.http.HttpHeaders;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import static io.ballerina.stdlib.grpc.GrpcConstants.CLIENT_CONNECTOR;
import static io.ballerina.stdlib.grpc.GrpcConstants.CONFIG;
import static io.ballerina.stdlib.grpc.GrpcConstants.ENDPOINT_URL;
import static io.ballerina.stdlib.grpc.GrpcConstants.MAX_INBOUND_MESSAGE_SIZE;
import static io.ballerina.stdlib.grpc.GrpcConstants.METHOD_DESCRIPTORS;
import static io.ballerina.stdlib.grpc.GrpcConstants.SERVICE_STUB;
import static io.ballerina.stdlib.grpc.GrpcUtil.getConnectionManager;
import static io.ballerina.stdlib.grpc.GrpcUtil.populatePoolingConfig;
import static io.ballerina.stdlib.grpc.GrpcUtil.populateSenderConfigurations;
import static io.ballerina.stdlib.grpc.MessageUtils.convertToHttpHeaders;
import static io.ballerina.stdlib.grpc.Status.Code.INTERNAL;
import static io.ballerina.stdlib.http.api.HttpConstants.CONNECTION_MANAGER;

/**
 * Utility methods represents actions for the client.
 *
 * @since 1.0.0
 */
public class FunctionUtils extends AbstractExecute {

    private FunctionUtils() {
    }

    /**
     * Extern function to initialize global connection pool.
     *
     * @param endpointObject   client endpoint instance.
     * @param globalPoolConfig global pool configuration.
     */
    public static void externInitGlobalPool(BObject endpointObject, BMap<BString, Long> globalPoolConfig) {

        PoolConfiguration globalPool = new PoolConfiguration();
        populatePoolingConfig(globalPoolConfig, globalPool);
        ConnectionManager connectionManager = new ConnectionManager(globalPool);
        globalPoolConfig.addNativeData(CONNECTION_MANAGER, connectionManager);
    }

    /**
     * Extern function to initialize client endpoint.
     *
     * @param clientEndpoint       client endpoint instance.
     * @param urlString            service Url.
     * @param clientEndpointConfig endpoint configuration.
     * @param globalPoolConfig     global pool configuration.
     * @return Error if there is an error while initializing the client endpoint, else returns nil
     */
    @SuppressWarnings("unchecked")
    public static Object externInit(BObject clientEndpoint, BString urlString,
                                    BMap clientEndpointConfig, BMap globalPoolConfig, BString optionsString) {

        HttpConnectionManager connectionManager = HttpConnectionManager.getInstance();
        URL url;
        try {
            url = new URL(urlString.getValue());
        } catch (MalformedURLException e) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Malformed URL: "
                            + urlString.getValue())));
        }

        String scheme = url.getProtocol();
        Map<String, Object> properties =
                HttpConnectorUtil.getTransportProperties(connectionManager.getTransportConfig());
        properties.put(HttpConstants.CLIENT_CONFIG_HASH_CODE, optionsString.hashCode());
        SenderConfiguration senderConfiguration =
                HttpConnectorUtil.getSenderConfiguration(connectionManager.getTransportConfig(), scheme);

        if (connectionManager.isHTTPTraceLoggerEnabled()) {
            senderConfiguration.setHttpTraceLogEnabled(true);
        }
        senderConfiguration.setTLSStoreType(HttpConstants.PKCS_STORE_TYPE);

        try {
            populateSenderConfigurations(senderConfiguration, clientEndpointConfig, scheme);
            BMap userDefinedPoolConfig = (BMap) clientEndpointConfig.get(
                    HttpConstants.USER_DEFINED_POOL_CONFIG);
            ConnectionManager poolManager = userDefinedPoolConfig == null ? getConnectionManager(globalPoolConfig) :
                    getConnectionManager(userDefinedPoolConfig);
            senderConfiguration.setHttpVersion(Constants.HTTP_2_0);
            senderConfiguration.setForceHttp2(true);
            HttpClientConnector clientConnector = HttpUtil.createHttpWsConnectionFactory()
                    .createHttpClientConnector(properties, senderConfiguration, poolManager);

            clientEndpoint.addNativeData(CLIENT_CONNECTOR, clientConnector);
            clientEndpoint.addNativeData(ENDPOINT_URL, urlString.getValue());
        } catch (BError ex) {
            return ex;
        } catch (RuntimeException ex) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withCause(ex)));
        }
        return null;
    }

    /**
     * Extern function to initialize client stub.
     *
     * @param genericEndpoint generic client endpoint instance.
     * @param clientEndpoint  generated client endpoint instance.
     * @param rootDescriptor  service descriptor.
     * @param descriptorMap   dependent descriptor map.
     * @return Error if there is an error while initializing the stub, else returns nil
     */
    public static Object externInitStub(BObject genericEndpoint, BObject clientEndpoint, BString rootDescriptor,
                                        BMap<BString, Object> descriptorMap) {

        HttpClientConnector clientConnector = (HttpClientConnector) genericEndpoint.getNativeData(CLIENT_CONNECTOR);
        String urlString = (String) genericEndpoint.getNativeData(ENDPOINT_URL);

        if (rootDescriptor == null || descriptorMap == null) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Error while initializing " +
                            "connector. message descriptor keys not exist. Please check the generated stub file")));
        }

        try {
            ServiceDefinition serviceDefinition = new ServiceDefinition(rootDescriptor.getValue(), descriptorMap);
            MessageRegistry.getInstance().setFileDescriptor(serviceDefinition.getDescriptor());
            ObjectType objectType = (ObjectType) TypeUtils.getReferredType(TypeUtils.getType(clientEndpoint));
            Map<String, MethodDescriptor> methodDescriptorMap = serviceDefinition.getMethodDescriptors(objectType);

            genericEndpoint.addNativeData(METHOD_DESCRIPTORS, methodDescriptorMap);
            Stub stub = new Stub(clientConnector, urlString);
            genericEndpoint.addNativeData(SERVICE_STUB, stub);
        } catch (RuntimeException | GrpcClientException e) {
            return MessageUtils.getConnectorError(e);
        }
        return null;
    }

    /**
     * Extern function to perform blocking call for the gRPC client.
     *
     * @param clientEndpoint client endpoint instance.
     * @param methodName     remote method name.
     * @param payloadBValue  request payload.
     * @param headerValues custom metadata to send with the request.
     * @return Error if there is an error while calling remote method, else returns response message.
     */
    @SuppressWarnings("unchecked")
    public static Object externExecuteSimpleRPC(Environment env, BObject clientEndpoint, BString methodName,
                                               Object payloadBValue, BMap headerValues) {
        if (clientEndpoint == null) {
            return notifyErrorReply(INTERNAL, "Error while getting connector. gRPC client connector " +
                    "is not initialized properly");
        }

        Object connectionStub = clientEndpoint.getNativeData(SERVICE_STUB);
        if (connectionStub == null) {
            return notifyErrorReply(INTERNAL, "Error while getting connection stub. gRPC Client " +
                    "connector is not initialized properly");
        }

        if (methodName == null) {
            return notifyErrorReply(INTERNAL, "Error while processing the request. RPC endpoint " +
                    "doesn't set properly");
        }
        Map<String, MethodDescriptor> methodDescriptors = (Map<String, MethodDescriptor>) clientEndpoint.getNativeData
                (METHOD_DESCRIPTORS);
        if (methodDescriptors == null) {
            return notifyErrorReply(INTERNAL, "Error while processing the request. method descriptors " +
                    "doesn't set properly");
        }

        Descriptors.MethodDescriptor methodDescriptor = methodDescriptors
                .get(methodName.getValue()) != null ? methodDescriptors.get(methodName.getValue()).getSchemaDescriptor()
                : null;
        if (methodDescriptor == null) {
            return notifyErrorReply(INTERNAL, "No registered method descriptor for '" + methodName.getValue() + "'");
        }

        Message requestMsg = new Message(methodDescriptor.getInputType(), payloadBValue);

        // Update request headers when request headers exists in the context.
        HttpHeaders headers = convertToHttpHeaders(headerValues);
        requestMsg.setHeaders(headers);
        Stub stub = (Stub) connectionStub;
        DataContext dataContext = null;

        Map<String, Long> messageSizeMap = new HashMap<>();
        messageSizeMap.put(MAX_INBOUND_MESSAGE_SIZE, (Long) clientEndpoint.getMapValue(CONFIG)
                .get(StringUtils.fromString((MAX_INBOUND_MESSAGE_SIZE))));
        try {
            MethodDescriptor.MethodType methodType = getMethodType(methodDescriptor);
            if (methodType.equals(MethodDescriptor.MethodType.UNARY)) {

                dataContext = new DataContext(env, env.markAsync());
                stub.executeUnary(requestMsg, methodDescriptors.get(methodName.getValue()),
                        dataContext, messageSizeMap);
            } else {
                return notifyErrorReply(INTERNAL, "Error while executing the client call. Method type " +
                        methodType.name() + " not supported");
            }
        } catch (Exception e) {
            try {
                if (dataContext != null) {
                    dataContext.getFuture().complete(e);
                }
            } finally {
                return notifyErrorReply(INTERNAL, "gRPC Client Connector Error :" + e.getMessage());
            }
        }
        return null;
    }

    /**
     * Extern function to perform server streaming call for the gRPC client.
     *
     * @param clientEndpoint client endpoint instance.
     * @param methodName     remote method name.
     * @param payload        request payload.
     * @param headerValues custom metadata to send with the request.
     * @return Error if there is an error while initializing the stub, else returns a BStream object.
     */
    @SuppressWarnings("unchecked")
    public static Object externExecuteServerStreaming(Environment env, BObject clientEndpoint, BString methodName,
                                                      Object payload, BMap headerValues) {

        if (clientEndpoint == null) {
            return notifyErrorReply(INTERNAL, "Error while getting connector. gRPC Client connector is " +
                    "not initialized properly");
        }

        Object connectionStub = clientEndpoint.getNativeData(SERVICE_STUB);
        if (connectionStub == null) {
            return notifyErrorReply(INTERNAL, "Error while getting connection stub. gRPC Client connector " +
                    "is not initialized properly");
        }

        if (methodName == null) {
            return notifyErrorReply(INTERNAL, "Error while processing the request. RPC endpoint doesn't " +
                    "set properly");
        }

        Map<String, MethodDescriptor> methodDescriptors = (Map<String, MethodDescriptor>) clientEndpoint.getNativeData
                (METHOD_DESCRIPTORS);
        if (methodDescriptors == null) {
            return notifyErrorReply(INTERNAL, "Error while processing the request. method descriptors " +
                    "doesn't set properly");
        }

        com.google.protobuf.Descriptors.MethodDescriptor methodDescriptor = methodDescriptors
                .get(methodName.getValue()) != null ? methodDescriptors.get(methodName.getValue()).getSchemaDescriptor()
                : null;
        if (methodDescriptor == null) {
            return notifyErrorReply(INTERNAL, "No registered method descriptor for '" + methodName.getValue() + "'");
        }

        Message requestMsg = new Message(methodDescriptor.getInputType(), payload);

        // Update request headers when request headers exists in the context.
        HttpHeaders headers = convertToHttpHeaders(headerValues);
        requestMsg.setHeaders(headers);
        Stub stub = (Stub) connectionStub;
        DataContext dataContext = null;

        Map<String, Long> messageSizeMap = new HashMap<>();
        messageSizeMap.put(MAX_INBOUND_MESSAGE_SIZE, (Long) clientEndpoint.getMapValue(CONFIG)
                .get(StringUtils.fromString((MAX_INBOUND_MESSAGE_SIZE))));
        try {
            dataContext = new DataContext(env, env.markAsync());
            stub.executeServerStreaming(requestMsg, methodDescriptors.get(methodName.getValue()),
                    dataContext, messageSizeMap);
        } catch (Exception e) {
            if (dataContext != null) {
                dataContext.getFuture().complete(e);
            }
            return notifyErrorReply(INTERNAL, "gRPC Client Connector Error :" + e.getMessage());
        }
        return null;
    }

    /**
     * Extern function to perform client streaming call for the gRPC client.
     *
     * @param env            Ballerina environment.
     * @param clientEndpoint client endpoint instance.
     * @param methodName     remote method name.
     * @param headerValues custom metadata to send with the request.
     * @return Error if there is an error while initializing the stub, else returns nil
     */
    @SuppressWarnings("unchecked")
    public static Object externExecuteClientStreaming(Environment env, BObject clientEndpoint, BString methodName,
                                                      BMap headerValues) {

        if (clientEndpoint == null) {
            return notifyErrorReply(INTERNAL, "Error while getting connector. gRPC Client connector " +
                    "is not initialized properly");
        }

        Object connectionStub = clientEndpoint.getNativeData(SERVICE_STUB);
        if (connectionStub == null) {
            return notifyErrorReply(INTERNAL, "Error while getting connection stub. gRPC Client connector is " +
                    "not initialized properly");
        }

        if (methodName == null) {
            return notifyErrorReply(INTERNAL, "Error while processing the request. RPC endpoint doesn't " +
                    "set properly");
        }

        Map<String, MethodDescriptor> methodDescriptors = (Map<String, MethodDescriptor>) clientEndpoint.getNativeData
                (METHOD_DESCRIPTORS);
        if (methodDescriptors == null) {
            return notifyErrorReply(INTERNAL, "Error while processing the request. method descriptors " +
                    "doesn't set properly");
        }

        com.google.protobuf.Descriptors.MethodDescriptor methodDescriptor = methodDescriptors
                .get(methodName.getValue()) != null ? methodDescriptors.get(methodName.getValue()).getSchemaDescriptor()
                : null;
        if (methodDescriptor == null) {
            return notifyErrorReply(INTERNAL, "No registered method descriptor for '" + methodName.getValue() + "'");
        }

        Map<String, Long> messageSizeMap = new HashMap<>();
        messageSizeMap.put(MAX_INBOUND_MESSAGE_SIZE, (Long) clientEndpoint.getMapValue(CONFIG)
                .get(StringUtils.fromString((MAX_INBOUND_MESSAGE_SIZE))));
        try {
            Stub stub = (Stub) connectionStub;
            // Update request headers when request headers exists in the context.
            HttpHeaders headers = convertToHttpHeaders(headerValues);
            DataContext context = new DataContext(env, null);
            return stub.executeClientStreaming(headers, methodDescriptors.get(methodName.getValue()),
                    context, messageSizeMap);
        } catch (Exception e) {
            return notifyErrorReply(INTERNAL, "gRPC Client Connector Error :" + e.getMessage());
        }

    }

    /**
     * Extern function to perform streaming call for the gRPC client.
     *
     * @param env            Ballerina environment.
     * @param clientEndpoint client endpoint instance.
     * @param methodName     remote method name.
     * @param headerValues custom metadata to send with the request.
     * @return Error if there is an error while initializing the stub, else returns nil
     */
    @SuppressWarnings("unchecked")
    public static Object externExecuteBidirectionalStreaming(Environment env, BObject clientEndpoint,
                                                             BString methodName, BMap headerValues) {

        if (clientEndpoint == null) {
            return notifyErrorReply(INTERNAL, "Error while getting connector. gRPC Client connector " +
                    "is not initialized properly");
        }

        Object connectionStub = clientEndpoint.getNativeData(SERVICE_STUB);
        if (connectionStub == null) {
            return notifyErrorReply(INTERNAL, "Error while getting connection stub. gRPC Client connector is " +
                    "not initialized properly");
        }

        if (methodName == null) {
            return notifyErrorReply(INTERNAL, "Error while processing the request. RPC endpoint doesn't " +
                    "set properly");
        }

        Map<String, MethodDescriptor> methodDescriptors = (Map<String, MethodDescriptor>) clientEndpoint.getNativeData
                (METHOD_DESCRIPTORS);
        if (methodDescriptors == null) {
            return notifyErrorReply(INTERNAL, "Error while processing the request. method descriptors " +
                    "doesn't set properly");
        }

        com.google.protobuf.Descriptors.MethodDescriptor methodDescriptor = methodDescriptors
                .get(methodName.getValue()) != null ? methodDescriptors.get(methodName.getValue()).getSchemaDescriptor()
                : null;
        if (methodDescriptor == null) {
            return notifyErrorReply(INTERNAL, "No registered method descriptor for '" + methodName.getValue() + "'");
        }

        Map<String, Long> messageSizeMap = new HashMap<>();
        messageSizeMap.put(MAX_INBOUND_MESSAGE_SIZE, (Long) clientEndpoint.getMapValue(CONFIG)
                .get(StringUtils.fromString((MAX_INBOUND_MESSAGE_SIZE))));

        try {
            Stub stub = (Stub) connectionStub;
            // Update request headers when request headers exists in the context.
            HttpHeaders headers = convertToHttpHeaders(headerValues);
            DataContext context = new DataContext(env, null);
            return stub.executeBidirectionalStreaming(headers, methodDescriptors.get(methodName.getValue()),
                    context, messageSizeMap);
        } catch (Exception e) {
            return notifyErrorReply(INTERNAL, "gRPC Client Connector Error :" + e.getMessage());
        }

    }

}
