// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/grpc;
import grpc_tests.messages.message2;
import grpc_tests.messages.message1;

@test:Config {enable: true}
function testUnaryPackageWithNestedModules() returns error? {
    helloWorld70Client 'client = check new ("http://localhost:9170");
    message2:ResMessage response = check 'client->helloWorld70Unary({req: 100, value: "Hello Service"});
    test:assertEquals(response, {req: 1, value: "Hello"});
}

@test:Config {enable: true}
function testClientStreamingPackageWithNestedModules() returns error? {
    helloWorld70Client 'client = check new ("http://localhost:9170");
    HelloWorld70ClientStreamStreamingClient streamingClient = check 'client->helloWorld70ClientStream();
    message1:ReqMessage m1 = {req: 1, value: "Hello Service"};
    check streamingClient->sendReqMessage(m1);
    check streamingClient->complete();
    message2:ResMessage? response = check streamingClient->receiveResMessage();
    test:assertEquals(response, {req: 1, value: "Hello"});
}

@test:Config {enable: true}
function testServerStreamingPackageWithNestedModules() returns error? {
    helloWorld70Client 'client = check new ("http://localhost:9170");
    message1:ReqMessage m1 = {req: 1, value: "Hello Service"};
    stream<message2:ResMessage, grpc:Error?> response = check 'client->helloWorld70ServerStream(m1);
    test:assertEquals(response.next(), {value: {req: 1, value: "Hello"}});
    test:assertEquals(response.next(), {value: {req: 2, value: "Hi"}});
}

@test:Config {enable: true}
function testBidiStreamingPackageWithNestedModules() returns error? {
    helloWorld70Client 'client = check new ("http://localhost:9170");
    HelloWorld70BidiStreamStreamingClient streamingClient = check 'client->helloWorld70BidiStream();
    message1:ReqMessage m1 = {req: 1, value: "Hello Service"};
    check streamingClient->sendReqMessage(m1);
    check streamingClient->complete();
    message2:ResMessage? response = check streamingClient->receiveResMessage();
    test:assertEquals(response, {req: 1, value: "Hello"});
    response = check streamingClient->receiveResMessage();
    test:assertEquals(response, {req: 2, value: "Hi"});
}
