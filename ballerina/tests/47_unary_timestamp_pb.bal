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

public isolated client class TimestampServiceClient {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_47, getDescriptorMap47());
    }

    isolated remote function getGreeting(string|ContextString req) returns (Greeting|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TimestampService/getGreeting", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Greeting>result;
    }

    isolated remote function getGreetingContext(string|ContextString req) returns (ContextGreeting|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TimestampService/getGreeting", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Greeting>result, headers: respHeaders};
    }

    isolated remote function exchangeGreeting(Greeting|ContextGreeting req) returns (Greeting|Error) {
        map<string|string[]> headers = {};
        Greeting message;
        if (req is ContextGreeting) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TimestampService/exchangeGreeting", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Greeting>result;
    }

    isolated remote function exchangeGreetingContext(Greeting|ContextGreeting req) returns (ContextGreeting|Error) {
        map<string|string[]> headers = {};
        Greeting message;
        if (req is ContextGreeting) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TimestampService/exchangeGreeting", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Greeting>result, headers: respHeaders};
    }

    isolated remote function exchangeTime(time:Utc|ContextTimestamp req) returns (time:Utc|Error) {
        map<string|string[]> headers = {};
        time:Utc message;
        if (req is ContextTimestamp) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TimestampService/exchangeTime", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <time:Utc>result.cloneReadOnly();
    }

    isolated remote function exchangeTimeContext(time:Utc|ContextTimestamp req) returns (ContextTimestamp|Error) {
        map<string|string[]> headers = {};
        time:Utc message;
        if (req is ContextTimestamp) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("TimestampService/exchangeTime", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <time:Utc>result.cloneReadOnly(), headers: respHeaders};
    }

    isolated remote function clientStreamTime() returns (ClientStreamTimeStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeClientStreaming("TimestampService/clientStreamTime");
        return new ClientStreamTimeStreamingClient(sClient);
    }

    isolated remote function serverStreamTime(time:Utc|ContextTimestamp req) returns stream<time:Utc, Error?>|Error {
        map<string|string[]> headers = {};
        time:Utc message;
        if (req is ContextTimestamp) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("TimestampService/serverStreamTime", message, headers);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        TimestampStream outputStream = new TimestampStream(result);
        return new stream<time:Utc, Error?>(outputStream);
    }

    isolated remote function serverStreamTimeContext(time:Utc|ContextTimestamp req) returns ContextTimestampStream|Error {
        map<string|string[]> headers = {};
        time:Utc message;
        if (req is ContextTimestamp) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("TimestampService/serverStreamTime", message, headers);
        [stream<anydata, Error?>, map<string|string[]>] [result, respHeaders] = payload;
        TimestampStream outputStream = new TimestampStream(result);
        return {content: new stream<time:Utc, Error?>(outputStream), headers: respHeaders};
    }
}

public client class ClientStreamTimeStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendTimestamp(time:Utc message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextTimestamp(ContextTimestamp message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveTimestamp() returns time:Utc|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <time:Utc>payload.cloneReadOnly();
        }
    }

    isolated remote function receiveContextTimestamp() returns ContextTimestamp|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <time:Utc>payload.cloneReadOnly(), headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public class TimestampStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|time:Utc value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|time:Utc value;|} nextRecord = {value: <time:Utc>streamValue.value.cloneReadOnly()};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public client class TimestampServiceTimestampCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendTimestamp(time:Utc response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextTimestamp(ContextTimestamp response) returns Error? {
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

public client class TimestampServiceGreetingCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendGreeting(Greeting response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextGreeting(ContextGreeting response) returns Error? {
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

// public type ContextTimestampStream record {|
//     stream<time:Utc, error?> content;
//     map<string|string[]> headers;
// |};

public type ContextGreeting record {|
    Greeting content;
    map<string|string[]> headers;
|};

// public type ContextString record {|
//     string content;
//     map<string|string[]> headers;
// |};

public type ContextTimestamp record {|
    time:Utc content;
    map<string|string[]> headers;
|};

public type Greeting record {|
    string name = "";
    time:Utc time = [0, 0.0d];
|};

const string ROOT_DESCRIPTOR_47 = "0A1768656C6C6F576F726C64426F6F6C65616E2E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F224E0A084772656574696E6712120A046E616D6518012001280952046E616D65122E0A0474696D6518022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520474696D6532E2020A1054696D657374616D705365727669636512380A0B6765744772656574696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A092E4772656574696E672200122A0A1065786368616E67654772656574696E6712092E4772656574696E671A092E4772656574696E67220012480A0C65786368616E676554696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D702200124E0A1073657276657253747265616D54696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D7022003001124E0A10636C69656E7453747265616D54696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D7022002801620670726F746F33";

isolated function getDescriptorMap47() returns map<string> {
    return {"google/protobuf/timestamp.proto": "0A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F120F676F6F676C652E70726F746F627566223B0A0954696D657374616D7012180A077365636F6E647318012001280352077365636F6E647312140A056E616E6F7318022001280552056E616E6F7342580A13636F6D2E676F6F676C652E70726F746F627566420E54696D657374616D7050726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "helloWorldBoolean.proto": "0A1768656C6C6F576F726C64426F6F6C65616E2E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F224E0A084772656574696E6712120A046E616D6518012001280952046E616D65122E0A0474696D6518022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520474696D6532E2020A1054696D657374616D705365727669636512380A0B6765744772656574696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A092E4772656574696E672200122A0A1065786368616E67654772656574696E6712092E4772656574696E671A092E4772656574696E67220012480A0C65786368616E676554696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D702200124E0A1073657276657253747265616D54696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D7022003001124E0A10636C69656E7453747265616D54696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D7022002801620670726F746F33"};
}
