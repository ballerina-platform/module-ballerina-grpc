// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

const string STREAMING_WITH_DEPENDING_MESSAGE_DESC = "0A2937335F73747265616D696E675F776974685F646570656E64696E675F6D6573736167652E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1037335F6D6573736167652E70726F746F32BF020A0C48656C6C6F576F726C64373312480A0C68656C6C6F3733556E617279121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1A2E6772706373657276696365732E5265706C794D657373616765124B0A0D68656C6C6F3733536572766572121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1A2E6772706373657276696365732E5265706C794D6573736167653001124B0A0D68656C6C6F3733436C69656E74121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1A2E6772706373657276696365732E5265706C794D6573736167652801124B0A0B68656C6C6F373342696469121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1A2E6772706373657276696365732E5265706C794D65737361676528013001620670726F746F33";

public isolated client class HelloWorld73Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, STREAMING_WITH_DEPENDING_MESSAGE_DESC);
    }

    isolated remote function hello73Unary(string|wrappers:ContextString req) returns ReplyMessage|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld73/hello73Unary", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ReplyMessage>result;
    }

    isolated remote function hello73UnaryContext(string|wrappers:ContextString req) returns ContextReplyMessage|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld73/hello73Unary", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ReplyMessage>result, headers: respHeaders};
    }

    isolated remote function hello73Client() returns Hello73ClientStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("grpcservices.HelloWorld73/hello73Client");
        return new Hello73ClientStreamingClient(sClient);
    }

    isolated remote function hello73Server(string|wrappers:ContextString req) returns stream<ReplyMessage, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("grpcservices.HelloWorld73/hello73Server", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ReplyMessageStream outputStream = new ReplyMessageStream(result);
        return new stream<ReplyMessage, grpc:Error?>(outputStream);
    }

    isolated remote function hello73ServerContext(string|wrappers:ContextString req) returns ContextReplyMessageStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("grpcservices.HelloWorld73/hello73Server", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ReplyMessageStream outputStream = new ReplyMessageStream(result);
        return {content: new stream<ReplyMessage, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function hello73Bidi() returns Hello73BidiStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("grpcservices.HelloWorld73/hello73Bidi");
        return new Hello73BidiStreamingClient(sClient);
    }
}

public isolated client class Hello73ClientStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendString(string message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextString(wrappers:ContextString message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveReplyMessage() returns ReplyMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <ReplyMessage>payload;
        }
    }

    isolated remote function receiveContextReplyMessage() returns ContextReplyMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <ReplyMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class ReplyMessageStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|ReplyMessage value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|ReplyMessage value;|} nextRecord = {value: <ReplyMessage>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public isolated client class Hello73BidiStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendString(string message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextString(wrappers:ContextString message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveReplyMessage() returns ReplyMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <ReplyMessage>payload;
        }
    }

    isolated remote function receiveContextReplyMessage() returns ContextReplyMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <ReplyMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class HelloWorld73ReplyMessageCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendReplyMessage(ReplyMessage response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextReplyMessage(ContextReplyMessage response) returns grpc:Error? {
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

public type ContextReplyMessageStream record {|
    stream<ReplyMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextReplyMessage record {|
    ReplyMessage content;
    map<string|string[]> headers;
|};

