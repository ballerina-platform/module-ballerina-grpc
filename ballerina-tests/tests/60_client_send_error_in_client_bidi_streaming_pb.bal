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
import ballerina/protobuf.types.wrappers;

const string CLIENT_SEND_ERROR_IN_CLIENT_BIDI_STREAMING_DESC = "0A3336305F636C69656E745F73656E645F6572726F725F696E5F636C69656E745F626964695F73747265616D696E672E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32C4010A104572726F7253656E645365727669636512570A1873656E644572726F72436C69656E7453747265616D696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1B2E676F6F676C652E70726F746F6275662E496E74333256616C7565280112570A1673656E644572726F724269646953747265616D696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1B2E676F6F676C652E70726F746F6275662E496E74333256616C756528013001620670726F746F33";

public isolated client class ErrorSendServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CLIENT_SEND_ERROR_IN_CLIENT_BIDI_STREAMING_DESC);
    }

    isolated remote function sendErrorClientStreaming() returns SendErrorClientStreamingStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("ErrorSendService/sendErrorClientStreaming");
        return new SendErrorClientStreamingStreamingClient(sClient);
    }

    isolated remote function sendErrorBidiStreaming() returns SendErrorBidiStreamingStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("ErrorSendService/sendErrorBidiStreaming");
        return new SendErrorBidiStreamingStreamingClient(sClient);
    }
}

public client class SendErrorClientStreamingStreamingClient {
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

    isolated remote function receiveInt() returns int|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <int>payload;
        }
    }

    isolated remote function receiveContextInt() returns wrappers:ContextInt|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <int>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class SendErrorBidiStreamingStreamingClient {
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

    isolated remote function receiveInt() returns int|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <int>payload;
        }
    }

    isolated remote function receiveContextInt() returns wrappers:ContextInt|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <int>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class ErrorSendServiceIntCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendInt(int response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextInt(wrappers:ContextInt response) returns grpc:Error? {
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

