import ballerina/grpc;
import ballerina/protobuf;
import tool_test_packaging_nested_dirs.messages;

const string SERVICE2_DESC = "0A12666F6F2F73657276696365322E70726F746F1A2362616C6C6572696E612F70726F746F6275662F64657363726970746F722E70726F746F1A0F6D65737361676573312E70726F746F22200A0C4D61696E4D6573736167653212100A036D736718012001280552036D736732520A0A4D79536572766963653212250A0563616C6C31120D2E4D61696E4D657373616765321A0D2E4D61696E4D65737361676532121D0A0563616C6C3212092E4D657373616765311A092E4D657373616765314222E2471F746F6F6C5F746573745F7061636B6167696E675F6E65737465645F64697273620670726F746F33";

public isolated client class MyService2Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SERVICE2_DESC);
    }

    isolated remote function call1(MainMessage2|ContextMainMessage2 req) returns MainMessage2|grpc:Error {
        map<string|string[]> headers = {};
        MainMessage2 message;
        if req is ContextMainMessage2 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MyService2/call1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <MainMessage2>result;
    }

    isolated remote function call1Context(MainMessage2|ContextMainMessage2 req) returns ContextMainMessage2|grpc:Error {
        map<string|string[]> headers = {};
        MainMessage2 message;
        if req is ContextMainMessage2 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MyService2/call1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <MainMessage2>result, headers: respHeaders};
    }

    isolated remote function call2(messages:Message1|ContextMessage1 req) returns messages:Message1|grpc:Error {
        map<string|string[]> headers = {};
        messages:Message1 message;
        if req is ContextMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MyService2/call2", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <messages:Message1>result;
    }

    isolated remote function call2Context(messages:Message1|ContextMessage1 req) returns ContextMessage1|grpc:Error {
        map<string|string[]> headers = {};
        messages:Message1 message;
        if req is ContextMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MyService2/call2", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <messages:Message1>result, headers: respHeaders};
    }
}

public client class MyService2Message1Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendMessage1(messages:Message1 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextMessage1(ContextMessage1 response) returns grpc:Error? {
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

public client class MyService2MainMessage2Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendMainMessage2(MainMessage2 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextMainMessage2(ContextMainMessage2 response) returns grpc:Error? {
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

public type ContextMessage1 record {|
    messages:Message1 content;
    map<string|string[]> headers;
|};

public type ContextMainMessage2 record {|
    MainMessage2 content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SERVICE2_DESC}
public type MainMessage2 record {|
    int msg = 0;
|};

