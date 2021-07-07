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

public isolated client class BidiStreamingTimestampServiceClient {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_48, getDescriptorMap_48());
    }

    isolated remote function bidiStreamingGreetServer() returns (BidiStreamingGreetServerStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("BidiStreamingTimestampService/bidiStreamingGreetServer");
        return new BidiStreamingGreetServerStreamingClient(sClient);
    }

    isolated remote function bidiStreamingGreetBoth() returns (BidiStreamingGreetBothStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("BidiStreamingTimestampService/bidiStreamingGreetBoth");
        return new BidiStreamingGreetBothStreamingClient(sClient);
    }

    isolated remote function bidiStreamingExchangeTime() returns (BidiStreamingExchangeTimeStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("BidiStreamingTimestampService/bidiStreamingExchangeTime");
        return new BidiStreamingExchangeTimeStreamingClient(sClient);
    }
}

public client class BidiStreamingGreetServerStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendString(string message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextString(ContextString message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveBiDiGreeting() returns BiDiGreeting|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <BiDiGreeting>payload;
        }
    }

    isolated remote function receiveContextBiDiGreeting() returns ContextBiDiGreeting|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <BiDiGreeting>payload, headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public client class BidiStreamingGreetBothStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendBiDiGreeting(BiDiGreeting message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextBiDiGreeting(ContextBiDiGreeting message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveBiDiGreeting() returns BiDiGreeting|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <BiDiGreeting>payload;
        }
    }

    isolated remote function receiveContextBiDiGreeting() returns ContextBiDiGreeting|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <BiDiGreeting>payload, headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public client class BidiStreamingExchangeTimeStreamingClient {
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

public client class BidiStreamingTimestampServiceTimestampCaller {
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

public client class BidiStreamingTimestampServiceBiDiGreetingCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBiDiGreeting(BiDiGreeting response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBiDiGreeting(ContextBiDiGreeting response) returns Error? {
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

public type ContextBiDiGreetingStream record {|
    stream<BiDiGreeting, error?> content;
    map<string|string[]> headers;
|};

// public type ContextStringStream record {|
//     stream<string, error?> content;
//     map<string|string[]> headers;
// |};

public type ContextTimestampStream record {|
    stream<time:Utc, error?> content;
    map<string|string[]> headers;
|};

public type ContextBiDiGreeting record {|
    BiDiGreeting content;
    map<string|string[]> headers;
|};

// public type ContextString record {|
//     string content;
//     map<string|string[]> headers;
// |};

// public type ContextTimestamp record {|
//     time:Utc content;
//     map<string|string[]> headers;
// |};

public type BiDiGreeting record {|
    string name = "";
    time:Utc time;
|};

const string ROOT_DESCRIPTOR_48 = "0A1968656C6C6F576F726C6454696D657374616D702E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F22520A0C426944694772656574696E6712120A046E616D6518012001280952046E616D65122E0A0474696D6518022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520474696D653287020A1D4269646953747265616D696E6754696D657374616D7053657276696365124D0A186269646953747265616D696E674772656574536572766572121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0D2E426944694772656574696E67220028013001123C0A166269646953747265616D696E674772656574426F7468120D2E426944694772656574696E671A0D2E426944694772656574696E6722002801300112590A196269646953747265616D696E6745786368616E676554696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D70220028013001620670726F746F33";

isolated function getDescriptorMap_48() returns map<string> {
    return {"google/protobuf/timestamp.proto": "0A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F120F676F6F676C652E70726F746F627566223B0A0954696D657374616D7012180A077365636F6E647318012001280352077365636F6E647312140A056E616E6F7318022001280552056E616E6F7342580A13636F6D2E676F6F676C652E70726F746F627566420E54696D657374616D7050726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "48_bidi_timestamp.proto": "0A1968656C6C6F576F726C6454696D657374616D702E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F22520A0C426944694772656574696E6712120A046E616D6518012001280952046E616D65122E0A0474696D6518022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520474696D653287020A1D4269646953747265616D696E6754696D657374616D7053657276696365124D0A186269646953747265616D696E674772656574536572766572121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0D2E426944694772656574696E67220028013001123C0A166269646953747265616D696E674772656574426F7468120D2E426944694772656574696E671A0D2E426944694772656574696E6722002801300112590A196269646953747265616D696E6745786368616E676554696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D70220028013001620670726F746F33"};
}
