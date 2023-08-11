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
import ballerina/time;
import ballerina/protobuf.types.timestamp;
import ballerina/protobuf.types.wrappers;
import ballerina/grpc.types.timestamp as stimestamp;

const string UNARY_TIMESTAMP_DESC = "0A1834375F756E6172795F74696D657374616D702E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F224E0A084772656574696E6712120A046E616D6518012001280952046E616D65122E0A0474696D6518022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520474696D6532E2020A1054696D657374616D705365727669636512380A0B6765744772656574696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A092E4772656574696E672200122A0A1065786368616E67654772656574696E6712092E4772656574696E671A092E4772656574696E67220012480A0C65786368616E676554696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D702200124E0A1073657276657253747265616D54696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D7022003001124E0A10636C69656E7453747265616D54696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D7022002801620670726F746F33";

public isolated client class TimestampServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, UNARY_TIMESTAMP_DESC);
    }

    isolated remote function getGreeting(string|wrappers:ContextString req) returns Greeting|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TimestampService/getGreeting", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Greeting>result;
    }

    isolated remote function getGreetingContext(string|wrappers:ContextString req) returns ContextGreeting|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TimestampService/getGreeting", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Greeting>result, headers: respHeaders};
    }

    isolated remote function exchangeGreeting(Greeting|ContextGreeting req) returns Greeting|grpc:Error {
        map<string|string[]> headers = {};
        Greeting message;
        if req is ContextGreeting {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TimestampService/exchangeGreeting", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Greeting>result;
    }

    isolated remote function exchangeGreetingContext(Greeting|ContextGreeting req) returns ContextGreeting|grpc:Error {
        map<string|string[]> headers = {};
        Greeting message;
        if req is ContextGreeting {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TimestampService/exchangeGreeting", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Greeting>result, headers: respHeaders};
    }

    isolated remote function exchangeTime(time:Utc|timestamp:ContextTimestamp req) returns time:Utc|grpc:Error {
        map<string|string[]> headers = {};
        time:Utc message;
        if req is timestamp:ContextTimestamp {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TimestampService/exchangeTime", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <time:Utc>result.cloneReadOnly();
    }

    isolated remote function exchangeTimeContext(time:Utc|timestamp:ContextTimestamp req) returns timestamp:ContextTimestamp|grpc:Error {
        map<string|string[]> headers = {};
        time:Utc message;
        if req is timestamp:ContextTimestamp {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TimestampService/exchangeTime", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <time:Utc>result.cloneReadOnly(), headers: respHeaders};
    }

    isolated remote function clientStreamTime() returns ClientStreamTimeStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("TimestampService/clientStreamTime");
        return new ClientStreamTimeStreamingClient(sClient);
    }

    isolated remote function serverStreamTime(time:Utc|timestamp:ContextTimestamp req) returns stream<time:Utc, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        time:Utc message;
        if req is timestamp:ContextTimestamp {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("TimestampService/serverStreamTime", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        stimestamp:TimestampStream outputStream = new stimestamp:TimestampStream(result);
        return new stream<time:Utc, grpc:Error?>(outputStream);
    }

    isolated remote function serverStreamTimeContext(time:Utc|timestamp:ContextTimestamp req) returns timestamp:ContextTimestampStream|grpc:Error {
        map<string|string[]> headers = {};
        time:Utc message;
        if req is timestamp:ContextTimestamp {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("TimestampService/serverStreamTime", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        stimestamp:TimestampStream outputStream = new stimestamp:TimestampStream(result);
        return {content: new stream<time:Utc, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public client class ClientStreamTimeStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendTimestamp(time:Utc message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextTimestamp(timestamp:ContextTimestamp message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveTimestamp() returns time:Utc|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <time:Utc>payload.cloneReadOnly();
        }
    }

    isolated remote function receiveContextTimestamp() returns timestamp:ContextTimestamp|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <time:Utc>payload.cloneReadOnly(), headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class TimestampServiceTimestampCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendTimestamp(time:Utc response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextTimestamp(timestamp:ContextTimestamp response) returns grpc:Error? {
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

public client class TimestampServiceGreetingCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendGreeting(Greeting response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextGreeting(ContextGreeting response) returns grpc:Error? {
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

public type ContextGreeting record {|
    Greeting content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: UNARY_TIMESTAMP_DESC}
public type Greeting record {|
    string name = "";
    time:Utc time = [0, 0.0d];
|};

