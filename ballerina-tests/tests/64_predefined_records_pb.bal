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
import ballerina/protobuf;
import ballerina/time;
import ballerina/protobuf.types.'any;
import ballerina/protobuf.types.duration;
import ballerina/protobuf.types.empty;
import ballerina/protobuf.types.struct;
import ballerina/protobuf.types.timestamp;

const string PREDEFINED_RECORDS_DESC = "0A1B36345F707265646566696E65645F7265636F7264732E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22190A03416E7912120A046E616D6518012001280952046E616D65221C0A0653747275637412120A046E616D6518012001280952046E616D65221E0A084475726174696F6E12120A046E616D6518012001280952046E616D65221F0A0954696D657374616D7012120A046E616D6518012001280952046E616D6522070A05456D7074793290020A11507265646566696E65645265636F72647312270A0743616C6C416E7912142E676F6F676C652E70726F746F6275662E416E791A042E416E79220012300A0A43616C6C53747275637412172E676F6F676C652E70726F746F6275662E5374727563741A072E537472756374220012360A0C43616C6C4475726174696F6E12192E676F6F676C652E70726F746F6275662E4475726174696F6E1A092E4475726174696F6E220012390A0D43616C6C54696D657374616D70121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A0A2E54696D657374616D702200122D0A0943616C6C456D70747912162E676F6F676C652E70726F746F6275662E456D7074791A062E456D7074792200620670726F746F33";

public isolated client class PredefinedRecordsClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, PREDEFINED_RECORDS_DESC);
    }

    isolated remote function CallAny('any:Any|'any:ContextAny req) returns Any|grpc:Error {
        map<string|string[]> headers = {};
        'any:Any message;
        if req is 'any:ContextAny {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedRecords/CallAny", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Any>result;
    }

    isolated remote function CallAnyContext('any:Any|'any:ContextAny req) returns ContextAny|grpc:Error {
        map<string|string[]> headers = {};
        'any:Any message;
        if req is 'any:ContextAny {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedRecords/CallAny", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Any>result, headers: respHeaders};
    }

    isolated remote function CallStruct(map<anydata>|struct:ContextStruct req) returns Struct|grpc:Error {
        map<string|string[]> headers = {};
        map<anydata> message;
        if req is struct:ContextStruct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedRecords/CallStruct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Struct>result;
    }

    isolated remote function CallStructContext(map<anydata>|struct:ContextStruct req) returns ContextStruct|grpc:Error {
        map<string|string[]> headers = {};
        map<anydata> message;
        if req is struct:ContextStruct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedRecords/CallStruct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Struct>result, headers: respHeaders};
    }

    isolated remote function CallDuration(time:Seconds|duration:ContextDuration req) returns Duration|grpc:Error {
        map<string|string[]> headers = {};
        time:Seconds message;
        if req is duration:ContextDuration {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedRecords/CallDuration", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Duration>result;
    }

    isolated remote function CallDurationContext(time:Seconds|duration:ContextDuration req) returns ContextDuration|grpc:Error {
        map<string|string[]> headers = {};
        time:Seconds message;
        if req is duration:ContextDuration {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedRecords/CallDuration", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Duration>result, headers: respHeaders};
    }

    isolated remote function CallTimestamp(time:Utc|timestamp:ContextTimestamp req) returns Timestamp|grpc:Error {
        map<string|string[]> headers = {};
        time:Utc message;
        if req is timestamp:ContextTimestamp {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedRecords/CallTimestamp", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Timestamp>result;
    }

    isolated remote function CallTimestampContext(time:Utc|timestamp:ContextTimestamp req) returns ContextTimestamp|grpc:Error {
        map<string|string[]> headers = {};
        time:Utc message;
        if req is timestamp:ContextTimestamp {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedRecords/CallTimestamp", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Timestamp>result, headers: respHeaders};
    }

    isolated remote function CallEmpty() returns Empty|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedRecords/CallEmpty", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Empty>result;
    }

    isolated remote function CallEmptyContext() returns ContextEmpty|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedRecords/CallEmpty", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Empty>result, headers: respHeaders};
    }
}

public client class PredefinedRecordsTimestampCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendTimestamp(Timestamp response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextTimestamp(ContextTimestamp response) returns grpc:Error? {
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

public client class PredefinedRecordsEmptyCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendEmpty(Empty response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextEmpty(ContextEmpty response) returns grpc:Error? {
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

public client class PredefinedRecordsStructCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendStruct(Struct response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextStruct(ContextStruct response) returns grpc:Error? {
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

public client class PredefinedRecordsDurationCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendDuration(Duration response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextDuration(ContextDuration response) returns grpc:Error? {
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

public client class PredefinedRecordsAnyCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAny(Any response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAny(ContextAny response) returns grpc:Error? {
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

public type ContextEmpty record {|
    Empty content;
    map<string|string[]> headers;
|};

public type ContextDuration record {|
    Duration content;
    map<string|string[]> headers;
|};

public type ContextAny record {|
    Any content;
    map<string|string[]> headers;
|};

public type ContextTimestamp record {|
    Timestamp content;
    map<string|string[]> headers;
|};

public type ContextStruct record {|
    Struct content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: PREDEFINED_RECORDS_DESC}
public type Empty record {|
|};

@protobuf:Descriptor {value: PREDEFINED_RECORDS_DESC}
public type Duration record {|
    string name = "";
|};

@protobuf:Descriptor {value: PREDEFINED_RECORDS_DESC}
public type Any record {|
    string name = "";
|};

@protobuf:Descriptor {value: PREDEFINED_RECORDS_DESC}
public type Timestamp record {|
    string name = "";
|};

@protobuf:Descriptor {value: PREDEFINED_RECORDS_DESC}
public type Struct record {|
    string name = "";
|};

