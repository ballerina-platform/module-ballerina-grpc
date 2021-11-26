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
