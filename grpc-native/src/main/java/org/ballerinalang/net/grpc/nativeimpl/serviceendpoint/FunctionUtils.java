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

package org.ballerinalang.net.grpc.nativeimpl.serviceendpoint;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.Runtime;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import org.ballerinalang.net.grpc.GrpcConstants;
import org.ballerinalang.net.grpc.Message;
import org.ballerinalang.net.grpc.MessageUtils;
import org.ballerinalang.net.grpc.ServerConnectorListener;
import org.ballerinalang.net.grpc.ServerConnectorPortBindingListener;
import org.ballerinalang.net.grpc.ServicesBuilderUtils;
import org.ballerinalang.net.grpc.ServicesRegistry;
import org.ballerinalang.net.grpc.Status;
import org.ballerinalang.net.grpc.exception.GrpcServerException;
import org.ballerinalang.net.grpc.exception.StatusRuntimeException;
import org.ballerinalang.net.grpc.nativeimpl.AbstractGrpcNativeFunction;
import org.ballerinalang.net.http.HttpConnectionManager;
import org.ballerinalang.net.http.HttpConstants;
import org.ballerinalang.net.transport.contract.ServerConnector;
import org.ballerinalang.net.transport.contract.ServerConnectorFuture;
import org.ballerinalang.net.transport.contract.config.ListenerConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.Semaphore;

import static org.ballerinalang.net.grpc.GrpcConstants.ANN_SERVICE_DESCRIPTOR_FQN;
import static org.ballerinalang.net.grpc.GrpcConstants.CLIENT_ENDPOINT_RESPONSE_OBSERVER;
import static org.ballerinalang.net.grpc.GrpcConstants.ERROR_MESSAGE;
import static org.ballerinalang.net.grpc.GrpcConstants.MESSAGE_QUEUE;
import static org.ballerinalang.net.grpc.GrpcConstants.SERVER_CONNECTOR;
import static org.ballerinalang.net.grpc.GrpcConstants.SERVICE_REGISTRY_BUILDER;
import static org.ballerinalang.net.grpc.GrpcUtil.getListenerConfig;
import static org.ballerinalang.net.grpc.MessageUtils.createHeaderMap;
import static org.ballerinalang.net.grpc.nativeimpl.caller.FunctionUtils.externComplete;
import static org.ballerinalang.net.http.HttpConstants.ENDPOINT_CONFIG_PORT;

/**
 * Utility methods represents lifecycle functions of the service listener.
 *
 * @since 1.0.0
 */

public class FunctionUtils  extends AbstractGrpcNativeFunction  {

    private static final Logger LOG = LoggerFactory.getLogger(FunctionUtils.class);

    private FunctionUtils() {
    }

    /**
     * Extern function to initialize gRPC service listener.
     *
     * @param listenerObject service listener instance.
     * @return Error if there is an error while initializing the service listener, else returns nil.
     */
    public static Object externInitEndpoint(BObject listenerObject) {
        BMap serviceEndpointConfig = listenerObject.getMapValue(HttpConstants.SERVICE_ENDPOINT_CONFIG);
        long port = listenerObject.getIntValue(ENDPOINT_CONFIG_PORT);
        try {
            ListenerConfiguration configuration = getListenerConfig(port, serviceEndpointConfig);
            ServerConnector httpServerConnector =
                    HttpConnectionManager.getInstance().createHttpServerConnector(configuration);
            ServicesRegistry.Builder servicesRegistryBuilder = new ServicesRegistry.Builder();
            listenerObject.addNativeData(SERVER_CONNECTOR, httpServerConnector);
            listenerObject.addNativeData(SERVICE_REGISTRY_BUILDER, servicesRegistryBuilder);
            return null;
        } catch (BError ex) {
            return ex;
        } catch (Exception e) {
            LOG.error("Error while initializing service listener.", e);
            return MessageUtils.getConnectorError(e);
        }
    }

    /**
     * Extern function to register service to service listener.
     *
     * @param listenerObject service listener instance.
     * @param service service instance.
     * @param servicePath service path.
     * @return Error if there is an error while registering the service, else returns nil.
     */
    public static Object externRegister(BObject listenerObject, BObject service,
                                        Object servicePath) {
        ServicesRegistry.Builder servicesRegistryBuilder = getServiceRegistryBuilder(listenerObject);
        try {
            if (servicesRegistryBuilder == null) {
                return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                        .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Error when " +
                                "initializing service register builder.")));
            } else {
                servicesRegistryBuilder.addService(ServicesBuilderUtils.getServiceDefinition(
                        Runtime.getCurrentRuntime(), service, servicePath,
                        service.getType().getAnnotation(StringUtils.fromString(ANN_SERVICE_DESCRIPTOR_FQN))));
                return null;
            }
        } catch (GrpcServerException e) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Error while registering " +
                     "the service. " + e.getLocalizedMessage())));
        }
    }

    private static Object startServerConnector(BObject listener, ServicesRegistry servicesRegistry) {
        ServerConnector serverConnector = getServerConnector(listener);
        ServerConnectorFuture serverConnectorFuture = serverConnector.start();
        serverConnectorFuture.setHttpConnectorListener(new ServerConnectorListener(servicesRegistry));

        serverConnectorFuture.setPortBindingEventListener(new ServerConnectorPortBindingListener());
        try {
            serverConnectorFuture.sync();
        } catch (Exception ex) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription(
                            "Failed to start server connector '" + serverConnector.getConnectorID()
                                    + "'. " + ex.getMessage())));
        }
        listener.addNativeData(HttpConstants.CONNECTOR_STARTED, true);
        return null;
    }

    /**
     * Extern function to start gRPC server instance.
     *
     * @param listener service listener instance.
     * @return Error if there is an error while starting the server, else returns nil.
     */
    public static Object externStart(BObject listener) {

        ServicesRegistry.Builder servicesRegistryBuilder = getServiceRegistryBuilder(listener);

        if (servicesRegistryBuilder.getServices().isEmpty()) {
            long port = listener.getIntValue(StringUtils.fromString("port"));
            LOG.warn("The listener start is terminated because no attached services found in the " +
                    "listener with port {}", port);
            return null;
        }

        if (!isConnectorStarted(listener)) {
            return startServerConnector(listener, servicesRegistryBuilder.build());
        }
        return null;
    }

    /**
     * Extern function to stop gRPC server instance.
     *
     * @param serverEndpoint service listener instance.
     * @return Error if there is an error while starting the server, else returns nil.
     */
    public static Object externStop(BObject serverEndpoint) {
        getServerConnector(serverEndpoint).stop();
        serverEndpoint.addNativeData(HttpConstants.CONNECTOR_STARTED, false);
        return null;
    }

    public static Object nextResult(BObject streamIterator) {
        BlockingQueue<?> messageQueue = (BlockingQueue<?>) streamIterator.getNativeData(MESSAGE_QUEUE);
        try {
            Message nextMessage = (Message) messageQueue.take();
            if (nextMessage.getHeaders() != null) {
                streamIterator.addNativeData(GrpcConstants.HEADERS, createHeaderMap(nextMessage.getHeaders()));
            }
            if (nextMessage.isError()) {
                return MessageUtils.getConnectorError(nextMessage.getError());
            } else {
                return nextMessage.getbMessage();
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            String message = "Internal error occurred. The current thread got interrupted";
            throw MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription(message)));
        }
    }

    public static Object closeStream(Environment env, BObject streamIterator) {
        Semaphore listenerSemaphore = (Semaphore) streamIterator.getNativeData(MESSAGE_QUEUE);
        BObject clientEndpoint = (BObject) streamIterator.getNativeData(CLIENT_ENDPOINT_RESPONSE_OBSERVER);
        Object errorVal = streamIterator.getNativeData(ERROR_MESSAGE);
        BError returnError;
        if (errorVal instanceof BError) {
            returnError = (BError) errorVal;
        } else {
            externComplete(env, clientEndpoint);
            returnError = null;
        }
        while (listenerSemaphore.hasQueuedThreads()) {
            listenerSemaphore.release();
        }
        return returnError;
    }
}
