package io.ballerina.stdlib.grpc;

import io.ballerina.stdlib.http.transport.message.HttpCarbonMessage;
import org.testng.annotations.Test;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

import static io.ballerina.stdlib.grpc.MessageUtils.createHttpCarbonMessage;
import static org.testng.Assert.fail;

/**
 * Interface to initiate processing of incoming remote calls.
 */
public class MessageFramerTest {

    @Test()
    public void testWritePayload() {
        HttpCarbonMessage result = createHttpCarbonMessage(false);
        MessageFramer framer = new MessageFramer(result);
        framer.setMessageCompression(false);
        InputStream stream = new ByteArrayInputStream("Test Message".getBytes());
        try {
            framer.writePayload(stream);
            framer.flush();
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test()
    public void testWritePayloadWithCompression() {
        HttpCarbonMessage result = createHttpCarbonMessage(false);
        Compressor compressor = new Codec.Identity.Gzip();
        MessageFramer framer = new MessageFramer(result);
        framer.setCompressor(compressor);
        framer.setMessageCompression(true);
        try {
            InputStream stream = new ByteArrayInputStream("Test Message".getBytes());
            framer.writePayload(stream);
            framer.flush();
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }
}
