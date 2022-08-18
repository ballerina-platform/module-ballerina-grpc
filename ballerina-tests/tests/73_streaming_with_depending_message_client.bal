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

@test:Config {enable: true}
function testReceiveUnaryResponse() returns error? {
    HelloWorld73Client helloWorldEp = check new ("http://localhost:9173");
    ReplyMessage result = check helloWorldEp->hello73Unary("Hi");
    ReplyMessage expectedResult = {id: 1, value: "Hello"};
    test:assertEquals(result, expectedResult);
}

@test:Config {enable: true}
function testReceiveServerStreamingResponse() returns error? {
    HelloWorld73Client helloWorldEp = check new ("http://localhost:9173");
    stream<ReplyMessage, grpc:Error?> result = check helloWorldEp->hello73Server("Hi");
    int waitCount = 0;
    ReplyMessage[] expectedResults = [{id: 1, value: "Hello"}, {id: 2, value: "Hi"}];
    check result.forEach(function(ReplyMessage msg) {
        test:assertEquals(msg, expectedResults[waitCount]);
        waitCount += 1;
    });
    test:assertEquals(waitCount, 2);
}

@test:Config {enable: true}
function testReceiveClientStreamingResponse() returns error? {
    HelloWorld73Client helloWorldEp = check new ("http://localhost:9173");
    Hello73ClientStreamingClient 'client = check helloWorldEp->hello73Client();
    check 'client->sendString("Hello");
    check 'client->sendString("Hi");
    check 'client->complete();
    ReplyMessage? response = check 'client->receiveReplyMessage();
    test:assertEquals(response, {id: 1, value: "Hello"});
}

@test:Config {enable: true}
function testReceiveBidiStreamingResponse() returns error? {
    HelloWorld73Client helloWorldEp = check new ("http://localhost:9173");
    Hello73BidiStreamingClient 'client = check helloWorldEp->hello73Bidi();
    check 'client->sendString("Hello");
    check 'client->sendString("Hi");
    check 'client->complete();
    ReplyMessage? response = check 'client->receiveReplyMessage();
    test:assertEquals(response, {id: 1, value: "Hello"});
    response = check 'client->receiveReplyMessage();
    test:assertEquals(response, {id: 2, value: "Hi"});
}
