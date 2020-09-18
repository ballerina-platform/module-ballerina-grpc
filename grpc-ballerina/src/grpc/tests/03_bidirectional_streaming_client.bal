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
import ballerina/runtime;
import ballerina/test;

string responseMsg = "";

@test:Config {}
public function testBidiStreaming() {
    StreamingClient ep = new;
    ChatClient chatEp = new ("https://localhost:9093", {
        secureSocket: {
            trustStore: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            }
        }
    });
    // Executing unary non-blocking call registering server message listener.
    var res = chatEp->chat(ChatMessageListener);
    if (res is Error) {
        string msg = io:sprintf(ERROR_MSG_FORMAT, res.message());
        io:println(msg);
    } else {
        ep = res;
    }
    runtime:sleep(1000);
    ChatMessage mes1 = {name:"Sam", message:"Hi"};
    Error? connErr = ep->send(mes1);
    if (connErr is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, connErr.message()));
    }
    if (!responseReceived("Sam: Hi")) {
        test:assertFail(io:sprintf(RESP_MSG_FORMAT, "Sam: Hi", responseMsg));
    } else {
        responseMsg = "";
    }

    ChatMessage mes2 = {name:"Sam", message:"GM"};
    connErr = ep->send(mes2);
    if (connErr is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, connErr.message()));
    }
    if (!responseReceived("Sam: GM")) {
        test:assertFail(io:sprintf(RESP_MSG_FORMAT, "Sam: GM", responseMsg));
    }

    checkpanic ep->complete();
}

function responseReceived(string expectedMsg) returns boolean {
    int waitCount = 0;
    while(responseMsg == "") {
        runtime:sleep(1000);
        io:println("response message: ", responseMsg);
        if (waitCount > 10) {
            break;
        }
        waitCount += 1;
    }
    return responseMsg == expectedMsg;
}

service ChatMessageListener = service {

    function onMessage(string message) {
        responseMsg = <@untainted> message;
        io:println("Response received from server: " + responseMsg);
    }

    function onError(error err) {
        responseMsg = io:sprintf(ERROR_MSG_FORMAT, err.message());
        io:println(responseMsg);
    }

    resource function onComplete() {
        io:println("Server Complete Sending Responses.");
    }
};


// Non-blocking client endpoint
public client class ChatClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_3, getDescriptorMap3());
    }

    public isolated remote function chat(service msgListener, Headers? headers = ()) returns
    (StreamingClient|Error) {
        return self.grpcClient->streamingExecute("Chat/chat", msgListener, headers);
    }
}
