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
import grpc_tests.messages.message1;
import grpc_tests.messages.message2;

const string PACKAGE_WITH_NESTED_MODULES_DESC = "0A2437305F7061636B6167655F776974685F6E65737465645F6D6F64756C65732E70726F746F12097061636B6167696E671A2362616C6C6572696E612F70726F746F6275662F64657363726970746F722E70726F746F1A1137305F6D657373616765312E70726F746F1A1137305F6D657373616765322E70726F746F32B5020A0C68656C6C6F576F726C64373012410A1168656C6C6F576F726C643730556E61727912152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D657373616765124A0A1868656C6C6F576F726C64373053657276657253747265616D12152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D6573736167653001124A0A1868656C6C6F576F726C643730436C69656E7453747265616D12152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D6573736167652801124A0A1668656C6C6F576F726C6437304269646953747265616D12152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D65737361676528013001420DE2470A677270635F7465737473620670726F746F33";

public isolated client class helloWorld70Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, PACKAGE_WITH_NESTED_MODULES_DESC);
    }

    isolated remote function helloWorld70Unary(message1:ReqMessage|ContextReqMessage req) returns message2:ResMessage|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld70/helloWorld70Unary", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <message2:ResMessage>result;
    }

    isolated remote function helloWorld70UnaryContext(message1:ReqMessage|ContextReqMessage req) returns ContextResMessage|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld70/helloWorld70Unary", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <message2:ResMessage>result, headers: respHeaders};
    }

    isolated remote function helloWorld70ClientStream() returns HelloWorld70ClientStreamStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("packaging.helloWorld70/helloWorld70ClientStream");
        return new HelloWorld70ClientStreamStreamingClient(sClient);
    }

    isolated remote function helloWorld70ServerStream(message1:ReqMessage|ContextReqMessage req) returns stream<message2:ResMessage, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld70/helloWorld70ServerStream", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ResMessageStream outputStream = new ResMessageStream(result);
        return new stream<message2:ResMessage, grpc:Error?>(outputStream);
    }

    isolated remote function helloWorld70ServerStreamContext(message1:ReqMessage|ContextReqMessage req) returns ContextResMessageStream|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld70/helloWorld70ServerStream", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ResMessageStream outputStream = new ResMessageStream(result);
        return {content: new stream<message2:ResMessage, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function helloWorld70BidiStream() returns HelloWorld70BidiStreamStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("packaging.helloWorld70/helloWorld70BidiStream");
        return new HelloWorld70BidiStreamStreamingClient(sClient);
    }
}

public isolated client class HelloWorld70ClientStreamStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendReqMessage(message1:ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(ContextReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage() returns message2:ResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <message2:ResMessage>payload;
        }
    }

    isolated remote function receiveContextResMessage() returns ContextResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <message2:ResMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class ResMessageStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|message2:ResMessage value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|message2:ResMessage value;|} nextRecord = {value: <message2:ResMessage>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public isolated client class HelloWorld70BidiStreamStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendReqMessage(message1:ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(ContextReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage() returns message2:ResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <message2:ResMessage>payload;
        }
    }

    isolated remote function receiveContextResMessage() returns ContextResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <message2:ResMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class HelloWorld70ResMessageCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendResMessage(message2:ResMessage response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextResMessage(ContextResMessage response) returns grpc:Error? {
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

public type ContextReqMessageStream record {|
    stream<message1:ReqMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextResMessageStream record {|
    stream<message2:ResMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextReqMessage record {|
    message1:ReqMessage content;
    map<string|string[]> headers;
|};

public type ContextResMessage record {|
    message2:ResMessage content;
    map<string|string[]> headers;
|};

