import ballerina/grpc;

public isolated client class helloWorldWithDependencyClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_HELLOWORLDWITHDEPENDENCY, getDescriptorMapHelloWorldWithDependency());
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
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithDependency/hello", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithDependency/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <HelloResponse>result, headers: respHeaders};
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

public type ContextHelloResponse record {|
    HelloResponse content;
    map<string|string[]> headers;
|};

public type ContextHelloRequest record {|
    HelloRequest content;
    map<string|string[]> headers;
|};

const string ROOT_DESCRIPTOR_HELLOWORLDWITHDEPENDENCY = "0A1E68656C6C6F576F726C6457697468446570656E64656E63792E70726F746F1A0D6D6573736167652E70726F746F32420A1868656C6C6F576F726C6457697468446570656E64656E637912260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E7365620670726F746F33";

public isolated function getDescriptorMapHelloWorldWithDependency() returns map<string> {
    return {"helloWorldWithDependency.proto": "0A1E68656C6C6F576F726C6457697468446570656E64656E63792E70726F746F1A0D6D6573736167652E70726F746F32420A1868656C6C6F576F726C6457697468446570656E64656E637912260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E7365620670726F746F33", "message.proto": "0A0D6D6573736167652E70726F746F22240A0C48656C6C6F5265717565737412140A0567726565741801200128095205677265657422210A0D48656C6C6F526573706F6E736512100A037361791801200128095203736179620670726F746F33"};
}

