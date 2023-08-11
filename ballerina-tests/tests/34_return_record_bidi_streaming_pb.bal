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

const string RETURN_RECORD_BIDI_STREAMING_DESC = "0A2533345F72657475726E5F7265636F72645F626964695F73747265616D696E672E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22310A0B53616D706C654D7367333412120A046E616D6518012001280952046E616D65120E0A02696418022001280552026964323C0A0C48656C6C6F576F726C643334122C0A0A73617948656C6C6F3334120C2E53616D706C654D736733341A0C2E53616D706C654D7367333428013001620670726F746F33";

public isolated client class HelloWorld34Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, RETURN_RECORD_BIDI_STREAMING_DESC);
    }

    isolated remote function sayHello34() returns SayHello34StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("HelloWorld34/sayHello34");
        return new SayHello34StreamingClient(sClient);
    }
}

public client class SayHello34StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendSampleMsg34(SampleMsg34 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextSampleMsg34(ContextSampleMsg34 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveSampleMsg34() returns SampleMsg34|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <SampleMsg34>payload;
        }
    }

    isolated remote function receiveContextSampleMsg34() returns ContextSampleMsg34|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <SampleMsg34>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class HelloWorld34SampleMsg34Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSampleMsg34(SampleMsg34 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSampleMsg34(ContextSampleMsg34 response) returns grpc:Error? {
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

public type ContextSampleMsg34Stream record {|
    stream<SampleMsg34, error?> content;
    map<string|string[]> headers;
|};

public type ContextSampleMsg34 record {|
    SampleMsg34 content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: RETURN_RECORD_BIDI_STREAMING_DESC}
public type SampleMsg34 record {|
    string name = "";
    int id = 0;
|};

