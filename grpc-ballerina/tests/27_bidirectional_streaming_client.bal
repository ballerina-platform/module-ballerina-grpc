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
function testBidiStreamingFromReturn() {
    StreamingClient streamingClient = new;
    ChatClientFromReturn chatEp = new ("http://localhost:9117");
    // Executing unary non-blocking call registering server message listener.
    var res = chatEp->chat();
    if (res is Error) {
        string msg = io:sprintf(ERROR_MSG_FORMAT, res.message());
        io:println(msg);
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
        var r = streamingClient->send(msg);
    }
    var r = streamingClient->complete();
    int i = 0;
    string[] expectedOutput = ["Hi Sam", "Hey Ann", "Hello John", "How are you Jack"];
    var result = streamingClient->receive();
    while !(result is EOS) {
        io:println(result);
        if (result is Error) {
            test:assertFail("Unexpected output in the stream");
        } else {
            [anydata, map<string|string[]>][content, headers] = result;
            test:assertEquals(content.toString(), expectedOutput[i]);
        }
        result = streamingClient->receive();
        i += 1;
    }
    test:assertEquals(i, 4);
}

public client class ChatClientFromReturn {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_27, getDescriptorMap27());
    }

    isolated remote function chat() returns (StreamingClient|Error) {
        return self.grpcClient->executeBidirectionalStreaming("ChatFromReturn/chat");
    }
}
