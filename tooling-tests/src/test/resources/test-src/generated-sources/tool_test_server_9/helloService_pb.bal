import ballerina/grpc;
import ballerina/protobuf;

const string HELLOSERVICE_DESC = "0A1268656C6C6F536572766963652E70726F746F22220A0A5265714D65737361676512140A0576616C7565180120012809520576616C756522220A0A5265734D65737361676512140A0576616C7565180120012809520576616C756532310A0E68656C6C6F42616C6C6572696E61121F0A03686579120B2E5265714D6573736167651A0B2E5265734D657373616765620670726F746F33";

public isolated client class helloBallerinaClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, HELLOSERVICE_DESC);
    }

    isolated remote function hey(ReqMessage|ContextReqMessage req) returns ResMessage|grpc:Error {
        map<string|string[]> headers = {};
        ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloBallerina/hey", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ResMessage>result;
    }

    isolated remote function heyContext(ReqMessage|ContextReqMessage req) returns ContextResMessage|grpc:Error {
        map<string|string[]> headers = {};
        ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloBallerina/hey", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ResMessage>result, headers: respHeaders};
    }
}

public client class HelloBallerinaResMessageCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendResMessage(ResMessage response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextResMessage(ContextResMessage response) returns grpc:Error? {
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

public type ContextReqMessage record {|
    ReqMessage content;
    map<string|string[]> headers;
|};

public type ContextResMessage record {|
    ResMessage content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: HELLOSERVICE_DESC}
public type ReqMessage record {|
    string value = "";
|};

@protobuf:Descriptor {value: HELLOSERVICE_DESC}
public type ResMessage record {|
    string value = "";
|};

