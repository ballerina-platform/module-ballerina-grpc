import ballerina/grpc;
import ballerina/protobuf.types.wrappers;

public const string HELLOWORLDFLOAT_DESC = "0A1568656C6C6F576F726C64466C6F61742E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32530A0A68656C6C6F576F726C6412450A0568656C6C6F121B2E676F6F676C652E70726F746F6275662E466C6F617456616C75651A1B2E676F6F676C652E70726F746F6275662E466C6F617456616C756528013001620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, HELLOWORLDFLOAT_DESC);
    }

    isolated remote function hello() returns HelloStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("helloWorld/hello");
        return new HelloStreamingClient(sClient);
    }
}

public client class HelloStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendFloat(float message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextFloat(wrappers:ContextFloat message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveFloat() returns float|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <float>payload;
        }
    }

    isolated remote function receiveContextFloat() returns wrappers:ContextFloat|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <float>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

