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

import ballerina/grpc;
import ballerina/test;
import ballerina/protobuf.types.wrappers;

@test:Config {enable: true}
isolated function testStringValueReturnWithBearerTokenAuth() returns grpc:Error? {
    HelloWorld39Client helloWorldEp = check new ("http://localhost:9129");
    map<string|string[]> requestHeaders = {};

    grpc:BearerTokenConfig config = {token: "eyJhbGciOiJSUzI1NiIsICJ0eXAiOiJKV1QifQ"};

    grpc:ClientBearerTokenAuthHandler handler = new (config);
    map<string|string[]>|grpc:ClientAuthError result = handler.enrich(requestHeaders);
    if result is grpc:ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    wrappers:ContextString requestMessage = {
        content: "WSO2",
        headers: requestHeaders
    };
    var response = helloWorldEp->testStringValueReturn(requestMessage);
    if response is grpc:Error {
        test:assertFail(msg = response.message());
    } else {
        test:assertEquals(response, "Hello WSO2");
    }
}

@test:Config {enable: true}
isolated function testStringValueReturnWithInvalidBearerTokenAuth() returns grpc:Error? {
    HelloWorld39Client helloWorldEp = check new ("http://localhost:9129");
    map<string|string[]> requestHeaders = {};

    grpc:BearerTokenConfig config = {token: "ABCD"};

    grpc:ClientBearerTokenAuthHandler handler = new (config);
    map<string|string[]>|grpc:ClientAuthError result = handler.enrich(requestHeaders);
    if result is grpc:ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    wrappers:ContextString requestMessage = {
        content: "WSO2",
        headers: requestHeaders
    };
    var response = helloWorldEp->testStringValueReturn(requestMessage);
    if response is grpc:Error {
        test:assertEquals(response.message(), "Invalid basic auth token: Bearer ABCD");
    } else {
        test:assertFail(msg = "Expected grpc:Error not found.");
    }
}
