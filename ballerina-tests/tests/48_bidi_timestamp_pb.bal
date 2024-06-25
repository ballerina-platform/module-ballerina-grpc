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
import ballerina/time;
import ballerina/protobuf.types.timestamp;
import ballerina/protobuf.types.wrappers;

const string BIDI_TIMESTAMP_DESC = "0A1734385F626964695F74696D657374616D702E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F22520A0C426944694772656574696E6712120A046E616D6518012001280952046E616D65122E0A0474696D6518022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520474696D653287020A1D4269646953747265616D696E6754696D657374616D7053657276696365124D0A186269646953747265616D696E674772656574536572766572121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0D2E426944694772656574696E67220028013001123C0A166269646953747265616D696E674772656574426F7468120D2E426944694772656574696E671A0D2E426944694772656574696E6722002801300112590A196269646953747265616D696E6745786368616E676554696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D70220028013001620670726F746F33";

public isolated client class BidiStreamingTimestampServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, BIDI_TIMESTAMP_DESC);
    }

    isolated remote function bidiStreamingGreetServer() returns BidiStreamingGreetServerStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("BidiStreamingTimestampService/bidiStreamingGreetServer");
        return new BidiStreamingGreetServerStreamingClient(sClient);
    }

    isolated remote function bidiStreamingGreetBoth() returns BidiStreamingGreetBothStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("BidiStreamingTimestampService/bidiStreamingGreetBoth");
        return new BidiStreamingGreetBothStreamingClient(sClient);
    }

    isolated remote function bidiStreamingExchangeTime() returns BidiStreamingExchangeTimeStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("BidiStreamingTimestampService/bidiStreamingExchangeTime");
        return new BidiStreamingExchangeTimeStreamingClient(sClient);
    }
}

public isolated client class BidiStreamingGreetServerStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendString(string message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextString(wrappers:ContextString message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveBiDiGreeting() returns BiDiGreeting|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <BiDiGreeting>payload;
        }
    }

    isolated remote function receiveContextBiDiGreeting() returns ContextBiDiGreeting|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <BiDiGreeting>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class BidiStreamingGreetBothStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendBiDiGreeting(BiDiGreeting message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextBiDiGreeting(ContextBiDiGreeting message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveBiDiGreeting() returns BiDiGreeting|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <BiDiGreeting>payload;
        }
    }

    isolated remote function receiveContextBiDiGreeting() returns ContextBiDiGreeting|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <BiDiGreeting>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class BidiStreamingExchangeTimeStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendTimestamp(time:Utc message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextTimestamp(timestamp:ContextTimestamp message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveTimestamp() returns time:Utc|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <time:Utc>payload.cloneReadOnly();
        }
    }

    isolated remote function receiveContextTimestamp() returns timestamp:ContextTimestamp|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <time:Utc>payload.cloneReadOnly(), headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class BidiStreamingTimestampServiceTimestampCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendTimestamp(time:Utc response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextTimestamp(timestamp:ContextTimestamp response) returns grpc:Error? {
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

public isolated client class BidiStreamingTimestampServiceBiDiGreetingCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBiDiGreeting(BiDiGreeting response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBiDiGreeting(ContextBiDiGreeting response) returns grpc:Error? {
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

public type ContextBiDiGreetingStream record {|
    stream<BiDiGreeting, error?> content;
    map<string|string[]> headers;
|};

public type ContextBiDiGreeting record {|
    BiDiGreeting content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: BIDI_TIMESTAMP_DESC}
public type BiDiGreeting record {|
    string name = "";
    time:Utc time = [0, 0.0d];
|};

