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
import ballerina/protobuf.types.empty;
import ballerina/protobuf.types.wrappers;
import ballerina/grpc.types.wrappers as swrappers;

const string EMPTY_VALUES_DESC = "0A1534365F656D7074795F76616C7565732E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F32EC010A0C456D70747948616E646C657212400A0E756E61727957697468456D70747912162E676F6F676C652E70726F746F6275662E456D7074791A162E676F6F676C652E70726F746F6275662E456D707479124C0A1273657276657253747257697468456D70747912162E676F6F676C652E70726F746F6275662E456D7074791A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75653001124C0A12636C69656E7453747257697468456D707479121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A162E676F6F676C652E70726F746F6275662E456D7074792801620670726F746F33";

public isolated client class EmptyHandlerClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, EMPTY_VALUES_DESC);
    }

    isolated remote function unaryWithEmpty() returns grpc:Error? {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        _ = check self.grpcClient->executeSimpleRPC("EmptyHandler/unaryWithEmpty", message, headers);
    }

    isolated remote function unaryWithEmptyContext() returns empty:ContextNil|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("EmptyHandler/unaryWithEmpty", message, headers);
        [anydata, map<string|string[]>] [_, respHeaders] = payload;
        return {headers: respHeaders};
    }

    isolated remote function clientStrWithEmpty() returns ClientStrWithEmptyStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("EmptyHandler/clientStrWithEmpty");
        return new ClientStrWithEmptyStreamingClient(sClient);
    }

    isolated remote function serverStrWithEmpty() returns stream<string, grpc:Error?>|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeServerStreaming("EmptyHandler/serverStrWithEmpty", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        swrappers:StringStream outputStream = new swrappers:StringStream(result);
        return new stream<string, grpc:Error?>(outputStream);
    }

    isolated remote function serverStrWithEmptyContext() returns wrappers:ContextStringStream|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeServerStreaming("EmptyHandler/serverStrWithEmpty", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        swrappers:StringStream outputStream = new swrappers:StringStream(result);
        return {content: new stream<string, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public client class ClientStrWithEmptyStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendString(string message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextString(wrappers:ContextString message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receive() returns grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            _ = response;
        }
    }

    isolated remote function receiveContextNil() returns empty:ContextNil|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [_, headers] = response;
            return {headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class EmptyHandlerNilCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
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

public client class EmptyHandlerStringCaller {
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

