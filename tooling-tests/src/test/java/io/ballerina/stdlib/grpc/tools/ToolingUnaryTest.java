package io.ballerina.stdlib.grpc.tools;

import org.testng.annotations.Test;

import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.assertGeneratedSources;

/**
 * gRPC tool unary tests.
 */
public class ToolingUnaryTest {

    @Test
    public void testUnaryHelloWorldString() {
        assertGeneratedSources("unary", "helloWorldString.proto",
                "helloWorldString_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_unary_1");
    }

    @Test
    public void testUnaryHelloWorldStringWithSpace() {
        assertGeneratedSources("unary/with space", "helloWorldString.proto",
                "helloWorldString_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_unary_1");
    }

    @Test
    public void testUnaryHelloWorldInt() {
        assertGeneratedSources("unary", "helloWorldInt.proto",
                "helloWorldInt_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_unary_2");
    }

    @Test
    public void testUnaryHelloWorldFloat() {
        assertGeneratedSources("unary", "helloWorldFloat.proto",
                "helloWorldFloat_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_unary_3");
    }

    @Test
    public void testUnaryHelloWorldBoolean() {
        assertGeneratedSources("unary", "helloWorldBoolean.proto",
                "helloWorldBoolean_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_unary_4");
    }

    @Test
    public void testUnaryHelloWorldBytes() {
        assertGeneratedSources("unary", "helloWorldBytes.proto",
                "helloWorldBytes_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_unary_5");
    }

    @Test
    public void testUnaryHelloWorldMessage() {
        assertGeneratedSources("unary", "helloWorldMessage.proto",
                "helloWorldMessage_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_unary_6");
    }

    @Test
    public void testUnaryHelloWorldInputEmptyOutputMessage() {
        assertGeneratedSources("unary", "helloWorldInputEmptyOutputMessage.proto",
                "helloWorldInputEmptyOutputMessage_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_unary_7");
    }

    @Test
    public void testUnaryHelloWorldInputMessageOutputEmpty() {
        assertGeneratedSources("unary", "helloWorldInputMessageOutputEmpty.proto",
                "helloWorldInputMessageOutputEmpty_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_unary_8");
    }

    @Test
    public void testUnaryHelloWorldTimestamp() {
        assertGeneratedSources("unary", "helloWorldTimestamp.proto",
                "helloWorldTimestamp_pb.bal", "helloWorld_sample_service.bal",
                "helloWorld_sample_client.bal", "tool_test_unary_10");
    }
}
