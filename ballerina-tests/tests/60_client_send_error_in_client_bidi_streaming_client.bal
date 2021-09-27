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
import ballerina/lang.runtime;

@test:Config {enable:true}
isolated function testClientStreamingSendErrorToService() returns grpc:Error? {
    SendErrorClient errorClient = check new ("http://localhost:9160");
    SendErrorClientStreamingStreamingClient streamingClient = check errorClient->sendErrorClientStreaming();

    check streamingClient->sendString("Hey");
    check streamingClient->sendError(error grpc:UnKnownError("Unknown gRPC error occured."));
    
    runtime:sleep(3);

    streamingClient = check errorClient->sendErrorClientStreaming();
    check streamingClient->sendString("Hello");
    check streamingClient->complete();
    boolean? errorStatus = check streamingClient->receiveBoolean();
    
    if errorStatus != () {
        test:assertTrue(errorStatus);
    } else {
        test:assertFail("Server has not received the error sent by the client");
    }
}

@test:Config {enable:true}
isolated function testBidiStreamingSendErrorToService() returns grpc:Error? {
    SendErrorClient errorClient = check new ("http://localhost:9160");
    SendErrorBidiStreamingStreamingClient streamingClient = check errorClient->sendErrorBidiStreaming();

    check streamingClient->sendString("Hey");
    check streamingClient->sendError(error grpc:AbortedError("Operation is aborted."));
    check streamingClient->complete();
    runtime:sleep(3);

    streamingClient = check errorClient->sendErrorBidiStreaming();
    check streamingClient->sendString("Hello");
    check streamingClient->complete();
    boolean? errorStatus = check streamingClient->receiveBoolean();

    if errorStatus != () {
        test:assertTrue(errorStatus);
    } else {
        test:assertFail("Server has not received the error sent by the client");
    }
}
