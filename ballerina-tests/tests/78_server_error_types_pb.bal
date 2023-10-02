import ballerina/grpc;
import ballerina/protobuf.types.empty;
import ballerina/protobuf.types.wrappers;

public const string SERVER_ERROR_TYPES_DESC = "0A1B37385F7365727665725F6572726F725F74797065732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32600A175365727665724572726F7254797065735365727669636512450A0E4765745365727665724572726F72121B2E676F6F676C652E70726F746F6275662E496E74333256616C75651A162E676F6F676C652E70726F746F6275662E456D707479620670726F746F33";

public isolated client class ServerErrorTypesServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SERVER_ERROR_TYPES_DESC);
    }

    isolated remote function GetServerError(int|wrappers:ContextInt req) returns grpc:Error? {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        _ = check self.grpcClient->executeSimpleRPC("ServerErrorTypesService/GetServerError", message, headers);
    }

    isolated remote function GetServerErrorContext(int|wrappers:ContextInt req) returns empty:ContextNil|grpc:Error {
        map<string|string[]> headers = {};
        int message;
        if req is wrappers:ContextInt {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ServerErrorTypesService/GetServerError", message, headers);
        [anydata, map<string|string[]>] [_, respHeaders] = payload;
        return {headers: respHeaders};
    }
}

public client class ServerErrorTypesServiceNilCaller {
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

