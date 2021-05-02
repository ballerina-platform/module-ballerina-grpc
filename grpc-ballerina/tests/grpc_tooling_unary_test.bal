// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;

@test:Config {enable:true}
function testUnaryHelloWorldString() {
    assertGeneratedSources("unary", "helloWorldString.proto", "helloWorldString_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_unary_1");
}

@test:Config {enable:true}
function testUnaryHelloWorldInt() {
    assertGeneratedSources("unary", "helloWorldInt.proto", "helloWorldInt_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_unary_2");
}

@test:Config {enable:true}
function testUnaryHelloWorldFloat() {
    assertGeneratedSources("unary", "helloWorldFloat.proto", "helloWorldFloat_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_unary_3");
}

@test:Config {enable:true}
function testUnaryHelloWorldBoolean() {
    assertGeneratedSources("unary", "helloWorldBoolean.proto", "helloWorldBoolean_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_unary_4");
}

@test:Config {enable:true}
function testUnaryHelloWorldBytes() {
    assertGeneratedSources("unary", "helloWorldBytes.proto", "helloWorldBytes_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_unary_5");
}

@test:Config {enable:true}
function testUnaryHelloWorldMessage() {
    assertGeneratedSources("unary", "helloWorldMessage.proto", "helloWorldMessage_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_unary_6");
}

@test:Config {enable:true}
function testUnaryHelloWorldInputEmptyOutputMessage() {
    assertGeneratedSources("unary", "helloWorldInputEmptyOutputMessage.proto", "helloWorldInputEmptyOutputMessage_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_unary_7");
}

@test:Config {enable:true}
function testUnaryHelloWorldInputMessageOutputEmpty() {
    assertGeneratedSources("unary", "helloWorldInputMessageOutputEmpty.proto", "helloWorldInputMessageOutputEmpty_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_unary_8");
}
