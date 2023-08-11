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
import ballerina/protobuf.types.wrappers;

const string GRPC_ENUM_TEST_SERVICE_DESC = "0A1F31325F677270635F656E756D5F746573745F736572766963652E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22430A094F72646572496E666F120E0A0269641801200128095202696412260A046D6F646518022001280E32122E6772706373657276696365732E4D6F646552046D6F64652A0D0A044D6F646512050A0172100032540A0F54657374456E756D5365727669636512410A0874657374456E756D12172E6772706373657276696365732E4F72646572496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33";

public isolated client class TestEnumServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, GRPC_ENUM_TEST_SERVICE_DESC);
    }

    isolated remote function testEnum(OrderInfo|ContextOrderInfo req) returns string|grpc:Error {
        map<string|string[]> headers = {};
        OrderInfo message;
        if req is ContextOrderInfo {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.TestEnumService/testEnum", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function testEnumContext(OrderInfo|ContextOrderInfo req) returns wrappers:ContextString|grpc:Error {
        map<string|string[]> headers = {};
        OrderInfo message;
        if req is ContextOrderInfo {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.TestEnumService/testEnum", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }
}

public client class TestEnumServiceStringCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendString(string response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextString(wrappers:ContextString response) returns grpc:Error? {
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

public type ContextOrderInfo record {|
    OrderInfo content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: GRPC_ENUM_TEST_SERVICE_DESC}
public type OrderInfo record {|
    string id = "";
    Mode mode = r;
|};

public enum Mode {
    r
}

