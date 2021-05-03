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
function testClientHelloWorldString() {
    var result = assertGeneratedSources("client", "helloWorldString.proto", "helloWorldString_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_client_1");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testClientHelloWorldInt() {
    var result = assertGeneratedSources("client", "helloWorldInt.proto", "helloWorldInt_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_client_2");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testClientHelloWorldFloat() {
    var result = assertGeneratedSources("client", "helloWorldFloat.proto", "helloWorldFloat_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_client_3");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testClientHelloWorldBoolean() {
    var result = assertGeneratedSources("client", "helloWorldBoolean.proto", "helloWorldBoolean_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_client_4");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testClientHelloWorldBytes() {
    var result = assertGeneratedSources("client", "helloWorldBytes.proto", "helloWorldBytes_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_client_5");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testClientHelloWorldMessage() {
    var result = assertGeneratedSources("client", "helloWorldMessage.proto", "helloWorldMessage_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_client_6");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testClientHelloWorldInputMessageOutputEmpty() {
    var result = assertGeneratedSources("client", "helloWorldInputMessageOutputEmpty.proto", "helloWorldInputMessageOutputEmpty_pb.bal", "helloWorld_sample_service.bal", "helloWorld_sample_client.bal", "tool_test_client_7");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}
