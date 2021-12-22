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

import ballerina/grpc;
import ballerina/test;

@test:Config {enable: true}
isolated function testBidiStreamingInChatClient() returns grpc:Error? {

    //Client endpoint configuration.
    Chat17Client chatEp = check new ("https://localhost:9093",
        secureSocket = {
        key: {
            path: KEYSTORE_PATH,
            password: "ballerina"
        },
        cert: {
            path: TRUSTSTORE_PATH,
            password: "ballerina"
        },
        protocol: {
            name: grpc:TLS,
            versions: ["TLSv1.2", "TLSv1.1"]
        },
        ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
    });

    // Executes unary non-blocking call registering server message listener.
    grpc:StreamingClient ep = check chatEp->chat();
    // Produces a message to the specified subject.
    ChatMessage mes = {name: "Sam", message: "Hi"};
    check ep->send(mes);

    [anydata, map<string|string[]>]? responseMsg = check ep->receive();
    test:assertFalse(responseMsg is ());
    if !(responseMsg is ()) {
        [anydata, map<string|string[]>] [content, _] = responseMsg;
        test:assertEquals(content.toString(), "Sam: Hi");
    }

    // Once all messages are sent, client send complete message to notify the server, I’m done.
    check ep->complete();
}

public isolated client class Chat17Client {

    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        // initialize client endpoint.
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_17_BIDIRECTIONAL_CHAT_CLIENT, getDescriptorMap17BidirectionalChatClient());
    }

    isolated remote function chat(map<string|string[]> headers = {}) returns (grpc:StreamingClient|grpc:Error) {
        return self.grpcClient->executeBidirectionalStreaming("Chat/chat", headers);
    }
}

const string ROOT_DESCRIPTOR_17_BIDIRECTIONAL_CHAT_CLIENT = "0A2830335F6269646972656374696F6E616C5F73747265616D696E675F736572766963652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223B0A0B436861744D65737361676512120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D657373616765323E0A044368617412360A0463686174120C2E436861744D6573736167651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756528013001620670726F746F33";

isolated function getDescriptorMap17BidirectionalChatClient() returns map<string> {
    return {
        "03_bidirectional_streaming_service.proto": "0A2830335F6269646972656374696F6E616C5F73747265616D696E675F736572766963652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223B0A0B436861744D65737361676512120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D657373616765323E0A044368617412360A0463686174120C2E436861744D6573736167651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756528013001620670726F746F33",
        "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C7565427C0A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A2A6769746875622E636F6D2F676F6C616E672F70726F746F6275662F7074797065732F7772617070657273F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"

    };
}
