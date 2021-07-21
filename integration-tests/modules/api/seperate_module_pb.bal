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

public isolated client class SeperateModuleServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function unary(SMReq|ContextSMReq req) returns (SMRes|grpc:Error) {
        map<string|string[]> headers = {};
        SMReq message;
        if (req is ContextSMReq) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("SeperateModuleService/unary", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SMRes>result;
    }

    isolated remote function unaryContext(SMReq|ContextSMReq req) returns (ContextSMRes|grpc:Error) {
        map<string|string[]> headers = {};
        SMReq message;
        if (req is ContextSMReq) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("SeperateModuleService/unary", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SMRes>result, headers: respHeaders};
    }

    isolated remote function clientStreaming() returns (ClientStreamingStreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("SeperateModuleService/clientStreaming");
        return new ClientStreamingStreamingClient(sClient);
    }

    isolated remote function serverStreaming(SMReq|ContextSMReq req) returns stream<SMRes, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        SMReq message;
        if (req is ContextSMReq) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("SeperateModuleService/serverStreaming", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        SMResStream outputStream = new SMResStream(result);
        return new stream<SMRes, grpc:Error?>(outputStream);
    }

    isolated remote function serverStreamingContext(SMReq|ContextSMReq req) returns ContextSMResStream|grpc:Error {
        map<string|string[]> headers = {};
        SMReq message;
        if (req is ContextSMReq) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("SeperateModuleService/serverStreaming", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        SMResStream outputStream = new SMResStream(result);
        return {content: new stream<SMRes, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function bidirectional1() returns (Bidirectional1StreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("SeperateModuleService/bidirectional1");
        return new Bidirectional1StreamingClient(sClient);
    }

    isolated remote function bidirectional2() returns (Bidirectional2StreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("SeperateModuleService/bidirectional2");
        return new Bidirectional2StreamingClient(sClient);
    }
}

public client class ClientStreamingStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendSMReq(SMReq message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextSMReq(ContextSMReq message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveSMRes() returns SMRes|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <SMRes>payload;
        }
    }

    isolated remote function receiveContextSMRes() returns ContextSMRes|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <SMRes>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class SMResStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|SMRes value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|SMRes value;|} nextRecord = {value: <SMRes>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class Bidirectional1StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendSMReq(SMReq message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextSMReq(ContextSMReq message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveSMRes() returns SMRes|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <SMRes>payload;
        }
    }

    isolated remote function receiveContextSMRes() returns ContextSMRes|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <SMRes>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class Bidirectional2StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendSMReq(SMReq message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextSMReq(ContextSMReq message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveSMRes() returns SMRes|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <SMRes>payload;
        }
    }

    isolated remote function receiveContextSMRes() returns ContextSMRes|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <SMRes>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class SeperateModuleServiceSMResCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSMRes(SMRes response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSMRes(ContextSMRes response) returns grpc:Error? {
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

public type ContextSMReqStream record {|
    stream<SMReq, error?> content;
    map<string|string[]> headers;
|};

public type ContextSMResStream record {|
    stream<SMRes, error?> content;
    map<string|string[]> headers;
|};

public type ContextSMReq record {|
    SMReq content;
    map<string|string[]> headers;
|};

public type ContextSMRes record {|
    SMRes content;
    map<string|string[]> headers;
|};

public type SMReq record {|
    string name = "";
    int id = 0;
|};

public type SMRes record {|
    string name = "";
    int id = 0;
|};

public const string ROOT_DESCRIPTOR = "0A1573657065726174655F6D6F64756C652E70726F746F222B0A05534D52657112120A046E616D6518012001280952046E616D65120E0A02696418022001280552026964222B0A05534D52657312120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696432C6010A1553657065726174654D6F64756C655365727669636512170A05756E61727912062E534D5265711A062E534D52657312230A0F73657276657253747265616D696E6712062E534D5265711A062E534D526573300112230A0F636C69656E7453747265616D696E6712062E534D5265711A062E534D526573280112240A0E6269646972656374696F6E616C3112062E534D5265711A062E534D5265732801300112240A0E6269646972656374696F6E616C3212062E534D5265711A062E534D52657328013001620670726F746F33";

public isolated function getDescriptorMap() returns map<string> {
    return {"seperate_module.proto": "0A1573657065726174655F6D6F64756C652E70726F746F222B0A05534D52657112120A046E616D6518012001280952046E616D65120E0A02696418022001280552026964222B0A05534D52657312120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696432C6010A1553657065726174654D6F64756C655365727669636512170A05756E61727912062E534D5265711A062E534D52657312230A0F73657276657253747265616D696E6712062E534D5265711A062E534D526573300112230A0F636C69656E7453747265616D696E6712062E534D5265711A062E534D526573280112240A0E6269646972656374696F6E616C3112062E534D5265711A062E534D5265732801300112240A0E6269646972656374696F6E616C3212062E534D5265711A062E534D52657328013001620670726F746F33"};
}

