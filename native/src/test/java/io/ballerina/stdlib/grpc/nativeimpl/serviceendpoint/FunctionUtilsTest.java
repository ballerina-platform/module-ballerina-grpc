package io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint;

import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.stdlib.grpc.GrpcConstants;
import io.ballerina.stdlib.grpc.MessageUtils;
import org.mockito.Mockito;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.util.concurrent.BlockingQueue;

import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.closeStream;
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

}
