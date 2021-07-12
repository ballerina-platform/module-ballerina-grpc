import ballerina/grpc;

public isolated client class helloWorldWithNestedEnumClient {
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
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithNestedEnum/hello", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithNestedEnum/hello", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithNestedEnum/bye", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithNestedEnum/bye", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {
            content: <ByeResponse>result,
            headers: respHeaders
        };
    }
}

public isolated client class helloFooWithNestedEnumClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function foo(HelloRequest|ContextHelloRequest req) returns (HelloResponse|grpc:Error) {
        map<string|string[]> headers = {};
        HelloRequest message;
        if (req is ContextHelloRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloFooWithNestedEnum/foo", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <HelloResponse>result;
    }

    isolated remote function fooContext(HelloRequest|ContextHelloRequest req) returns (ContextHelloResponse|grpc:Error) {
        map<string|string[]> headers = {};
        HelloRequest message;
        if (req is ContextHelloRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloFooWithNestedEnum/foo", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {
            content: <HelloResponse>result,
            headers: respHeaders
        };
    }

    isolated remote function bar(ByeRequest|ContextByeRequest req) returns (ByeResponse|grpc:Error) {
        map<string|string[]> headers = {};
        ByeRequest message;
        if (req is ContextByeRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloFooWithNestedEnum/bar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ByeResponse>result;
    }

    isolated remote function barContext(ByeRequest|ContextByeRequest req) returns (ContextByeResponse|grpc:Error) {
        map<string|string[]> headers = {};
        ByeRequest message;
        if (req is ContextByeRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloFooWithNestedEnum/bar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {
            content: <ByeResponse>result,
            headers: respHeaders
        };
    }
}

public client class HelloWorldWithNestedEnumByeResponseCaller {
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

public client class HelloWorldWithNestedEnumHelloResponseCaller {
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

public client class HelloFooWithNestedEnumHelloResponseCaller {
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

public client class HelloFooWithNestedEnumByeResponseCaller {
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
    priority mode = high;
|};

public type ByeRequest record {|
    string greet = "";
|};

public type HelloResponse record {|
    string message = "";
    sentiment mode = happy;
|};

public enum sentiment {
    happy,
    sad,
    neutral
}

public type HelloRequest record {|
    string name = "";
|};

public enum priority {
    high,
    medium,
    low
}

const string ROOT_DESCRIPTOR = "0A1E68656C6C6F576F726C64576974684E6573746564456E756D2E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D652285010A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D657373616765122C0A046D6F646518022001280E32182E48656C6C6F526573706F6E73652E73656E74696D656E7452046D6F6465222C0A0973656E74696D656E7412090A056861707079100012070A037361641001120B0A076E65757472616C100222220A0A4279655265717565737412140A05677265657418012001280952056772656574223E0A0B427965526573706F6E736512100A037361791801200128095203736179121D0A046D6F646518022001280E32092E7072696F7269747952046D6F64652A290A087072696F7269747912080A04686967681000120A0A066D656469756D100112070A036C6F77100232640A1868656C6C6F576F726C64576974684E6573746564456E756D12260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E736512200A03627965120B2E427965526571756573741A0C2E427965526573706F6E736532600A1668656C6C6F466F6F576974684E6573746564456E756D12240A03666F6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E736512200A03626172120B2E427965526571756573741A0C2E427965526573706F6E7365620670726F746F33";

isolated function getDescriptorMap() returns map<string> {
    return {"helloWorldWithNestedEnum.proto": "0A1E68656C6C6F576F726C64576974684E6573746564456E756D2E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D652285010A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D657373616765122C0A046D6F646518022001280E32182E48656C6C6F526573706F6E73652E73656E74696D656E7452046D6F6465222C0A0973656E74696D656E7412090A056861707079100012070A037361641001120B0A076E65757472616C100222220A0A4279655265717565737412140A05677265657418012001280952056772656574223E0A0B427965526573706F6E736512100A037361791801200128095203736179121D0A046D6F646518022001280E32092E7072696F7269747952046D6F64652A290A087072696F7269747912080A04686967681000120A0A066D656469756D100112070A036C6F77100232640A1868656C6C6F576F726C64576974684E6573746564456E756D12260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E736512200A03627965120B2E427965526571756573741A0C2E427965526573706F6E736532600A1668656C6C6F466F6F576974684E6573746564456E756D12240A03666F6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E736512200A03626172120B2E427965526571756573741A0C2E427965526573706F6E7365620670726F746F33"};
}

