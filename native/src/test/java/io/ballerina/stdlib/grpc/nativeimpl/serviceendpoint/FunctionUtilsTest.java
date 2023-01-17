/*
 *  Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
 *
 *  WSO2 LLC. licenses this file to you under the Apache License,
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

import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.stdlib.grpc.GrpcConstants;
import io.ballerina.stdlib.grpc.MessageUtils;
import io.ballerina.stdlib.grpc.ServerServiceDefinition;
import io.ballerina.stdlib.grpc.ServicesRegistry;
import io.ballerina.stdlib.grpc.nativeimpl.ModuleUtils;
import io.ballerina.stdlib.http.api.HttpConstants;
import io.ballerina.stdlib.http.transport.contract.ServerConnector;
import io.ballerina.stdlib.http.transport.contract.ServerConnectorFuture;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.BlockingQueue;

import static io.ballerina.stdlib.grpc.GrpcConstants.CONFIG;
import static io.ballerina.stdlib.grpc.GrpcConstants.MAX_INBOUND_MESSAGE_SIZE;
import static io.ballerina.stdlib.grpc.ServicesBuilderUtils.fileDescriptorHashMapByFilename;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.closeStream;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.externGetAllExtensionNumbersOfType;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.externGetFileContainingExtension;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.externInitEndpoint;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.externRegister;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.externStart;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.nextResult;
import static io.ballerina.stdlib.http.api.HttpConstants.ENDPOINT_CONFIG_PORT;

/**
 * A test class to test FunctionUtils class functions.
 */
public class FunctionUtilsTest {

    @Test()
    public void testExternInitEndpointBErrorCase() {
        BMap serviceEndpointConfig = Mockito.mock(BMap.class);
        BObject listenerObject = Mockito.mock(BObject.class);
        Mockito.when(serviceEndpointConfig.getStringValue(HttpConstants.ENDPOINT_CONFIG_HOST))
                .thenThrow(MessageUtils.getConnectorError(new Exception("This is a test BError")));
        Mockito.when(listenerObject.getMapValue(StringUtils.fromString(HttpConstants.SERVICE_ENDPOINT_CONFIG)))
                .thenReturn(serviceEndpointConfig);
        Mockito.when(listenerObject.getIntValue(ENDPOINT_CONFIG_PORT)).thenReturn(9090L);

        Object result = externInitEndpoint(listenerObject);
        Assert.assertTrue(result instanceof BError);
        Assert.assertEquals(((BError) result).getMessage(), "This is a test BError");
    }

    @Test()
    public void testExternInitEndpointExceptionCase() {
        BMap serviceEndpointConfig = Mockito.mock(BMap.class);
        BObject listenerObject = Mockito.mock(BObject.class);
        Mockito.when(serviceEndpointConfig.getStringValue(HttpConstants.ENDPOINT_CONFIG_HOST))
                .thenThrow(new RuntimeException("This is a test exception"));
        Mockito.when(listenerObject.getMapValue(StringUtils.fromString(HttpConstants.SERVICE_ENDPOINT_CONFIG)))
                .thenReturn(serviceEndpointConfig);
        Mockito.when(listenerObject.getIntValue(ENDPOINT_CONFIG_PORT)).thenReturn(9090L);

        Object result = externInitEndpoint(listenerObject);
        Assert.assertTrue(result instanceof BError);
        Assert.assertEquals(((BError) result).getMessage(), "This is a test exception");
    }

    @Test()
    public void testExternRegisterErrorCase() {
        BObject serviceEndpoint = Mockito.mock(BObject.class);
        Mockito.when(serviceEndpoint.getNativeData(GrpcConstants.SERVICE_REGISTRY_BUILDER)).thenReturn(null);

        Object result = externRegister(serviceEndpoint, null, null);
        Assert.assertTrue(result instanceof BError);
        Assert.assertEquals(((BError) result).getMessage(), "Error when " +
                "initializing service register builder.");
    }

    @Test()
    public void testStartServerConnectorErrorCase() throws InterruptedException {
        BMap config = Mockito.mock(BMap.class);
        BObject listener = Mockito.mock(BObject.class);
        ServerConnectorFuture serverConnectorFuture = Mockito.mock(ServerConnectorFuture.class);
        ServicesRegistry.Builder serviceRegistryBuilder = Mockito.mock(ServicesRegistry.Builder.class);
        HashMap<String, ServerServiceDefinition> serviceDefinitionHashMap = new HashMap<>();
        serviceDefinitionHashMap.put("TestDefinition", null);
        ServicesRegistry servicesRegistry = Mockito.mock(ServicesRegistry.class);
        ServerConnector serverConnector = Mockito.mock(ServerConnector.class);
        Mockito.when(config.get(StringUtils.fromString((MAX_INBOUND_MESSAGE_SIZE)))).thenReturn(1L);
        Mockito.when(listener.getMapValue(CONFIG)).thenReturn(config);
        Mockito.when(listener.getNativeData(GrpcConstants.SERVER_CONNECTOR)).thenReturn(serverConnector);
        Mockito.when(serverConnector.start()).thenReturn(serverConnectorFuture);
        Mockito.when(serverConnector.getConnectorID()).thenReturn("10");
        Mockito.when(listener.getNativeData(GrpcConstants.SERVICE_REGISTRY_BUILDER)).thenReturn(serviceRegistryBuilder);
        Mockito.when(listener.getNativeData(GrpcConstants.CONNECTOR_STARTED)).thenReturn(false);
        Mockito.when(serviceRegistryBuilder.getServices()).thenReturn(serviceDefinitionHashMap);
        Mockito.when(serviceRegistryBuilder.build()).thenReturn(servicesRegistry);
        Mockito.doThrow(new InterruptedException("Interrupted by test")).when(serverConnectorFuture).sync();

        Object result = externStart(listener);
        Assert.assertTrue(result instanceof BError);
        Assert.assertEquals(((BError) result).getMessage(),
                "Failed to start server connector '10'. Interrupted by test");
    }

    @Test()
    public void testNextResultErrorCase() throws InterruptedException {
        BObject streamIterator = Mockito.mock(BObject.class);
        BlockingQueue<?> messageQueue = Mockito.mock(BlockingQueue.class);
        Mockito.when(streamIterator.getNativeData(GrpcConstants.MESSAGE_QUEUE)).thenReturn(messageQueue);
        Mockito.when(messageQueue.take()).thenThrow(new InterruptedException());

        try {
            nextResult(streamIterator);
        } catch (Exception e) {
            Assert.assertEquals(e.getMessage(), "Internal error occurred. The current thread got interrupted");
        }
    }

    @Test()
    public void testCloseStreamErrorCase() {
        BObject streamIterator = Mockito.mock(BObject.class);
        BlockingQueue<?> messageQueue = Mockito.mock(BlockingQueue.class);
        BObject clientEndpoint = Mockito.mock(BObject.class);
        Object errorVal = MessageUtils.getConnectorError(new Exception("This is a test error"));
        Mockito.when(streamIterator.getNativeData(GrpcConstants.MESSAGE_QUEUE)).thenReturn(messageQueue);
        Mockito.when(streamIterator.getNativeData(GrpcConstants.CLIENT_ENDPOINT_RESPONSE_OBSERVER))
                .thenReturn(clientEndpoint);
        Mockito.when(streamIterator.getNativeData(GrpcConstants.ERROR_MESSAGE)).thenReturn(errorVal);

        Object result = closeStream(null, streamIterator);
        Assert.assertTrue(result instanceof BError);
        Assert.assertEquals(((BError) result).getMessage(), "This is a test error");
    }

    @Test()
    public void testCloseStreamInvalidErrorCase() {
        BObject streamIterator = Mockito.mock(BObject.class);
        BlockingQueue<?> messageQueue = Mockito.mock(BlockingQueue.class);
        BObject clientEndpoint = Mockito.mock(BObject.class);
        Object errorVal = Mockito.mock(BObject.class);
        Mockito.when(streamIterator.getNativeData(GrpcConstants.MESSAGE_QUEUE)).thenReturn(messageQueue);
        Mockito.when(streamIterator.getNativeData(GrpcConstants.CLIENT_ENDPOINT_RESPONSE_OBSERVER))
                .thenReturn(clientEndpoint);
        Mockito.when(streamIterator.getNativeData(GrpcConstants.ERROR_MESSAGE)).thenReturn(errorVal);

        Object result = closeStream(null, streamIterator);
        Assert.assertNull(result);
    }

    @Test()
    public void testExternGetFileContainingExtensionStaticMapUsageCase() {
        Descriptors.FileDescriptor fileDescriptor = Mockito.mock(Descriptors.FileDescriptor.class);
        List<Descriptors.FieldDescriptor> fieldDescriptors = new ArrayList<>();
        Descriptors.FieldDescriptor fieldDescriptor = Mockito.mock(Descriptors.FieldDescriptor.class);
        fieldDescriptors.add(fieldDescriptor);
        Descriptors.Descriptor descriptor = Mockito.mock(Descriptors.Descriptor.class);
        DescriptorProtos.FileDescriptorProto proto = Mockito.mock(DescriptorProtos.FileDescriptorProto.class);
        Mockito.when(fieldDescriptor.getContainingType()).thenReturn(descriptor);
        Mockito.when(fieldDescriptor.getNumber()).thenReturn(12);
        Mockito.when(descriptor.getFullName()).thenReturn("TestMessage");
        Mockito.when(fileDescriptor.getExtensions()).thenReturn(fieldDescriptors);
        Mockito.when(fileDescriptor.toProto()).thenReturn(proto);
        Mockito.when(proto.toByteArray()).thenReturn("bytes".getBytes(StandardCharsets.UTF_8));
        fileDescriptorHashMapByFilename.put("TestFile", fileDescriptor);
        BMap bMap = Mockito.mock(BMap.class);
        try (MockedStatic<ValueCreator> mockedStatic = Mockito.mockStatic(ValueCreator.class)) {
            mockedStatic.when(() -> ValueCreator.createRecordValue(ModuleUtils.getModule(),
                    "FileDescriptorResponse")).thenReturn(bMap);
            mockedStatic.when(() -> ValueCreator.createArrayValue(fileDescriptor.toProto().toByteArray()))
                    .thenReturn(null);

            Object result = externGetFileContainingExtension(StringUtils.fromString("TestMessage"), 12);
            Assert.assertTrue(result instanceof BMap);
        }
    }

    @Test()
    public void testExternGetAllExtensionNumbersOfTypeStaticMapUsageCase() {
        Descriptors.FileDescriptor fileDescriptor = Mockito.mock(Descriptors.FileDescriptor.class);
        List<Descriptors.FieldDescriptor> fieldDescriptors = new ArrayList<>();
        Descriptors.FieldDescriptor fieldDescriptor = Mockito.mock(Descriptors.FieldDescriptor.class);
        fieldDescriptors.add(fieldDescriptor);
        Descriptors.Descriptor descriptor = Mockito.mock(Descriptors.Descriptor.class);
        Mockito.when(fieldDescriptor.getContainingType()).thenReturn(descriptor);
        Mockito.when(fieldDescriptor.getNumber()).thenReturn(10);
        Mockito.when(descriptor.getFullName()).thenReturn("TestMessage");
        Mockito.when(fileDescriptor.getExtensions()).thenReturn(fieldDescriptors);
        fileDescriptorHashMapByFilename.put("TestFile", fileDescriptor);
        BMap bMap = Mockito.mock(BMap.class);
        BArray extensionArray = ValueCreator.createArrayValue(TypeCreator.createArrayType(PredefinedTypes.TYPE_INT));
        try (MockedStatic<ValueCreator> mockedStatic = Mockito.mockStatic(ValueCreator.class)) {
            mockedStatic.when(() -> ValueCreator.createRecordValue(ModuleUtils.getModule(),
                    "ExtensionNumberResponse")).thenReturn(bMap);
            mockedStatic.when(() -> ValueCreator.createArrayValue(TypeCreator
                    .createArrayType(PredefinedTypes.TYPE_INT))).thenReturn(extensionArray);

            Object result = externGetAllExtensionNumbersOfType(StringUtils.fromString("TestMessage"));
            Assert.assertTrue(result instanceof BMap);
        }
    }

}
