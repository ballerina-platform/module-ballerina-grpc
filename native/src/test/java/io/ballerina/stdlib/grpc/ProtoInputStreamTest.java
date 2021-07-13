package io.ballerina.stdlib.grpc;

import org.testng.annotations.Test;

import java.io.IOException;

import static org.testng.Assert.assertEquals;
import static org.testng.Assert.fail;

/**
 * Interface to initiate processing of incoming remote calls.
 */
public class ProtoInputStreamTest {

    @Test()
    public void testRead() {
        Message message = new Message(new IllegalStateException("Illegal test case"));
        ProtoInputStream pis = new ProtoInputStream(message);
        assertEquals(pis.read(), -1);
    }

    @Test()
    public void testReadBytes() {
        Message message = new Message(new IllegalStateException("Illegal test case"));
        ProtoInputStream pis = new ProtoInputStream(message);
        try {
            assertEquals(pis.read("Bleh".getBytes(), 1, 4), -1);
        } catch (IOException e) {
            fail(e.getMessage());
        }
    }

    @Test()
    public void testMessage() {
        ProtoInputStream pis = new ProtoInputStream(null);
        try {
            pis.message();
            fail();
        } catch (IllegalStateException e) {
            assertEquals(e.getMessage(), "message not available");
        }
        Message message = new Message(new IllegalStateException("Illegal test case"));
        pis = new ProtoInputStream(message);
        assertEquals(pis.message(), message);
    }
}
