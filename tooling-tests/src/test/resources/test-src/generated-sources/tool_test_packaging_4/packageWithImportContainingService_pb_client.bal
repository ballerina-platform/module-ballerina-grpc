import ballerina/grpc;
import ballerina/protobuf;
import tool_test_packaging_4.message;

const string PACKAGEWITHIMPORTCONTAININGSERVICE_DESC = "0A287061636B61676557697468496D706F7274436F6E7461696E696E67536572766963652E70726F746F12097061636B6167696E671A2362616C6C6572696E612F70726F746F6275662F64657363726970746F722E70726F746F1A186D65737361676557697468536572766963652E70726F746F22480A0B526F6F744D65737361676512100A036D736718012001280952036D736712270A03656E7518022001280E32152E7061636B6167696E672E53696D706C65456E756D5203656E7532B2020A0A68656C6C6F576F726C6412360A0668656C6C6F3112152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D65737361676512380A0668656C6C6F3212152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D657373616765300112380A0668656C6C6F3312152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D6573736167652801123A0A0668656C6C6F3412152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D65737361676528013001123C0A0668656C6C6F3512162E7061636B6167696E672E526F6F744D6573736167651A162E7061636B6167696E672E526F6F744D657373616765280130014218E24715746F6F6C5F746573745F7061636B6167696E675F34620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, PACKAGEWITHIMPORTCONTAININGSERVICE_DESC);
    }

    isolated remote function hello1(message:ReqMessage|message:ContextReqMessage req) returns message:ResMessage|grpc:Error {
        map<string|string[]> headers = {};
        message:ReqMessage message;
        if req is message:ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld/hello1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <message:ResMessage>result;
    }

    isolated remote function hello1Context(message:ReqMessage|message:ContextReqMessage req) returns message:ContextResMessage|grpc:Error {
        map<string|string[]> headers = {};
        message:ReqMessage message;
        if req is message:ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld/hello1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <message:ResMessage>result, headers: respHeaders};
    }

    isolated remote function hello3() returns Hello3StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("packaging.helloWorld/hello3");
        return new Hello3StreamingClient(sClient);
    }

    isolated remote function hello2(message:ReqMessage|message:ContextReqMessage req) returns stream<message:ResMessage, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        message:ReqMessage message;
        if req is message:ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld/hello2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        message:ResMessageStream outputStream = new message:ResMessageStream(result);
        return new stream<message:ResMessage, grpc:Error?>(outputStream);
    }

    isolated remote function hello2Context(message:ReqMessage|message:ContextReqMessage req) returns message:ContextResMessageStream|grpc:Error {
        map<string|string[]> headers = {};
        message:ReqMessage message;
        if req is message:ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld/hello2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        message:ResMessageStream outputStream = new message:ResMessageStream(result);
        return {content: new stream<message:ResMessage, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function hello4() returns Hello4StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("packaging.helloWorld/hello4");
        return new Hello4StreamingClient(sClient);
    }

    isolated remote function hello5() returns Hello5StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("packaging.helloWorld/hello5");
        return new Hello5StreamingClient(sClient);
    }
}

public client class Hello3StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendReqMessage(message:ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(message:ContextReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage() returns message:ResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <message:ResMessage>payload;
        }
    }

    isolated remote function receiveContextResMessage() returns message:ContextResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <message:ResMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class Hello4StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendReqMessage(message:ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(message:ContextReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage() returns message:ResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <message:ResMessage>payload;
        }
    }

    isolated remote function receiveContextResMessage() returns message:ContextResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <message:ResMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class Hello5StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendRootMessage(RootMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextRootMessage(ContextRootMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveRootMessage() returns RootMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <RootMessage>payload;
        }
    }

    isolated remote function receiveContextRootMessage() returns ContextRootMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <RootMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public type ContextRootMessageStream record {|
    stream<RootMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextRootMessage record {|
    RootMessage content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: PACKAGEWITHIMPORTCONTAININGSERVICE_DESC}
public type RootMessage record {|
    string msg = "";
    message:SimpleEnum enu = message:x;
|};

