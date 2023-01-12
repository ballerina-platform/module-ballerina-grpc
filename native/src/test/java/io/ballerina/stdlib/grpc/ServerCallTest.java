package io.ballerina.stdlib.grpc;

import org.mockito.Mockito;
import org.testng.Assert;
import org.testng.annotations.Test;

import static io.ballerina.stdlib.grpc.GrpcConstants.MESSAGE_ACCEPT_ENCODING;

/**
 * A test class to test ServerCall class functions.
 */
public class ServerCallTest {

    @Test()
    public void testServerCallReadHeadersNegative() {
        InboundMessage im = Mockito.mock(InboundMessage.class);
        OutboundMessage om = Mockito.mock(OutboundMessage.class);
        Status status = Status.fromCode(Status.Code.CANCELLED);
        Mockito.when(im.getHeader(MESSAGE_ACCEPT_ENCODING)).thenReturn("Test");
        ServerCall serverCall = new ServerCall(im, om, null, null, null, null);
        serverCall.close(status, null);
        try {
            serverCall.close(status, null);
        } catch (Exception e) {
            Assert.assertEquals(e.getMessage(), "CANCELLED: Call already closed.");
        }
    }

}
