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

import ballerina/grpc;
import ballerina/protobuf;
import ballerina/protobuf.types.wrappers;

const string BIDI_STREAMING_WITH_CALLER_DESC = "0A2333385F626964695F73747265616D696E675F776974685F63616C6C65722E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223D0A0D436861744D657373616765333812120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D65737361676532440A06436861743338123A0A06636861743338120E2E436861744D65737361676533381A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756528013001620670726F746F33";

public isolated client class Chat38Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, BIDI_STREAMING_WITH_CALLER_DESC);
    }

    isolated remote function chat38() returns Chat38StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("Chat38/chat38");
        return new Chat38StreamingClient(sClient);
    }
}

public isolated client class Chat38StreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendChatMessage38(ChatMessage38 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextChatMessage38(ContextChatMessage38 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveString() returns string|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return payload.toString();
        }
    }

    isolated remote function receiveContextString() returns wrappers:ContextString|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: payload.toString(), headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class Chat38StringCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendString(string response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextString(wrappers:ContextString response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextChatMessage38Stream record {|
    stream<ChatMessage38, error?> content;
    map<string|string[]> headers;
|};

public type ContextChatMessage38 record {|
    ChatMessage38 content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: BIDI_STREAMING_WITH_CALLER_DESC}
public type ChatMessage38 record {|
    string name = "";
    string message = "";
|};

