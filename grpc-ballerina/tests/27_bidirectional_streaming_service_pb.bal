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
import ballerina/runtime;
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
    runtime:sleep(1000);
    ChatMessage27 msg1 = {name:"Sam", message:"Hi"};
    ChatMessage27 msg2 = {name:"Ann", message:"Hi"};
    ChatMessage27 msg3 = {name:"John", message:"Hi"};
    ChatMessage27[] messages = [msg1, msg2, msg3];
    foreach ChatMessage27 msg in messages {
        var r = streamingClient->send(msg);
    }
    var r = streamingClient->complete();

    var result = streamingClient->receive();
    int i = 0;
    string[] expectedOutput = ["Hi WSO2", "Hi Ballerina", "Hey WSO2", "Hey Ballerina"];
    while !(result is EOS) {
        io:println(result);
        result = streamingClient->receive();
        if (result is anydata) {
            test:assertEquals(<string> result, expectedOutput[i]);
        } else {
            test:assertFail("Unexpected output in the stream");
        }
        i += 1;
    }

}

public client class ChatClientFromReturn {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_27, getDescriptorMap27());
    }

    isolated remote function chat(Headers? headers = ()) returns (StreamingClient|Error) {
        return self.grpcClient->executeBidirectionalStreaming("ChatFromReturn/chat", headers);
    }
}
