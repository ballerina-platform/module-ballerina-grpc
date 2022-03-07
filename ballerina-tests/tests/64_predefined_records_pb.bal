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
import ballerina/time;
import ballerina/protobuf.types.empty;
import ballerina/protobuf.types.'any;
import ballerina/protobuf.types.timestamp;
import ballerina/protobuf.types.struct;
import ballerina/protobuf.types.duration;

public isolated client class PredefinedRecordsClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_64_PREDEFINED_RECORDS, getDescriptorMap64PredefinedRecords());
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

public type Duration record {|
    string name = "";
|};

public type Any record {|
    string name = "";
|};

public type Timestamp record {|
    string name = "";
|};

public type Struct record {|
    string name = "";
|};

//public type Empty record {|
//|};

const string ROOT_DESCRIPTOR_64_PREDEFINED_RECORDS = "0A1B36345F707265646566696E65645F7265636F7264732E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22190A03416E7912120A046E616D6518012001280952046E616D65221C0A0653747275637412120A046E616D6518012001280952046E616D65221E0A084475726174696F6E12120A046E616D6518012001280952046E616D65221F0A0954696D657374616D7012120A046E616D6518012001280952046E616D6522070A05456D7074793290020A11507265646566696E65645265636F72647312270A0743616C6C416E7912142E676F6F676C652E70726F746F6275662E416E791A042E416E79220012300A0A43616C6C53747275637412172E676F6F676C652E70726F746F6275662E5374727563741A072E537472756374220012360A0C43616C6C4475726174696F6E12192E676F6F676C652E70726F746F6275662E4475726174696F6E1A092E4475726174696F6E220012390A0D43616C6C54696D657374616D70121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A0A2E54696D657374616D702200122D0A0943616C6C456D70747912162E676F6F676C652E70726F746F6275662E456D7074791A062E456D7074792200620670726F746F33";

public isolated function getDescriptorMap64PredefinedRecords() returns map<string> {
    return {"64_predefined_records.proto": "0A1B36345F707265646566696E65645F7265636F7264732E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22190A03416E7912120A046E616D6518012001280952046E616D65221C0A0653747275637412120A046E616D6518012001280952046E616D65221E0A084475726174696F6E12120A046E616D6518012001280952046E616D65221F0A0954696D657374616D7012120A046E616D6518012001280952046E616D6522070A05456D7074793290020A11507265646566696E65645265636F72647312270A0743616C6C416E7912142E676F6F676C652E70726F746F6275662E416E791A042E416E79220012300A0A43616C6C53747275637412172E676F6F676C652E70726F746F6275662E5374727563741A072E537472756374220012360A0C43616C6C4475726174696F6E12192E676F6F676C652E70726F746F6275662E4475726174696F6E1A092E4475726174696F6E220012390A0D43616C6C54696D657374616D70121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A0A2E54696D657374616D702200122D0A0943616C6C456D70747912162E676F6F676C652E70726F746F6275662E456D7074791A062E456D7074792200620670726F746F33", "google/protobuf/any.proto": "0A19676F6F676C652F70726F746F6275662F616E792E70726F746F120F676F6F676C652E70726F746F62756622360A03416E7912190A08747970655F75726C18012001280952077479706555726C12140A0576616C756518022001280C520576616C7565424F0A13636F6D2E676F6F676C652E70726F746F6275664208416E7950726F746F50015A057479706573A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/duration.proto": "0A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F120F676F6F676C652E70726F746F627566223A0A084475726174696F6E12180A077365636F6E647318012001280352077365636F6E647312140A056E616E6F7318022001280552056E616E6F7342570A13636F6D2E676F6F676C652E70726F746F627566420D4475726174696F6E50726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/empty.proto": "0A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F120F676F6F676C652E70726F746F62756622070A05456D70747942540A13636F6D2E676F6F676C652E70726F746F627566420A456D70747950726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/struct.proto": "0A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F120F676F6F676C652E70726F746F6275662298010A06537472756374123B0A066669656C647318012003280B32232E676F6F676C652E70726F746F6275662E5374727563742E4669656C6473456E74727952066669656C64731A510A0B4669656C6473456E74727912100A036B657918012001280952036B6579122C0A0576616C756518022001280B32162E676F6F676C652E70726F746F6275662E56616C7565520576616C75653A02380122B2020A0556616C7565123B0A0A6E756C6C5F76616C756518012001280E321A2E676F6F676C652E70726F746F6275662E4E756C6C56616C7565480052096E756C6C56616C756512230A0C6E756D6265725F76616C75651802200128014800520B6E756D62657256616C756512230A0C737472696E675F76616C75651803200128094800520B737472696E6756616C7565121F0A0A626F6F6C5F76616C756518042001280848005209626F6F6C56616C7565123C0A0C7374727563745F76616C756518052001280B32172E676F6F676C652E70726F746F6275662E5374727563744800520B73747275637456616C7565123B0A0A6C6973745F76616C756518062001280B321A2E676F6F676C652E70726F746F6275662E4C69737456616C7565480052096C69737456616C756542060A046B696E64223B0A094C69737456616C7565122E0A0676616C75657318012003280B32162E676F6F676C652E70726F746F6275662E56616C7565520676616C7565732A1B0A094E756C6C56616C7565120E0A0A4E554C4C5F56414C5545100042550A13636F6D2E676F6F676C652E70726F746F627566420B53747275637450726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/timestamp.proto": "0A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F120F676F6F676C652E70726F746F627566223B0A0954696D657374616D7012180A077365636F6E647318012001280352077365636F6E647312140A056E616E6F7318022001280552056E616E6F7342580A13636F6D2E676F6F676C652E70726F746F627566420E54696D657374616D7050726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}
