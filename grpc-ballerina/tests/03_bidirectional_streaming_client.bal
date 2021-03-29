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
isolated function testBidiStreaming() returns Error? {
    ChatStreamingClient ep;
    ChatClient chatEp = check new ("https://localhost:9093", {
        secureSocket: {
            key: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            cert: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            },
            protocol:{
                name: TLS,
                versions: ["TLSv1.2", "TLSv1.1"]
            },
            ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
        }
    });
    // Executing unary non-blocking call registering server message listener.
    var res = chatEp->chat();
    if (res is Error) {
        io:println(string `Error from Connector: ${res.message()}`);
        return;
    } else {
        ep = res;
    }
    runtime:sleep(1);
    ChatMessage mes1 = {name:"Sam", message:"Hi"};
    Error? connErr = ep->sendChatMessage(mes1);
    if (connErr is Error) {
        test:assertFail(string `Error from Connector: ${connErr.message()}`);
    }

    var responseMsg = ep->receiveString();
    if responseMsg is string {
        test:assertEquals(responseMsg, "Sam: Hi");
    } else if responseMsg is error {
        test:assertFail(msg = responseMsg.message());
    }

    ChatMessage mes2 = {name:"Sam", message:"GM"};
    connErr = ep->sendChatMessage(mes2);
    if (connErr is Error) {
        test:assertFail(string `Error from Connector: ${connErr.message()}`);
    }

    responseMsg = ep->receiveString();
    if (responseMsg is string) {
        test:assertEquals(responseMsg, "Sam: GM");
    } else if (responseMsg is Error) {
        test:assertFail(msg = responseMsg.message());
    }

    checkpanic ep->complete();
}

public client class ChatClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        // initialize client endpoint.
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_3, getDescriptorMap3());
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

    isolated remote function sendChatMessage(ChatMessage message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextChatMessage(ContextChatMessage message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveString() returns string|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return payload.toString();
        }
    }

    isolated remote function receiveContextString() returns ContextString|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: payload.toString(), headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}
