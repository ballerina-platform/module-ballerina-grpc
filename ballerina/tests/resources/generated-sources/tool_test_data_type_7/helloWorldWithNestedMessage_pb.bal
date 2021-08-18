import ballerina/grpc;

public isolated client class helloWorldWithNestedMessageClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_HELLOWORLDWITHNESTEDMESSAGE, getDescriptorMapHelloWorldWithNestedMessage());
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
        var payload = check self.grpcClient->executeSimpleRPC("myproj.apis.helloWorldWithNestedMessage/hello", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("myproj.apis.helloWorldWithNestedMessage/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <HelloResponse>result, headers: respHeaders};
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
        var payload = check self.grpcClient->executeSimpleRPC("myproj.apis.helloWorldWithNestedMessage/bye", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("myproj.apis.helloWorldWithNestedMessage/bye", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ByeResponse>result, headers: respHeaders};
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

public type FileInfo record {|
    FileInfo_Observability observability = {};
|};

public type FileInfo_Observability record {|
    string id = "";
    string latest_version = "";
    FileInfo_Observability_TraceId traceId = {};
|};

public type FileInfo_Observability_TraceId record {|
    string id = "";
    string latest_version = "";
|};

public type Log record {|
    Log_Observability observability = {};
|};

public type Log_Observability record {|
    string id = "";
    string latest_version = "";
|};

public type HelloResponse record {|
    string message = "";
    HelloResponse_Bar[] bars = [];
|};

public type HelloResponse_Bar record {|
    int i = 0;
    HelloResponse_Bar_Foo[] foo = [];
|};

public type HelloResponse_Bar_Foo record {|
    int i = 0;
|};

public type HelloRequest record {|
    string name = "";
|};

public type Baz record {|
    string age = "";
|};

const string ROOT_DESCRIPTOR_HELLOWORLDWITHNESTEDMESSAGE = "0A2168656C6C6F576F726C64576974684E65737465644D6573736167652E70726F746F120B6D7970726F6A2E6170697322220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522BD010A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D65737361676512320A046261727318022003280B321E2E6D7970726F6A2E617069732E48656C6C6F526573706F6E73652E4261725204626172731A5E0A03426172120C0A016918012001280552016912340A03666F6F18022003280B32222E6D7970726F6A2E617069732E48656C6C6F526573706F6E73652E4261722E466F6F5203666F6F1A130A03466F6F120C0A016918012001280552016922220A0A4279655265717565737412140A0567726565741801200128095205677265657422430A0B427965526573706F6E736512100A03736179180120012809520373617912220A0362617A18022001280B32102E6D7970726F6A2E617069732E42617A520362617A22170A0342617A12100A03616765180120012809520361676522C1020A0846696C65496E666F12490A0D6F62736572766162696C69747918012001280B32232E6D7970726F6A2E617069732E46696C65496E666F2E4F62736572766162696C697479520D6F62736572766162696C6974791AE9010A0D4F62736572766162696C697479121B0A026964180120012809520F6F62736572766162696C697479496412250A0E6C61746573745F76657273696F6E180220012809520D6C617465737456657273696F6E12450A077472616365496418032001280B322B2E6D7970726F6A2E617069732E46696C65496E666F2E4F62736572766162696C6974792E547261636549645207747261636549641A4D0A0754726163654964121B0A026964180120012809520F6F62736572766162696C697479496412250A0E6C61746573745F76657273696F6E180220012809520D6C617465737456657273696F6E22A0010A034C6F6712440A0D6F62736572766162696C69747918012001280B321E2E6D7970726F6A2E617069732E4C6F672E4F62736572766162696C697479520D6F62736572766162696C6974791A530A0D4F62736572766162696C697479121B0A026964180120012809520F6F62736572766162696C697479496412250A0E6C61746573745F76657273696F6E180220012809520D6C617465737456657273696F6E3297010A1B68656C6C6F576F726C64576974684E65737465644D657373616765123E0A0568656C6C6F12192E6D7970726F6A2E617069732E48656C6C6F526571756573741A1A2E6D7970726F6A2E617069732E48656C6C6F526573706F6E736512380A0362796512172E6D7970726F6A2E617069732E427965526571756573741A182E6D7970726F6A2E617069732E427965526573706F6E7365620670726F746F33";

public isolated function getDescriptorMapHelloWorldWithNestedMessage() returns map<string> {
    return {"helloWorldWithNestedMessage.proto": "0A2168656C6C6F576F726C64576974684E65737465644D6573736167652E70726F746F120B6D7970726F6A2E6170697322220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522BD010A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D65737361676512320A046261727318022003280B321E2E6D7970726F6A2E617069732E48656C6C6F526573706F6E73652E4261725204626172731A5E0A03426172120C0A016918012001280552016912340A03666F6F18022003280B32222E6D7970726F6A2E617069732E48656C6C6F526573706F6E73652E4261722E466F6F5203666F6F1A130A03466F6F120C0A016918012001280552016922220A0A4279655265717565737412140A0567726565741801200128095205677265657422430A0B427965526573706F6E736512100A03736179180120012809520373617912220A0362617A18022001280B32102E6D7970726F6A2E617069732E42617A520362617A22170A0342617A12100A03616765180120012809520361676522C1020A0846696C65496E666F12490A0D6F62736572766162696C69747918012001280B32232E6D7970726F6A2E617069732E46696C65496E666F2E4F62736572766162696C697479520D6F62736572766162696C6974791AE9010A0D4F62736572766162696C697479121B0A026964180120012809520F6F62736572766162696C697479496412250A0E6C61746573745F76657273696F6E180220012809520D6C617465737456657273696F6E12450A077472616365496418032001280B322B2E6D7970726F6A2E617069732E46696C65496E666F2E4F62736572766162696C6974792E547261636549645207747261636549641A4D0A0754726163654964121B0A026964180120012809520F6F62736572766162696C697479496412250A0E6C61746573745F76657273696F6E180220012809520D6C617465737456657273696F6E22A0010A034C6F6712440A0D6F62736572766162696C69747918012001280B321E2E6D7970726F6A2E617069732E4C6F672E4F62736572766162696C697479520D6F62736572766162696C6974791A530A0D4F62736572766162696C697479121B0A026964180120012809520F6F62736572766162696C697479496412250A0E6C61746573745F76657273696F6E180220012809520D6C617465737456657273696F6E3297010A1B68656C6C6F576F726C64576974684E65737465644D657373616765123E0A0568656C6C6F12192E6D7970726F6A2E617069732E48656C6C6F526571756573741A1A2E6D7970726F6A2E617069732E48656C6C6F526573706F6E736512380A0362796512172E6D7970726F6A2E617069732E427965526571756573741A182E6D7970726F6A2E617069732E427965526573706F6E7365620670726F746F33"};
}

