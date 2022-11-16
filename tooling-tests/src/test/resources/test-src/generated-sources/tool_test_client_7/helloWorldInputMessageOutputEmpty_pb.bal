import ballerina/grpc;
import ballerina/protobuf;
import ballerina/protobuf.types.empty;

public const string HELLOWORLDINPUTMESSAGEOUTPUTEMPTY_DESC = "0A2768656C6C6F576F726C64496E7075744D6573736167654F7574707574456D7074792E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D65325D0A0A68656C6C6F576F726C64124F0A1774657374496E7075745374727563744E6F4F7574707574121A2E6772706373657276696365732E48656C6C6F526571756573741A162E676F6F676C652E70726F746F6275662E456D7074792801620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, HELLOWORLDINPUTMESSAGEOUTPUTEMPTY_DESC);
    }

    isolated remote function testInputStructNoOutput() returns TestInputStructNoOutputStreamingClient|grpc:Error {
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
            _ = response;
        }
    }

    isolated remote function receiveContextNil() returns empty:ContextNil|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [_, headers] = response;
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

public type ContextHelloRequest record {|
    HelloRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: HELLOWORLDINPUTMESSAGEOUTPUTEMPTY_DESC}
public type HelloRequest record {|
    string name = "";
|};

