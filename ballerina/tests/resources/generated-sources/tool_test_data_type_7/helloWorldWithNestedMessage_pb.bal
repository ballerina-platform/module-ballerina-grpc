import ballerina/grpc;

public isolated client class helloWorldWithNestedMessageClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function hello(HelloRequest|ContextHelloRequest req) returns (HelloResponse|grpc:Error) {
        map<string|string[]> headers = {};
        HelloRequest message;
        if (req is ContextHelloRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithNestedMessage/hello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <HelloResponse>result;
    }

    isolated remote function helloContext(HelloRequest|ContextHelloRequest req) returns (ContextHelloResponse|grpc:Error) {
        map<string|string[]> headers = {};
        HelloRequest message;
        if (req is ContextHelloRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithNestedMessage/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {
            content: <HelloResponse>result,
            headers: respHeaders
        };
    }

    isolated remote function bye(ByeRequest|ContextByeRequest req) returns (ByeResponse|grpc:Error) {
        map<string|string[]> headers = {};
        ByeRequest message;
        if (req is ContextByeRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithNestedMessage/bye", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ByeResponse>result;
    }

    isolated remote function byeContext(ByeRequest|ContextByeRequest req) returns (ContextByeResponse|grpc:Error) {
        map<string|string[]> headers = {};
        ByeRequest message;
        if (req is ContextByeRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithNestedMessage/bye", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {
            content: <ByeResponse>result,
            headers: respHeaders
        };
    }
}

public client class HelloWorldWithNestedMessageHelloResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendHelloResponse(HelloResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextHelloResponse(ContextHelloResponse response) returns grpc:Error? {
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

public client class HelloWorldWithNestedMessageByeResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendByeResponse(ByeResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextByeResponse(ContextByeResponse response) returns grpc:Error? {
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

public type ByeResponse record {|
    string say = "";
    Baz baz = {};
|};

public type ByeRequest record {|
    string greet = "";
|};

public type HelloResponse record {|
    string message = "";
    Bar[] bars = [];
|};

public type Bar record {|
    int i = 0;
    Foo[] foo = [];
|};

public type Foo record {|
    int i = 0;
|};

public type HelloRequest record {|
    string name = "";
|};

public type Baz record {|
    string age = "";
|};

const string ROOT_DESCRIPTOR = "0A2168656C6C6F576F726C64576974684E65737465644D6573736167652E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522A5010A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D65737361676512260A046261727318022003280B32122E48656C6C6F526573706F6E73652E4261725204626172731A520A03426172120C0A016918012001280552016912280A03666F6F18022003280B32162E48656C6C6F526573706F6E73652E4261722E466F6F5203666F6F1A130A03466F6F120C0A016918012001280552016922220A0A4279655265717565737412140A0567726565741801200128095205677265657422370A0B427965526573706F6E736512100A03736179180120012809520373617912160A0362617A18022001280B32042E42617A520362617A22170A0342617A12100A03616765180120012809520361676532670A1B68656C6C6F576F726C64576974684E65737465644D65737361676512260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E736512200A03627965120B2E427965526571756573741A0C2E427965526573706F6E7365620670726F746F33";

isolated function getDescriptorMap() returns map<string> {
    return {"helloWorldWithNestedMessage.proto": "0A2168656C6C6F576F726C64576974684E65737465644D6573736167652E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522A5010A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D65737361676512260A046261727318022003280B32122E48656C6C6F526573706F6E73652E4261725204626172731A520A03426172120C0A016918012001280552016912280A03666F6F18022003280B32162E48656C6C6F526573706F6E73652E4261722E466F6F5203666F6F1A130A03466F6F120C0A016918012001280552016922220A0A4279655265717565737412140A0567726565741801200128095205677265657422370A0B427965526573706F6E736512100A03736179180120012809520373617912160A0362617A18022001280B32042E42617A520362617A22170A0342617A12100A03616765180120012809520361676532670A1B68656C6C6F576F726C64576974684E65737465644D65737361676512260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E736512200A03627965120B2E427965526571756573741A0C2E427965526573706F6E7365620670726F746F33"};
}

