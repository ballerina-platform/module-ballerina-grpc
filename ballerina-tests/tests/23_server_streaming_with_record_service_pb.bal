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

const string SERVER_STREAMING_WITH_RECORD_SERVICE_DESC = "0A2D32335F7365727665725F73747265616D696E675F776974685F7265636F72645F736572766963652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D657373616765324D0A1948656C6C6F576F726C6453657276657253747265616D696E6712300A0D6C6F74734F665265706C696573120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E73653001620670726F746F33";

public isolated client class HelloWorldServerStreamingClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SERVER_STREAMING_WITH_RECORD_SERVICE_DESC);
    }

    isolated remote function lotsOfReplies(HelloRequest|ContextHelloRequest req) returns stream<HelloResponse, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest message;
        if req is ContextHelloRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("HelloWorldServerStreaming/lotsOfReplies", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        HelloResponseStream outputStream = new HelloResponseStream(result);
        return new stream<HelloResponse, grpc:Error?>(outputStream);
    }

    isolated remote function lotsOfRepliesContext(HelloRequest|ContextHelloRequest req) returns ContextHelloResponseStream|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest message;
        if req is ContextHelloRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("HelloWorldServerStreaming/lotsOfReplies", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        HelloResponseStream outputStream = new HelloResponseStream(result);
        return {content: new stream<HelloResponse, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public class HelloResponseStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|HelloResponse value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|HelloResponse value;|} nextRecord = {value: <HelloResponse>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class HelloWorldServerStreamingHelloResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendHelloResponse(HelloResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextHelloResponse(ContextHelloResponse response) returns grpc:Error? {
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

public type ContextHelloResponseStream record {|
    stream<HelloResponse, error?> content;
    map<string|string[]> headers;
|};

public type ContextHelloResponse record {|
    HelloResponse content;
    map<string|string[]> headers;
|};

public type ContextHelloRequest record {|
    HelloRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SERVER_STREAMING_WITH_RECORD_SERVICE_DESC}
public type HelloResponse record {|
    string message = "";
|};

@protobuf:Descriptor {value: SERVER_STREAMING_WITH_RECORD_SERVICE_DESC}
public type HelloRequest record {|
    string name = "";
|};

