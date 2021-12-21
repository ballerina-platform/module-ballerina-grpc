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
function testClientFunctionUtilsMalformedUrl() returns error? {
    HelloWorld51Client|grpc:Error hClient = new ("localhost:9151");
    test:assertTrue(hClient is grpc:Error);
    test:assertEquals((<grpc:Error>hClient).message(), "Malformed URL: localhost:9151");
}

@test:Config {enable: true}
function testClientFunctionUtilsInvalidRPCCall() returns error? {
    HelloWorld51Client hClient = check new ("http://localhost:9151");
    string|grpc:Error unaryResult = hClient->stringUnary("Hey");
    test:assertTrue(unaryResult is grpc:Error);
    test:assertEquals((<grpc:Error>unaryResult).message(), "Error while executing the client call. Method type BIDI_STREAMING not supported");

    StringClientStreamingStreamingClient|grpc:Error clientResult = hClient->stringClientStreaming();
    test:assertTrue(clientResult is grpc:Error);
    test:assertEquals((<grpc:Error>clientResult).message(), "No registered method descriptor for 'HelloWorld51/InvalidRPCCall'");

    stream<string, error?>|grpc:Error serverResult = hClient->stringServerStreaming("Hey");
    test:assertTrue(serverResult is grpc:Error);
    test:assertEquals((<grpc:Error>serverResult).message(), "No registered method descriptor for 'HelloWorld51/InvalidRPCCall'");

    StringBiDiStreamingClient|grpc:Error biDiResult = hClient->stringBiDi();
    test:assertTrue(biDiResult is grpc:Error);
    test:assertEquals((<grpc:Error>biDiResult).message(), "No registered method descriptor for 'HelloWorld51/InvalidRPCCall'");
}
