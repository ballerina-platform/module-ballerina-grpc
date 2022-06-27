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
import grpc_tests.message2;

@test:Config {enable: true}
function testUnaryPackageWithMultipleImports() returns error? {
    packagingServiceClient 'client = check new ("http://localhost:9168");
    message2:ResMessage2 response = check 'client->hello1({req: 100, value: "Hello Service"});
    test:assertEquals(response, {req: 100, value: "Hello"});
}

@test:Config {enable: true}
function testClientStreamingPackageWithMultipleImports() returns error? {
    packagingServiceClient 'client = check new ("http://localhost:9168");
    Hello3StreamingClient streamingClient = check 'client->hello3();
    check streamingClient->sendReqMessage1({req: 100, value: "Hello Service"});
    message2:ResMessage2? response = check streamingClient->receiveResMessage2();
    test:assertEquals(response, {req: 100, value: "Hello"});
}

@test:Config {enable: true}
function testServerStreamingPackageWithMultipleImports() returns error? {
    packagingServiceClient 'client = check new ("http://localhost:9168");
    stream<message2:ResMessage2, grpc:Error?> response = check 'client->hello2({req: 100, value: "Hello Service"});
    test:assertEquals(response.next(), {value: {req: 100, value: "Hello"}});
    test:assertEquals(response.next(), {value: {req: 101, value: "Hi"}});
}

@test:Config {enable: true}
function testBidiStreamingPackageWithMultipleImports() returns error? {
    packagingServiceClient 'client = check new ("http://localhost:9168");
    Hello4StreamingClient streamingClient = check 'client->hello4();
    check streamingClient->sendReqMessage1({req: 100, value: "Hello Service"});
    message2:ResMessage2? response = check streamingClient->receiveResMessage2();
    test:assertEquals(response, {req: 100, value: "Hello"});
    response = check streamingClient->receiveResMessage2();
    test:assertEquals(response, {req: 101, value: "Hi"});
    check streamingClient->complete();
}

@test:Config {enable: true}
function testRootMessagePackageWithMultipleImports() returns error? {
    packagingServiceClient 'client = check new ("http://localhost:9168");
    Hello5StreamingClient streamingClient = check 'client->hello5();
    check streamingClient->sendRootMessage({msg: "Hello Service"});
    RootMessage? response = check streamingClient->receiveRootMessage();
    test:assertEquals(response, {msg: "Hello"});
    response = check streamingClient->receiveRootMessage();
    test:assertEquals(response, {msg: "Hi"});
    check streamingClient->complete();
}
