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
// This is server implementation for bidirectional streaming scenario

public isolated client class Chat38Client {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_38, getDescriptorMap38());
    }

    isolated remote function chat38() returns (Chat38StreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("Chat38/chat38");
        return new Chat38StreamingClient(sClient);
    }
}

public client class Chat38StreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendChatMessage38(ChatMessage38 message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextChatMessage38(ContextChatMessage38 message) returns Error? {
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

public client class Chat38StringCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendString(string response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextString(ContextString response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

//public type ContextStringStream record {|
//    stream<string, error?> content;
//    map<string|string[]> headers;
//|};

//public type ContextString record {|
//    string content;
//    map<string|string[]> headers;
//|};

public type ContextChatMessage38Stream record {|
    stream<ChatMessage38, error?> content;
    map<string|string[]> headers;
|};

public type ContextChatMessage38 record {|
    ChatMessage38 content;
    map<string|string[]> headers;
|};

public type ChatMessage38 record {|
    string name = "";
    string message = "";
|};

const string ROOT_DESCRIPTOR_38 = "0A2333385F626964695F73747265616D696E675F776974685F63616C6C65722E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223D0A0D436861744D657373616765333812120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D65737361676532440A06436861743338123A0A06636861743338120E2E436861744D65737361676533381A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756528013001620670726F746F33";

isolated function getDescriptorMap38() returns map<string> {
    return {"38_bidi_streaming_with_caller.proto": "0A2333385F626964695F73747265616D696E675F776974685F63616C6C65722E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223D0A0D436861744D657373616765333812120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D65737361676532440A06436861743338123A0A06636861743338120E2E436861744D65737361676533381A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756528013001620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

