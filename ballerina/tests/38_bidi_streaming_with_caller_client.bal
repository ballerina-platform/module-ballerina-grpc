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

// Client endpoint configuration.
Chat38Client chatEp = check new("http://localhost:9128");

@test:Config {enable:true}
public function testBidiStreamingServerResponseCount () returns error? {
    // Executes the RPC call and receives the customized streaming client.
    Chat38StreamingClient streamingClient = check chatEp->chat38();

    // Sends multiple messages to the server.
    ChatMessage38[] messages = [
        {name: "Sam", message: "Hi"},
        {name: "Ann", message: "Hey"},
        {name: "John", message: "Hello"}
    ];
    foreach ChatMessage38 msg in messages {
        check streamingClient->sendChatMessage38(msg);
    }
    // Once all the messages are sent, the client sends the message to notify the server about the completion.
    check streamingClient->complete();
    // Receives the server stream response iteratively.
    int i = 0;
    var result = streamingClient->receiveString();
    while !((result is ()) ||  (result is Error)) {
        io:println(result);
        result = streamingClient->receiveString();
        i += 1;
    }
    test:assertEquals(i, 3, "Server response message count is not equal to 3");
    if (result is Error) {
        test:assertEquals(result.message(), "Request Aborted.");
    } else {
        test:assertFail("Client should receive an error response");
    }
}
