import ballerina/grpc;

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function testInputStructNoOutput() returns (TestInputStructNoOutputStreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("grpcservices.helloWorld/testInputStructNoOutput");
        return new TestInputStructNoOutputStreamingClient(sClient);
    }
}

public client class TestInputStructNoOutputStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendHelloRequest(HelloRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextHelloRequest(ContextHelloRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receive() returns grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
        }
    }

    isolated remote function receiveContextNil() returns ContextNil|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class HelloWorldNilCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
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

public type ContextHelloRequestStream record {|
    stream<HelloRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextNil record {|
    map<string|string[]> headers;
|};

public type ContextHelloRequest record {|
    HelloRequest content;
    map<string|string[]> headers;
|};

public type Empty record {|
|};

public type HelloRequest record {|
    string name = "";
|};

const string ROOT_DESCRIPTOR = "0A2768656C6C6F576F726C64496E7075744D6573736167654F7574707574456D7074792E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D65325D0A0A68656C6C6F576F726C64124F0A1774657374496E7075745374727563744E6F4F7574707574121A2E6772706373657276696365732E48656C6C6F526571756573741A162E676F6F676C652E70726F746F6275662E456D7074792801620670726F746F33";

isolated function getDescriptorMap() returns map<string> {
    return {
        "google/protobuf/empty.proto": "0A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F120F676F6F676C652E70726F746F62756622070A05456D70747942540A13636F6D2E676F6F676C652E70726F746F627566420A456D70747950726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33",
        "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33",
        "helloWorldInputMessageOutputEmpty.proto": "0A2768656C6C6F576F726C64496E7075744D6573736167654F7574707574456D7074792E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D65325D0A0A68656C6C6F576F726C64124F0A1774657374496E7075745374727563744E6F4F7574707574121A2E6772706373657276696365732E48656C6C6F526571756573741A162E676F6F676C652E70726F746F6275662E456D7074792801620670726F746F33"
    };
}

