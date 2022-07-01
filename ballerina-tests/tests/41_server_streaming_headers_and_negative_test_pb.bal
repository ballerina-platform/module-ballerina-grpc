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
import ballerina/grpc.types.wrappers as swrappers;

const string SERVER_STREAMING_HEADERS_AND_NEGATIVE_TEST_DESC = "0A3334315F7365727665725F73747265616D696E675F686561646572735F616E645F6E656761746976655F746573742E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223D0A0D436861744D657373616765343112120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D657373616765327A0A0643686174343112370A0563616C6C31120E2E436861744D65737361676534311A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565300112370A0563616C6C32120E2E436861744D65737361676534311A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75653001620670726F746F33";

public isolated client class Chat41Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SERVER_STREAMING_HEADERS_AND_NEGATIVE_TEST_DESC);
    }

    isolated remote function call1(ChatMessage41|ContextChatMessage41 req) returns stream<string, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ChatMessage41 message;
        if req is ContextChatMessage41 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("Chat41/call1", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        swrappers:StringStream outputStream = new swrappers:StringStream(result);
        return new stream<string, grpc:Error?>(outputStream);
    }

    isolated remote function call1Context(ChatMessage41|ContextChatMessage41 req) returns wrappers:ContextStringStream|grpc:Error {
        map<string|string[]> headers = {};
        ChatMessage41 message;
        if req is ContextChatMessage41 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("Chat41/call1", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        swrappers:StringStream outputStream = new swrappers:StringStream(result);
        return {content: new stream<string, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function call2(ChatMessage41|ContextChatMessage41 req) returns stream<string, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ChatMessage41 message;
        if req is ContextChatMessage41 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("Chat41/call2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        swrappers:StringStream outputStream = new swrappers:StringStream(result);
        return new stream<string, grpc:Error?>(outputStream);
    }

    isolated remote function call2Context(ChatMessage41|ContextChatMessage41 req) returns wrappers:ContextStringStream|grpc:Error {
        map<string|string[]> headers = {};
        ChatMessage41 message;
        if req is ContextChatMessage41 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("Chat41/call2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        swrappers:StringStream outputStream = new swrappers:StringStream(result);
        return {content: new stream<string, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public client class Chat41StringCaller {
    private grpc:Caller caller;

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

public type ContextChatMessage41 record {|
    ChatMessage41 content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SERVER_STREAMING_HEADERS_AND_NEGATIVE_TEST_DESC}
public type ChatMessage41 record {|
    string name = "";
    string message = "";
|};

