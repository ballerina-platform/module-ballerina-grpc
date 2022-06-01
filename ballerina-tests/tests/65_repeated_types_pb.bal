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
import ballerina/protobuf;
import ballerina/protobuf.types.'any;

public isolated client class RepeatedTypesServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_65_REPEATED_TYPES, getDescriptorMap65RepeatedTypes());
    }

    isolated remote function anyCall(AnyArrayRequest|ContextAnyArrayRequest req) returns AnyArrayResponse|grpc:Error {
        map<string|string[]> headers = {};
        AnyArrayRequest message;
        if req is ContextAnyArrayRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RepeatedTypesService/anyCall", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AnyArrayResponse>result;
    }

    isolated remote function anyCallContext(AnyArrayRequest|ContextAnyArrayRequest req) returns ContextAnyArrayResponse|grpc:Error {
        map<string|string[]> headers = {};
        AnyArrayRequest message;
        if req is ContextAnyArrayRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RepeatedTypesService/anyCall", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AnyArrayResponse>result, headers: respHeaders};
    }

    isolated remote function structCall(StructArrayRequest|ContextStructArrayRequest req) returns StructArrayResponse|grpc:Error {
        map<string|string[]> headers = {};
        StructArrayRequest message;
        if req is ContextStructArrayRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RepeatedTypesService/structCall", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <StructArrayResponse>result;
    }

    isolated remote function structCallContext(StructArrayRequest|ContextStructArrayRequest req) returns ContextStructArrayResponse|grpc:Error {
        map<string|string[]> headers = {};
        StructArrayRequest message;
        if req is ContextStructArrayRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RepeatedTypesService/structCall", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <StructArrayResponse>result, headers: respHeaders};
    }

    isolated remote function timestampCall(TimestampArrayRequest|ContextTimestampArrayRequest req) returns TimestampArrayResponse|grpc:Error {
        map<string|string[]> headers = {};
        TimestampArrayRequest message;
        if req is ContextTimestampArrayRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RepeatedTypesService/timestampCall", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <TimestampArrayResponse>result;
    }

    isolated remote function timestampCallContext(TimestampArrayRequest|ContextTimestampArrayRequest req) returns ContextTimestampArrayResponse|grpc:Error {
        map<string|string[]> headers = {};
        TimestampArrayRequest message;
        if req is ContextTimestampArrayRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RepeatedTypesService/timestampCall", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <TimestampArrayResponse>result, headers: respHeaders};
    }

    isolated remote function durationCall(DurationArrayRequest|ContextDurationArrayRequest req) returns DurationArrayResponse|grpc:Error {
        map<string|string[]> headers = {};
        DurationArrayRequest message;
        if req is ContextDurationArrayRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RepeatedTypesService/durationCall", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <DurationArrayResponse>result;
    }

    isolated remote function durationCallContext(DurationArrayRequest|ContextDurationArrayRequest req) returns ContextDurationArrayResponse|grpc:Error {
        map<string|string[]> headers = {};
        DurationArrayRequest message;
        if req is ContextDurationArrayRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RepeatedTypesService/durationCall", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <DurationArrayResponse>result, headers: respHeaders};
    }
}

public client class RepeatedTypesServiceDurationArrayResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendDurationArrayResponse(DurationArrayResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextDurationArrayResponse(ContextDurationArrayResponse response) returns grpc:Error? {
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

public client class RepeatedTypesServiceTimestampArrayResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendTimestampArrayResponse(TimestampArrayResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextTimestampArrayResponse(ContextTimestampArrayResponse response) returns grpc:Error? {
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

public client class RepeatedTypesServiceAnyArrayResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAnyArrayResponse(AnyArrayResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAnyArrayResponse(ContextAnyArrayResponse response) returns grpc:Error? {
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

public client class RepeatedTypesServiceStructArrayResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendStructArrayResponse(StructArrayResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextStructArrayResponse(ContextStructArrayResponse response) returns grpc:Error? {
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

public type ContextDurationArrayRequest record {|
    DurationArrayRequest content;
    map<string|string[]> headers;
|};

public type ContextStructArrayResponse record {|
    StructArrayResponse content;
    map<string|string[]> headers;
|};

public type ContextAnyArrayResponse record {|
    AnyArrayResponse content;
    map<string|string[]> headers;
|};

public type ContextStructArrayRequest record {|
    StructArrayRequest content;
    map<string|string[]> headers;
|};

public type ContextDurationArrayResponse record {|
    DurationArrayResponse content;
    map<string|string[]> headers;
|};

public type ContextAnyArrayRequest record {|
    AnyArrayRequest content;
    map<string|string[]> headers;
|};

public type ContextTimestampArrayResponse record {|
    TimestampArrayResponse content;
    map<string|string[]> headers;
|};

public type ContextTimestampArrayRequest record {|
    TimestampArrayRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor{
    value: ROOT_DESCRIPTOR_65_REPEATED_TYPES
}
public type AnyTypeMsg record {|
    string name = "";
    int code = 0;
|};

@protobuf:Descriptor{
    value: ROOT_DESCRIPTOR_65_REPEATED_TYPES
}
public type DurationArrayRequest record {|
    string name = "";
    time:Seconds[] details = [];
|};

@protobuf:Descriptor{
    value: ROOT_DESCRIPTOR_65_REPEATED_TYPES
}
public type StructArrayResponse record {|
    string name = "";
    int code = 0;
    map<anydata>[] details = [];
|};

@protobuf:Descriptor{
    value: ROOT_DESCRIPTOR_65_REPEATED_TYPES
}
public type AnyArrayResponse record {|
    string name = "";
    int code = 0;
    'any:Any[] details = [];
|};

@protobuf:Descriptor{
    value: ROOT_DESCRIPTOR_65_REPEATED_TYPES
}
public type StructArrayRequest record {|
    string name = "";
    map<anydata>[] details = [];
|};

@protobuf:Descriptor{
    value: ROOT_DESCRIPTOR_65_REPEATED_TYPES
}
public type DurationArrayResponse record {|
    string name = "";
    int code = 0;
    time:Seconds[] details = [];
|};

@protobuf:Descriptor{
    value: ROOT_DESCRIPTOR_65_REPEATED_TYPES
}
public type AnyArrayRequest record {|
    string name = "";
    'any:Any[] details = [];
|};

@protobuf:Descriptor{
    value: ROOT_DESCRIPTOR_65_REPEATED_TYPES
}
public type TimestampArrayResponse record {|
    string name = "";
    int code = 0;
    time:Utc[] details = [];
|};

@protobuf:Descriptor{
    value: ROOT_DESCRIPTOR_65_REPEATED_TYPES
}
public type TimestampArrayRequest record {|
    string name = "";
    time:Utc[] details = [];
|};

const string ROOT_DESCRIPTOR_65_REPEATED_TYPES = "0A1736355F72657065617465645F74797065732E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F22550A0F416E7941727261795265717565737412120A046E616D6518012001280952046E616D65122E0A0764657461696C7318022003280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C73226A0A10416E794172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465122E0A0764657461696C7318032003280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C7322340A0A416E79547970654D736712120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465225B0A1253747275637441727261795265717565737412120A046E616D6518012001280952046E616D6512310A0764657461696C7318022003280B32172E676F6F676C652E70726F746F6275662E537472756374520764657461696C7322700A135374727563744172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512310A0764657461696C7318032003280B32172E676F6F676C652E70726F746F6275662E537472756374520764657461696C7322610A1554696D657374616D7041727261795265717565737412120A046E616D6518012001280952046E616D6512340A0764657461696C7318022003280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520764657461696C7322760A1654696D657374616D704172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512340A0764657461696C7318032003280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520764657461696C73225F0A144475726174696F6E41727261795265717565737412120A046E616D6518012001280952046E616D6512330A0764657461696C7318022003280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E520764657461696C7322740A154475726174696F6E4172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512330A0764657461696C7318032003280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E520764657461696C733288020A14526570656174656454797065735365727669636512300A07616E7943616C6C12102E416E794172726179526571756573741A112E416E794172726179526573706F6E7365220012390A0A73747275637443616C6C12132E5374727563744172726179526571756573741A142E5374727563744172726179526573706F6E7365220012420A0D74696D657374616D7043616C6C12162E54696D657374616D704172726179526571756573741A172E54696D657374616D704172726179526573706F6E73652200123F0A0C6475726174696F6E43616C6C12152E4475726174696F6E4172726179526571756573741A162E4475726174696F6E4172726179526573706F6E73652200620670726F746F33";

public isolated function getDescriptorMap65RepeatedTypes() returns map<string> {
    return {};
}

