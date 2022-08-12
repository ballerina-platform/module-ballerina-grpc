import ballerina/grpc;
import ballerina/protobuf.types.wrappers;

const string HELLOWORLDBOOLEAN_DESC = "0A1768656C6C6F576F726C64426F6F6C65616E2E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F324D0A0A68656C6C6F576F726C64123F0A0568656C6C6F121A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75651A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C7565620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, HELLOWORLDBOOLEAN_DESC);
    }

    isolated remote function hello(boolean|wrappers:ContextBoolean req) returns boolean|grpc:Error {
        map<string|string[]> headers = {};
        boolean message;
        if req is wrappers:ContextBoolean {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/hello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <boolean>result;
    }

    isolated remote function helloContext(boolean|wrappers:ContextBoolean req) returns wrappers:ContextBoolean|grpc:Error {
        map<string|string[]> headers = {};
        boolean message;
        if req is wrappers:ContextBoolean {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <boolean>result, headers: respHeaders};
    }
}

