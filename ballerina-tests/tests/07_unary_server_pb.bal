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
import ballerina/protobuf.types.empty;
import ballerina/protobuf.types.wrappers;

const string UNARY_SERVER_DESC = "0A1530375F756E6172795F7365727665722E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22370A075265717565737412120A046E616D6518012001280952046E616D6512180A076D65737361676518022001280952076D657373616765221E0A08526573706F6E736512120A047265737018012001280952047265737032C4040A0D48656C6C6F576F726C6431303012430A0568656C6C6F121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512430A0774657374496E74121B2E676F6F676C652E70726F746F6275662E496E74333256616C75651A1B2E676F6F676C652E70726F746F6275662E496E74333256616C756512450A0974657374466C6F6174121B2E676F6F676C652E70726F746F6275662E466C6F617456616C75651A1B2E676F6F676C652E70726F746F6275662E466C6F617456616C756512450A0B74657374426F6F6C65616E121A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75651A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C7565123B0A0A7465737453747275637412152E6772706373657276696365732E526571756573741A162E6772706373657276696365732E526573706F6E736512450A0D746573744E6F5265717565737412162E676F6F676C652E70726F746F6275662E456D7074791A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512460A0E746573744E6F526573706F6E7365121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A162E676F6F676C652E70726F746F6275662E456D707479124F0A1774657374526573706F6E7365496E736964654D61746368121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A162E6772706373657276696365732E526573706F6E7365620670726F746F33";

public isolated client class HelloWorld100Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, UNARY_SERVER_DESC);
    }

    isolated remote function hello(string|wrappers:ContextString req) returns string|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/hello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function helloContext(string|wrappers:ContextString req) returns wrappers:ContextString|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function testInt(int|wrappers:ContextInt req) returns int|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testInt", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <int>result;
    }

    isolated remote function testIntContext(int|wrappers:ContextInt req) returns wrappers:ContextInt|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testInt", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <int>result, headers: respHeaders};
    }

    isolated remote function testFloat(float|wrappers:ContextFloat req) returns float|grpc:Error {
        map<string|string[]> headers = {};
        float message;
        if req is wrappers:ContextFloat {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testFloat", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <float>result;
    }

    isolated remote function testFloatContext(float|wrappers:ContextFloat req) returns wrappers:ContextFloat|grpc:Error {
        map<string|string[]> headers = {};
        float message;
        if req is wrappers:ContextFloat {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testFloat", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <float>result, headers: respHeaders};
    }

    isolated remote function testBoolean(boolean|wrappers:ContextBoolean req) returns boolean|grpc:Error {
        map<string|string[]> headers = {};
        boolean message;
        if req is wrappers:ContextBoolean {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testBoolean", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <boolean>result;
    }

    isolated remote function testBooleanContext(boolean|wrappers:ContextBoolean req) returns wrappers:ContextBoolean|grpc:Error {
        map<string|string[]> headers = {};
        boolean message;
        if req is wrappers:ContextBoolean {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testBoolean", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <boolean>result, headers: respHeaders};
    }

    isolated remote function testStruct(Request|ContextRequest req) returns Response|grpc:Error {
        map<string|string[]> headers = {};
        Request message;
        if req is ContextRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testStruct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Response>result;
    }

    isolated remote function testStructContext(Request|ContextRequest req) returns ContextResponse|grpc:Error {
        map<string|string[]> headers = {};
        Request message;
        if req is ContextRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testStruct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Response>result, headers: respHeaders};
    }

    isolated remote function testNoRequest() returns string|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testNoRequest", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function testNoRequestContext() returns wrappers:ContextString|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testNoRequest", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function testNoResponse(string|wrappers:ContextString req) returns grpc:Error? {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        _ = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testNoResponse", message, headers);
    }

    isolated remote function testNoResponseContext(string|wrappers:ContextString req) returns empty:ContextNil|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testNoResponse", message, headers);
        [anydata, map<string|string[]>] [_, respHeaders] = payload;
        return {headers: respHeaders};
    }

    isolated remote function testResponseInsideMatch(string|wrappers:ContextString req) returns Response|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testResponseInsideMatch", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Response>result;
    }

    isolated remote function testResponseInsideMatchContext(string|wrappers:ContextString req) returns ContextResponse|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testResponseInsideMatch", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Response>result, headers: respHeaders};
    }
}

public isolated client class HelloWorld100BooleanCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBoolean(boolean response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBoolean(wrappers:ContextBoolean response) returns grpc:Error? {
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

public isolated client class HelloWorld100StringCaller {
    private final grpc:Caller caller;

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

public isolated client class HelloWorld100IntCaller {
    private final grpc:Caller caller;

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

public isolated client class HelloWorld100NilCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
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

public isolated client class HelloWorld100FloatCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendFloat(float response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextFloat(wrappers:ContextFloat response) returns grpc:Error? {
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

public isolated client class HelloWorld100ResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendResponse(Response response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextResponse(ContextResponse response) returns grpc:Error? {
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

public type ContextResponse record {|
    Response content;
    map<string|string[]> headers;
|};

public type ContextRequest record {|
    Request content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: UNARY_SERVER_DESC}
public type Response record {|
    string resp = "";
|};

@protobuf:Descriptor {value: UNARY_SERVER_DESC}
public type Request record {|
    string name = "";
    string message = "";
|};

