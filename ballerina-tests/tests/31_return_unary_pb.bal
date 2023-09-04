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

const string RETURN_UNARY_DESC = "0A1533315F72657475726E5F756E6172792E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22310A0B53616D706C654D7367333112120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696432360A0C48656C6C6F576F726C64333112260A0873617948656C6C6F120C2E53616D706C654D736733311A0C2E53616D706C654D73673331620670726F746F33";

public isolated client class HelloWorld31Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, RETURN_UNARY_DESC);
    }

    isolated remote function sayHello(SampleMsg31|ContextSampleMsg31 req) returns SampleMsg31|grpc:Error {
        map<string|string[]> headers = {};
        SampleMsg31 message;
        if req is ContextSampleMsg31 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld31/sayHello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SampleMsg31>result;
    }

    isolated remote function sayHelloContext(SampleMsg31|ContextSampleMsg31 req) returns ContextSampleMsg31|grpc:Error {
        map<string|string[]> headers = {};
        SampleMsg31 message;
        if req is ContextSampleMsg31 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld31/sayHello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SampleMsg31>result, headers: respHeaders};
    }
}

public client class HelloWorld31SampleMsg31Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSampleMsg31(SampleMsg31 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSampleMsg31(ContextSampleMsg31 response) returns grpc:Error? {
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

public type ContextSampleMsg31 record {|
    SampleMsg31 content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: RETURN_UNARY_DESC}
public type SampleMsg31 record {|
    string name = "";
    int id = 0;
|};

