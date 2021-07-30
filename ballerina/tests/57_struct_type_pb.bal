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

public isolated client class StructServiceClient {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_57, getDescriptorMap57());
    }

    isolated remote function getStruct(string|ContextString req) returns (map<anydata>|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("struct.StructService/getStruct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <map<anydata>>result;
    }

    isolated remote function getStructContext(string|ContextString req) returns (ContextStruct|Error) {
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("struct.StructService/getStruct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <map<anydata>>result, headers: respHeaders};
    }

    isolated remote function sendStruct(map<anydata>|ContextStruct req) returns (string|Error) {
        map<string|string[]> headers = {};
        map<anydata> message;
        if (req is ContextStruct) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("struct.StructService/sendStruct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function sendStructContext(map<anydata>|ContextStruct req) returns (ContextString|Error) {
        map<string|string[]> headers = {};
        map<anydata> message;
        if (req is ContextStruct) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("struct.StructService/sendStruct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function exchangeStruct(map<anydata>|ContextStruct req) returns (map<anydata>|Error) {
        map<string|string[]> headers = {};
        map<anydata> message;
        if (req is ContextStruct) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("struct.StructService/exchangeStruct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <map<anydata>>result;
    }

    isolated remote function exchangeStructContext(map<anydata>|ContextStruct req) returns (ContextStruct|Error) {
        map<string|string[]> headers = {};
        map<anydata> message;
        if (req is ContextStruct) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("struct.StructService/exchangeStruct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <map<anydata>>result, headers: respHeaders};
    }

    isolated remote function clientStreamStruct() returns (ClientStreamStructStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeClientStreaming("struct.StructService/clientStreamStruct");
        return new ClientStreamStructStreamingClient(sClient);
    }

    isolated remote function serverStreamStruct(map<anydata> req) returns stream<map<anydata>, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("struct.StructService/serverStreamStruct", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        StructStream outputStream = new StructStream(result);
        return new stream<map<anydata>, Error?>(outputStream);
    }

    isolated remote function serverStreamStructContext(map<anydata> req) returns ContextStructStream|Error {
        var payload = check self.grpcClient->executeServerStreaming("struct.StructService/serverStreamStruct", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        StructStream outputStream = new StructStream(result);
        return {content: new stream<map<anydata>, Error?>(outputStream), headers: headers};
    }

    isolated remote function bidirectionalStreamStruct() returns (BidirectionalStreamStructStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("struct.StructService/bidirectionalStreamStruct");
        return new BidirectionalStreamStructStreamingClient(sClient);
    }
}

public client class ClientStreamStructStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendStruct(map<anydata> message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextStruct(ContextStruct message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveStruct() returns map<anydata>|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <map<anydata>>payload;
        }
    }

    isolated remote function receiveContextStruct() returns ContextStruct|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <map<anydata>>payload, headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public class StructStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|map<anydata> value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|map<anydata> value;|} nextRecord = {value: <map<anydata>>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public client class BidirectionalStreamStructStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendStruct(map<anydata> message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextStruct(ContextStruct message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveStruct() returns map<anydata>|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <map<anydata>>payload;
        }
    }

    isolated remote function receiveContextStruct() returns ContextStruct|Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <map<anydata>>payload, headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public client class StructServiceStructCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendStruct(map<anydata> response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextStruct(ContextStruct response) returns Error? {
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

public client class StructServiceStringCaller {
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

public type ContextStructStream record {|
    stream<map<anydata>, error?> content;
    map<string|string[]> headers;
|};

// public type ContextString record {|
//     string content;
//     map<string|string[]> headers;
// |};

public type ContextStruct record {|
    map<anydata> content;
    map<string|string[]> headers;
|};

const string ROOT_DESCRIPTOR_57 = "0A1435375F7374727563745F747970652E70726F746F12067374727563741A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F32CF030A0D5374727563745365727669636512440A09676574537472756374121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A172E676F6F676C652E70726F746F6275662E537472756374220012450A0A73656E6453747275637412172E676F6F676C652E70726F746F6275662E5374727563741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565220012440A0E65786368616E676553747275637412172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200124A0A1273657276657253747265616D53747275637412172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E53747275637422003001124A0A12636C69656E7453747265616D53747275637412172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200280112530A196269646972656374696F6E616C53747265616D53747275637412172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E537472756374220028013001421D0A19677270632E6A6176612E7475746F7269616C2E7374727563745001620670726F746F33";

isolated function getDescriptorMap57() returns map<string> {
    return {"57_struct_type.proto": "0A1435375F7374727563745F747970652E70726F746F12067374727563741A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F32CF030A0D5374727563745365727669636512440A09676574537472756374121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A172E676F6F676C652E70726F746F6275662E537472756374220012450A0A73656E6453747275637412172E676F6F676C652E70726F746F6275662E5374727563741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565220012440A0E65786368616E676553747275637412172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200124A0A1273657276657253747265616D53747275637412172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E53747275637422003001124A0A12636C69656E7453747265616D53747275637412172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200280112530A196269646972656374696F6E616C53747265616D53747275637412172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E537472756374220028013001421D0A19677270632E6A6176612E7475746F7269616C2E7374727563745001620670726F746F33", "google/protobuf/struct.proto": "0A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F120F676F6F676C652E70726F746F6275662298010A06537472756374123B0A066669656C647318012003280B32232E676F6F676C652E70726F746F6275662E5374727563742E4669656C6473456E74727952066669656C64731A510A0B4669656C6473456E74727912100A036B657918012001280952036B6579122C0A0576616C756518022001280B32162E676F6F676C652E70726F746F6275662E56616C7565520576616C75653A02380122B2020A0556616C7565123B0A0A6E756C6C5F76616C756518012001280E321A2E676F6F676C652E70726F746F6275662E4E756C6C56616C7565480052096E756C6C56616C756512230A0C6E756D6265725F76616C75651802200128014800520B6E756D62657256616C756512230A0C737472696E675F76616C75651803200128094800520B737472696E6756616C7565121F0A0A626F6F6C5F76616C756518042001280848005209626F6F6C56616C7565123C0A0C7374727563745F76616C756518052001280B32172E676F6F676C652E70726F746F6275662E5374727563744800520B73747275637456616C7565123B0A0A6C6973745F76616C756518062001280B321A2E676F6F676C652E70726F746F6275662E4C69737456616C7565480052096C69737456616C756542060A046B696E64223B0A094C69737456616C7565122E0A0676616C75657318012003280B32162E676F6F676C652E70726F746F6275662E56616C7565520676616C7565732A1B0A094E756C6C56616C7565120E0A0A4E554C4C5F56414C5545100042550A13636F6D2E676F6F676C652E70726F746F627566420B53747275637450726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

