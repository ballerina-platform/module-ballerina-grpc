import ballerina/grpc;
import ballerina/protobuf;

const string SERVICE_DESC = "0A15666F6F2F6261722F736572766963652E70726F746F1A0F6D65737361676573312E70726F746F1A0F6D65737361676573322E70726F746F221F0A0B4D61696E4D65737361676512100A036D736718012001280552036D7367324F0A094D795365727669636512230A0563616C6C31120C2E4D61696E4D6573736167651A0C2E4D61696E4D657373616765121D0A0563616C6C3212092E4D657373616765311A092E4D65737361676532421D5A1B6578616D706C652E636F6D2F666F6F2F6261722F73657276696365620670726F746F33";

public isolated client class MyServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SERVICE_DESC);
    }

    isolated remote function call1(MainMessage|ContextMainMessage req) returns MainMessage|grpc:Error {
        map<string|string[]> headers = {};
        MainMessage message;
        if req is ContextMainMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MyService/call1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <MainMessage>result;
    }

    isolated remote function call1Context(MainMessage|ContextMainMessage req) returns ContextMainMessage|grpc:Error {
        map<string|string[]> headers = {};
        MainMessage message;
        if req is ContextMainMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MyService/call1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <MainMessage>result, headers: respHeaders};
    }

    isolated remote function call2(Message1|ContextMessage1 req) returns Message2|grpc:Error {
        map<string|string[]> headers = {};
        Message1 message;
        if req is ContextMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MyService/call2", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Message2>result;
    }

    isolated remote function call2Context(Message1|ContextMessage1 req) returns ContextMessage2|grpc:Error {
        map<string|string[]> headers = {};
        Message1 message;
        if req is ContextMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("MyService/call2", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Message2>result, headers: respHeaders};
    }
}

public client class MyServiceMessage2Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendMessage2(Message2 response) returns grpc:Error? {
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

public client class MyServiceMainMessageCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendMainMessage(MainMessage response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextMainMessage(ContextMainMessage response) returns grpc:Error? {
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
    Message2 content;
    map<string|string[]> headers;
|};

public type ContextMessage1 record {|
    Message1 content;
    map<string|string[]> headers;
|};

public type ContextMainMessage record {|
    MainMessage content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SERVICE_DESC}
public type MainMessage record {|
    int msg = 0;
|};

