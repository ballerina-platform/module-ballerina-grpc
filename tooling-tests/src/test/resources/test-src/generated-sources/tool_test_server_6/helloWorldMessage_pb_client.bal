import ballerina/grpc;
import ballerina/protobuf;

const string HELLOWORLDMESSAGE_DESC = "0A1768656C6C6F576F726C644D6573736167652E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D65737361676522220A0A4279655265717565737412140A05677265657418012001280952056772656574221F0A0B427965526573706F6E736512100A037361791801200128095203736179325A0A0A68656C6C6F576F726C6412280A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E7365300112220A03627965120B2E427965526571756573741A0C2E427965526573706F6E73653001620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, HELLOWORLDMESSAGE_DESC);
    }

    isolated remote function hello(HelloRequest|ContextHelloRequest req) returns stream<HelloResponse, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest message;
        if req is ContextHelloRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("helloWorld/hello", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        HelloResponseStream outputStream = new HelloResponseStream(result);
        return new stream<HelloResponse, grpc:Error?>(outputStream);
    }

    isolated remote function helloContext(HelloRequest|ContextHelloRequest req) returns ContextHelloResponseStream|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest message;
        if req is ContextHelloRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("helloWorld/hello", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        HelloResponseStream outputStream = new HelloResponseStream(result);
        return {content: new stream<HelloResponse, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function bye(ByeRequest|ContextByeRequest req) returns stream<ByeResponse, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ByeRequest message;
        if req is ContextByeRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("helloWorld/bye", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ByeResponseStream outputStream = new ByeResponseStream(result);
        return new stream<ByeResponse, grpc:Error?>(outputStream);
    }

    isolated remote function byeContext(ByeRequest|ContextByeRequest req) returns ContextByeResponseStream|grpc:Error {
        map<string|string[]> headers = {};
        ByeRequest message;
        if req is ContextByeRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("helloWorld/bye", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ByeResponseStream outputStream = new ByeResponseStream(result);
        return {content: new stream<ByeResponse, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public class HelloResponseStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|HelloResponse value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|HelloResponse value;|} nextRecord = {value: <HelloResponse>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class ByeResponseStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|ByeResponse value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|ByeResponse value;|} nextRecord = {value: <ByeResponse>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public type ContextByeResponseStream record {|
    stream<ByeResponse, error?> content;
    map<string|string[]> headers;
|};

public type ContextHelloResponseStream record {|
    stream<HelloResponse, error?> content;
    map<string|string[]> headers;
|};

public type ContextByeResponse record {|
    ByeResponse content;
    map<string|string[]> headers;
|};

public type ContextByeRequest record {|
    ByeRequest content;
    map<string|string[]> headers;
|};

public type ContextHelloResponse record {|
    HelloResponse content;
    map<string|string[]> headers;
|};

public type ContextHelloRequest record {|
    HelloRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: HELLOWORLDMESSAGE_DESC}
public type ByeResponse record {|
    string say = "";
|};

@protobuf:Descriptor {value: HELLOWORLDMESSAGE_DESC}
public type ByeRequest record {|
    string greet = "";
|};

@protobuf:Descriptor {value: HELLOWORLDMESSAGE_DESC}
public type HelloResponse record {|
    string message = "";
|};

@protobuf:Descriptor {value: HELLOWORLDMESSAGE_DESC}
public type HelloRequest record {|
    string name = "";
|};

