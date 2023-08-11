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

const string SERVICES_WITH_HEADERS_DESC = "0A1E34355F73657276696365735F776974685F686561646572732E70726F746F22350A05485352657112120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D65737361676522350A05485352657312120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D657373616765328F010A0E486561646572735365727669636512170A05756E61727912062E48535265711A062E4853526573121D0A0973657276657253747212062E48535265711A062E48535265733001121D0A09636C69656E7453747212062E48535265711A062E4853526573280112260A106269646972656374696F6E616C53747212062E48535265711A062E485352657328013001620670726F746F33";

public isolated client class HeadersServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SERVICES_WITH_HEADERS_DESC);
    }

    isolated remote function unary(HSReq|ContextHSReq req) returns HSRes|grpc:Error {
        map<string|string[]> headers = {};
        HSReq message;
        if req is ContextHSReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HeadersService/unary", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <HSRes>result;
    }

    isolated remote function unaryContext(HSReq|ContextHSReq req) returns ContextHSRes|grpc:Error {
        map<string|string[]> headers = {};
        HSReq message;
        if req is ContextHSReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HeadersService/unary", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <HSRes>result, headers: respHeaders};
    }

    isolated remote function clientStr() returns ClientStrStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("HeadersService/clientStr");
        return new ClientStrStreamingClient(sClient);
    }

    isolated remote function serverStr(HSReq|ContextHSReq req) returns stream<HSRes, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        HSReq message;
        if req is ContextHSReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("HeadersService/serverStr", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        HSResStream outputStream = new HSResStream(result);
        return new stream<HSRes, grpc:Error?>(outputStream);
    }

    isolated remote function serverStrContext(HSReq|ContextHSReq req) returns ContextHSResStream|grpc:Error {
        map<string|string[]> headers = {};
        HSReq message;
        if req is ContextHSReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("HeadersService/serverStr", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        HSResStream outputStream = new HSResStream(result);
        return {content: new stream<HSRes, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function bidirectionalStr() returns BidirectionalStrStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("HeadersService/bidirectionalStr");
        return new BidirectionalStrStreamingClient(sClient);
    }
}

public client class ClientStrStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendHSReq(HSReq message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextHSReq(ContextHSReq message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveHSRes() returns HSRes|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <HSRes>payload;
        }
    }

    isolated remote function receiveContextHSRes() returns ContextHSRes|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <HSRes>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class HSResStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|HSRes value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|HSRes value;|} nextRecord = {value: <HSRes>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class BidirectionalStrStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendHSReq(HSReq message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextHSReq(ContextHSReq message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveHSRes() returns HSRes|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <HSRes>payload;
        }
    }

    isolated remote function receiveContextHSRes() returns ContextHSRes|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <HSRes>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class HeadersServiceHSResCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendHSRes(HSRes response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextHSRes(ContextHSRes response) returns grpc:Error? {
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

public type ContextHSResStream record {|
    stream<HSRes, error?> content;
    map<string|string[]> headers;
|};

public type ContextHSReqStream record {|
    stream<HSReq, error?> content;
    map<string|string[]> headers;
|};

public type ContextHSRes record {|
    HSRes content;
    map<string|string[]> headers;
|};

public type ContextHSReq record {|
    HSReq content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SERVICES_WITH_HEADERS_DESC}
public type HSRes record {|
    string name = "";
    string message = "";
|};

@protobuf:Descriptor {value: SERVICES_WITH_HEADERS_DESC}
public type HSReq record {|
    string name = "";
    string message = "";
|};

