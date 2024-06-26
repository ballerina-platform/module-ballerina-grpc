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

const string BIDIRECTIONAL_STREAMING_NEGATIVE_TEST_DESC = "0A2E34305F6269646972656374696F6E616C5F73747265616D696E675F6E656761746976655F746573742E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223D0A0D436861744D657373616765343012120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D657373616765324A0A0E436861745769746843616C6C657212380A0463616C6C120E2E436861744D65737361676534301A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756528013001620670726F746F33";

public isolated client class ChatWithCallerClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, BIDIRECTIONAL_STREAMING_NEGATIVE_TEST_DESC);
    }

    isolated remote function call() returns CallStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("ChatWithCaller/call");
        return new CallStreamingClient(sClient);
    }
}

public isolated client class CallStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendChatMessage40(ChatMessage40 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextChatMessage40(ContextChatMessage40 message) returns grpc:Error? {
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

public isolated client class ChatWithCallerStringCaller {
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

public type ContextChatMessage40Stream record {|
    stream<ChatMessage40, error?> content;
    map<string|string[]> headers;
|};

public type ContextChatMessage40 record {|
    ChatMessage40 content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: BIDIRECTIONAL_STREAMING_NEGATIVE_TEST_DESC}
public type ChatMessage40 record {|
    string name = "";
    string message = "";
|};

