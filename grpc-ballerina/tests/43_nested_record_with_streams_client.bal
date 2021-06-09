
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
isolated function testNestedMessagesWithUnary() returns error? {
    NestedMsgServiceClient ep = check new ("http://localhost:9143");
    NestedMsg expectedMessage = {name: "Name 01", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 1}}}};
    NestedMsg message = check ep->nestedMsgUnary("Unary RPC");
    test:assertEquals(message, expectedMessage);
}

@test:Config {enable: true}
function testNestedMessagesWithServerStreaming() returns error? {
    NestedMsgServiceClient ep = check new ("http://localhost:9143");
    NestedMsg[] expectedMessages = [
        {name: "Name 01", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 1}}}}, 
        {name: "Name 02", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 2}}}}, 
        {name: "Name 03", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 3}}}}, 
        {name: "Name 04", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 4}}}}, 
        {name: "Name 05", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 5}}}}
    ];
    stream<NestedMsg, Error?> messages = check ep->nestedMsgServerStreaming("Server Streaming RPC");
    int i = 0;
    error? e = messages.forEach(function(NestedMsg m) {
        test:assertEquals(m, expectedMessages[i]);
        i += 1;
    });
    test:assertEquals(i, 5);
}

@test:Config {enable: true}
function testNestedMessagesWithClientStreaming() returns error? {
    NestedMsgServiceClient ep = check new ("http://localhost:9143");
    NestedMsg[] messages = [
        {name: "Name 01", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 1}}}}, 
        {name: "Name 02", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 2}}}}, 
        {name: "Name 03", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 3}}}}, 
        {name: "Name 04", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 4}}}}, 
        {name: "Name 05", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 5}}}}
    ];
    NestedMsgClientStreamingStreamingClient sc = check ep->nestedMsgClientStreaming();
    foreach NestedMsg m in messages {
        check sc->sendNestedMsg(m);
    }
    check sc->complete();
    string? response = check sc->receiveString();
    if response is string {
        test:assertEquals(response, "Ack 43");
    } else {
        test:assertFail(msg = "Unexpected empty response");
    }
}

@test:Config {enable: true}
function testNestedMessagesWithBidirectionalStreaming() returns error? {
    NestedMsgServiceClient ep = check new ("http://localhost:9143");
    NestedMsg[] sendingMessages = [
        {name: "N 01", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 1}}}}, 
        {name: "N 02", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 2}}}}, 
        {name: "N 03", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 3}}}}, 
        {name: "N 04", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 4}}}}, 
        {name: "N 05", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 5}}}}
    ];
    NestedMsg[] receivingMessages = [
        {name: "Name 01", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 1}}}}, 
        {name: "Name 02", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 2}}}}, 
        {name: "Name 03", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 3}}}}, 
        {name: "Name 04", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 4}}}}, 
        {name: "Name 05", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 5}}}}
    ];
    NestedMsgBidirectionalStreamingStreamingClient sc = check ep->nestedMsgBidirectionalStreaming();
    foreach NestedMsg m in sendingMessages {
        check sc->sendNestedMsg(m);
    }
    check sc->complete();
    int i = 0;
    NestedMsg? response = check sc->receiveNestedMsg();
    if response is NestedMsg {
        test:assertEquals(response, receivingMessages[i]);
        i += 1;
    }
    while !(response is ()) {
        response = check sc->receiveNestedMsg();
        if response is NestedMsg {
            test:assertEquals(response, receivingMessages[i]);
            i += 1;
        }
    }
    test:assertEquals(i, 5);
}
