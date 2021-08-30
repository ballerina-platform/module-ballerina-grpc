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
// This is server implementation for bidirectional streaming scenario

public isolated client class HelloWorld24Client {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_24, getDescriptorMap24());
    }

    isolated remote function testStringValueReturn(string|ContextString req) returns (string|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testStringValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function testStringValueReturnContext(string|ContextString req) returns (ContextString|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testStringValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function testFloatValueReturn(float|ContextFloat req) returns (float|Error) {
        map<string|string[]> headers = {};
        float message;
        if (req is ContextFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testFloatValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <float>result;
    }

    isolated remote function testFloatValueReturnContext(float|ContextFloat req) returns (ContextFloat|Error) {
        map<string|string[]> headers = {};
        float message;
        if (req is ContextFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testFloatValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <float>result, headers: respHeaders};
    }

    isolated remote function testDoubleValueReturn(float|ContextFloat req) returns (float|Error) {
        map<string|string[]> headers = {};
        float message;
        if (req is ContextFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testDoubleValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <float>result;
    }

    isolated remote function testDoubleValueReturnContext(float|ContextFloat req) returns (ContextFloat|Error) {
        map<string|string[]> headers = {};
        float message;
        if (req is ContextFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testDoubleValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <float>result, headers: respHeaders};
    }

    isolated remote function testInt64ValueReturn(int|ContextInt req) returns (int|Error) {
        map<string|string[]> headers = {};
        int message;
        if (req is ContextInt) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testInt64ValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <int>result;
    }

    isolated remote function testInt64ValueReturnContext(int|ContextInt req) returns (ContextInt|Error) {
        map<string|string[]> headers = {};
        int message;
        if (req is ContextInt) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testInt64ValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <int>result, headers: respHeaders};
    }

    isolated remote function testBoolValueReturn(boolean|ContextBoolean req) returns (boolean|Error) {
        map<string|string[]> headers = {};
        boolean message;
        if (req is ContextBoolean) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testBoolValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <boolean>result;
    }

    isolated remote function testBoolValueReturnContext(boolean|ContextBoolean req) returns (ContextBoolean|Error) {
        map<string|string[]> headers = {};
        boolean message;
        if (req is ContextBoolean) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testBoolValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <boolean>result, headers: respHeaders};
    }

    isolated remote function testBytesValueReturn(byte[]|ContextBytes req) returns (byte[]|Error) {
        map<string|string[]> headers = {};
        byte[] message;
        if (req is ContextBytes) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testBytesValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <byte[]>result;
    }

    isolated remote function testBytesValueReturnContext(byte[]|ContextBytes req) returns (ContextBytes|Error) {
        map<string|string[]> headers = {};
        byte[] message;
        if (req is ContextBytes) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testBytesValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <byte[]>result, headers: respHeaders};
    }

    isolated remote function testRecordValueReturn(string|ContextString req) returns (SampleMsg24|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testRecordValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SampleMsg24>result;
    }

    isolated remote function testRecordValueReturnContext(string|ContextString req) returns (ContextSampleMsg24|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testRecordValueReturn", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SampleMsg24>result, headers: respHeaders};
    }

    isolated remote function testRecordValueReturnStream(string req) returns stream<SampleMsg24, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("HelloWorld24/testRecordValueReturnStream", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        SampleMsg24Stream outputStream = new SampleMsg24Stream(result);
        return new stream<SampleMsg24, Error?>(outputStream);
    }

    isolated remote function testRecordValueReturnStreamContext(string req) returns ContextSampleMsg24Stream|Error {
        var payload = check self.grpcClient->executeServerStreaming("HelloWorld24/testRecordValueReturnStream", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        SampleMsg24Stream outputStream = new SampleMsg24Stream(result);
        return {content: new stream<SampleMsg24, Error?>(outputStream), headers: headers};
    }
}

public class SampleMsg24Stream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|SampleMsg24 value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|SampleMsg24 value;|} nextRecord = {value: <SampleMsg24>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public client class HelloWorld24BooleanCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBoolean(boolean response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBoolean(ContextBoolean response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorld24ByteCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBytes(byte[] response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBytes(ContextBytes response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorld24StringCaller {
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

public client class HelloWorld24SampleMsg24Caller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSampleMsg24(SampleMsg24 response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSampleMsg24(ContextSampleMsg24 response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorld24IntCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendInt(int response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextInt(ContextInt response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorld24FloatCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendFloat(float response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextFloat(ContextFloat response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

//public type ContextBytes record {|
//    byte[] content;
//    map<string|string[]> headers;
//|};

//public type ContextBoolean record {|
//    boolean content;
//    map<string|string[]> headers;
//|};

//public type ContextString record {|
//    string content;
//    map<string|string[]> headers;
//|};

public type ContextSampleMsg24Stream record {|
    stream<SampleMsg24, error?> content;
    map<string|string[]> headers;
|};

public type ContextSampleMsg24 record {|
    SampleMsg24 content;
    map<string|string[]> headers;
|};

//public type ContextFloat record {|
//    float content;
//    map<string|string[]> headers;
//|};

//public type ContextInt record {|
//    int content;
//    map<string|string[]> headers;
//|};

public type SampleMsg24 record {|
    string name = "";
    int id = 0;
|};

const string ROOT_DESCRIPTOR_24 = "0A1A32345F72657475726E5F646174615F756E6172792E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22310A0B53616D706C654D7367323412120A046E616D6518012001280952046E616D65120E0A02696418022001280552026964328F050A0C48656C6C6F576F726C64323412530A1574657374537472696E6756616C756552657475726E121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512500A1474657374466C6F617456616C756552657475726E121B2E676F6F676C652E70726F746F6275662E466C6F617456616C75651A1B2E676F6F676C652E70726F746F6275662E466C6F617456616C756512530A1574657374446F75626C6556616C756552657475726E121C2E676F6F676C652E70726F746F6275662E446F75626C6556616C75651A1C2E676F6F676C652E70726F746F6275662E446F75626C6556616C756512500A1474657374496E74363456616C756552657475726E121B2E676F6F676C652E70726F746F6275662E496E74363456616C75651A1B2E676F6F676C652E70726F746F6275662E496E74363456616C7565124D0A1374657374426F6F6C56616C756552657475726E121A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75651A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C756512500A1474657374427974657356616C756552657475726E121B2E676F6F676C652E70726F746F6275662E427974657356616C75651A1B2E676F6F676C652E70726F746F6275662E427974657356616C756512430A15746573745265636F726456616C756552657475726E121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E53616D706C654D73673234124B0A1B746573745265636F726456616C756552657475726E53747265616D121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E53616D706C654D736732343001620670726F746F33";

isolated function getDescriptorMap24() returns map<string> {
    return {"24_return_data_unary.proto": "0A1A32345F72657475726E5F646174615F756E6172792E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22310A0B53616D706C654D7367323412120A046E616D6518012001280952046E616D65120E0A02696418022001280552026964328F050A0C48656C6C6F576F726C64323412530A1574657374537472696E6756616C756552657475726E121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512500A1474657374466C6F617456616C756552657475726E121B2E676F6F676C652E70726F746F6275662E466C6F617456616C75651A1B2E676F6F676C652E70726F746F6275662E466C6F617456616C756512530A1574657374446F75626C6556616C756552657475726E121C2E676F6F676C652E70726F746F6275662E446F75626C6556616C75651A1C2E676F6F676C652E70726F746F6275662E446F75626C6556616C756512500A1474657374496E74363456616C756552657475726E121B2E676F6F676C652E70726F746F6275662E496E74363456616C75651A1B2E676F6F676C652E70726F746F6275662E496E74363456616C7565124D0A1374657374426F6F6C56616C756552657475726E121A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75651A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C756512500A1474657374427974657356616C756552657475726E121B2E676F6F676C652E70726F746F6275662E427974657356616C75651A1B2E676F6F676C652E70726F746F6275662E427974657356616C756512430A15746573745265636F726456616C756552657475726E121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E53616D706C654D73673234124B0A1B746573745265636F726456616C756552657475726E53747265616D121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E53616D706C654D736732343001620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

