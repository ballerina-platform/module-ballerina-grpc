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
import ballerina/time;

public isolated client class DurationHandlerClient {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_49, getDescriptorMap49());
    }

    isolated remote function unaryCall1(string|ContextString req) returns (time:Seconds|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("DurationHandler/unaryCall1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <time:Seconds>result;
    }

    isolated remote function unaryCall1Context(string|ContextString req) returns (ContextDuration|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("DurationHandler/unaryCall1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <time:Seconds>result, headers: respHeaders};
    }

    isolated remote function unaryCall2(DurationMsg|ContextDurationMsg req) returns (DurationMsg|Error) {
        map<string|string[]> headers = {};
        DurationMsg message;
        if (req is ContextDurationMsg) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("DurationHandler/unaryCall2", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <DurationMsg>result;
    }

    isolated remote function unaryCall2Context(DurationMsg|ContextDurationMsg req) returns (ContextDurationMsg|Error) {
        map<string|string[]> headers = {};
        DurationMsg message;
        if (req is ContextDurationMsg) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("DurationHandler/unaryCall2", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <DurationMsg>result, headers: respHeaders};
    }

    isolated remote function clientStreaming() returns (ClientStreamingStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeClientStreaming("DurationHandler/clientStreaming");
        return new ClientStreamingStreamingClient(sClient);
    }

    isolated remote function serverStreaming(string|ContextString req) returns stream<time:Seconds, Error?>|Error {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DurationHandler/serverStreaming", message, headers);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        DurationStream outputStream = new DurationStream(result);
        return new stream<time:Seconds, Error?>(outputStream);
    }

    isolated remote function serverStreamingContext(string|ContextString req) returns ContextDurationStream|Error {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DurationHandler/serverStreaming", message, headers);
        [stream<anydata, Error?>, map<string|string[]>] [result, respHeaders] = payload;
        DurationStream outputStream = new DurationStream(result);
        return {content: new stream<time:Seconds, Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function bidirectionalStreaming() returns (BidirectionalStreamingStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("DurationHandler/bidirectionalStreaming");
        return new BidirectionalStreamingStreamingClient(sClient);
    }
}

public client class ClientStreamingStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendDuration(time:Seconds message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextDuration(ContextDuration message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveString() returns string|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return payload.toString();
        }
    }

    isolated remote function receiveContextString() returns ContextString|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: payload.toString(), headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public class DurationStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|time:Seconds value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|time:Seconds value;|} nextRecord = {value: <time:Seconds>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public client class BidirectionalStreamingStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendDurationMsg(DurationMsg message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextDurationMsg(ContextDurationMsg message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveDurationMsg() returns DurationMsg|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <DurationMsg>payload;
        }
    }

    isolated remote function receiveContextDurationMsg() returns ContextDurationMsg|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <DurationMsg>payload, headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public client class DurationHandlerDurationMsgCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendDurationMsg(DurationMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextDurationMsg(ContextDurationMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class DurationHandlerDurationCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendDuration(time:Seconds response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextDuration(ContextDuration response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class DurationHandlerStringCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendString(string response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextString(ContextString response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextDurationMsgStream record {|
    stream<DurationMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextDurationStream record {|
    stream<time:Seconds, error?> content;
    map<string|string[]> headers;
|};

//public type ContextString record {|
//    string content;
//    map<string|string[]> headers;
//|};

public type ContextDurationMsg record {|
    DurationMsg content;
    map<string|string[]> headers;
|};

public type ContextDuration record {|
    time:Seconds content;
    map<string|string[]> headers;
|};

public type DurationMsg record {|
    string name = "";
    time:Seconds duration = 0.0d;
|};

const string ROOT_DESCRIPTOR_49 = "0A1134395F6475726174696F6E2E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F22580A0B4475726174696F6E4D736712120A046E616D6518012001280952046E616D6512350A086475726174696F6E18022001280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E52086475726174696F6E32E2020A0F4475726174696F6E48616E646C657212470A0A756E61727943616C6C31121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A192E676F6F676C652E70726F746F6275662E4475726174696F6E2200122A0A0A756E61727943616C6C32120C2E4475726174696F6E4D73671A0C2E4475726174696F6E4D73672200124E0A0F73657276657253747265616D696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A192E676F6F676C652E70726F746F6275662E4475726174696F6E22003001124E0A0F636C69656E7453747265616D696E6712192E676F6F676C652E70726F746F6275662E4475726174696F6E1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756522002801123A0A166269646972656374696F6E616C53747265616D696E67120C2E4475726174696F6E4D73671A0C2E4475726174696F6E4D7367220028013001620670726F746F33";

isolated function getDescriptorMap49() returns map<string> {
    return {"49_duration.proto": "0A1134395F6475726174696F6E2E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F22580A0B4475726174696F6E4D736712120A046E616D6518012001280952046E616D6512350A086475726174696F6E18022001280B32192E676F6F676C652E70726F746F6275662E4475726174696F6E52086475726174696F6E32E2020A0F4475726174696F6E48616E646C657212470A0A756E61727943616C6C31121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A192E676F6F676C652E70726F746F6275662E4475726174696F6E2200122A0A0A756E61727943616C6C32120C2E4475726174696F6E4D73671A0C2E4475726174696F6E4D73672200124E0A0F73657276657253747265616D696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A192E676F6F676C652E70726F746F6275662E4475726174696F6E22003001124E0A0F636C69656E7453747265616D696E6712192E676F6F676C652E70726F746F6275662E4475726174696F6E1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756522002801123A0A166269646972656374696F6E616C53747265616D696E67120C2E4475726174696F6E4D73671A0C2E4475726174696F6E4D7367220028013001620670726F746F33", "google/protobuf/duration.proto": "0A1E676F6F676C652F70726F746F6275662F6475726174696F6E2E70726F746F120F676F6F676C652E70726F746F627566223A0A084475726174696F6E12180A077365636F6E647318012001280352077365636F6E647312140A056E616E6F7318022001280552056E616E6F7342570A13636F6D2E676F6F676C652E70726F746F627566420D4475726174696F6E50726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

