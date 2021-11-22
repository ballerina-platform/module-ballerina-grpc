package io.ballerina.stdlib.grpc.tools;

import org.testng.annotations.Test;

import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.assertGeneratedSources;

/**
 * gRPC tool common tests.
 */
public class ToolingBidirectionalTest {

    @Test
    public void testBidirectionalHelloWorldString() {
        assertGeneratedSources("bidirectional", "helloWorldString.proto",
                "helloWorldString_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_bidirectional_1");
    }

    @Test
    public void testBidirectionalHelloWorldInt() {
        assertGeneratedSources("bidirectional", "helloWorldInt.proto",
                "helloWorldInt_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_bidirectional_2");
    }

    @Test
    public void testBidirectionalHelloWorldFloat() {
        assertGeneratedSources("bidirectional", "helloWorldFloat.proto",
                "helloWorldFloat_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_bidirectional_3");
    }

    @Test
    public void testBidirectionalHelloWorldBoolean() {
        assertGeneratedSources("bidirectional", "helloWorldBoolean.proto",
                "helloWorldBoolean_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_bidirectional_4");
    }

    @Test
    public void testBidirectionalHelloWorldBytes() {
        assertGeneratedSources("bidirectional", "helloWorldBytes.proto",
                "helloWorldBytes_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_bidirectional_5");
    }

    @Test
    public void testBidirectionalHelloWorldMessage() {
        assertGeneratedSources("bidirectional", "helloWorldMessage.proto",
                "helloWorldMessage_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_bidirectional_6");
    }

    @Test
    public void testBidirectionalHelloWorldTimestamp() {
        assertGeneratedSources("bidirectional", "helloWorldTimestamp.proto",
                "helloWorldTimestamp_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_bidirectional_7");
    }
}
