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
 * gRPC tool unary tests.
 */
public class ToolingUnaryTest {

    @Test
    public void testUnaryHelloWorldString() {
        assertGeneratedSources("unary", "helloWorldString.proto",
                "helloWorldString_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_unary_1");
    }

    @Test
    public void testUnaryHelloWorldStringWithSpace() {
        assertGeneratedSources("unary/with space", "helloWorldString.proto",
                "helloWorldString_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_unary_1");
    }

    @Test
    public void testUnaryHelloWorldInt() {
        assertGeneratedSources("unary", "helloWorldInt.proto",
                "helloWorldInt_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_unary_2");
    }

    @Test
    public void testUnaryHelloWorldFloat() {
        assertGeneratedSources("unary", "helloWorldFloat.proto",
                "helloWorldFloat_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_unary_3");
    }

    @Test
    public void testUnaryHelloWorldBoolean() {
        assertGeneratedSources("unary", "helloWorldBoolean.proto",
                "helloWorldBoolean_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_unary_4");
    }

    @Test
    public void testUnaryHelloWorldBytes() {
        assertGeneratedSources("unary", "helloWorldBytes.proto",
                "helloWorldBytes_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_unary_5");
    }

    @Test
    public void testUnaryHelloWorldMessage() {
        assertGeneratedSources("unary", "helloWorldMessage.proto",
                "helloWorldMessage_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_unary_6");
    }

    @Test
    public void testUnaryHelloWorldInputEmptyOutputMessage() {
        assertGeneratedSources("unary", "helloWorldInputEmptyOutputMessage.proto",
                "helloWorldInputEmptyOutputMessage_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_unary_7");
    }

    @Test
    public void testUnaryHelloWorldInputMessageOutputEmpty() {
        assertGeneratedSources("unary", "helloWorldInputMessageOutputEmpty.proto",
                "helloWorldInputMessageOutputEmpty_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_unary_8");
    }

    @Test
    public void testUnaryHelloWorldTimestamp() {
        assertGeneratedSources("unary", "helloWorldTimestamp.proto",
                "helloWorldTimestamp_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_unary_10");
    }
}
