import ballerina/grpc;
import grpc_tests.messageWithService;

const string PACKAGE_WITH_SERVICE_IN_SUBMODULE_DESC = "0A2A37315F7061636B6167655F776974685F736572766963655F696E5F7375626D6F64756C652E70726F746F12097061636B6167696E671A2362616C6C6572696E612F70726F746F6275662F64657363726970746F722E70726F746F1A1037315F6D6573736167652E70726F746F32B5020A0C68656C6C6F576F726C64373112410A1168656C6C6F576F726C643731556E61727912152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D657373616765124A0A1868656C6C6F576F726C64373153657276657253747265616D12152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D6573736167653001124A0A1868656C6C6F576F726C643731436C69656E7453747265616D12152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D6573736167652801124A0A1668656C6C6F576F726C6437314269646953747265616D12152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D65737361676528013001420DE2470A677270635F7465737473620670726F746F33";

public isolated client class helloWorld71Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, PACKAGE_WITH_SERVICE_IN_SUBMODULE_DESC);
    }

    isolated remote function helloWorld71Unary(messageWithService:ReqMessage|messageWithService:ContextReqMessage req) returns messageWithService:ResMessage|grpc:Error {
        map<string|string[]> headers = {};
        messageWithService:ReqMessage message;
        if req is messageWithService:ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld71/helloWorld71Unary", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <messageWithService:ResMessage>result;
    }

    isolated remote function helloWorld71UnaryContext(messageWithService:ReqMessage|messageWithService:ContextReqMessage req) returns messageWithService:ContextResMessage|grpc:Error {
        map<string|string[]> headers = {};
        messageWithService:ReqMessage message;
        if req is messageWithService:ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld71/helloWorld71Unary", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <messageWithService:ResMessage>result, headers: respHeaders};
    }

    isolated remote function helloWorld71ClientStream() returns HelloWorld71ClientStreamStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("packaging.helloWorld71/helloWorld71ClientStream");
        return new HelloWorld71ClientStreamStreamingClient(sClient);
    }

    isolated remote function helloWorld71ServerStream(messageWithService:ReqMessage|messageWithService:ContextReqMessage req) returns stream<messageWithService:ResMessage, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        messageWithService:ReqMessage message;
        if req is messageWithService:ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld71/helloWorld71ServerStream", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        messageWithService:ResMessageStream outputStream = new messageWithService:ResMessageStream(result);
        return new stream<messageWithService:ResMessage, grpc:Error?>(outputStream);
    }

    isolated remote function helloWorld71ServerStreamContext(messageWithService:ReqMessage|messageWithService:ContextReqMessage req) returns messageWithService:ContextResMessageStream|grpc:Error {
        map<string|string[]> headers = {};
        messageWithService:ReqMessage message;
        if req is messageWithService:ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld71/helloWorld71ServerStream", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        messageWithService:ResMessageStream outputStream = new messageWithService:ResMessageStream(result);
        return {content: new stream<messageWithService:ResMessage, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function helloWorld71BidiStream() returns HelloWorld71BidiStreamStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("packaging.helloWorld71/helloWorld71BidiStream");
        return new HelloWorld71BidiStreamStreamingClient(sClient);
    }
}

public client class HelloWorld71ClientStreamStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendReqMessage(messageWithService:ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(messageWithService:ContextReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage() returns messageWithService:ResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <messageWithService:ResMessage>payload;
        }
    }

    isolated remote function receiveContextResMessage() returns messageWithService:ContextResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <messageWithService:ResMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class HelloWorld71BidiStreamStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendReqMessage(messageWithService:ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(messageWithService:ContextReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage() returns messageWithService:ResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <messageWithService:ResMessage>payload;
        }
    }

    isolated remote function receiveContextResMessage() returns messageWithService:ContextResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <messageWithService:ResMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class HelloWorld71ResMessageCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendResMessage(messageWithService:ResMessage response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextResMessage(messageWithService:ContextResMessage response) returns grpc:Error? {
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

