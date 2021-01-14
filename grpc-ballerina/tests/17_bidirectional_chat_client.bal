// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

string responseChatMsg = "";

@test:Config {enable:true}
public function testBidiStreamingInChatClient() {

    //Client endpoint configuration.
    Chat17Client chatEp = new("https://localhost:9093", {
        secureSocket: {
            trustStore: {
                path: TRUSTSTORE_PATH,
                password: "ballerina"
            }
        }
    });

    StreamingClient ep;
    // Executes unary non-blocking call registering server message listener.
    var res = chatEp->chat(Chat17MessageListener);
    if (res is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, res.message()));
        return;
    } else {
        ep = res;
    }
    runtime:sleep(1000);
    // Produces a message to the specified subject.
    ChatMessage mes = {name: "Sam", message: "Hi"};
    Error? result = ep->send(mes);
    if (result is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, result.message()));
    }
    if (!isValidResponse("Sam: Hi")) {
        test:assertFail(io:sprintf(RESP_MSG_FORMAT, "Sam: Hi", responseChatMsg));
    } else {
        responseChatMsg = "";
    }

    // Once all messages are sent, client send complete message to notify the server, I’m done.
    checkpanic ep->complete();
}

function isValidResponse(string expectedMsg) returns boolean {
    int waitCount = 0;
    while(responseChatMsg == "") {
        runtime:sleep(1000);
        io:println("response message: ", responseChatMsg);
        if (waitCount > 10) {
            break;
        }
        waitCount += 1;
    }
    return responseChatMsg == expectedMsg;
}


service object {} Chat17MessageListener = service object {

    // Resource registered to receive server messages.
    remote function onMessage(string message) {
        responseChatMsg = <@untainted> message;
        io:println("Response received from server: " + responseChatMsg);
    }

    // Resource registered to receive server error messages.
    remote function onError(error err) {
        responseChatMsg = io:sprintf(ERROR_MSG_FORMAT, err.message());
        io:println(responseChatMsg);
    }

    // Resource registered to receive server completed message.
    remote function onComplete() {
        io:println("Server Complete Sending Responses.");
    }
};

// Non-blocking client endpoint
public client class Chat17Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_17, getDescriptorMap17());
    }


    isolated remote function chat(service object {} msgListener, map<string[]> headers = {}) returns (StreamingClient|Error) {
        return self.grpcClient->streamingExecute("Chat/chat", msgListener, headers);
    }
}

const string ROOT_DESCRIPTOR_17 = "0A2830335F6269646972656374696F6E616C5F73747265616D696E675F736572766963652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223B0A0B436861744D65737361676512120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D657373616765323E0A044368617412360A0463686174120C2E436861744D6573736167651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756528013001620670726F746F33";
isolated function getDescriptorMap17() returns map<string> {
    return {
        "03_bidirectional_streaming_service.proto":"0A2830335F6269646972656374696F6E616C5F73747265616D696E675F736572766963652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223B0A0B436861744D65737361676512120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D657373616765323E0A044368617412360A0463686174120C2E436861744D6573736167651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756528013001620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C7565427C0A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A2A6769746875622E636F6D2F676F6C616E672F70726F746F6275662F7074797065732F7772617070657273F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"

    };
}
