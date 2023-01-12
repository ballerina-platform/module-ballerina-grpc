package io.ballerina.stdlib.grpc.nativeimpl.streamingclient;

import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.stdlib.grpc.GrpcConstants;
import org.mockito.Mockito;
import org.testng.Assert;
import org.testng.annotations.Test;

/**
 * A test class to test FunctionUtils class functions.
 */
public class FunctionUtilsTest {

    @Test()
    public void testStreamSendErrorCase() {
        BObject streamConnection = Mockito.mock(BObject.class);
        Mockito.when(streamConnection.getNativeData(GrpcConstants.REQUEST_SENDER)).thenReturn(null);
        Object result = FunctionUtils.streamSend(streamConnection, null);
        Assert.assertTrue(result instanceof BError);
        Assert.assertEquals(((BError) result).getMessage(), "Error while sending the " +
                "message. endpoint does not exist");
    }

    @Test()
    public void testStreamSendErrorErrorCase() {
        BObject streamConnection = Mockito.mock(BObject.class);
        Mockito.when(streamConnection.getNativeData(GrpcConstants.REQUEST_SENDER)).thenReturn(null);
        Object result = FunctionUtils.streamSendError(null, streamConnection, null);
        Assert.assertTrue(result instanceof BError);
        Assert.assertEquals(((BError) result).getMessage(), "Error while sending the " +
                "error. endpoint does not exist");
    }

    @Test()
    public void testStreamCompleteCase() {
        BObject streamConnection = Mockito.mock(BObject.class);
        Mockito.when(streamConnection.getNativeData(GrpcConstants.REQUEST_SENDER)).thenReturn(null);
        Object result = FunctionUtils.streamComplete(streamConnection);
        Assert.assertTrue(result instanceof BError);
        Assert.assertEquals(((BError) result).getMessage(), "Error while completing the " +
                "message. endpoint does not exist");
    }

}
