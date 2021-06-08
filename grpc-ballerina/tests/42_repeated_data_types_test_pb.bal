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

public isolated client class DataTypesServiceClient {
    *AbstractClientEndpoint;

    private final Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_42, getDescriptorMap42());
    }

    isolated remote function helloWithInt32Array(string req) returns stream<Int32ArrMsg, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithInt32Array", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        Int32ArrMsgStream outputStream = new Int32ArrMsgStream(result);
        return new stream<Int32ArrMsg, Error?>(outputStream);
    }

    isolated remote function helloWithInt32ArrayContext(string req) returns ContextInt32ArrMsgStream|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithInt32Array", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        Int32ArrMsgStream outputStream = new Int32ArrMsgStream(result);
        return {content: new stream<Int32ArrMsg, Error?>(outputStream), headers: headers};
    }

    isolated remote function helloWithInt64Array(string req) returns stream<Int64ArrMsg, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithInt64Array", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        Int64ArrMsgStream outputStream = new Int64ArrMsgStream(result);
        return new stream<Int64ArrMsg, Error?>(outputStream);
    }

    isolated remote function helloWithInt64ArrayContext(string req) returns ContextInt64ArrMsgStream|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithInt64Array", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        Int64ArrMsgStream outputStream = new Int64ArrMsgStream(result);
        return {content: new stream<Int64ArrMsg, Error?>(outputStream), headers: headers};
    }

    isolated remote function helloWithUnsignedInt64Array(string req) returns stream<UnsignedInt64ArrMsg, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithUnsignedInt64Array", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        UnsignedInt64ArrMsgStream outputStream = new UnsignedInt64ArrMsgStream(result);
        return new stream<UnsignedInt64ArrMsg, Error?>(outputStream);
    }

    isolated remote function helloWithUnsignedInt64ArrayContext(string req) returns ContextUnsignedInt64ArrMsgStream|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithUnsignedInt64Array", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        UnsignedInt64ArrMsgStream outputStream = new UnsignedInt64ArrMsgStream(result);
        return {content: new stream<UnsignedInt64ArrMsg, Error?>(outputStream), headers: headers};
    }

    isolated remote function helloWithFixed32Array(string req) returns stream<Fixed32ArrMsg, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithFixed32Array", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        Fixed32ArrMsgStream outputStream = new Fixed32ArrMsgStream(result);
        return new stream<Fixed32ArrMsg, Error?>(outputStream);
    }

    isolated remote function helloWithFixed32ArrayContext(string req) returns ContextFixed32ArrMsgStream|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithFixed32Array", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        Fixed32ArrMsgStream outputStream = new Fixed32ArrMsgStream(result);
        return {content: new stream<Fixed32ArrMsg, Error?>(outputStream), headers: headers};
    }

    isolated remote function helloWithFixed64Array(string req) returns stream<Fixed64ArrMsg, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithFixed64Array", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        Fixed64ArrMsgStream outputStream = new Fixed64ArrMsgStream(result);
        return new stream<Fixed64ArrMsg, Error?>(outputStream);
    }

    isolated remote function helloWithFixed64ArrayContext(string req) returns ContextFixed64ArrMsgStream|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithFixed64Array", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        Fixed64ArrMsgStream outputStream = new Fixed64ArrMsgStream(result);
        return {content: new stream<Fixed64ArrMsg, Error?>(outputStream), headers: headers};
    }

    isolated remote function helloWithFloatArray(string req) returns stream<FloatArrMsg, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithFloatArray", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        FloatArrMsgStream outputStream = new FloatArrMsgStream(result);
        return new stream<FloatArrMsg, Error?>(outputStream);
    }

    isolated remote function helloWithFloatArrayContext(string req) returns ContextFloatArrMsgStream|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithFloatArray", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        FloatArrMsgStream outputStream = new FloatArrMsgStream(result);
        return {content: new stream<FloatArrMsg, Error?>(outputStream), headers: headers};
    }

    isolated remote function helloWithDoubleArray(string req) returns stream<DoubleArrMsg, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithDoubleArray", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        DoubleArrMsgStream outputStream = new DoubleArrMsgStream(result);
        return new stream<DoubleArrMsg, Error?>(outputStream);
    }

    isolated remote function helloWithDoubleArrayContext(string req) returns ContextDoubleArrMsgStream|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithDoubleArray", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        DoubleArrMsgStream outputStream = new DoubleArrMsgStream(result);
        return {content: new stream<DoubleArrMsg, Error?>(outputStream), headers: headers};
    }

    isolated remote function helloWithStringArray(string req) returns stream<StringArrMsg, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithStringArray", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        StringArrMsgStream outputStream = new StringArrMsgStream(result);
        return new stream<StringArrMsg, Error?>(outputStream);
    }

    isolated remote function helloWithStringArrayContext(string req) returns ContextStringArrMsgStream|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithStringArray", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        StringArrMsgStream outputStream = new StringArrMsgStream(result);
        return {content: new stream<StringArrMsg, Error?>(outputStream), headers: headers};
    }

    isolated remote function helloWithBooleanArray(string req) returns stream<BooleanArrMsg, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithBooleanArray", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        BooleanArrMsgStream outputStream = new BooleanArrMsgStream(result);
        return new stream<BooleanArrMsg, Error?>(outputStream);
    }

    isolated remote function helloWithBooleanArrayContext(string req) returns ContextBooleanArrMsgStream|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithBooleanArray", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        BooleanArrMsgStream outputStream = new BooleanArrMsgStream(result);
        return {content: new stream<BooleanArrMsg, Error?>(outputStream), headers: headers};
    }

    isolated remote function helloWithBytesArray(string req) returns stream<BytesArrMsg, Error?>|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithBytesArray", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, _] = payload;
        BytesArrMsgStream outputStream = new BytesArrMsgStream(result);
        return new stream<BytesArrMsg, Error?>(outputStream);
    }

    isolated remote function helloWithBytesArrayContext(string req) returns ContextBytesArrMsgStream|Error {
        var payload = check self.grpcClient->executeServerStreaming("DataTypesService/helloWithBytesArray", req);
        [stream<anydata, Error?>, map<string|string[]>] [result, headers] = payload;
        BytesArrMsgStream outputStream = new BytesArrMsgStream(result);
        return {content: new stream<BytesArrMsg, Error?>(outputStream), headers: headers};
    }
}

public class Int32ArrMsgStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Int32ArrMsg value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|Int32ArrMsg value;|} nextRecord = {value: <Int32ArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public class Int64ArrMsgStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Int64ArrMsg value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|Int64ArrMsg value;|} nextRecord = {value: <Int64ArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public class UnsignedInt64ArrMsgStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|UnsignedInt64ArrMsg value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|UnsignedInt64ArrMsg value;|} nextRecord = {value: <UnsignedInt64ArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public class Fixed32ArrMsgStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Fixed32ArrMsg value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|Fixed32ArrMsg value;|} nextRecord = {value: <Fixed32ArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public class Fixed64ArrMsgStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Fixed64ArrMsg value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|Fixed64ArrMsg value;|} nextRecord = {value: <Fixed64ArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public class FloatArrMsgStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|FloatArrMsg value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|FloatArrMsg value;|} nextRecord = {value: <FloatArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public class DoubleArrMsgStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|DoubleArrMsg value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|DoubleArrMsg value;|} nextRecord = {value: <DoubleArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public class StringArrMsgStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|StringArrMsg value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|StringArrMsg value;|} nextRecord = {value: <StringArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public class BooleanArrMsgStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|BooleanArrMsg value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|BooleanArrMsg value;|} nextRecord = {value: <BooleanArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public class BytesArrMsgStream {
    private stream<anydata, Error?> anydataStream;

    public isolated function init(stream<anydata, Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|BytesArrMsg value;|}|Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is Error) {
            return streamValue;
        } else {
            record {|BytesArrMsg value;|} nextRecord = {value: <BytesArrMsg>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns Error? {
        return self.anydataStream.close();
    }
}

public client class DataTypesServiceInt64ArrMsgCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendInt64ArrMsg(Int64ArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextInt64ArrMsg(ContextInt64ArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class DataTypesServiceInt32ArrMsgCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendInt32ArrMsg(Int32ArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextInt32ArrMsg(ContextInt32ArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class DataTypesServiceBytesArrMsgCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBytesArrMsg(BytesArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBytesArrMsg(ContextBytesArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class DataTypesServiceStringArrMsgCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendStringArrMsg(StringArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextStringArrMsg(ContextStringArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class DataTypesServiceFixed32ArrMsgCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendFixed32ArrMsg(Fixed32ArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextFixed32ArrMsg(ContextFixed32ArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class DataTypesServiceFixed64ArrMsgCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendFixed64ArrMsg(Fixed64ArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextFixed64ArrMsg(ContextFixed64ArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class DataTypesServiceUnsignedInt64ArrMsgCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUnsignedInt64ArrMsg(UnsignedInt64ArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUnsignedInt64ArrMsg(ContextUnsignedInt64ArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class DataTypesServiceFloatArrMsgCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendFloatArrMsg(FloatArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextFloatArrMsg(ContextFloatArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class DataTypesServiceBooleanArrMsgCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBooleanArrMsg(BooleanArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBooleanArrMsg(ContextBooleanArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class DataTypesServiceDoubleArrMsgCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendDoubleArrMsg(DoubleArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextDoubleArrMsg(ContextDoubleArrMsg response) returns Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public type ContextFixed32ArrMsgStream record {|
    stream<Fixed32ArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextFixed32ArrMsg record {|
    Fixed32ArrMsg content;
    map<string|string[]> headers;
|};

public type ContextFloatArrMsgStream record {|
    stream<FloatArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextFloatArrMsg record {|
    FloatArrMsg content;
    map<string|string[]> headers;
|};

public type ContextFixed64ArrMsgStream record {|
    stream<Fixed64ArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextFixed64ArrMsg record {|
    Fixed64ArrMsg content;
    map<string|string[]> headers;
|};

public type ContextBooleanArrMsgStream record {|
    stream<BooleanArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextBooleanArrMsg record {|
    BooleanArrMsg content;
    map<string|string[]> headers;
|};

public type ContextBytesArrMsgStream record {|
    stream<BytesArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextBytesArrMsg record {|
    BytesArrMsg content;
    map<string|string[]> headers;
|};

//public type ContextString record {|
//    string content;
//    map<string|string[]> headers;
//|};

public type ContextDoubleArrMsgStream record {|
    stream<DoubleArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextDoubleArrMsg record {|
    DoubleArrMsg content;
    map<string|string[]> headers;
|};

public type ContextUnsignedInt64ArrMsgStream record {|
    stream<UnsignedInt64ArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextUnsignedInt64ArrMsg record {|
    UnsignedInt64ArrMsg content;
    map<string|string[]> headers;
|};

public type ContextStringArrMsgStream record {|
    stream<StringArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextStringArrMsg record {|
    StringArrMsg content;
    map<string|string[]> headers;
|};

public type ContextInt64ArrMsgStream record {|
    stream<Int64ArrMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextInt64ArrMsg record {|
    Int64ArrMsg content;
    map<string|string[]> headers;
|};

public type ContextInt32ArrMsgStream record {|
    stream<Int32ArrMsg, error?> content;
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

const string ROOT_DESCRIPTOR_42 = "0A2134325F72657065617465645F646174615F74797065735F746573742E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22330A0B496E7433324172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032805520361727222330A0B496E7436344172724D736712120A046E6F746518012001280952046E6F746512100A036172721802200328035203617272223B0A13556E7369676E6564496E7436344172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032804520361727222350A0D466978656433324172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032807520361727222350A0D466978656436344172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032806520361727222330A0B466C6F61744172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032802520361727222340A0C446F75626C654172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032801520361727222340A0C537472696E674172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032809520361727222350A0D426F6F6C65616E4172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032808520361727222330A0B42797465734172724D736712120A046E6F746518012001280952046E6F746512100A0361727218022003280C520361727232E4050A104461746154797065735365727669636512430A1368656C6C6F57697468496E7433324172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E496E7433324172724D7367300112430A1368656C6C6F57697468496E7436344172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E496E7436344172724D7367300112530A1B68656C6C6F57697468556E7369676E6564496E7436344172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A142E556E7369676E6564496E7436344172724D7367300112470A1568656C6C6F57697468466978656433324172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E466978656433324172724D7367300112470A1568656C6C6F57697468466978656436344172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E466978656436344172724D7367300112430A1368656C6C6F57697468466C6F61744172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E466C6F61744172724D7367300112450A1468656C6C6F57697468446F75626C654172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0D2E446F75626C654172724D7367300112450A1468656C6C6F57697468537472696E674172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0D2E537472696E674172724D7367300112470A1568656C6C6F57697468426F6F6C65616E4172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E426F6F6C65616E4172724D7367300112430A1368656C6C6F5769746842797465734172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E42797465734172724D73673001620670726F746F33";

isolated function getDescriptorMap42() returns map<string> {
    return {"42_repeated_data_types_test.proto": "0A2134325F72657065617465645F646174615F74797065735F746573742E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22330A0B496E7433324172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032805520361727222330A0B496E7436344172724D736712120A046E6F746518012001280952046E6F746512100A036172721802200328035203617272223B0A13556E7369676E6564496E7436344172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032804520361727222350A0D466978656433324172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032807520361727222350A0D466978656436344172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032806520361727222330A0B466C6F61744172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032802520361727222340A0C446F75626C654172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032801520361727222340A0C537472696E674172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032809520361727222350A0D426F6F6C65616E4172724D736712120A046E6F746518012001280952046E6F746512100A03617272180220032808520361727222330A0B42797465734172724D736712120A046E6F746518012001280952046E6F746512100A0361727218022003280C520361727232E4050A104461746154797065735365727669636512430A1368656C6C6F57697468496E7433324172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E496E7433324172724D7367300112430A1368656C6C6F57697468496E7436344172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E496E7436344172724D7367300112530A1B68656C6C6F57697468556E7369676E6564496E7436344172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A142E556E7369676E6564496E7436344172724D7367300112470A1568656C6C6F57697468466978656433324172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E466978656433324172724D7367300112470A1568656C6C6F57697468466978656436344172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E466978656436344172724D7367300112430A1368656C6C6F57697468466C6F61744172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E466C6F61744172724D7367300112450A1468656C6C6F57697468446F75626C654172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0D2E446F75626C654172724D7367300112450A1468656C6C6F57697468537472696E674172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0D2E537472696E674172724D7367300112470A1568656C6C6F57697468426F6F6C65616E4172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E426F6F6C65616E4172724D7367300112430A1368656C6C6F5769746842797465734172726179121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0C2E42797465734172724D73673001620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

