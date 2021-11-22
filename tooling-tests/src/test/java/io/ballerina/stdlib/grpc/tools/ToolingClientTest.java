package io.ballerina.stdlib.grpc.tools;

import org.testng.annotations.Test;

import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.assertGeneratedSources;

/**
 * gRPC tool client tests.
 */
public class ToolingClientTest {

    @Test
    public void testClientHelloWorldString() {
        assertGeneratedSources("client", "helloWorldString.proto", "helloWorldString_pb.bal",
                "helloWorld_sample_service.bal", "helloWorld_sample_client.bal",
                "tool_test_client_1");
    }

    @Test
    public void testClientHelloWorldInt() {
        assertGeneratedSources("client", "helloWorldInt.proto", "helloWorldInt_pb.bal",
                "helloWorld_sample_service.bal", "helloWorld_sample_client.bal",
                "tool_test_client_2");
    }

    @Test
    public void testClientHelloWorldFloat() {
        assertGeneratedSources("client", "helloWorldFloat.proto", "helloWorldFloat_pb.bal",
                "helloWorld_sample_service.bal", "helloWorld_sample_client.bal",
                "tool_test_client_3");
    }

    @Test
    public void testClientHelloWorldBoolean() {
        assertGeneratedSources("client", "helloWorldBoolean.proto", "helloWorldBoolean_pb.bal",
                "helloWorld_sample_service.bal", "helloWorld_sample_client.bal",
                "tool_test_client_4");
    }

    @Test
    public void testClientHelloWorldBytes() {
        assertGeneratedSources("client", "helloWorldBytes.proto", "helloWorldBytes_pb.bal",
                "helloWorld_sample_service.bal", "helloWorld_sample_client.bal",
                "tool_test_client_5");
    }

    @Test
    public void testClientHelloWorldMessage() {
        assertGeneratedSources("client", "helloWorldMessage.proto",
                "helloWorldMessage_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_client_6");
    }

    @Test
    public void testClientHelloWorldInputMessageOutputEmpty() {
        assertGeneratedSources("client", "helloWorldInputMessageOutputEmpty.proto",
                "helloWorldInputMessageOutputEmpty_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_client_7");
    }

    @Test
    public void testClientHelloWorldTimestamp() {
        assertGeneratedSources("client", "helloWorldTimestamp.proto",
                "helloWorldTimestamp_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_client_8");
    }
}
