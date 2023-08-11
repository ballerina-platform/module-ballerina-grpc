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

const string RETURN_RECORD_CLIENT_STREAMING_DESC = "0A2733335F72657475726E5F7265636F72645F636C69656E745F73747265616D696E672E70726F746F22310A0B53616D706C654D7367333312120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696432380A0C48656C6C6F576F726C64333312280A0873617948656C6C6F120C2E53616D706C654D736733331A0C2E53616D706C654D736733332801620670726F746F33";

public isolated client class HelloWorld33Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, RETURN_RECORD_CLIENT_STREAMING_DESC);
    }

    isolated remote function sayHello() returns SayHelloStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("HelloWorld33/sayHello");
        return new SayHelloStreamingClient(sClient);
    }
}

public client class SayHelloStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendSampleMsg33(SampleMsg33 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextSampleMsg33(ContextSampleMsg33 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveSampleMsg33() returns SampleMsg33|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <SampleMsg33>payload;
        }
    }

    isolated remote function receiveContextSampleMsg33() returns ContextSampleMsg33|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <SampleMsg33>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class HelloWorld33SampleMsg33Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSampleMsg33(SampleMsg33 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSampleMsg33(ContextSampleMsg33 response) returns grpc:Error? {
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

public type ContextSampleMsg33Stream record {|
    stream<SampleMsg33, error?> content;
    map<string|string[]> headers;
|};

public type ContextSampleMsg33 record {|
    SampleMsg33 content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: RETURN_RECORD_CLIENT_STREAMING_DESC}
public type SampleMsg33 record {|
    string name = "";
    int id = 0;
|};

