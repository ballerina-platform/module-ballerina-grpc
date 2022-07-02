import ballerina/grpc;
import ballerina/protobuf;

const string MESSAGE_DESC = "0A1037315F6D6573736167652E70726F746F12097061636B6167696E671A2362616C6C6572696E612F70726F746F6275662F64657363726970746F722E70726F746F22340A0A5265714D65737361676512100A03726571180120012805520372657112140A0576616C7565180220012809520576616C756522340A0A5265734D65737361676512100A03726571180120012805520372657112140A0576616C7565180220012809520576616C756532EF010A1068656C6C6F42616C6C6572696E61373112320A02686912152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D65737361676512350A0368657912152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D657373616765300112370A0568656C6C6F12152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D657373616765280112370A0362796512152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D657373616765280130014220E2471D677270635F74657374732E6D6573736167655769746853657276696365620670726F746F33";

public isolated client class helloBallerina71Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, MESSAGE_DESC);
    }

    isolated remote function hi(ReqMessage|ContextReqMessage req) returns ResMessage|grpc:Error {
        map<string|string[]> headers = {};
        ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloBallerina71/hi", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ResMessage>result;
    }

    isolated remote function hiContext(ReqMessage|ContextReqMessage req) returns ContextResMessage|grpc:Error {
        map<string|string[]> headers = {};
        ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloBallerina71/hi", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ResMessage>result, headers: respHeaders};
    }

    isolated remote function hello() returns HelloStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("packaging.helloBallerina71/hello");
        return new HelloStreamingClient(sClient);
    }

    isolated remote function hey(ReqMessage|ContextReqMessage req) returns stream<ResMessage, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloBallerina71/hey", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ResMessageStream outputStream = new ResMessageStream(result);
        return new stream<ResMessage, grpc:Error?>(outputStream);
    }

    isolated remote function heyContext(ReqMessage|ContextReqMessage req) returns ContextResMessageStream|grpc:Error {
        map<string|string[]> headers = {};
        ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloBallerina71/hey", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ResMessageStream outputStream = new ResMessageStream(result);
        return {content: new stream<ResMessage, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function bye() returns ByeStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("packaging.helloBallerina71/bye");
        return new ByeStreamingClient(sClient);
    }
}

public client class HelloStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendReqMessage(ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(ContextReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage() returns ResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <ResMessage>payload;
        }
    }

    isolated remote function receiveContextResMessage() returns ContextResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <ResMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class ResMessageStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|ResMessage value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|ResMessage value;|} nextRecord = {value: <ResMessage>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class ByeStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendReqMessage(ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(ContextReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage() returns ResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <ResMessage>payload;
        }
    }

    isolated remote function receiveContextResMessage() returns ContextResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <ResMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class HelloBallerina71ResMessageCaller {
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

public type ContextReqMessageStream record {|
    stream<ReqMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextResMessageStream record {|
    stream<ResMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextReqMessage record {|
    ReqMessage content;
    map<string|string[]> headers;
|};

public type ContextResMessage record {|
    ResMessage content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: MESSAGE_DESC}
public type ReqMessage record {|
    int req = 0;
    string value = "";
|};

@protobuf:Descriptor {value: MESSAGE_DESC}
public type ResMessage record {|
    int req = 0;
    string value = "";
|};

