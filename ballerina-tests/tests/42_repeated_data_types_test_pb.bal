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

public isolated client class DataTypesServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_42_REPEATED_DATA_TYPES_TEST, getDescriptorMap42RepeatedDataTypesTest());
    }

    isolated remote function helloWithInt32Array(string|wrappers:ContextString req) returns stream<Int32ArrMsg, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithInt32Array", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        Int32ArrMsgStream outputStream = new Int32ArrMsgStream(result);
        return new stream<Int32ArrMsg, grpc:Error?>(outputStream);
    }

    isolated remote function helloWithInt32ArrayContext(string|wrappers:ContextString req) returns ContextInt32ArrMsgStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithInt32Array", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        Int32ArrMsgStream outputStream = new Int32ArrMsgStream(result);
        return {content: new stream<Int32ArrMsg, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function helloWithInt64Array(string|wrappers:ContextString req) returns stream<Int64ArrMsg, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithInt64Array", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        Int64ArrMsgStream outputStream = new Int64ArrMsgStream(result);
        return new stream<Int64ArrMsg, grpc:Error?>(outputStream);
    }

    isolated remote function helloWithInt64ArrayContext(string|wrappers:ContextString req) returns ContextInt64ArrMsgStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithInt64Array", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        Int64ArrMsgStream outputStream = new Int64ArrMsgStream(result);
        return {content: new stream<Int64ArrMsg, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function helloWithUnsignedInt64Array(string|wrappers:ContextString req) returns stream<UnsignedInt64ArrMsg, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithUnsignedInt64Array", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        UnsignedInt64ArrMsgStream outputStream = new UnsignedInt64ArrMsgStream(result);
        return new stream<UnsignedInt64ArrMsg, grpc:Error?>(outputStream);
    }

    isolated remote function helloWithUnsignedInt64ArrayContext(string|wrappers:ContextString req) returns ContextUnsignedInt64ArrMsgStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithUnsignedInt64Array", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        UnsignedInt64ArrMsgStream outputStream = new UnsignedInt64ArrMsgStream(result);
        return {content: new stream<UnsignedInt64ArrMsg, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function helloWithFixed32Array(string|wrappers:ContextString req) returns stream<Fixed32ArrMsg, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithFixed32Array", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        Fixed32ArrMsgStream outputStream = new Fixed32ArrMsgStream(result);
        return new stream<Fixed32ArrMsg, grpc:Error?>(outputStream);
    }

    isolated remote function helloWithFixed32ArrayContext(string|wrappers:ContextString req) returns ContextFixed32ArrMsgStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithFixed32Array", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        Fixed32ArrMsgStream outputStream = new Fixed32ArrMsgStream(result);
        return {content: new stream<Fixed32ArrMsg, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function helloWithFixed64Array(string|wrappers:ContextString req) returns stream<Fixed64ArrMsg, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithFixed64Array", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        Fixed64ArrMsgStream outputStream = new Fixed64ArrMsgStream(result);
        return new stream<Fixed64ArrMsg, grpc:Error?>(outputStream);
    }

    isolated remote function helloWithFixed64ArrayContext(string|wrappers:ContextString req) returns ContextFixed64ArrMsgStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithFixed64Array", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        Fixed64ArrMsgStream outputStream = new Fixed64ArrMsgStream(result);
        return {content: new stream<Fixed64ArrMsg, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function helloWithFloatArray(string|wrappers:ContextString req) returns stream<FloatArrMsg, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithFloatArray", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        FloatArrMsgStream outputStream = new FloatArrMsgStream(result);
        return new stream<FloatArrMsg, grpc:Error?>(outputStream);
    }

    isolated remote function helloWithFloatArrayContext(string|wrappers:ContextString req) returns ContextFloatArrMsgStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithFloatArray", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        FloatArrMsgStream outputStream = new FloatArrMsgStream(result);
        return {content: new stream<FloatArrMsg, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function helloWithDoubleArray(string|wrappers:ContextString req) returns stream<DoubleArrMsg, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithDoubleArray", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        DoubleArrMsgStream outputStream = new DoubleArrMsgStream(result);
        return new stream<DoubleArrMsg, grpc:Error?>(outputStream);
    }

    isolated remote function helloWithDoubleArrayContext(string|wrappers:ContextString req) returns ContextDoubleArrMsgStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithDoubleArray", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        DoubleArrMsgStream outputStream = new DoubleArrMsgStream(result);
        return {content: new stream<DoubleArrMsg, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function helloWithStringArray(string|wrappers:ContextString req) returns stream<StringArrMsg, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithStringArray", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        StringArrMsgStream outputStream = new StringArrMsgStream(result);
        return new stream<StringArrMsg, grpc:Error?>(outputStream);
    }

    isolated remote function helloWithStringArrayContext(string|wrappers:ContextString req) returns ContextStringArrMsgStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithStringArray", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        StringArrMsgStream outputStream = new StringArrMsgStream(result);
        return {content: new stream<StringArrMsg, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function helloWithBooleanArray(string|wrappers:ContextString req) returns stream<BooleanArrMsg, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithBooleanArray", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        BooleanArrMsgStream outputStream = new BooleanArrMsgStream(result);
        return new stream<BooleanArrMsg, grpc:Error?>(outputStream);
    }

    isolated remote function helloWithBooleanArrayContext(string|wrappers:ContextString req) returns ContextBooleanArrMsgStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithBooleanArray", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        BooleanArrMsgStream outputStream = new BooleanArrMsgStream(result);
        return {content: new stream<BooleanArrMsg, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function helloWithBytesArray(string|wrappers:ContextString req) returns stream<BytesArrMsg, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithBytesArray", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        BytesArrMsgStream outputStream = new BytesArrMsgStream(result);
        return new stream<BytesArrMsg, grpc:Error?>(outputStream);
    }

    isolated remote function helloWithBytesArrayContext(string|wrappers:ContextString req) returns ContextBytesArrMsgStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithBytesArray", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        BytesArrMsgStream outputStream = new BytesArrMsgStream(result);
        return {content: new stream<BytesArrMsg, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public class Int32ArrMsgStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Int32ArrMsg value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|Int32ArrMsg value;|} nextRecord = {value: <Int32ArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class Int64ArrMsgStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Int64ArrMsg value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|Int64ArrMsg value;|} nextRecord = {value: <Int64ArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class UnsignedInt64ArrMsgStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|UnsignedInt64ArrMsg value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|UnsignedInt64ArrMsg value;|} nextRecord = {value: <UnsignedInt64ArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class Fixed32ArrMsgStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Fixed32ArrMsg value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|Fixed32ArrMsg value;|} nextRecord = {value: <Fixed32ArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class Fixed64ArrMsgStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Fixed64ArrMsg value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|Fixed64ArrMsg value;|} nextRecord = {value: <Fixed64ArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class FloatArrMsgStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|FloatArrMsg value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|FloatArrMsg value;|} nextRecord = {value: <FloatArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class DoubleArrMsgStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|DoubleArrMsg value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|DoubleArrMsg value;|} nextRecord = {value: <DoubleArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class StringArrMsgStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|StringArrMsg value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|StringArrMsg value;|} nextRecord = {value: <StringArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class BooleanArrMsgStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|BooleanArrMsg value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|BooleanArrMsg value;|} nextRecord = {value: <BooleanArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class BytesArrMsgStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|BytesArrMsg value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|BytesArrMsg value;|} nextRecord = {value: <BytesArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class DataTypesServiceInt64ArrMsgCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendInt64ArrMsg(Int64ArrMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextInt64ArrMsg(ContextInt64ArrMsg response) returns grpc:Error? {
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

public client class DataTypesServiceInt32ArrMsgCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendInt32ArrMsg(Int32ArrMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextInt32ArrMsg(ContextInt32ArrMsg response) returns grpc:Error? {
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

public client class DataTypesServiceBytesArrMsgCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBytesArrMsg(BytesArrMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBytesArrMsg(ContextBytesArrMsg response) returns grpc:Error? {
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

public client class DataTypesServiceStringArrMsgCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendStringArrMsg(StringArrMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextStringArrMsg(ContextStringArrMsg response) returns grpc:Error? {
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

public client class DataTypesServiceFixed32ArrMsgCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendFixed32ArrMsg(Fixed32ArrMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextFixed32ArrMsg(ContextFixed32ArrMsg response) returns grpc:Error? {
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

public client class DataTypesServiceFixed64ArrMsgCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendFixed64ArrMsg(Fixed64ArrMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextFixed64ArrMsg(ContextFixed64ArrMsg response) returns grpc:Error? {
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

public client class DataTypesServiceUnsignedInt64ArrMsgCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUnsignedInt64ArrMsg(UnsignedInt64ArrMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUnsignedInt64ArrMsg(ContextUnsignedInt64ArrMsg response) returns grpc:Error? {
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

public client class DataTypesServiceFloatArrMsgCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendFloatArrMsg(FloatArrMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextFloatArrMsg(ContextFloatArrMsg response) returns grpc:Error? {
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

public client class DataTypesServiceBooleanArrMsgCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBooleanArrMsg(BooleanArrMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBooleanArrMsg(ContextBooleanArrMsg response) returns grpc:Error? {
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

public client class DataTypesServiceDoubleArrMsgCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendDoubleArrMsg(DoubleArrMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextDoubleArrMsg(ContextDoubleArrMsg response) returns grpc:Error? {
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

public type ContextFixed32ArrMsgStream record {|
    stream<Fixed32ArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextFloatArrMsgStream record {|
    stream<FloatArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextFixed64ArrMsgStream record {|
    stream<Fixed64ArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextBooleanArrMsgStream record {|
    stream<BooleanArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextBytesArrMsgStream record {|
    stream<BytesArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextDoubleArrMsgStream record {|
    stream<DoubleArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextUnsignedInt64ArrMsgStream record {|
    stream<UnsignedInt64ArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextStringArrMsgStream record {|
    stream<StringArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextInt64ArrMsgStream record {|
    stream<Int64ArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextInt32ArrMsgStream record {|
    stream<Int32ArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextFixed32ArrMsg record {|
    Fixed32ArrMsg content;
    map<string|string[]> headers;
|};

public type ContextFloatArrMsg record {|
    FloatArrMsg content;
    map<string|string[]> headers;
|};

public type ContextFixed64ArrMsg record {|
    Fixed64ArrMsg content;
    map<string|string[]> headers;
|};

public type ContextBooleanArrMsg record {|
    BooleanArrMsg content;
    map<string|string[]> headers;
|};

public type ContextBytesArrMsg record {|
    BytesArrMsg content;
    map<string|string[]> headers;
|};

public type ContextDoubleArrMsg record {|
    DoubleArrMsg content;
    map<string|string[]> headers;
|};

public type ContextUnsignedInt64ArrMsg record {|
    UnsignedInt64ArrMsg content;
    map<string|string[]> headers;
|};

public type ContextStringArrMsg record {|
    StringArrMsg content;
    map<string|string[]> headers;
|};

public type ContextInt64ArrMsg record {|
    Int64ArrMsg content;
    map<string|string[]> headers;
|};

public type ContextInt32ArrMsg record {|
    Int32ArrMsg content;
    map<string|string[]> headers;
|};

public type Fixed32ArrMsg record {|
    string note = "";
    int[] arr = [];
|};

public type FloatArrMsg record {|
    string note = "";
    float[] arr = [];
|};

public type Fixed64ArrMsg record {|
    string note = "";
    int[] arr = [];
|};

public type BooleanArrMsg record {|
    string note = "";
    boolean[] arr = [];
|};

public type BytesArrMsg record {|
    string note = "";
    byte[] arr = [];
|};

public type DoubleArrMsg record {|
    string note = "";
    float[] arr = [];
|};

public type UnsignedInt64ArrMsg record {|
    string note = "";
    int[] arr = [];
|};

public type StringArrMsg record {|
    string note = "";
    string[] arr = [];
|};

public type Int64ArrMsg record {|
    string note = "";
    int[] arr = [];
|};

public type Int32ArrMsg record {|
    string note = "";
    int[] arr = [];
|};

const string ROOT_DESCRIPTOR_42_REPEATED_DATA_TYPES_TEST = "0A2134325F72657065617465645F646174615F74797065735F746573742E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22330A0B496E7433324172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032805520361727222330A0B496E7436344172724D736712120A046E6F746518012001280952046E6F746512100A036172721802200328035203617272223B0A13556E7369676E6564496E7436344172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032804520361727222350A0D466978656433324172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032807520361727222350A0D466978656436344172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032806520361727222330A0B466C6F61744172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032802520361727222340A0C446F75626C654172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032801520361727222340A0C537472696E674172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032809520361727222350A0D426F6F6C65616E4172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032808520361727222330A0B42797465734172724D736712120A046E6F746518012001280952046E6F746512100A0361727218022003280C520361727232E4050A104461746154797065735365727669636512430A1368656C6C6F57697468496E7433324172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E496E7433324172724D7367300112430A1368656C6C6F57697468496E7436344172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E496E7436344172724D7367300112530A1B68656C6C6F57697468556E7369676E6564496E7436344172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A142E556E7369676E6564496E7436344172724D7367300112470A1568656C6C6F57697468466978656433324172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E466978656433324172724D7367300112470A1568656C6C6F57697468466978656436344172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E466978656436344172724D7367300112430A1368656C6C6F57697468466C6F61744172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E466C6F61744172724D7367300112450A1468656C6C6F57697468446F75626C654172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0D2E446F75626C654172724D7367300112450A1468656C6C6F57697468537472696E674172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0D2E537472696E674172724D7367300112470A1568656C6C6F57697468426F6F6C65616E4172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E426F6F6C65616E4172724D7367300112430A1368656C6C6F5769746842797465734172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E42797465734172724D73673001620670726F746F33";

public isolated function getDescriptorMap42RepeatedDataTypesTest() returns map<string> {
    return {"42_repeated_data_types_test.proto": "0A2134325F72657065617465645F646174615F74797065735F746573742E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22330A0B496E7433324172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032805520361727222330A0B496E7436344172724D736712120A046E6F746518012001280952046E6F746512100A036172721802200328035203617272223B0A13556E7369676E6564496E7436344172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032804520361727222350A0D466978656433324172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032807520361727222350A0D466978656436344172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032806520361727222330A0B466C6F61744172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032802520361727222340A0C446F75626C654172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032801520361727222340A0C537472696E674172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032809520361727222350A0D426F6F6C65616E4172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032808520361727222330A0B42797465734172724D736712120A046E6F746518012001280952046E6F746512100A0361727218022003280C520361727232E4050A104461746154797065735365727669636512430A1368656C6C6F57697468496E7433324172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E496E7433324172724D7367300112430A1368656C6C6F57697468496E7436344172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E496E7436344172724D7367300112530A1B68656C6C6F57697468556E7369676E6564496E7436344172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A142E556E7369676E6564496E7436344172724D7367300112470A1568656C6C6F57697468466978656433324172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E466978656433324172724D7367300112470A1568656C6C6F57697468466978656436344172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E466978656436344172724D7367300112430A1368656C6C6F57697468466C6F61744172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E466C6F61744172724D7367300112450A1468656C6C6F57697468446F75626C654172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0D2E446F75626C654172724D7367300112450A1468656C6C6F57697468537472696E674172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0D2E537472696E674172724D7367300112470A1568656C6C6F57697468426F6F6C65616E4172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E426F6F6C65616E4172724D7367300112430A1368656C6C6F5769746842797465734172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E42797465734172724D73673001620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

