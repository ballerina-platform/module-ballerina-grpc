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

const string RETURN_RECORD_SERVER_STREAMING_DESC = "0A2733325F72657475726E5F7265636F72645F7365727665725F73747265616D696E672E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22310A0B53616D706C654D7367333212120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696432380A0C48656C6C6F576F726C64333212280A0873617948656C6C6F120C2E53616D706C654D736733321A0C2E53616D706C654D736733323001620670726F746F33";

public isolated client class HelloWorld32Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, RETURN_RECORD_SERVER_STREAMING_DESC);
    }

    isolated remote function sayHello(SampleMsg32|ContextSampleMsg32 req) returns stream<SampleMsg32, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        SampleMsg32 message;
        if req is ContextSampleMsg32 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("HelloWorld32/sayHello", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        SampleMsg32Stream outputStream = new SampleMsg32Stream(result);
        return new stream<SampleMsg32, grpc:Error?>(outputStream);
    }

    isolated remote function sayHelloContext(SampleMsg32|ContextSampleMsg32 req) returns ContextSampleMsg32Stream|grpc:Error {
        map<string|string[]> headers = {};
        SampleMsg32 message;
        if req is ContextSampleMsg32 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("HelloWorld32/sayHello", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        SampleMsg32Stream outputStream = new SampleMsg32Stream(result);
        return {content: new stream<SampleMsg32, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public class SampleMsg32Stream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|SampleMsg32 value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|SampleMsg32 value;|} nextRecord = {value: <SampleMsg32>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class HelloWorld32SampleMsg32Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSampleMsg32(SampleMsg32 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSampleMsg32(ContextSampleMsg32 response) returns grpc:Error? {
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

public type ContextSampleMsg32Stream record {|
    stream<SampleMsg32, error?> content;
    map<string|string[]> headers;
|};

public type ContextSampleMsg32 record {|
    SampleMsg32 content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: RETURN_RECORD_SERVER_STREAMING_DESC}
public type SampleMsg32 record {|
    string name = "";
    int id = 0;
|};

