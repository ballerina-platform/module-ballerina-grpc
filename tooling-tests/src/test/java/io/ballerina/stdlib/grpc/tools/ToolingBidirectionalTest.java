/*
 *  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package io.ballerina.stdlib.grpc.tools;

import org.testng.annotations.Test;

import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.assertGeneratedSources;

/**
 * gRPC tool bidirectional tests.
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
