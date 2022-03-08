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

public isolated client class PredefinedTypesInServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES, getDescriptorMap66PredefinedTypesInMessages());
    }

    isolated remote function anyCall(AnyMessageRequest|ContextAnyMessageRequest req) returns AnyMessageResponse|grpc:Error {
        map<string|string[]> headers = {};
        AnyMessageRequest message;
        if req is ContextAnyMessageRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedTypesInService/anyCall", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AnyMessageResponse>result;
    }

    isolated remote function anyCallContext(AnyMessageRequest|ContextAnyMessageRequest req) returns ContextAnyMessageResponse|grpc:Error {
        map<string|string[]> headers = {};
        AnyMessageRequest message;
        if req is ContextAnyMessageRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedTypesInService/anyCall", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AnyMessageResponse>result, headers: respHeaders};
    }

    isolated remote function structCall(StructMessageRequest|ContextStructMessageRequest req) returns StructMessageResponse|grpc:Error {
        map<string|string[]> headers = {};
        StructMessageRequest message;
        if req is ContextStructMessageRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedTypesInService/structCall", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <StructMessageResponse>result;
    }

    isolated remote function structCallContext(StructMessageRequest|ContextStructMessageRequest req) returns ContextStructMessageResponse|grpc:Error {
        map<string|string[]> headers = {};
        StructMessageRequest message;
        if req is ContextStructMessageRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedTypesInService/structCall", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <StructMessageResponse>result, headers: respHeaders};
    }

    isolated remote function timestampCall(TimestampMessageRequest|ContextTimestampMessageRequest req) returns TimestampMessageResponse|grpc:Error {
        map<string|string[]> headers = {};
        TimestampMessageRequest message;
        if req is ContextTimestampMessageRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedTypesInService/timestampCall", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <TimestampMessageResponse>result;
    }

    isolated remote function timestampCallContext(TimestampMessageRequest|ContextTimestampMessageRequest req) returns ContextTimestampMessageResponse|grpc:Error {
        map<string|string[]> headers = {};
        TimestampMessageRequest message;
        if req is ContextTimestampMessageRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedTypesInService/timestampCall", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <TimestampMessageResponse>result, headers: respHeaders};
    }

    isolated remote function durationCall(DurationMessageRequest|ContextDurationMessageRequest req) returns DurationMessageResponse|grpc:Error {
        map<string|string[]> headers = {};
        DurationMessageRequest message;
        if req is ContextDurationMessageRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedTypesInService/durationCall", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <DurationMessageResponse>result;
    }

    isolated remote function durationCallContext(DurationMessageRequest|ContextDurationMessageRequest req) returns ContextDurationMessageResponse|grpc:Error {
        map<string|string[]> headers = {};
        DurationMessageRequest message;
        if req is ContextDurationMessageRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("PredefinedTypesInService/durationCall", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <DurationMessageResponse>result, headers: respHeaders};
    }
}

public client class PredefinedTypesInServiceStructMessageResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendStructMessageResponse(StructMessageResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextStructMessageResponse(ContextStructMessageResponse response) returns grpc:Error? {
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

public client class PredefinedTypesInServiceTimestampMessageResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendTimestampMessageResponse(TimestampMessageResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextTimestampMessageResponse(ContextTimestampMessageResponse response) returns grpc:Error? {
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

public client class PredefinedTypesInServiceAnyMessageResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAnyMessageResponse(AnyMessageResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAnyMessageResponse(ContextAnyMessageResponse response) returns grpc:Error? {
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

public client class PredefinedTypesInServiceDurationMessageResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendDurationMessageResponse(DurationMessageResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextDurationMessageResponse(ContextDurationMessageResponse response) returns grpc:Error? {
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

public type ContextStructMessageResponse record {|
    StructMessageResponse content;
    map<string|string[]> headers;
|};

public type ContextDurationMessageResponse record {|
    DurationMessageResponse content;
    map<string|string[]> headers;
|};

public type ContextTimestampMessageResponse record {|
    TimestampMessageResponse content;
    map<string|string[]> headers;
|};

public type ContextAnyMessageRequest record {|
    AnyMessageRequest content;
    map<string|string[]> headers;
|};

public type ContextAnyMessageResponse record {|
    AnyMessageResponse content;
    map<string|string[]> headers;
|};

public type ContextStructMessageRequest record {|
    StructMessageRequest content;
    map<string|string[]> headers;
|};

public type ContextDurationMessageRequest record {|
    DurationMessageRequest content;
    map<string|string[]> headers;
|};

public type ContextTimestampMessageRequest record {|
    TimestampMessageRequest content;
    map<string|string[]> headers;
|};

public type StructMessageResponse record {|
    string name = "";
    int code = 0;
    map<anydata> details = {};
|};

public type DurationMessageResponse record {|
    string name = "";
    int code = 0;
    time:Seconds details = 0.0d;
|};

public type TimestampMessageResponse record {|
    string name = "";
    int code = 0;
    time:Utc details = [0, 0.0d];
|};

public type AnyMessageRequest record {|
    string name = "";
    'any:Any details = {typeUrl: "", value: ()};
|};

public type AnyMessageResponse record {|
    string name = "";
    int code = 0;
    'any:Any details = {typeUrl: "", value: ()};
|};

public type AnyTypeMsgForAnyMessage record {|
    string name = "";
    int code = 0;
|};

public type StructMessageRequest record {|
    string name = "";
    map<anydata> details = {};
|};

public type DurationMessageRequest record {|
    string name = "";
    time:Seconds details = 0.0d;
|};

public type TimestampMessageRequest record {|
    string name = "";
    time:Utc details = [0, 0.0d];
|};

const string ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES = "0A2536365F707265646566696E65645F74797065735F696E5F6D657373616765732E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F22570A11416E794D6573736167655265717565737412120A046E616D6518012001280952046E616D65122E0A0764657461696C7318022001280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C73226C0A12416E794D657373616765526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465122E0A0764657461696C7318032001280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C7322410A17416E79547970654D7367466F72416E794D65737361676512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465225D0A145374727563744D6573736167655265717565737412120A046E616D6518012001280952046E616D6512310A0764657461696C7318022001280B32172E676F6F676C652E70726F746F6275662E537472756374520764657461696C7322720A155374727563744D657373616765526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512310A0764657461696C7318032001280B32172E676F6F676C652E70726F746F6275662E537472756374520764657461696C7322630A1754696D657374616D704D6573736167655265717565737412120A046E616D6518012001280952046E616D6512340A0764657461696C7318022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520764657461696C7322780A1854696D657374616D704D657373616765526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512340A0764657461696C7318032001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520764657461696C7322610A164475726174696F6E4D6573736167655265717565737412120A046E616D6518012001280952046E616D6512330A0764657461696C7318022001280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E520764657461696C7322760A174475726174696F6E4D657373616765526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512330A0764657461696C7318032001280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E520764657461696C73329C020A18507265646566696E65645479706573496E5365727669636512340A07616E7943616C6C12122E416E794D657373616765526571756573741A132E416E794D657373616765526573706F6E73652200123D0A0A73747275637443616C6C12152E5374727563744D657373616765526571756573741A162E5374727563744D657373616765526573706F6E7365220012460A0D74696D657374616D7043616C6C12182E54696D657374616D704D657373616765526571756573741A192E54696D657374616D704D657373616765526573706F6E7365220012430A0C6475726174696F6E43616C6C12172E4475726174696F6E4D657373616765526571756573741A182E4475726174696F6E4D657373616765526573706F6E73652200620670726F746F33";

public isolated function getDescriptorMap66PredefinedTypesInMessages() returns map<string> {
    return {"66_predefined_types_in_messages.proto": "0A2536365F707265646566696E65645F74797065735F696E5F6D657373616765732E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F22570A11416E794D6573736167655265717565737412120A046E616D6518012001280952046E616D65122E0A0764657461696C7318022001280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C73226C0A12416E794D657373616765526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465122E0A0764657461696C7318032001280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C7322410A17416E79547970654D7367466F72416E794D65737361676512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465225D0A145374727563744D6573736167655265717565737412120A046E616D6518012001280952046E616D6512310A0764657461696C7318022001280B32172E676F6F676C652E70726F746F6275662E537472756374520764657461696C7322720A155374727563744D657373616765526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512310A0764657461696C7318032001280B32172E676F6F676C652E70726F746F6275662E537472756374520764657461696C7322630A1754696D657374616D704D6573736167655265717565737412120A046E616D6518012001280952046E616D6512340A0764657461696C7318022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520764657461696C7322780A1854696D657374616D704D657373616765526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512340A0764657461696C7318032001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520764657461696C7322610A164475726174696F6E4D6573736167655265717565737412120A046E616D6518012001280952046E616D6512330A0764657461696C7318022001280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E520764657461696C7322760A174475726174696F6E4D657373616765526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512330A0764657461696C7318032001280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E520764657461696C73329C020A18507265646566696E65645479706573496E5365727669636512340A07616E7943616C6C12122E416E794D657373616765526571756573741A132E416E794D657373616765526573706F6E73652200123D0A0A73747275637443616C6C12152E5374727563744D657373616765526571756573741A162E5374727563744D657373616765526573706F6E7365220012460A0D74696D657374616D7043616C6C12182E54696D657374616D704D657373616765526571756573741A192E54696D657374616D704D657373616765526573706F6E7365220012430A0C6475726174696F6E43616C6C12172E4475726174696F6E4D657373616765526571756573741A182E4475726174696F6E4D657373616765526573706F6E73652200620670726F746F33", "google/protobuf/any.proto": "0A19676F6F676C652F70726F746F6275662F616E792E70726F746F120F676F6F676C652E70726F746F62756622360A03416E7912190A08747970655F75726C18012001280952077479706555726C12140A0576616C756518022001280C520576616C7565424F0A13636F6D2E676F6F676C652E70726F746F6275664208416E7950726F746F50015A057479706573A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/duration.proto": "0A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F120F676F6F676C652E70726F746F627566223A0A084475726174696F6E12180A077365636F6E647318012001280352077365636F6E647312140A056E616E6F7318022001280552056E616E6F7342570A13636F6D2E676F6F676C652E70726F746F627566420D4475726174696F6E50726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/struct.proto": "0A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F120F676F6F676C652E70726F746F6275662298010A06537472756374123B0A066669656C647318012003280B32232E676F6F676C652E70726F746F6275662E5374727563742E4669656C6473456E74727952066669656C64731A510A0B4669656C6473456E74727912100A036B657918012001280952036B6579122C0A0576616C756518022001280B32162E676F6F676C652E70726F746F6275662E56616C7565520576616C75653A02380122B2020A0556616C7565123B0A0A6E756C6C5F76616C756518012001280E321A2E676F6F676C652E70726F746F6275662E4E756C6C56616C7565480052096E756C6C56616C756512230A0C6E756D6265725F76616C75651802200128014800520B6E756D62657256616C756512230A0C737472696E675F76616C75651803200128094800520B737472696E6756616C7565121F0A0A626F6F6C5F76616C756518042001280848005209626F6F6C56616C7565123C0A0C7374727563745F76616C756518052001280B32172E676F6F676C652E70726F746F6275662E5374727563744800520B73747275637456616C7565123B0A0A6C6973745F76616C756518062001280B321A2E676F6F676C652E70726F746F6275662E4C69737456616C7565480052096C69737456616C756542060A046B696E64223B0A094C69737456616C7565122E0A0676616C75657318012003280B32162E676F6F676C652E70726F746F6275662E56616C7565520676616C7565732A1B0A094E756C6C56616C7565120E0A0A4E554C4C5F56414C5545100042550A13636F6D2E676F6F676C652E70726F746F627566420B53747275637450726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/timestamp.proto": "0A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F120F676F6F676C652E70726F746F627566223B0A0954696D657374616D7012180A077365636F6E647318012001280352077365636F6E647312140A056E616E6F7318022001280552056E616E6F7342580A13636F6D2E676F6F676C652E70726F746F627566420E54696D657374616D7050726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

