import ballerina/grpc;
import ballerina/protobuf;
import tool_test_packaging_nested_dirs.messages;

const string SERVICE1_DESC = "0A16666F6F2F6261722F73657276696365312E70726F746F1A2362616C6C6572696E612F70726F746F6275662F64657363726970746F722E70726F746F1A0F6D65737361676573322E70726F746F22200A0C4D61696E4D6573736167653112100A036D736718012001280552036D736732520A0A4D79536572766963653112250A0563616C6C31120D2E4D61696E4D657373616765311A0D2E4D61696E4D65737361676531121D0A0563616C6C3212092E4D657373616765321A092E4D657373616765324222E2471F746F6F6C5F746573745F7061636B6167696E675F6E65737465645F64697273620670726F746F33";

public isolated client class MyService1Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SERVICE1_DESC);
    }

    isolated remote function call1(MainMessage1|ContextMainMessage1 req) returns MainMessage1|grpc:Error {
        map<string|string[]> headers = {};
        MainMessage1 message;
        if req is ContextMainMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MyService1/call1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <MainMessage1>result;
    }

    isolated remote function call1Context(MainMessage1|ContextMainMessage1 req) returns ContextMainMessage1|grpc:Error {
        map<string|string[]> headers = {};
        MainMessage1 message;
        if req is ContextMainMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MyService1/call1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <MainMessage1>result, headers: respHeaders};
    }

    isolated remote function call2(messages:Message2|ContextMessage2 req) returns messages:Message2|grpc:Error {
        map<string|string[]> headers = {};
        messages:Message2 message;
        if req is ContextMessage2 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MyService1/call2", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <messages:Message2>result;
    }

    isolated remote function call2Context(messages:Message2|ContextMessage2 req) returns ContextMessage2|grpc:Error {
        map<string|string[]> headers = {};
        messages:Message2 message;
        if req is ContextMessage2 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MyService1/call2", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <messages:Message2>result, headers: respHeaders};
    }
}

public client class MyService1MainMessage1Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendMainMessage1(MainMessage1 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextMainMessage1(ContextMainMessage1 response) returns grpc:Error? {
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

public client class MyService1Message2Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendMessage2(messages:Message2 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextMessage2(ContextMessage2 response) returns grpc:Error? {
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

public type ContextMessage2 record {|
    messages:Message2 content;
    map<string|string[]> headers;
|};

public type ContextMainMessage1 record {|
    MainMessage1 content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SERVICE1_DESC}
public type MainMessage1 record {|
    int msg = 0;
|};

