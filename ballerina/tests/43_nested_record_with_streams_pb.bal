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
public isolated client class NestedMsgServiceClient {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_43, getDescriptorMap43());
    }

    isolated remote function nestedMsgUnary(string|ContextString req) returns (NestedMsg|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("NestedMsgService/nestedMsgUnary", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <NestedMsg>result;
    }

    isolated remote function nestedMsgUnaryContext(string|ContextString req) returns (ContextNestedMsg|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("NestedMsgService/nestedMsgUnary", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <NestedMsg>result, headers: respHeaders};
    }

    isolated remote function nestedMsgClientStreaming() returns (NestedMsgClientStreamingStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeClientStreaming("NestedMsgService/nestedMsgClientStreaming");
        return new NestedMsgClientStreamingStreamingClient(sClient);
    }

    isolated remote function nestedMsgServerStreaming(string req) returns stream<NestedMsg, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("NestedMsgService/nestedMsgServerStreaming", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        NestedMsgStream outputStream = new NestedMsgStream(result);
        return new stream<NestedMsg, Error?>(outputStream);
    }

    isolated remote function nestedMsgServerStreamingContext(string req) returns ContextNestedMsgStream|Error {
        var payload = check self.grpcClient->executeServerStreaming("NestedMsgService/nestedMsgServerStreaming", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        NestedMsgStream outputStream = new NestedMsgStream(result);
        return {content: new stream<NestedMsg, Error?>(outputStream), headers: headers};
    }

    isolated remote function nestedMsgBidirectionalStreaming() returns (NestedMsgBidirectionalStreamingStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("NestedMsgService/nestedMsgBidirectionalStreaming");
        return new NestedMsgBidirectionalStreamingStreamingClient(sClient);
    }
}

public client class NestedMsgClientStreamingStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendNestedMsg(NestedMsg message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextNestedMsg(ContextNestedMsg message) returns Error? {
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

public class NestedMsgStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|NestedMsg value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|NestedMsg value;|} nextRecord = {value: <NestedMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public client class NestedMsgBidirectionalStreamingStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendNestedMsg(NestedMsg message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextNestedMsg(ContextNestedMsg message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveNestedMsg() returns NestedMsg|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <NestedMsg>payload;
        }
    }

    isolated remote function receiveContextNestedMsg() returns ContextNestedMsg|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <NestedMsg>payload, headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public client class NestedMsgServiceStringCaller {
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
}

public client class NestedMsgServiceNestedMsgCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendNestedMsg(NestedMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextNestedMsg(ContextNestedMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

//public type ContextString record {|
//    string content;
//    map<string|string[]> headers;
//|};

public type ContextNestedMsgStream record {|
    stream<NestedMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextNestedMsg record {|
    NestedMsg content;
    map<string|string[]> headers;
|};

public type NestedMsgL1 record {|
    string name1 = "";
    NestedMsgL2 msg1 = {};
|};

public type NestedMsg record {|
    string name = "";
    NestedMsgL1 msg = {};
|};

public type NestedMsgL3 record {|
    string name3 = "";
    int id = 0;
|};

public type NestedMsgL2 record {|
    string name2 = "";
    NestedMsgL3 msg2 = {};
|};

const string ROOT_DESCRIPTOR_43 = "0A2334335F6E65737465645F7265636F72645F776974685F73747265616D732E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223F0A094E65737465644D736712120A046E616D6518012001280952046E616D65121E0A036D736718022001280B320C2E4E65737465644D73674C3152036D736722450A0B4E65737465644D73674C3112140A056E616D653118012001280952056E616D653112200A046D73673118022001280B320C2E4E65737465644D73674C3252046D73673122450A0B4E65737465644D73674C3212140A056E616D653218012001280952056E616D653212200A046D73673218022001280B320C2E4E65737465644D73674C3352046D73673222330A0B4E65737465644D73674C3312140A056E616D653318012001280952056E616D6533120E0A02696418022001280552026964329D020A104E65737465644D736753657276696365123A0A0E6E65737465644D7367556E617279121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0A2E4E65737465644D736712460A186E65737465644D736753657276657253747265616D696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0A2E4E65737465644D7367300112460A186E65737465644D7367436C69656E7453747265616D696E67120A2E4E65737465644D73671A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75652801123D0A1F6E65737465644D73674269646972656374696F6E616C53747265616D696E67120A2E4E65737465644D73671A0A2E4E65737465644D736728013001620670726F746F33";

isolated function getDescriptorMap43() returns map<string> {
    return {"43_nested_record_with_streams.proto": "0A2334335F6E65737465645F7265636F72645F776974685F73747265616D732E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223F0A094E65737465644D736712120A046E616D6518012001280952046E616D65121E0A036D736718022001280B320C2E4E65737465644D73674C3152036D736722450A0B4E65737465644D73674C3112140A056E616D653118012001280952056E616D653112200A046D73673118022001280B320C2E4E65737465644D73674C3252046D73673122450A0B4E65737465644D73674C3212140A056E616D653218012001280952056E616D653212200A046D73673218022001280B320C2E4E65737465644D73674C3352046D73673222330A0B4E65737465644D73674C3312140A056E616D653318012001280952056E616D6533120E0A02696418022001280552026964329D020A104E65737465644D736753657276696365123A0A0E6E65737465644D7367556E617279121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0A2E4E65737465644D736712460A186E65737465644D736753657276657253747265616D696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0A2E4E65737465644D7367300112460A186E65737465644D7367436C69656E7453747265616D696E67120A2E4E65737465644D73671A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75652801123D0A1F6E65737465644D73674269646972656374696F6E616C53747265616D696E67120A2E4E65737465644D73671A0A2E4E65737465644D736728013001620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

