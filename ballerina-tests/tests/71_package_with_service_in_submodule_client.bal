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
import grpc_tests.messageWithService;

@test:Config {enable: true}
function testUnaryPackageWithServiceInSubmodule() returns error? {
    helloWorld71Client 'client = check new ("http://localhost:9171");
    messageWithService:ResMessage response = check 'client->helloWorld71Unary({req: 100, value: "Hello Service"});
    test:assertEquals(response, {req: 1, value: "Hello"});
}

@test:Config {enable: true}
function testClientStreamingPackageWithServiceInSubmodule() returns error? {
    helloWorld71Client 'client = check new ("http://localhost:9171");
    HelloWorld71ClientStreamStreamingClient streamingClient = check 'client->helloWorld71ClientStream();
    messageWithService:ReqMessage m1 = {req: 1, value: "Hello Service"};
    check streamingClient->sendReqMessage(m1);
    check streamingClient->complete();
    messageWithService:ResMessage? response = check streamingClient->receiveResMessage();
    test:assertEquals(response, {req: 1, value: "Hello"});
}

@test:Config {enable: true}
function testServerStreamingPackageWithServiceInSubmodule() returns error? {
    helloWorld71Client 'client = check new ("http://localhost:9171");
    messageWithService:ReqMessage m1 = {req: 1, value: "Hello Service"};
    stream<messageWithService:ResMessage, grpc:Error?> response = check 'client->helloWorld71ServerStream(m1);
    test:assertEquals(response.next(), {value: {req: 1, value: "Hello"}});
    test:assertEquals(response.next(), {value: {req: 2, value: "Hi"}});
}

@test:Config {enable: true}
function testBidiStreamingPackageWithServiceInSubmodule() returns error? {
    helloWorld71Client 'client = check new ("http://localhost:9171");
    HelloWorld71BidiStreamStreamingClient streamingClient = check 'client->helloWorld71BidiStream();
    messageWithService:ReqMessage m1 = {req: 1, value: "Hello Service"};
    check streamingClient->sendReqMessage(m1);
    check streamingClient->complete();
    messageWithService:ResMessage? response = check streamingClient->receiveResMessage();
    test:assertEquals(response, {req: 1, value: "Hello"});
    response = check streamingClient->receiveResMessage();
    test:assertEquals(response, {req: 2, value: "Hi"});
}
