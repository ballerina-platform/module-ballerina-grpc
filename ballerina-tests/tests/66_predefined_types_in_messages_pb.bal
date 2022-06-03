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
import ballerina/protobuf;

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

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type ContextStructMessageResponse record {|
    StructMessageResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type ContextDurationMessageResponse record {|
    DurationMessageResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type ContextTimestampMessageResponse record {|
    TimestampMessageResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type ContextAnyMessageRequest record {|
    AnyMessageRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type ContextAnyMessageResponse record {|
    AnyMessageResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type ContextStructMessageRequest record {|
    StructMessageRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type ContextDurationMessageRequest record {|
    DurationMessageRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type ContextTimestampMessageRequest record {|
    TimestampMessageRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type StructMessageResponse record {|
    string name = "";
    int code = 0;
    map<anydata> details = {};
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type DurationMessageResponse record {|
    string name = "";
    int code = 0;
    time:Seconds details = 0.0d;
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type TimestampMessageResponse record {|
    string name = "";
    int code = 0;
    time:Utc details = [0, 0.0d];
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type AnyMessageRequest record {|
    string name = "";
    'any:Any details = {typeUrl: "", value: ()};
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type AnyMessageResponse record {|
    string name = "";
    int code = 0;
    'any:Any details = {typeUrl: "", value: ()};
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type AnyTypeMsgForAnyMessage record {|
    string name = "";
    int code = 0;
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type StructMessageRequest record {|
    string name = "";
    map<anydata> details = {};
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type DurationMessageRequest record {|
    string name = "";
    time:Seconds details = 0.0d;
|};

@protobuf:Descriptor {
    value: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES
}
public type TimestampMessageRequest record {|
    string name = "";
    time:Utc details = [0, 0.0d];
|};

const string ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES = "0A2536365F707265646566696E65645F74797065735F696E5F6D657373616765732E70726F746F1A19676F6F676C652F70726F746F6275662F616E792E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F22570A11416E794D6573736167655265717565737412120A046E616D6518012001280952046E616D65122E0A0764657461696C7318022001280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C73226C0A12416E794D657373616765526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465122E0A0764657461696C7318032001280B32142E676F6F676C652E70726F746F6275662E416E79520764657461696C7322410A17416E79547970654D7367466F72416E794D65737361676512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F6465225D0A145374727563744D6573736167655265717565737412120A046E616D6518012001280952046E616D6512310A0764657461696C7318022001280B32172E676F6F676C652E70726F746F6275662E537472756374520764657461696C7322720A155374727563744D657373616765526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512310A0764657461696C7318032001280B32172E676F6F676C652E70726F746F6275662E537472756374520764657461696C7322630A1754696D657374616D704D6573736167655265717565737412120A046E616D6518012001280952046E616D6512340A0764657461696C7318022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520764657461696C7322780A1854696D657374616D704D657373616765526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512340A0764657461696C7318032001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520764657461696C7322610A164475726174696F6E4D6573736167655265717565737412120A046E616D6518012001280952046E616D6512330A0764657461696C7318022001280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E520764657461696C7322760A174475726174696F6E4D657373616765526573706F6E736512120A046E616D6518012001280952046E616D6512120A04636F64651802200128055204636F646512330A0764657461696C7318032001280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E520764657461696C73329C020A18507265646566696E65645479706573496E5365727669636512340A07616E7943616C6C12122E416E794D657373616765526571756573741A132E416E794D657373616765526573706F6E73652200123D0A0A73747275637443616C6C12152E5374727563744D657373616765526571756573741A162E5374727563744D657373616765526573706F6E7365220012460A0D74696D657374616D7043616C6C12182E54696D657374616D704D657373616765526571756573741A192E54696D657374616D704D657373616765526573706F6E7365220012430A0C6475726174696F6E43616C6C12172E4475726174696F6E4D657373616765526571756573741A182E4475726174696F6E4D657373616765526573706F6E73652200620670726F746F33";

public isolated function getDescriptorMap66PredefinedTypesInMessages() returns map<string> {
    return {};
}

