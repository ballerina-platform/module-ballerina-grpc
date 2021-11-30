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
import ballerina/protobuf.types.wrappers;
import ballerina/protobuf.types.struct;
import ballerina/grpc.types.struct as sstruct;

public isolated client class StructServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_57_STRUCT_TYPE, getDescriptorMap57StructType());
    }

    isolated remote function getStructType1(string|wrappers:ContextString req) returns map<anydata>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructService/getStructType1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <map<anydata>>result;
    }

    isolated remote function getStructType1Context(string|wrappers:ContextString req) returns struct:ContextStruct|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructService/getStructType1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <map<anydata>>result, headers: respHeaders};
    }

    isolated remote function getStructType2(string|wrappers:ContextString req) returns StructMsg|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructService/getStructType2", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <StructMsg>result;
    }

    isolated remote function getStructType2Context(string|wrappers:ContextString req) returns ContextStructMsg|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructService/getStructType2", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <StructMsg>result, headers: respHeaders};
    }

    isolated remote function sendStructType1(map<anydata>|struct:ContextStruct req) returns string|grpc:Error {
        map<string|string[]> headers = {};
        map<anydata> message;
        if req is struct:ContextStruct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructService/sendStructType1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function sendStructType1Context(map<anydata>|struct:ContextStruct req) returns wrappers:ContextString|grpc:Error {
        map<string|string[]> headers = {};
        map<anydata> message;
        if req is struct:ContextStruct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructService/sendStructType1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function sendStructType2(StructMsg|ContextStructMsg req) returns string|grpc:Error {
        map<string|string[]> headers = {};
        StructMsg message;
        if req is ContextStructMsg {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructService/sendStructType2", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function sendStructType2Context(StructMsg|ContextStructMsg req) returns wrappers:ContextString|grpc:Error {
        map<string|string[]> headers = {};
        StructMsg message;
        if req is ContextStructMsg {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructService/sendStructType2", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function exchangeStructType1(map<anydata>|struct:ContextStruct req) returns map<anydata>|grpc:Error {
        map<string|string[]> headers = {};
        map<anydata> message;
        if req is struct:ContextStruct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructService/exchangeStructType1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <map<anydata>>result;
    }

    isolated remote function exchangeStructType1Context(map<anydata>|struct:ContextStruct req) returns struct:ContextStruct|grpc:Error {
        map<string|string[]> headers = {};
        map<anydata> message;
        if req is struct:ContextStruct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructService/exchangeStructType1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <map<anydata>>result, headers: respHeaders};
    }

    isolated remote function exchangeStructType2(StructMsg|ContextStructMsg req) returns StructMsg|grpc:Error {
        map<string|string[]> headers = {};
        StructMsg message;
        if req is ContextStructMsg {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructService/exchangeStructType2", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <StructMsg>result;
    }

    isolated remote function exchangeStructType2Context(StructMsg|ContextStructMsg req) returns ContextStructMsg|grpc:Error {
        map<string|string[]> headers = {};
        StructMsg message;
        if req is ContextStructMsg {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructService/exchangeStructType2", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <StructMsg>result, headers: respHeaders};
    }

    isolated remote function clientStreamStructType1() returns ClientStreamStructType1StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("StructService/clientStreamStructType1");
        return new ClientStreamStructType1StreamingClient(sClient);
    }

    isolated remote function clientStreamStructType2() returns ClientStreamStructType2StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("StructService/clientStreamStructType2");
        return new ClientStreamStructType2StreamingClient(sClient);
    }

    isolated remote function serverStreamStructType1(map<anydata>|struct:ContextStruct req) returns stream<map<anydata>, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        map<anydata> message;
        if req is struct:ContextStruct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("StructService/serverStreamStructType1", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        sstruct:StructStream outputStream = new sstruct:StructStream(result);
        return new stream<map<anydata>, grpc:Error?>(outputStream);
    }

    isolated remote function serverStreamStructType1Context(map<anydata>|struct:ContextStruct req) returns struct:ContextStructStream|grpc:Error {
        map<string|string[]> headers = {};
        map<anydata> message;
        if req is struct:ContextStruct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("StructService/serverStreamStructType1", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        sstruct:StructStream outputStream = new sstruct:StructStream(result);
        return {content: new stream<map<anydata>, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function serverStreamStructType2(StructMsg|ContextStructMsg req) returns stream<StructMsg, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        StructMsg message;
        if req is ContextStructMsg {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("StructService/serverStreamStructType2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        StructMsgStream outputStream = new StructMsgStream(result);
        return new stream<StructMsg, grpc:Error?>(outputStream);
    }

    isolated remote function serverStreamStructType2Context(StructMsg|ContextStructMsg req) returns ContextStructMsgStream|grpc:Error {
        map<string|string[]> headers = {};
        StructMsg message;
        if req is ContextStructMsg {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("StructService/serverStreamStructType2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        StructMsgStream outputStream = new StructMsgStream(result);
        return {content: new stream<StructMsg, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function bidirectionalStreamStructType1() returns BidirectionalStreamStructType1StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("StructService/bidirectionalStreamStructType1");
        return new BidirectionalStreamStructType1StreamingClient(sClient);
    }

    isolated remote function bidirectionalStreamStructType2() returns BidirectionalStreamStructType2StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("StructService/bidirectionalStreamStructType2");
        return new BidirectionalStreamStructType2StreamingClient(sClient);
    }
}

public client class ClientStreamStructType1StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendStruct(map<anydata> message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextStruct(struct:ContextStruct message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveStruct() returns map<anydata>|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <map<anydata>>payload;
        }
    }

    isolated remote function receiveContextStruct() returns struct:ContextStruct|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <map<anydata>>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class ClientStreamStructType2StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendStructMsg(StructMsg message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextStructMsg(ContextStructMsg message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveStructMsg() returns StructMsg|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <StructMsg>payload;
        }
    }

    isolated remote function receiveContextStructMsg() returns ContextStructMsg|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <StructMsg>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class StructMsgStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|StructMsg value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|StructMsg value;|} nextRecord = {value: <StructMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class BidirectionalStreamStructType1StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendStruct(map<anydata> message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextStruct(struct:ContextStruct message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveStruct() returns map<anydata>|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <map<anydata>>payload;
        }
    }

    isolated remote function receiveContextStruct() returns struct:ContextStruct|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <map<anydata>>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class BidirectionalStreamStructType2StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendStructMsg(StructMsg message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextStructMsg(ContextStructMsg message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveStructMsg() returns StructMsg|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <StructMsg>payload;
        }
    }

    isolated remote function receiveContextStructMsg() returns ContextStructMsg|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <StructMsg>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class StructServiceStructMsgCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendStructMsg(StructMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextStructMsg(ContextStructMsg response) returns grpc:Error? {
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

public client class StructServiceStructCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendStruct(map<anydata> response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextStruct(struct:ContextStruct response) returns grpc:Error? {
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

public client class StructServiceStringCaller {
    private grpc:Caller caller;

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

public type ContextStructMsgStream record {|
    stream<StructMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextStructMsg record {|
    StructMsg content;
    map<string|string[]> headers;
|};

public type StructMsg record {|
    string name = "";
    map<anydata> struct = {};
|};

const string ROOT_DESCRIPTOR_57_STRUCT_TYPE = "0A1435375F7374727563745F747970652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F22500A095374727563744D736712120A046E616D6518012001280952046E616D65122F0A0673747275637418022001280B32172E676F6F676C652E70726F746F6275662E537472756374520673747275637432C9060A0D5374727563745365727669636512490A0E6765745374727563745479706531121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A172E676F6F676C652E70726F746F6275662E5374727563742200123C0A0E6765745374727563745479706532121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0A2E5374727563744D73672200124A0A0F73656E64537472756374547970653112172E676F6F676C652E70726F746F6275662E5374727563741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75652200123D0A0F73656E645374727563745479706532120A2E5374727563744D73671A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565220012490A1365786368616E6765537472756374547970653112172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200122F0A1365786368616E67655374727563745479706532120A2E5374727563744D73671A0A2E5374727563744D73672200124F0A1773657276657253747265616D537472756374547970653112172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200300112350A1773657276657253747265616D5374727563745479706532120A2E5374727563744D73671A0A2E5374727563744D736722003001124F0A17636C69656E7453747265616D537472756374547970653112172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200280112350A17636C69656E7453747265616D5374727563745479706532120A2E5374727563744D73671A0A2E5374727563744D73672200280112580A1E6269646972656374696F6E616C53747265616D537472756374547970653112172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E537472756374220028013001123E0A1E6269646972656374696F6E616C53747265616D5374727563745479706532120A2E5374727563744D73671A0A2E5374727563744D7367220028013001620670726F746F33";

public isolated function getDescriptorMap57StructType() returns map<string> {
    return {"57_struct_type.proto": "0A1435375F7374727563745F747970652E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F22500A095374727563744D736712120A046E616D6518012001280952046E616D65122F0A0673747275637418022001280B32172E676F6F676C652E70726F746F6275662E537472756374520673747275637432C9060A0D5374727563745365727669636512490A0E6765745374727563745479706531121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A172E676F6F676C652E70726F746F6275662E5374727563742200123C0A0E6765745374727563745479706532121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0A2E5374727563744D73672200124A0A0F73656E64537472756374547970653112172E676F6F676C652E70726F746F6275662E5374727563741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75652200123D0A0F73656E645374727563745479706532120A2E5374727563744D73671A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565220012490A1365786368616E6765537472756374547970653112172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200122F0A1365786368616E67655374727563745479706532120A2E5374727563744D73671A0A2E5374727563744D73672200124F0A1773657276657253747265616D537472756374547970653112172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200300112350A1773657276657253747265616D5374727563745479706532120A2E5374727563744D73671A0A2E5374727563744D736722003001124F0A17636C69656E7453747265616D537472756374547970653112172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E5374727563742200280112350A17636C69656E7453747265616D5374727563745479706532120A2E5374727563744D73671A0A2E5374727563744D73672200280112580A1E6269646972656374696F6E616C53747265616D537472756374547970653112172E676F6F676C652E70726F746F6275662E5374727563741A172E676F6F676C652E70726F746F6275662E537472756374220028013001123E0A1E6269646972656374696F6E616C53747265616D5374727563745479706532120A2E5374727563744D73671A0A2E5374727563744D7367220028013001620670726F746F33", "google/protobuf/struct.proto": "0A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F120F676F6F676C652E70726F746F6275662298010A06537472756374123B0A066669656C647318012003280B32232E676F6F676C652E70726F746F6275662E5374727563742E4669656C6473456E74727952066669656C64731A510A0B4669656C6473456E74727912100A036B657918012001280952036B6579122C0A0576616C756518022001280B32162E676F6F676C652E70726F746F6275662E56616C7565520576616C75653A02380122B2020A0556616C7565123B0A0A6E756C6C5F76616C756518012001280E321A2E676F6F676C652E70726F746F6275662E4E756C6C56616C7565480052096E756C6C56616C756512230A0C6E756D6265725F76616C75651802200128014800520B6E756D62657256616C756512230A0C737472696E675F76616C75651803200128094800520B737472696E6756616C7565121F0A0A626F6F6C5F76616C756518042001280848005209626F6F6C56616C7565123C0A0C7374727563745F76616C756518052001280B32172E676F6F676C652E70726F746F6275662E5374727563744800520B73747275637456616C7565123B0A0A6C6973745F76616C756518062001280B321A2E676F6F676C652E70726F746F6275662E4C69737456616C7565480052096C69737456616C756542060A046B696E64223B0A094C69737456616C7565122E0A0676616C75657318012003280B32162E676F6F676C652E70726F746F6275662E56616C7565520676616C7565732A1B0A094E756C6C56616C7565120E0A0A4E554C4C5F56414C5545100042550A13636F6D2E676F6F676C652E70726F746F627566420B53747275637450726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

