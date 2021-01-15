// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/lang.runtime as runtime;
import ballerina/test;


@test:Config {enable:true}
function testBidiStreaming() {
    ChatStreamingClient ep;
    ChatClient chatEp = new ("https://localhost:9093", {
        secureSocket: {
            trustStore: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            }
        }
    });
    // Executing unary non-blocking call registering server message listener.
    var res = chatEp->chat();
    if (res is Error) {
        string msg = io:sprintf(ERROR_MSG_FORMAT, res.message());
        io:println(msg);
        return;
    } else {
        ep = res;
    }
    runtime:sleep(1);
    ChatMessage mes1 = {name:"Sam", message:"Hi"};
    Error? connErr = ep->send(mes1);
    if (connErr is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, connErr.message()));
    }

    var responseMsg = ep->receive();
    if (responseMsg is anydata) {
        string receivedMsg = <string> responseMsg;
        test:assertEquals(receivedMsg, "Sam: Hi");
    } else {
        test:assertFail(msg = responseMsg.message());
    }

    ChatMessage mes2 = {name:"Sam", message:"GM"};
    connErr = ep->send(mes2);
    if (connErr is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, connErr.message()));
    }

    responseMsg = ep->receive();
    if (responseMsg is anydata) {
        string receivedMsg = <string> responseMsg;
        test:assertEquals(receivedMsg, "Sam: GM");
    } else {
        test:assertFail(msg = responseMsg.message());
    }

    checkpanic ep->complete();
}

public client class ChatClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_3, getDescriptorMap3());
    }

    isolated remote function chat() returns (ChatStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("Chat/chat");
        return new ChatStreamingClient(sClient);
    }
}

public client class ChatStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function send(ChatMessage message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receive() returns string|Error {
        var payload = check self.sClient->receive();
        return payload.toString();
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}
