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

public type AnyTypeMsg record {|
    string name = "";
    int code = 0;
|};

public type DurationArrayRequest record {|
    string name = "";
    time:Seconds[] details = [];
|};

public type StructArrayResponse record {|
    string name = "";
    int code = 0;
    map<anydata>[] details = [];
|};

public type AnyArrayResponse record {|
    string name = "";
    int code = 0;
    'any:Any[] details = [];
|};

public type StructArrayRequest record {|
    string name = "";
    map<anydata>[] details = [];
|};

public type DurationArrayResponse record {|
    string name = "";
    int code = 0;
    time:Seconds[] details = [];
|};

public type AnyArrayRequest record {|
    string name = "";
    'any:Any[] details = [];
|};

public type TimestampArrayResponse record {|
    string name = "";
    int code = 0;
    time:Utc[] details = [];
|};

public type TimestampArrayRequest record {|
    string name = "";
    time:Utc[] details = [];
|};

const string ROOT_DESCRIPTOR_65_REPEATED_TYPES = "0A1736355F72657065617465645F74797065732E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F22550A0F416E7941727261795265717565737412120A046E616D6518012001280952046E616D65122E0A0764657461696C7318022003280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C73226A0A10416E794172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465122E0A0764657461696C7318032003280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C7322340A0A416E79547970654D736712120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465225B0A1253747275637441727261795265717565737412120A046E616D6518012001280952046E616D6512310A0764657461696C7318022003280B32172E676F6F676C652E70726F746F6275662E537472756374520764657461696C7322700A135374727563744172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512310A0764657461696C7318032003280B32172E676F6F676C652E70726F746F6275662E537472756374520764657461696C7322610A1554696D657374616D7041727261795265717565737412120A046E616D6518012001280952046E616D6512340A0764657461696C7318022003280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520764657461696C7322760A1654696D657374616D704172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512340A0764657461696C7318032003280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520764657461696C73225F0A144475726174696F6E41727261795265717565737412120A046E616D6518012001280952046E616D6512330A0764657461696C7318022003280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E520764657461696C7322740A154475726174696F6E4172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512330A0764657461696C7318032003280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E520764657461696C733288020A14526570656174656454797065735365727669636512300A07616E7943616C6C12102E416E794172726179526571756573741A112E416E794172726179526573706F6E7365220012390A0A73747275637443616C6C12132E5374727563744172726179526571756573741A142E5374727563744172726179526573706F6E7365220012420A0D74696D657374616D7043616C6C12162E54696D657374616D704172726179526571756573741A172E54696D657374616D704172726179526573706F6E73652200123F0A0C6475726174696F6E43616C6C12152E4475726174696F6E4172726179526571756573741A162E4475726174696F6E4172726179526573706F6E73652200620670726F746F33";

public isolated function getDescriptorMap65RepeatedTypes() returns map<string> {
    return {"65_repeated_types.proto": "0A1736355F72657065617465645F74797065732E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F22550A0F416E7941727261795265717565737412120A046E616D6518012001280952046E616D65122E0A0764657461696C7318022003280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C73226A0A10416E794172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465122E0A0764657461696C7318032003280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C7322340A0A416E79547970654D736712120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465225B0A1253747275637441727261795265717565737412120A046E616D6518012001280952046E616D6512310A0764657461696C7318022003280B32172E676F6F676C652E70726F746F6275662E537472756374520764657461696C7322700A135374727563744172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512310A0764657461696C7318032003280B32172E676F6F676C652E70726F746F6275662E537472756374520764657461696C7322610A1554696D657374616D7041727261795265717565737412120A046E616D6518012001280952046E616D6512340A0764657461696C7318022003280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520764657461696C7322760A1654696D657374616D704172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512340A0764657461696C7318032003280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520764657461696C73225F0A144475726174696F6E41727261795265717565737412120A046E616D6518012001280952046E616D6512330A0764657461696C7318022003280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E520764657461696C7322740A154475726174696F6E4172726179526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512330A0764657461696C7318032003280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E520764657461696C733288020A14526570656174656454797065735365727669636512300A07616E7943616C6C12102E416E794172726179526571756573741A112E416E794172726179526573706F6E7365220012390A0A73747275637443616C6C12132E5374727563744172726179526571756573741A142E5374727563744172726179526573706F6E7365220012420A0D74696D657374616D7043616C6C12162E54696D657374616D704172726179526571756573741A172E54696D657374616D704172726179526573706F6E73652200123F0A0C6475726174696F6E43616C6C12152E4475726174696F6E4172726179526571756573741A162E4475726174696F6E4172726179526573706F6E73652200620670726F746F33", "google/protobuf/any.proto": "0A19676F6F676C652F70726F746F6275662F616E792E70726F746F120F676F6F676C652E70726F746F62756622360A03416E7912190A08747970655F75726C18012001280952077479706555726C12140A0576616C756518022001280C520576616C7565424F0A13636F6D2E676F6F676C652E70726F746F6275664208416E7950726F746F50015A057479706573A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/duration.proto": "0A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F120F676F6F676C652E70726F746F627566223A0A084475726174696F6E12180A077365636F6E647318012001280352077365636F6E647312140A056E616E6F7318022001280552056E616E6F7342570A13636F6D2E676F6F676C652E70726F746F627566420D4475726174696F6E50726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/struct.proto": "0A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F120F676F6F676C652E70726F746F6275662298010A06537472756374123B0A066669656C647318012003280B32232E676F6F676C652E70726F746F6275662E5374727563742E4669656C6473456E74727952066669656C64731A510A0B4669656C6473456E74727912100A036B657918012001280952036B6579122C0A0576616C756518022001280B32162E676F6F676C652E70726F746F6275662E56616C7565520576616C75653A02380122B2020A0556616C7565123B0A0A6E756C6C5F76616C756518012001280E321A2E676F6F676C652E70726F746F6275662E4E756C6C56616C7565480052096E756C6C56616C756512230A0C6E756D6265725F76616C75651802200128014800520B6E756D62657256616C756512230A0C737472696E675F76616C75651803200128094800520B737472696E6756616C7565121F0A0A626F6F6C5F76616C756518042001280848005209626F6F6C56616C7565123C0A0C7374727563745F76616C756518052001280B32172E676F6F676C652E70726F746F6275662E5374727563744800520B73747275637456616C7565123B0A0A6C6973745F76616C756518062001280B321A2E676F6F676C652E70726F746F6275662E4C69737456616C7565480052096C69737456616C756542060A046B696E64223B0A094C69737456616C7565122E0A0676616C75657318012003280B32162E676F6F676C652E70726F746F6275662E56616C7565520676616C7565732A1B0A094E756C6C56616C7565120E0A0A4E554C4C5F56414C5545100042550A13636F6D2E676F6F676C652E70726F746F627566420B53747275637450726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/timestamp.proto": "0A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F120F676F6F676C652E70726F746F627566223B0A0954696D657374616D7012180A077365636F6E647318012001280352077365636F6E647312140A056E616E6F7318022001280552056E616E6F7342580A13636F6D2E676F6F676C652E70726F746F627566420E54696D657374616D7050726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

