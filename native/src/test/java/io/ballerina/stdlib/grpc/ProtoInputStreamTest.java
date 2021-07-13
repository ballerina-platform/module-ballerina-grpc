package io.ballerina.stdlib.grpc;

//import org.testng.annotations.Test;

import io.ballerina.stdlib.http.transport.message.HttpCarbonMessage;
import org.testng.annotations.Test;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.InputStream;

import static io.ballerina.stdlib.grpc.MessageUtils.createHttpCarbonMessage;

/**
 * Interface to initiate processing of incoming remote calls.
 * <p>
 * Referenced from grpc-java implementation.
 * <p>
 * @since 0.980.0
 */
public class ProtoInputStreamTest {

    @Test()
    public void testRead() {
        HttpCarbonMessage result = createHttpCarbonMessage(false);
        MessageFramer framer = new MessageFramer(result);
        framer.setMessageCompression(true);
        InputStream stream = new ByteArrayInputStream("ABCD".getBytes());
        framer.writePayload(stream);
    }

}
