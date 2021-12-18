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

@test:Config {enable: true}
function testUnaryCases() returns grpc:Error? {
    HelloWorld62Client helloWorldEp = check new ("http://localhost:9162", maxInboundMessageSize = 1024);

    // Sending a normal size message
    string response = check helloWorldEp->msgSizeUnary("small");
    test:assertEquals(response, "Hello Client");

    // Sending a large message than the `maxInboundMessageSize`
    string|grpc:Error result = helloWorldEp->msgSizeUnary(LARGE_PAYLOAD);
    test:assertTrue(result is error);
    if result is error {
        test:assertEquals(result.message(), "HTTP status code 500\ninvalid content-type: text/plain\nMESSAGE DATA: Frame size 2503 exceeds maximum: 1024.");
    }

    // Receiving a large message than the `maxInboundMessageSize`
    result = helloWorldEp->msgSizeUnary("large");
    test:assertTrue(result is error);
    test:assertEquals((<error>result).message(), "Frame size 2503 exceeds maximum: 1024.");
}

@test:Config {enable: true}
function testClientStreamingCases() returns grpc:Error? {
    string[] requests = ["Hi", "Hey", "Hello"];

    HelloWorld62Client helloWorldEp = check new ("http://localhost:9162", maxInboundMessageSize = 1024);

    // Streaming normal size messages
    MsgSizeClientStreamingStreamingClient streamingClient = check helloWorldEp->msgSizeClientStreaming();

    foreach string request in requests {
        grpc:Error? err = streamingClient->sendString(request);
        if err is grpc:Error {
            test:assertFail("Error from Connector: " + err.message());
        }
    }
    check streamingClient->complete();
    string? response = check streamingClient->receiveString();
    test:assertEquals(response, "Hello Client");

    // Receiving large size messages
    streamingClient = check helloWorldEp->msgSizeClientStreaming();

    check streamingClient->sendString("large");
    check streamingClient->complete();

    string|grpc:Error? result = streamingClient->receiveString();
    test:assertTrue(result is error);
    test:assertEquals((<error>result).message(), "Frame size 2503 exceeds maximum: 1024.");

    // Streaming large size messages
    streamingClient = check helloWorldEp->msgSizeClientStreaming();

    check streamingClient->sendString(LARGE_PAYLOAD);
    check streamingClient->complete();

    result = streamingClient->receiveString();
    test:assertTrue(result is error);
    test:assertEquals((<error>result).message(), "HTTP status code 500\ninvalid content-type: text/plain\nMESSAGE DATA: Frame size 2503 exceeds maximum: 1024.");
}

@test:Config {enable: true}
function testServerStreamingCases() returns error? {
    HelloWorld62Client helloWorldEp = check new ("http://localhost:9162", maxInboundMessageSize = 1024);

    // Streaming normal size messages
    stream<string, error?> response = check helloWorldEp->msgSizeServerStreaming("small");

    check response.forEach(function(anydata value) {
        test:assertEquals(value, "Hello Client");
    });

    // Receiving large size messages
    response = check helloWorldEp->msgSizeServerStreaming("large");

    error? err = response.forEach(function(anydata value) {
        test:assertFail("Expected error from client");
    });
    test:assertTrue(err is error);
    test:assertEquals((<error>err).message(), "Frame size 2503 exceeds maximum: 1024.");

    // Sending large size messages
    response = check helloWorldEp->msgSizeServerStreaming(LARGE_PAYLOAD);

    err = response.forEach(function(anydata value) {
        test:assertFail("Expected error from client");
    });
    test:assertTrue(err is error);
    test:assertEquals((<error>err).message(), "HTTP status code 500\ninvalid content-type: text/plain\nMESSAGE DATA: Frame size 2503 exceeds maximum: 1024.");
}

@test:Config {enable: true}
function testBidiStreamingCases() returns grpc:Error? {
    string[] requests = ["Hi", "Hey", "Hello"];

    HelloWorld62Client helloWorldEp = check new ("http://localhost:9162", maxInboundMessageSize = 1024);

    // Streaming normal size messages
    MsgSizeBidiStreamingStreamingClient streamingClient = check helloWorldEp->msgSizeBidiStreaming();

    foreach string request in requests {
        grpc:Error? err = streamingClient->sendString(request);
        if err is grpc:Error {
            test:assertFail("Error from Connector: " + err.message());
        }
    }
    check streamingClient->complete();

    int count = 0;

    foreach string request in requests {
        string? res = check streamingClient->receiveString();
        test:assertEquals(res, request);
        count += 1;
    }
    test:assertEquals(count, 3);

    // Receiving large size messages
    streamingClient = check helloWorldEp->msgSizeBidiStreaming();

    check streamingClient->sendString("large");
    check streamingClient->complete();
    string|grpc:Error? result = streamingClient->receiveString();
    test:assertTrue(result is error);
    test:assertEquals((<error>result).message(), "Frame size 2503 exceeds maximum: 1024.");

    // Streaming large size messages
    streamingClient = check helloWorldEp->msgSizeBidiStreaming();
    check streamingClient->sendString(LARGE_PAYLOAD);
    check streamingClient->complete();
    result = streamingClient->receiveString();
    test:assertTrue(result is error);
    test:assertEquals((<error>result).message(), "HTTP status code 500\ninvalid content-type: text/plain\nMESSAGE DATA: Frame size 2503 exceeds maximum: 1024.");
}
