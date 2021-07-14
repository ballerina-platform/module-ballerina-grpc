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

@test:Config {enable: true}
function testClientFunctionUtilsMalformedUrl() returns error? {
    HelloWorld51Client|Error hClient = new ("localhost:9151");
    if hClient is Error {
        test:assertEquals(hClient.message(), "Malformed URL: localhost:9151");
    } else {
        test:assertFail(msg = "Expected an error");
    }
}

@test:Config {enable: true}
function testClientFunctionUtilsInvalidRPCCall() returns error? {
    HelloWorld51Client hClient = check new ("http://localhost:9151");
    string|Error unaryResult = hClient->stringUnary("Hey");
    if unaryResult is Error {
        test:assertEquals(unaryResult.message(), "Error while executing the client call. Method type BIDI_STREAMING not supported");
    } else {
        test:assertFail(msg = "Expected an error");
    }
    StringClientStreamingStreamingClient|Error clientResult = hClient->stringClientStreaming();
    if clientResult is Error {
        test:assertEquals(clientResult.message(), "No registered method descriptor for 'HelloWorld51/InvalidRPCCall'");
    } else {
        test:assertFail(msg = "Expected an error");
    }
    stream<string, Error?>|Error serverResult = hClient->stringServerStreaming("Hey");
    if serverResult is Error {
        test:assertEquals(serverResult.message(), "No registered method descriptor for 'HelloWorld51/InvalidRPCCall'");
    } else {
        test:assertFail(msg = "Expected an error");
    }
    StringBiDiStreamingClient|Error biDiResult = hClient->stringBiDi();
    if biDiResult is Error {
        test:assertEquals(biDiResult.message(), "No registered method descriptor for 'HelloWorld51/InvalidRPCCall'");
    } else {
        test:assertFail(msg = "Expected an error");
    }
}
