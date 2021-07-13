package io.ballerina.stdlib.grpc;

import org.testng.annotations.Test;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

import static io.ballerina.stdlib.grpc.ProtoUtils.copy;
import static org.testng.Assert.assertEquals;
import static org.testng.Assert.fail;

/**
 * Interface to initiate processing of incoming remote calls.
 * <p>
 * Referenced from grpc-java implementation.
 * <p>
 * @since 0.980.0
 */
public class ProtoUtilsTest {

    @Test()
    public void testCopy() {
        String s = "Test gRPC native";
        InputStream is = new ByteArrayInputStream(s.getBytes(StandardCharsets.UTF_8));
        OutputStream os = new ByteArrayOutputStream();
        try {
            long result = copy(is, os);
            assertEquals(result, s.length());
        } catch (IOException e) {
            fail(e.getMessage());
        }
    }
}
