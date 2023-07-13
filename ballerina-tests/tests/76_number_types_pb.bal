// Copyright (c) 2022 WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
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
import ballerina/lang.'int;
import ballerina/protobuf;
import ballerina/protobuf.types.wrappers;

public const string NUMBER_TYPES_DESC = "0A1537365F6E756D6265725F74797065732E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22EA020A0C54797065734D657373616765121E0A0A696E74333256616C7565180120012805520A696E74333256616C7565121E0A0A696E74363456616C7565180220012803520A696E74363456616C756512200A0B75696E74333256616C756518032001280D520B75696E74333256616C756512200A0B75696E74363456616C7565180420012804520B75696E74363456616C756512200A0B73696E74333256616C7565180520012811520B73696E74333256616C756512200A0B73696E74363456616C7565180620012812520B73696E74363456616C756512220A0C6669786564333256616C7565180720012807520C6669786564333256616C756512220A0C6669786564363456616C7565180820012806520C6669786564363456616C756512240A0D736669786564333256616C756518092001280F520D736669786564333256616C756512240A0D736669786564363456616C7565180A20012810520D736669786564363456616C75652286030A14526570656174656454797065734D65737361676512200A0B696E74333256616C756573180120032805520B696E74333256616C75657312200A0B696E74363456616C756573180220032803520B696E74363456616C75657312220A0C75696E74333256616C75657318032003280D520C75696E74333256616C75657312220A0C75696E74363456616C756573180420032804520C75696E74363456616C75657312220A0C73696E74333256616C756573180520032811520C73696E74333256616C75657312220A0C73696E74363456616C756573180620032812520C73696E74363456616C75657312240A0D6669786564333256616C756573180720032807520D6669786564333256616C75657312240A0D6669786564363456616C756573180820032806520D6669786564363456616C75657312260A0E736669786564333256616C75657318092003280F520E736669786564333256616C75657312260A0E736669786564363456616C756573180A20032810520E736669786564363456616C75657332B4030A0C547970657353657276696365122A0A086765745479706573120D2E54797065734D6573736167651A0D2E54797065734D657373616765220012420A106765745265706561746564547970657312152E526570656174656454797065734D6573736167651A152E526570656174656454797065734D6573736167652200124A0A0C676574496E74333254797065121B2E676F6F676C652E70726F746F6275662E496E74333256616C75651A1B2E676F6F676C652E70726F746F6275662E496E74333256616C75652200124A0A0C676574496E74363454797065121B2E676F6F676C652E70726F746F6275662E496E74363456616C75651A1B2E676F6F676C652E70726F746F6275662E496E74363456616C75652200124D0A0D67657455496E74333254797065121C2E676F6F676C652E70726F746F6275662E55496E74333256616C75651A1C2E676F6F676C652E70726F746F6275662E55496E74333256616C75652200124D0A0D67657455496E74363454797065121C2E676F6F676C652E70726F746F6275662E55496E74363456616C75651A1C2E676F6F676C652E70726F746F6275662E55496E74363456616C75652200620670726F746F33";

public isolated client class TypesServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, NUMBER_TYPES_DESC);
    }

    isolated remote function getTypes(TypesMessage|ContextTypesMessage req) returns TypesMessage|grpc:Error {
        map<string|string[]> headers = {};
        TypesMessage message;
        if req is ContextTypesMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TypesService/getTypes", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <TypesMessage>result;
    }

    isolated remote function getTypesContext(TypesMessage|ContextTypesMessage req) returns ContextTypesMessage|grpc:Error {
        map<string|string[]> headers = {};
        TypesMessage message;
        if req is ContextTypesMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TypesService/getTypes", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <TypesMessage>result, headers: respHeaders};
    }

    isolated remote function getRepeatedTypes(RepeatedTypesMessage|ContextRepeatedTypesMessage req) returns RepeatedTypesMessage|grpc:Error {
        map<string|string[]> headers = {};
        RepeatedTypesMessage message;
        if req is ContextRepeatedTypesMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TypesService/getRepeatedTypes", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <RepeatedTypesMessage>result;
    }

    isolated remote function getRepeatedTypesContext(RepeatedTypesMessage|ContextRepeatedTypesMessage req) returns ContextRepeatedTypesMessage|grpc:Error {
        map<string|string[]> headers = {};
        RepeatedTypesMessage message;
        if req is ContextRepeatedTypesMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TypesService/getRepeatedTypes", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <RepeatedTypesMessage>result, headers: respHeaders};
    }

    isolated remote function getInt32Type(int|wrappers:ContextInt req) returns int|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TypesService/getInt32Type", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <int>result;
    }

    isolated remote function getInt32TypeContext(int|wrappers:ContextInt req) returns wrappers:ContextInt|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TypesService/getInt32Type", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <int>result, headers: respHeaders};
    }

    isolated remote function getInt64Type(int|wrappers:ContextInt req) returns int|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TypesService/getInt64Type", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <int>result;
    }

    isolated remote function getInt64TypeContext(int|wrappers:ContextInt req) returns wrappers:ContextInt|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TypesService/getInt64Type", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <int>result, headers: respHeaders};
    }

    isolated remote function getUInt32Type(int|wrappers:ContextInt req) returns int|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TypesService/getUInt32Type", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <int>result;
    }

    isolated remote function getUInt32TypeContext(int|wrappers:ContextInt req) returns wrappers:ContextInt|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TypesService/getUInt32Type", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <int>result, headers: respHeaders};
    }

    isolated remote function getUInt64Type(int|wrappers:ContextInt req) returns int|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TypesService/getUInt64Type", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <int>result;
    }

    isolated remote function getUInt64TypeContext(int|wrappers:ContextInt req) returns wrappers:ContextInt|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TypesService/getUInt64Type", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <int>result, headers: respHeaders};
    }
}

public client class TypesServiceRepeatedTypesMessageCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendRepeatedTypesMessage(RepeatedTypesMessage response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextRepeatedTypesMessage(ContextRepeatedTypesMessage response) returns grpc:Error? {
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

public client class TypesServiceTypesMessageCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendTypesMessage(TypesMessage response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextTypesMessage(ContextTypesMessage response) returns grpc:Error? {
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

public client class TypesServiceIntCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendInt(int response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextInt(wrappers:ContextInt response) returns grpc:Error? {
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

public type ContextTypesMessage record {|
    TypesMessage content;
    map<string|string[]> headers;
|};

public type ContextRepeatedTypesMessage record {|
    RepeatedTypesMessage content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: NUMBER_TYPES_DESC}
public type TypesMessage record {|
    int int32Value = 0;
    int int64Value = 0;
    int:Unsigned32 uint32Value = 0;
    int uint64Value = 0;
    int:Signed32 sint32Value = 0;
    int sint64Value = 0;
    int fixed32Value = 0;
    int fixed64Value = 0;
    int sfixed32Value = 0;
    int sfixed64Value = 0;
|};

@protobuf:Descriptor {value: NUMBER_TYPES_DESC}
public type RepeatedTypesMessage record {|
    int[] int32Values = [];
    int[] int64Values = [];
    int:Unsigned32[] uint32Values = [];
    int[] uint64Values = [];
    int:Signed32[] sint32Values = [];
    int[] sint64Values = [];
    int[] fixed32Values = [];
    int[] fixed64Values = [];
    int[] sfixed32Values = [];
    int[] sfixed64Values = [];
|};

