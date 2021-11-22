package io.ballerina.stdlib.grpc.tools;

import org.testng.annotations.Test;

import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.assertGeneratedSources;

/**
 * gRPC tool server tests.
 */
public class ToolingServerTest {

    @Test
    public void testServerHelloWorldString() {
        assertGeneratedSources("server", "helloWorldString.proto",
                "helloWorldString_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_server_1");
    }

    @Test
    public void testServerHelloWorldInt() {
        assertGeneratedSources("server", "helloWorldInt.proto",
                    "helloWorldInt_pb.bal", "helloWorld_sample_service.bal",
                    "helloWorld_sample_client.bal", "tool_test_server_2");
    }

    @Test
    public void testServerHelloWorldFloat() {
        assertGeneratedSources("server", "helloWorldFloat.proto",
                "helloWorldFloat_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_server_3");
    }

    @Test
    public void testServerHelloWorldBoolean() {
        assertGeneratedSources("server", "helloWorldBoolean.proto",
                "helloWorldBoolean_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_server_4");
    }

    @Test
    public void testServerHelloWorldBytes() {
        assertGeneratedSources("server", "helloWorldBytes.proto",
                "helloWorldBytes_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_server_5");
    }

    @Test
    public void testServerHelloWorldMessage() {
        assertGeneratedSources("server", "helloWorldMessage.proto",
                "helloWorldMessage_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_server_6");
    }

    @Test
    public void testServerHelloWorldInputEmptyOutputMessage() {
        assertGeneratedSources("server", "helloWorldInputEmptyOutputMessage.proto",
                "helloWorldInputEmptyOutputMessage_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_server_7");
    }

    @Test
    public void testServerHelloWorldTimestamp() {
        assertGeneratedSources("server", "helloWorldTimestamp.proto",
                "helloWorldTimestamp_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_server_8");
    }
}
