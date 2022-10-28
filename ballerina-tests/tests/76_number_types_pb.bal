// Copyright (c) 2022 WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
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

const string NUMBER_TYPES_DESC = "0A1537365F6E756D6265725F74797065732E70726F746F22EA020A0C54797065734D657373616765121E0A0A696E74333256616C7565180120012805520A696E74333256616C7565121E0A0A696E74363456616C7565180220012803520A696E74363456616C756512200A0B75696E74333256616C756518032001280D520B75696E74333256616C756512200A0B75696E74363456616C7565180420012804520B75696E74363456616C756512200A0B73696E74333256616C7565180520012811520B73696E74333256616C756512200A0B73696E74363456616C7565180620012812520B73696E74363456616C756512220A0C6669786564333256616C7565180720012807520C6669786564333256616C756512220A0C6669786564363456616C7565180820012806520C6669786564363456616C756512240A0D736669786564333256616C756518092001280F520D736669786564333256616C756512240A0D736669786564363456616C7565180A20012810520D736669786564363456616C7565323A0A0C547970657353657276696365122A0A086765745479706573120D2E54797065734D6573736167651A0D2E54797065734D6573736167652200620670726F746F33";

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

public type ContextTypesMessage record {|
    TypesMessage content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: NUMBER_TYPES_DESC}
public type TypesMessage record {|
    int int32Value = 0;
    int int64Value = 0;
    int uint32Value = 0;
    int uint64Value = 0;
    int sint32Value = 0;
    int sint64Value = 0;
    int fixed32Value = 0;
    int fixed64Value = 0;
    int sfixed32Value = 0;
    int sfixed64Value = 0;
|};

