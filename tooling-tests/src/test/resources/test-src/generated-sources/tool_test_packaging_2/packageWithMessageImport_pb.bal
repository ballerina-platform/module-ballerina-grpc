import ballerina/grpc;
import ballerina/protobuf;
import ballerina/protobuf.types.wrappers;
import tool_test_packaging_2.message1;

const string PACKAGEWITHMESSAGEIMPORT_DESC = "0A1E7061636B616765576974684D657373616765496D706F72742E70726F746F12097061636B6167696E671A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A2362616C6C6572696E612F70726F746F6275662F64657363726970746F722E70726F746F1A0E6D657373616765312E70726F746F22490A0B526F6F744D65737361676512100A036D736718012001280952036D736712280A03656E3118022001280E32162E7061636B6167696E672E53696D706C65456E756D315203656E3132FD030A0A68656C6C6F576F726C6412430A0568656C6C6F121A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75651A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75652801300112380A0668656C6C6F3112162E7061636B6167696E672E5265714D657373616765311A162E7061636B6167696E672E5265734D65737361676531123A0A0668656C6C6F3212162E7061636B6167696E672E5265714D657373616765311A162E7061636B6167696E672E5265734D657373616765313001123A0A0668656C6C6F3312162E7061636B6167696E672E5265714D657373616765311A162E7061636B6167696E672E5265734D657373616765312801123C0A0668656C6C6F3412162E7061636B6167696E672E5265714D657373616765311A162E7061636B6167696E672E5265734D6573736167653128013001123C0A0668656C6C6F3512162E7061636B6167696E672E526F6F744D6573736167651A162E7061636B6167696E672E526F6F744D65737361676528013001123D0A0768656C6C6F313012162E7061636B6167696E672E526F6F744D6573736167651A162E7061636B6167696E672E5265734D6573736167653128013001123D0A0768656C6C6F313112162E7061636B6167696E672E5265714D657373616765311A162E7061636B6167696E672E526F6F744D657373616765280130014218E24715746F6F6C5F746573745F7061636B6167696E675F32620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, PACKAGEWITHMESSAGEIMPORT_DESC);
    }

    isolated remote function hello1(message1:ReqMessage1|message1:ContextReqMessage1 req) returns message1:ResMessage1|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage1 message;
        if req is message1:ContextReqMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld/hello1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <message1:ResMessage1>result;
    }

    isolated remote function hello1Context(message1:ReqMessage1|message1:ContextReqMessage1 req) returns message1:ContextResMessage1|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage1 message;
        if req is message1:ContextReqMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld/hello1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <message1:ResMessage1>result, headers: respHeaders};
    }

    isolated remote function hello3() returns Hello3StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("packaging.helloWorld/hello3");
        return new Hello3StreamingClient(sClient);
    }

    isolated remote function hello2(message1:ReqMessage1|message1:ContextReqMessage1 req) returns stream<message1:ResMessage1, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage1 message;
        if req is message1:ContextReqMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld/hello2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        message1:ResMessage1Stream outputStream = new message1:ResMessage1Stream(result);
        return new stream<message1:ResMessage1, grpc:Error?>(outputStream);
    }

    isolated remote function hello2Context(message1:ReqMessage1|message1:ContextReqMessage1 req) returns message1:ContextResMessage1Stream|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage1 message;
        if req is message1:ContextReqMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld/hello2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        message1:ResMessage1Stream outputStream = new message1:ResMessage1Stream(result);
        return {content: new stream<message1:ResMessage1, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function hello() returns HelloStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("packaging.helloWorld/hello");
        return new HelloStreamingClient(sClient);
    }

    isolated remote function hello4() returns Hello4StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("packaging.helloWorld/hello4");
        return new Hello4StreamingClient(sClient);
    }

    isolated remote function hello5() returns Hello5StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("packaging.helloWorld/hello5");
        return new Hello5StreamingClient(sClient);
    }

    isolated remote function hello10() returns Hello10StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("packaging.helloWorld/hello10");
        return new Hello10StreamingClient(sClient);
    }

    isolated remote function hello11() returns Hello11StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("packaging.helloWorld/hello11");
        return new Hello11StreamingClient(sClient);
    }
}

public client class Hello3StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendReqMessage1(message1:ReqMessage1 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage1(message1:ContextReqMessage1 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage1() returns message1:ResMessage1|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <message1:ResMessage1>payload;
        }
    }

    isolated remote function receiveContextResMessage1() returns message1:ContextResMessage1|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <message1:ResMessage1>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class HelloStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendBoolean(boolean message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextBoolean(wrappers:ContextBoolean message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveBoolean() returns boolean|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <boolean>payload;
        }
    }

    isolated remote function receiveContextBoolean() returns wrappers:ContextBoolean|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <boolean>payload, headers: headers};
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

    isolated remote function sendReqMessage1(message1:ReqMessage1 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage1(message1:ContextReqMessage1 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage1() returns message1:ResMessage1|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <message1:ResMessage1>payload;
        }
    }

    isolated remote function receiveContextResMessage1() returns message1:ContextResMessage1|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <message1:ResMessage1>payload, headers: headers};
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

public client class Hello10StreamingClient {
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

    isolated remote function receiveResMessage1() returns message1:ResMessage1|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <message1:ResMessage1>payload;
        }
    }

    isolated remote function receiveContextResMessage1() returns message1:ContextResMessage1|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <message1:ResMessage1>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class Hello11StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendReqMessage1(message1:ReqMessage1 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage1(message1:ContextReqMessage1 message) returns grpc:Error? {
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

public client class HelloWorldResMessage1Caller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendResMessage1(message1:ResMessage1 response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextResMessage1(message1:ContextResMessage1 response) returns grpc:Error? {
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

public client class HelloWorldRootMessageCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendRootMessage(RootMessage response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextRootMessage(ContextRootMessage response) returns grpc:Error? {
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

public client class HelloWorldBooleanCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBoolean(boolean response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBoolean(wrappers:ContextBoolean response) returns grpc:Error? {
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

public type ContextRootMessageStream record {|
    stream<RootMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextRootMessage record {|
    RootMessage content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: PACKAGEWITHMESSAGEIMPORT_DESC}
public type RootMessage record {|
    string msg = "";
    message1:SimpleEnum1 en1 = message1:x;
|};

