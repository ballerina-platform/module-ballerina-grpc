// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
isolated function testClientStreaming() returns grpc:Error? {
    string[] requests = ["Hi Sam", "Hey Sam", "GM Sam"];
    // Client endpoint configuration
    HelloWorld7Client helloWorldEp = check new ("http://localhost:9094");

    LotsOfGreetingsStreamingClient ep = check helloWorldEp->lotsOfGreetings();
    // Executing unary non-blocking call registering server message listener.
    foreach var greet in requests {
        check ep->sendString(greet);
    }
    check ep->complete();
    anydata response = check ep->receiveString();
    test:assertEquals(<string>response, "Ack");
}

@test:Config {enable: true}
isolated function testClientStreamingSendMessageAfterError() returns grpc:Error? {
    HelloWorld7Client helloWorldEp = check new ("http://localhost:9094");
    LotsOfGreetingsStreamingClient res = check helloWorldEp->lotsOfGreetings();

    check res->sendError(error grpc:AbortedError("Aborted for testing"));
    grpc:Error? err = res->sendString("Hey");
    test:assertTrue(err is grpc:Error);
    test:assertEquals((<grpc:Error>err).message(), "Client call was already cancelled.");
}

@test:Config {enable: true}
isolated function testClientStreamingSendMessageAfterComplete() returns grpc:Error? {
    grpc:ClientConfiguration config = {
        compression: grpc:COMPRESSION_ALWAYS
    };
    HelloWorld7Client helloWorldEp = check new ("http://localhost:9094", config);
    LotsOfGreetingsStreamingClient res = check helloWorldEp->lotsOfGreetings();
    grpc:Error? err = res->sendString("Hey");
    check res->complete();
    err = res->sendString("Hey");
    test:assertTrue(err is grpc:Error);
    test:assertEquals((<grpc:Error>err).message(), "Client call was already closed.");
}
