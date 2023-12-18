import ballerina/grpc;
import ballerina/protobuf.types.empty;

public isolated client class MultipleClientConfigsService1Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_65_MULTIPLE_CLIENT_CONFIGURATIONS, getDescriptorMap65MultipleClientConfigurations());
    }

    isolated remote function call1() returns grpc:Error? {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        _ = check self.grpcClient->executeSimpleRPC("MultipleClientConfigsService1/call1", message, headers);
    }

    isolated remote function call1Context() returns empty:ContextNil|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("MultipleClientConfigsService1/call1", message, headers);
        [anydata, map<string|string[]>] [_, respHeaders] = payload;
        return {headers: respHeaders};
    }
}

public isolated client class MultipleClientConfigsService2Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_65_MULTIPLE_CLIENT_CONFIGURATIONS, getDescriptorMap65MultipleClientConfigurations());
    }

    isolated remote function call1() returns grpc:Error? {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        _ = check self.grpcClient->executeSimpleRPC("MultipleClientConfigsService2/call1", message, headers);
    }

    isolated remote function call1Context() returns empty:ContextNil|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("MultipleClientConfigsService2/call1", message, headers);
        [anydata, map<string|string[]>] [_, respHeaders] = payload;
        return {headers: respHeaders};
    }
}

public client class MultipleClientConfigsService1NilCaller {
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

public client class MultipleClientConfigsService2NilCaller {
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

const string ROOT_DESCRIPTOR_65_MULTIPLE_CLIENT_CONFIGURATIONS = "0A2736355F6D756C7469706C655F636C69656E745F636F6E66696775726174696F6E732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F32580A1D4D756C7469706C65436C69656E74436F6E66696773536572766963653112370A0563616C6C3112162E676F6F676C652E70726F746F6275662E456D7074791A162E676F6F676C652E70726F746F6275662E456D70747932580A1D4D756C7469706C65436C69656E74436F6E66696773536572766963653212370A0563616C6C3112162E676F6F676C652E70726F746F6275662E456D7074791A162E676F6F676C652E70726F746F6275662E456D707479620670726F746F33";

public isolated function getDescriptorMap65MultipleClientConfigurations() returns map<string> {
    return {"65_multiple_client_configurations.proto": "0A2736355F6D756C7469706C655F636C69656E745F636F6E66696775726174696F6E732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F32580A1D4D756C7469706C65436C69656E74436F6E66696773536572766963653112370A0563616C6C3112162E676F6F676C652E70726F746F6275662E456D7074791A162E676F6F676C652E70726F746F6275662E456D70747932580A1D4D756C7469706C65436C69656E74436F6E66696773536572766963653212370A0563616C6C3112162E676F6F676C652E70726F746F6275662E456D7074791A162E676F6F676C652E70726F746F6275662E456D707479620670726F746F33", "google/protobuf/empty.proto": "0A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F120F676F6F676C652E70726F746F62756622070A05456D70747942540A13636F6D2E676F6F676C652E70726F746F627566420A456D70747950726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

