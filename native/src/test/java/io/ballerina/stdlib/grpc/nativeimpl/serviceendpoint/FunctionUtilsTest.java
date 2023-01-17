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
import io.ballerina.stdlib.grpc.nativeimpl.ModuleUtils;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.BlockingQueue;

import static io.ballerina.stdlib.grpc.ServicesBuilderUtils.fileDescriptorHashMapByFilename;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.closeStream;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.externGetAllExtensionNumbersOfType;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.externGetFileContainingExtension;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.externRegister;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.nextResult;

/**
 * A test class to test FunctionUtils class functions.
 */
public class FunctionUtilsTest {

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
