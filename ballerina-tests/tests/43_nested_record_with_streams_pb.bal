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

const string NESTED_RECORD_WITH_STREAMS_DESC = "0A2334335F6E65737465645F7265636F72645F776974685F73747265616D732E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223F0A094E65737465644D736712120A046E616D6518012001280952046E616D65121E0A036D736718022001280B320C2E4E65737465644D73674C3152036D736722450A0B4E65737465644D73674C3112140A056E616D653118012001280952056E616D653112200A046D73673118022001280B320C2E4E65737465644D73674C3252046D73673122450A0B4E65737465644D73674C3212140A056E616D653218012001280952056E616D653212200A046D73673218022001280B320C2E4E65737465644D73674C3352046D73673222330A0B4E65737465644D73674C3312140A056E616D653318012001280952056E616D6533120E0A02696418022001280552026964329D020A104E65737465644D736753657276696365123A0A0E6E65737465644D7367556E617279121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0A2E4E65737465644D736712460A186E65737465644D736753657276657253747265616D696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0A2E4E65737465644D7367300112460A186E65737465644D7367436C69656E7453747265616D696E67120A2E4E65737465644D73671A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75652801123D0A1F6E65737465644D73674269646972656374696F6E616C53747265616D696E67120A2E4E65737465644D73671A0A2E4E65737465644D736728013001620670726F746F33";

public isolated client class NestedMsgServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, NESTED_RECORD_WITH_STREAMS_DESC);
    }

    isolated remote function nestedMsgUnary(string|wrappers:ContextString req) returns NestedMsg|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("NestedMsgService/nestedMsgUnary", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <NestedMsg>result;
    }

    isolated remote function nestedMsgUnaryContext(string|wrappers:ContextString req) returns ContextNestedMsg|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("NestedMsgService/nestedMsgUnary", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <NestedMsg>result, headers: respHeaders};
    }

    isolated remote function nestedMsgClientStreaming() returns NestedMsgClientStreamingStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("NestedMsgService/nestedMsgClientStreaming");
        return new NestedMsgClientStreamingStreamingClient(sClient);
    }

    isolated remote function nestedMsgServerStreaming(string|wrappers:ContextString req) returns stream<NestedMsg, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("NestedMsgService/nestedMsgServerStreaming", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        NestedMsgStream outputStream = new NestedMsgStream(result);
        return new stream<NestedMsg, grpc:Error?>(outputStream);
    }

    isolated remote function nestedMsgServerStreamingContext(string|wrappers:ContextString req) returns ContextNestedMsgStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("NestedMsgService/nestedMsgServerStreaming", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        NestedMsgStream outputStream = new NestedMsgStream(result);
        return {content: new stream<NestedMsg, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function nestedMsgBidirectionalStreaming() returns NestedMsgBidirectionalStreamingStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("NestedMsgService/nestedMsgBidirectionalStreaming");
        return new NestedMsgBidirectionalStreamingStreamingClient(sClient);
    }
}

public isolated client class NestedMsgClientStreamingStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendNestedMsg(NestedMsg message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextNestedMsg(ContextNestedMsg message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveString() returns string|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return payload.toString();
        }
    }

    isolated remote function receiveContextString() returns wrappers:ContextString|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: payload.toString(), headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class NestedMsgStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|NestedMsg value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|NestedMsg value;|} nextRecord = {value: <NestedMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public isolated client class NestedMsgBidirectionalStreamingStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendNestedMsg(NestedMsg message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextNestedMsg(ContextNestedMsg message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveNestedMsg() returns NestedMsg|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <NestedMsg>payload;
        }
    }

    isolated remote function receiveContextNestedMsg() returns ContextNestedMsg|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <NestedMsg>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class NestedMsgServiceStringCaller {
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

public isolated client class NestedMsgServiceNestedMsgCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendNestedMsg(NestedMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextNestedMsg(ContextNestedMsg response) returns grpc:Error? {
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

public type ContextNestedMsgStream record {|
    stream<NestedMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextNestedMsg record {|
    NestedMsg content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: NESTED_RECORD_WITH_STREAMS_DESC}
public type NestedMsgL1 record {|
    string name1 = "";
    NestedMsgL2 msg1 = {};
|};

@protobuf:Descriptor {value: NESTED_RECORD_WITH_STREAMS_DESC}
public type NestedMsg record {|
    string name = "";
    NestedMsgL1 msg = {};
|};

@protobuf:Descriptor {value: NESTED_RECORD_WITH_STREAMS_DESC}
public type NestedMsgL3 record {|
    string name3 = "";
    int id = 0;
|};

@protobuf:Descriptor {value: NESTED_RECORD_WITH_STREAMS_DESC}
public type NestedMsgL2 record {|
    string name2 = "";
    NestedMsgL3 msg2 = {};
|};

