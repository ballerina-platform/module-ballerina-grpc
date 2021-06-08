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

import ballerina/io;
import ballerina/test;

@test:Config {enable:true}
isolated function testClientStreamingFromReturnRecord() returns Error? {
    HelloWorld33Client helloWorldEp = check new ("http://localhost:9123");
    SayHelloStreamingClient streamingClient;
    var res = helloWorldEp->sayHello();
    if (res is Error) {
        test:assertFail("Error from Connector: " + res.message());
        return;
    } else {
        streamingClient = res;
    }
    io:println("Initialized connection sucessfully.");
    SampleMsg33[] requests = [
        {name: "WSO2", id: 0},
        {name: "Microsoft", id: 1},
        {name: "Facebook", id: 2},
        {name: "Google", id: 3}
    ];
    foreach var r in requests {
        Error? err = streamingClient->sendSampleMsg33(r);
        if (err is Error) {
            test:assertFail("Error from Connector: " + err.message());
        }
    }
    check streamingClient->complete();
    io:println("Completed successfully");
    var response = check streamingClient->receiveContextSampleMsg33();
    if response is ContextSampleMsg33 {
        test:assertEquals(<SampleMsg33>response.content, {name: "WSO2", id: 1});
    }
}

@test:Config {enable:true}
isolated function testClientStreamingSendError() returns Error? {
    HelloWorld33Client helloWorldEp = check new ("http://localhost:9123");
    SayHelloStreamingClient streamingClient;
    var res = helloWorldEp->sayHello();
    if (res is Error) {
        test:assertFail("Error from Connector: " + res.message());
        return;
    } else {
        streamingClient = res;
    }
    io:println("Initialized connection sucessfully.");

    Error? err1 = streamingClient->sendSampleMsg33({name: "WSO2", id: 0});
    Error? err2 = streamingClient->sendError(error UnKnownError("Unknown gRPC error occured."));
    Error? err3 = streamingClient->complete();
    if err3 is Error {
        test:assertEquals(err3.message(), "Client call was cancelled.");
    } else {
        test:assertFail("Expected grpc:Error not found");
    }
}
