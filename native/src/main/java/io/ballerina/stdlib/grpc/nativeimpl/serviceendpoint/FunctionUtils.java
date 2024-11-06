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

package io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint;

import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.ObjectType;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.stdlib.grpc.GrpcConstants;
import io.ballerina.stdlib.grpc.Message;
import io.ballerina.stdlib.grpc.MessageUtils;
import io.ballerina.stdlib.grpc.ServerConnectorListener;
import io.ballerina.stdlib.grpc.ServerConnectorPortBindingListener;
import io.ballerina.stdlib.grpc.ServerServiceDefinition;
import io.ballerina.stdlib.grpc.ServicesBuilderUtils;
import io.ballerina.stdlib.grpc.ServicesRegistry;
import io.ballerina.stdlib.grpc.StandardDescriptorBuilder;
import io.ballerina.stdlib.grpc.Status;
import io.ballerina.stdlib.grpc.exception.GrpcServerException;
import io.ballerina.stdlib.grpc.exception.StatusRuntimeException;
import io.ballerina.stdlib.grpc.nativeimpl.AbstractGrpcNativeFunction;
import io.ballerina.stdlib.grpc.nativeimpl.ModuleUtils;
import io.ballerina.stdlib.http.api.HttpConnectionManager;
import io.ballerina.stdlib.http.api.HttpConstants;
import io.ballerina.stdlib.http.transport.contract.ServerConnector;
import io.ballerina.stdlib.http.transport.contract.ServerConnectorFuture;
import io.ballerina.stdlib.http.transport.contract.config.ListenerConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.BlockingQueue;

import static io.ballerina.stdlib.grpc.GrpcConstants.ANN_DESCRIPTOR_FQN;
import static io.ballerina.stdlib.grpc.GrpcConstants.ANN_SERVICE_DESCRIPTOR_FQN;
import static io.ballerina.stdlib.grpc.GrpcConstants.CONFIG;
import static io.ballerina.stdlib.grpc.GrpcConstants.MAX_INBOUND_MESSAGE_SIZE;
import static io.ballerina.stdlib.grpc.GrpcConstants.SERVICE_REGISTRY_BUILDER;
import static io.ballerina.stdlib.grpc.GrpcUtil.getListenerConfig;
import static io.ballerina.stdlib.grpc.ServicesBuilderUtils.fileDescriptorHashMapByFilename;
import static io.ballerina.stdlib.grpc.nativeimpl.caller.FunctionUtils.externComplete;
import static io.ballerina.stdlib.http.api.HttpConstants.ENDPOINT_CONFIG_PORT;

/**
 * Utility methods represents lifecycle functions of the service listener.
 *
 * @since 1.0.0
 */

public class FunctionUtils extends AbstractGrpcNativeFunction {

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

        BMap serviceEndpointConfig = listenerObject.getMapValue(StringUtils.fromString(
                HttpConstants.SERVICE_ENDPOINT_CONFIG));
        long port = listenerObject.getIntValue(ENDPOINT_CONFIG_PORT);
        try {
            ListenerConfiguration configuration = getListenerConfig(port, serviceEndpointConfig);
            ServerConnector httpServerConnector =
                    HttpConnectionManager.getInstance().createHttpServerConnector(configuration);
            ServicesRegistry.Builder servicesRegistryBuilder = new ServicesRegistry.Builder();
            listenerObject.addNativeData(GrpcConstants.SERVER_CONNECTOR, httpServerConnector);
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
     * @param service        service instance.
     * @param servicePath    service path.
     * @return Error if there is an error while registering the service, else returns nil.
     */
    public static Object externRegister(Environment env, BObject listenerObject, BObject service,
                                        Object servicePath) {

        ServicesRegistry.Builder servicesRegistryBuilder = getServiceRegistryBuilder(listenerObject);
        try {
            if (servicesRegistryBuilder == null) {
                return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                        .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Error when " +
                                "initializing service register builder.")));
            } else {
                ObjectType serviceType = (ObjectType) TypeUtils.getReferredType(TypeUtils.getType(service));
                servicesRegistryBuilder.addService(ServicesBuilderUtils.getServiceDefinition(
                        env.getRuntime(), service, servicePath, getDescriptorAnnotation(serviceType)));
                return null;
            }
        } catch (GrpcServerException e) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Error while registering " +
                            "the service. " + e.getLocalizedMessage())));
        }
    }

    private static Object startServerConnector(BObject listener, ServicesRegistry servicesRegistry) {

        Map<String, Long> messageSizeMap = new HashMap<>();
        messageSizeMap.put(MAX_INBOUND_MESSAGE_SIZE, (Long) listener.getMapValue(CONFIG)
                .get(StringUtils.fromString((MAX_INBOUND_MESSAGE_SIZE))));

        ServerConnector serverConnector = getServerConnector(listener);
        ServerConnectorFuture serverConnectorFuture = serverConnector.start();
        serverConnectorFuture.setHttpConnectorListener(new ServerConnectorListener(servicesRegistry, messageSizeMap));

        serverConnectorFuture.setPortBindingEventListener(new ServerConnectorPortBindingListener());
        try {
            serverConnectorFuture.sync();
        } catch (Exception ex) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription(
                            "Failed to start server connector '" + serverConnector.getConnectorID()
                                    + "'. " + ex.getMessage())));
        }
        listener.addNativeData(GrpcConstants.CONNECTOR_STARTED, true);
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
     * Extern function to gracefully stop gRPC server instance.
     *
     * @param serverEndpoint service listener instance.
     * @return Error if there is an error while stopping the server, else returns nil.
     */
    public static Object gracefulStop(BObject serverEndpoint) {

        getServerConnector(serverEndpoint).stop();
        serverEndpoint.addNativeData(GrpcConstants.CONNECTOR_STARTED, false);
        return null;
    }

    /**
     * Extern function to immediately stop gRPC server instance.
     *
     * @param serverEndpoint service listener instance.
     * @return Error if there is an error while stopping the server, else returns nil.
     */
    public static Object immediateStop(BObject serverEndpoint) {
        getServerConnector(serverEndpoint).immediateStop();
        serverEndpoint.addNativeData(GrpcConstants.CONNECTOR_STARTED, false);
        return null;
    }

    public static Object nextResult(Environment env, BObject streamIterator) {
        return env.yieldAndRun(() -> {
            BlockingQueue<?> messageQueue =
                    (BlockingQueue<?>) streamIterator.getNativeData(GrpcConstants.MESSAGE_QUEUE);
            try {
                Message nextMessage = (Message) messageQueue.take();
                if (nextMessage.getHeaders() != null) {
                    streamIterator.addNativeData(GrpcConstants.HEADERS,
                            MessageUtils.createHeaderMap(nextMessage.getHeaders()));
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
        });
    }

    public static Object closeStream(Environment env, BObject streamIterator) {

        BlockingQueue<?> messageQueue = (BlockingQueue<?>) streamIterator.getNativeData(GrpcConstants.MESSAGE_QUEUE);
        BObject clientEndpoint = (BObject) streamIterator.getNativeData(
                GrpcConstants.CLIENT_ENDPOINT_RESPONSE_OBSERVER);
        Object errorVal = streamIterator.getNativeData(GrpcConstants.ERROR_MESSAGE);
        BError returnError;
        if (errorVal instanceof BError) {
            returnError = (BError) errorVal;
        } else {
            if (clientEndpoint != null) {
                externComplete(env, clientEndpoint);
            }
            returnError = null;
        }
        messageQueue.clear();
        return returnError;
    }

    /**
     * Extern function to get the services registered to a listener via reflection.
     *
     * @param listener service listener instance.
     * @return An array of service names.
     */
    public static Object externGetServices(BObject listener) {
        BMap<BString, Object> listServiceResponse = ValueCreator
                .createRecordValue(ModuleUtils.getModule(), "ListServiceResponse");
        BArray serviceResponses = ValueCreator.createArrayValue(TypeCreator.createArrayType(TypeCreator
                .createRecordType("ServiceResponse", ModuleUtils.getModule(), 0,
                        false, 0)));
        ServicesRegistry.Builder servicesRegistryBuilder = (ServicesRegistry.Builder) listener
                .getNativeData(SERVICE_REGISTRY_BUILDER);
        HashMap<String, ServerServiceDefinition> services = servicesRegistryBuilder.getServices();
        int i = 0;
        for (ServerServiceDefinition serviceDefinition: services.values()) {
            BMap<BString, Object> serviceResponse = ValueCreator
                    .createRecordValue(ModuleUtils.getModule(), "ServiceResponse");
            serviceResponse.put(StringUtils.fromString("name"),
                    StringUtils.fromString(serviceDefinition.getServiceDescriptor().getName()));
            serviceResponses.add(i, serviceResponse);
            i += 1;
        }
        listServiceResponse.put(StringUtils.fromString("service"), serviceResponses);
        return listServiceResponse;
    }

    /**
     * Extern function to get the FileDescriptor of a given fully-qualified symbol name.
     *
     * @param listener service listener instance.
     * @param symbol fully qualified symbol name
     * @return FileDescriptorResponse containing the file descriptor of the symbol.
     */
    public static Object externGetFileDescBySymbol(BObject listener, BString symbol) {
        if (ServicesBuilderUtils.fileDescriptorHashMapBySymbol.containsKey(symbol.getValue())) {
            return createFileDescriptorResponse("file_descriptor_proto",
                    ValueCreator.createArrayValue(ServicesBuilderUtils.fileDescriptorHashMapBySymbol
                            .get(symbol.getValue()).toProto().toByteArray()));
        }
        return MessageUtils.getConnectorError(new StatusRuntimeException(Status.fromCode(
                Status.Code.NOT_FOUND.toStatus().getCode()).withDescription(symbol.getValue() + " symbol not found")));
    }

    /**
     * Extern function to get the FileDescriptor by a filename.
     *
     * @param filename filename of the required FileDescriptor.
     * @return FileDescriptor of the respective file.
     */
    public static Object externGetFileDescByFilename(BString filename) {
        Descriptors.FileDescriptor fd;
        if (StandardDescriptorBuilder.getFileDescriptor(filename.getValue()) != null) {
            fd = StandardDescriptorBuilder.getFileDescriptor(filename.getValue());
        } else if (fileDescriptorHashMapByFilename.containsKey(filename.getValue())) {
            fd = fileDescriptorHashMapByFilename.get(filename.getValue());
        } else {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status.fromCode(
                    Status.Code.NOT_FOUND.toStatus().getCode()).withDescription(filename.getValue() + " not found")));
        }
        return createFileDescriptorResponse("file_descriptor_proto",
                ValueCreator.createArrayValue(fd.toProto().toByteArray()));
    }

    /**
     * Extern function to get the FileDescriptor of the file containing the given extension.
     *
     * @param containingType fully qualified typename.
     * @param extensionNumber related extension number.
     * @return FileDescriptor of the file containing the given type and the extension number.
     */
    public static Object externGetFileContainingExtension(BString containingType, int extensionNumber) {
        for (Descriptors.FileDescriptor fd: StandardDescriptorBuilder.getDescriptorMapForPackageKey().values()) {
            for (Descriptors.FieldDescriptor fieldDescriptor: fd.getExtensions()) {
                if (fieldDescriptor.getContainingType().getFullName().equals(containingType.getValue()) &&
                        fieldDescriptor.getNumber() == extensionNumber) {
                    return createFileDescriptorResponse("file_descriptor_proto",
                            ValueCreator.createArrayValue(fd.toProto().toByteArray()));
                }
            }
        }
        for (Descriptors.FileDescriptor fd: fileDescriptorHashMapByFilename.values()) {
            for (Descriptors.FieldDescriptor fieldDescriptor: fd.getExtensions()) {
                if (fieldDescriptor.getContainingType().getFullName().equals(containingType.getValue()) &&
                        fieldDescriptor.getNumber() == extensionNumber) {
                    return createFileDescriptorResponse("file_descriptor_proto",
                            ValueCreator.createArrayValue(fd.toProto().toByteArray()));
                }
            }
        }
        return MessageUtils.getConnectorError(new StatusRuntimeException(Status.fromCode(
                Status.Code.NOT_FOUND.toStatus().getCode()).withDescription("File descriptor containing type " +
                containingType.getValue() + " and extension " + extensionNumber + " not found")));
    }

    /**
     * Extern function to get all the extension numbers of a given type.
     *
     * @param messageType fully qualified message type name.
     * @return An unordered array of extension numbers of a given type.
     */
    public static Object externGetAllExtensionNumbersOfType(BString messageType) {
        BArray extensionArray = ValueCreator.createArrayValue(TypeCreator.createArrayType(PredefinedTypes.TYPE_INT));
        int i = 0;
        for (Descriptors.FileDescriptor fileDescriptor: StandardDescriptorBuilder.getDescriptorMapForPackageKey()
                .values()) {
            for (Descriptors.FieldDescriptor fieldDescriptor : fileDescriptor.getExtensions()) {
                if (fieldDescriptor.getContainingType().getFullName().equals(messageType.getValue())) {
                    extensionArray.add(i, fieldDescriptor.getNumber());
                    i += 1;
                }
            }
        }
        for (Descriptors.FileDescriptor fileDescriptor: fileDescriptorHashMapByFilename.values()) {
            for (Descriptors.FieldDescriptor fieldDescriptor : fileDescriptor.getExtensions()) {
                if (fieldDescriptor.getContainingType().getFullName().equals(messageType.getValue())) {
                    extensionArray.add(i, fieldDescriptor.getNumber());
                    i += 1;
                }
            }
        }
        if (extensionArray.size() == 0) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status.fromCode(
                    Status.Code.NOT_FOUND.toStatus().getCode()).withDescription("Message type " +
                    messageType.getValue() + " not found")));
        }
        BMap<BString, Object> fileDescriptorResponse = ValueCreator.createRecordValue(ModuleUtils.getModule(),
                "ExtensionNumberResponse");
        fileDescriptorResponse.put(StringUtils.fromString("base_type_name"), messageType);
        fileDescriptorResponse.put(StringUtils.fromString("extension_number"), extensionArray);
        return fileDescriptorResponse;
    }

    private static Object createFileDescriptorResponse(String key, Object value) {
        BMap<BString, Object> fileDescriptorResponse = ValueCreator
                .createRecordValue(ModuleUtils.getModule(), "FileDescriptorResponse");
        fileDescriptorResponse.put(StringUtils.fromString(key), value);
        return fileDescriptorResponse;
    }

    private static Object getDescriptorAnnotation(ObjectType type) {
        if (type.getAnnotation(ANN_SERVICE_DESCRIPTOR_FQN) != null) {
            return type.getAnnotation(ANN_SERVICE_DESCRIPTOR_FQN);
        }
        return type.getAnnotation(ANN_DESCRIPTOR_FQN);
    }
}
