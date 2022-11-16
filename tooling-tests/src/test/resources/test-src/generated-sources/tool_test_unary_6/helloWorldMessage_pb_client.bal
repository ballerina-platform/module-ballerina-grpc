import ballerina/grpc;
import ballerina/protobuf;

public const string HELLOWORLDMESSAGE_DESC = "0A1768656C6C6F576F726C644D6573736167652E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D65737361676522220A0A4279655265717565737412140A05677265657418012001280952056772656574221F0A0B427965526573706F6E736512100A03736179180120012809520373617932560A0A68656C6C6F576F726C6412260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E736512200A03627965120B2E427965526571756573741A0C2E427965526573706F6E7365620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, HELLOWORLDMESSAGE_DESC);
    }

    isolated remote function hello(HelloRequest|ContextHelloRequest req) returns HelloResponse|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest message;
        if req is ContextHelloRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/hello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <HelloResponse>result;
    }

    isolated remote function helloContext(HelloRequest|ContextHelloRequest req) returns ContextHelloResponse|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest message;
        if req is ContextHelloRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <HelloResponse>result, headers: respHeaders};
    }

    isolated remote function bye(ByeRequest|ContextByeRequest req) returns ByeResponse|grpc:Error {
        map<string|string[]> headers = {};
        ByeRequest message;
        if req is ContextByeRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/bye", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ByeResponse>result;
    }

    isolated remote function byeContext(ByeRequest|ContextByeRequest req) returns ContextByeResponse|grpc:Error {
        map<string|string[]> headers = {};
        ByeRequest message;
        if req is ContextByeRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/bye", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ByeResponse>result, headers: respHeaders};
    }
}

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

