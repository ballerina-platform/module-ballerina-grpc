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
// This is client implementation for bidirectional streaming scenario

import ballerina/io;
import ballerina/test;

@test:Config {enable:true}
isolated function testBidiStreamingFromReturn() returns Error? {
    Chat27StreamingClient streamingClient;
    ChatFromReturnClient chatEp = check new ("http://localhost:9117");
    // Executing unary non-blocking call registering server message listener.
    var res = chatEp->chat27();
    if (res is Error) {
        io:println(string `Error from Connector: ${res.message()}`);
        return;
    } else {
        streamingClient = res;
    }

    ChatMessage27[] messages = [
        {name:"Sam", message:"Hi"},
        {name:"Ann", message:"Hey"},
        {name:"John", message:"Hello"},
        {name:"Jack", message:"How are you"}
    ];
    foreach ChatMessage27 msg in messages {
        error? r = streamingClient->sendChatMessage27(msg);
    }
    error? r = streamingClient->complete();
    int i = 0;
    string[] expectedOutput = ["Hi Sam", "Hey Ann", "Hello John", "How are you Jack"];
    var result = streamingClient->receiveString();
    while !(result is ()) {
        io:println(result);
        if (result is Error) {
            test:assertFail("Unexpected output in the stream");
        } else {
            test:assertEquals(result, expectedOutput[i]);
        }
        result = streamingClient->receiveString();
        i += 1;
    }
    test:assertEquals(i, 4);
}
