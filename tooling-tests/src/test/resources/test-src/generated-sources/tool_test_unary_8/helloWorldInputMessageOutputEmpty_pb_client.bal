import ballerina/grpc;
import ballerina/protobuf;
import ballerina/protobuf.types.empty;

const string HELLOWORLDINPUTMESSAGEOUTPUTEMPTY_DESC = "0A2768656C6C6F576F726C64496E7075744D6573736167654F7574707574456D7074792E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D65325B0A0A68656C6C6F576F726C64124D0A1774657374496E7075745374727563744E6F4F7574707574121A2E6772706373657276696365732E48656C6C6F526571756573741A162E676F6F676C652E70726F746F6275662E456D707479620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, HELLOWORLDINPUTMESSAGEOUTPUTEMPTY_DESC);
    }

    isolated remote function testInputStructNoOutput(HelloRequest|ContextHelloRequest req) returns grpc:Error? {
        map<string|string[]> headers = {};
        HelloRequest message;
        if req is ContextHelloRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        _ = check self.grpcClient->executeSimpleRPC("grpcservices.helloWorld/testInputStructNoOutput", message, headers);
    }

    isolated remote function testInputStructNoOutputContext(HelloRequest|ContextHelloRequest req) returns empty:ContextNil|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest message;
        if req is ContextHelloRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.helloWorld/testInputStructNoOutput", message, headers);
        [anydata, map<string|string[]>] [_, respHeaders] = payload;
        return {headers: respHeaders};
    }
}

public type ContextHelloRequest record {|
    HelloRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: HELLOWORLDINPUTMESSAGEOUTPUTEMPTY_DESC}
public type HelloRequest record {|
    string name = "";
|};

