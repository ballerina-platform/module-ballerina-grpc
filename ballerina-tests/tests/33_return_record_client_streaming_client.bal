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
import ballerina/io;
import ballerina/test;

@test:Config {enable: true}
isolated function testClientStreamingFromReturnRecord() returns grpc:Error? {
    HelloWorld33Client helloWorldEp = check new ("http://localhost:9123");
    SayHelloStreamingClient streamingClient = check helloWorldEp->sayHello();

    SampleMsg33[] requests = [
        {name: "WSO2", id: 0},
        {name: "Microsoft", id: 1},
        {name: "Facebook", id: 2},
        {name: "Google", id: 3}
    ];
    foreach var r in requests {
        check streamingClient->sendSampleMsg33(r);
    }
    check streamingClient->complete();
    io:println("Completed successfully");
    var response = check streamingClient->receiveContextSampleMsg33();
    test:assertTrue(response is ContextSampleMsg33);
    test:assertEquals(<SampleMsg33>(<ContextSampleMsg33>response).content, {name: "WSO2", id: 1});
}

@test:Config {enable: true}
isolated function testClientStreamingSendError() returns grpc:Error? {
    HelloWorld33Client helloWorldEp = check new ("http://localhost:9123");
    SayHelloStreamingClient streamingClient = check helloWorldEp->sayHello();

    check streamingClient->sendSampleMsg33({name: "WSO2", id: 0});
    check streamingClient->sendError(error grpc:UnKnownError("Unknown gRPC error occured."));
    grpc:Error? err = streamingClient->complete();
    test:assertTrue(err is grpc:Error);
    test:assertEquals((<grpc:Error>err).message(), "Client call was cancelled.");
}

@test:Config {enable: true}
isolated function testClientStreamingReceiveAfterSendError() returns grpc:Error? {
    HelloWorld33Client helloWorldEp = check new ("http://localhost:9123");
    SayHelloStreamingClient streamingClient = check helloWorldEp->sayHello();

    check streamingClient->sendSampleMsg33({name: "WSO2", id: 0});
    check streamingClient->sendError(error grpc:UnKnownError("Unknown gRPC error occured."));
    SampleMsg33|grpc:Error? err = streamingClient->receiveSampleMsg33();
    test:assertTrue(err is grpc:Error);
    test:assertEquals((<grpc:Error>err).message(), "Client call was already cancelled.");
}
