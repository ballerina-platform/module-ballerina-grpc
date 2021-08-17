import ballerina/grpc;

public isolated client class helloWorldWithDependencyClient {
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
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithDependency/hello", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithDependency/hello", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithDependency/bye", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithDependency/bye", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {
            content: <ByeResponse>result,
            headers: respHeaders
        };
    }
}

public client class HelloWorldWithDependencyHelloResponseCaller {
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

public client class HelloWorldWithDependencyByeResponseCaller {
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

const string ROOT_DESCRIPTOR = "0A1E68656C6C6F576F726C6457697468446570656E64656E63792E70726F746F1A0D6D6573736167652E70726F746F1A116C69622F6D6573736167652E70726F746F32640A1868656C6C6F576F726C6457697468446570656E64656E637912260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E736512200A03627965120B2E427965526571756573741A0C2E427965526573706F6E7365620670726F746F33";

isolated function getDescriptorMap() returns map<string> {
    return {
        "google/protobuf/timestamp.proto": "0A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F120F676F6F676C652E70726F746F627566223B0A0954696D657374616D7012180A077365636F6E647318012001280352077365636F6E647312140A056E616E6F7318022001280552056E616E6F7342580A13636F6D2E676F6F676C652E70726F746F627566420E54696D657374616D7050726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33",
        "helloWorldWithDependency.proto": "0A1E68656C6C6F576F726C6457697468446570656E64656E63792E70726F746F1A0D6D6573736167652E70726F746F1A116C69622F6D6573736167652E70726F746F32640A1868656C6C6F576F726C6457697468446570656E64656E637912260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E736512200A03627965120B2E427965526571756573741A0C2E427965526573706F6E7365620670726F746F33",
        "lib/message.proto": "0A116C69622F6D6573736167652E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D657373616765620670726F746F33",
        "message.proto": "0A0D6D6573736167652E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F22220A0A4279655265717565737412140A05677265657418012001280952056772656574221F0A0B427965526573706F6E736512100A037361791801200128095203736179227C0A045573657212390A0A637265617465645F617418012001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520963726561746564417412390A0A657870697265645F617418022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D705209657870697265644174620670726F746F33"
    };
}

