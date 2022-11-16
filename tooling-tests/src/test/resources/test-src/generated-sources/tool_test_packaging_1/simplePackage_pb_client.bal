import ballerina/grpc;
import ballerina/protobuf;
import ballerina/protobuf.types.wrappers;

public const string SIMPLEPACKAGE_DESC = "0A1373696D706C655061636B6167652E70726F746F120D73696D706C655061636B6167651A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A2362616C6C6572696E612F70726F746F6275662F64657363726970746F722E70726F746F22300A0C48656C6C6F5265717565737412100A036D736718012001280952036D7367120E0A0269641802200128055202696422310A0D48656C6C6F526573706F6E736512100A036D736718012001280952036D7367120E0A02696418022001280552026964328E010A0A68656C6C6F576F726C64123F0A0568656C6C6F121A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75651A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C7565123F0A026869121B2E73696D706C655061636B6167652E48656C6C6F526571756573741A1C2E73696D706C655061636B6167652E48656C6C6F526573706F6E73654218E24715746F6F6C5F746573745F7061636B6167696E675F31620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SIMPLEPACKAGE_DESC);
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
        var payload = check self.grpcClient->executeSimpleRPC("simplePackage.helloWorld/hello", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("simplePackage.helloWorld/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <boolean>result, headers: respHeaders};
    }

    isolated remote function hi(HelloRequest|ContextHelloRequest req) returns HelloResponse|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest message;
        if req is ContextHelloRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("simplePackage.helloWorld/hi", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <HelloResponse>result;
    }

    isolated remote function hiContext(HelloRequest|ContextHelloRequest req) returns ContextHelloResponse|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest message;
        if req is ContextHelloRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("simplePackage.helloWorld/hi", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <HelloResponse>result, headers: respHeaders};
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

@protobuf:Descriptor {value: SIMPLEPACKAGE_DESC}
public type HelloResponse record {|
    string msg = "";
    int id = 0;
|};

@protobuf:Descriptor {value: SIMPLEPACKAGE_DESC}
public type HelloRequest record {|
    string msg = "";
    int id = 0;
|};

