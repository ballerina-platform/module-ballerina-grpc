import ballerina/grpc;

public isolated client class helloWorldClient {
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
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/hello", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {
            content: <HelloResponse>result,
            headers: respHeaders
        };
    }
}

public client class HelloWorldHelloResponseCaller {
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

public type HelloResponse record {|
    string message = "";
    record {| string key; string value; |}[] tags = [];
|};

public type HelloRequest record {|
    string name = "";
    record {| string key; string value; |}[] tags = [];
|};

const string ROOT_DESCRIPTOR = "0A1768656C6C6F576F726C64576974684D61702E70726F746F2288010A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D65122B0A047461677318042003280B32172E48656C6C6F526571756573742E54616773456E7472795204746167731A370A0954616773456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A0238012290010A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D657373616765122C0A047461677318042003280B32182E48656C6C6F526573706F6E73652E54616773456E7472795204746167731A370A0954616773456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A02380132340A0A68656C6C6F576F726C6412260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E7365620670726F746F33";

isolated function getDescriptorMap() returns map<string> {
    return {"helloWorldWithMap.proto": "0A1768656C6C6F576F726C64576974684D61702E70726F746F2288010A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D65122B0A047461677318042003280B32172E48656C6C6F526571756573742E54616773456E7472795204746167731A370A0954616773456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A0238012290010A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D657373616765122C0A047461677318042003280B32182E48656C6C6F526573706F6E73652E54616773456E7472795204746167731A370A0954616773456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A02380132340A0A68656C6C6F576F726C6412260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E7365620670726F746F33"};
}

