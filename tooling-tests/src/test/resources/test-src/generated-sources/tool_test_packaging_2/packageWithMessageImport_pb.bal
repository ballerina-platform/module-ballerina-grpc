import ballerina/grpc;
import ballerina/protobuf;
import ballerina/protobuf.types.wrappers;
import tool_test_packaging_2.message;

public const string PACKAGEWITHMESSAGEIMPORT_DESC = "0A1E7061636B616765576974684D657373616765496D706F72742E70726F746F12097061636B6167696E671A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A2362616C6C6572696E612F70726F746F6275662F64657363726970746F722E70726F746F1A0D6D6573736167652E70726F746F22480A0B526F6F744D65737361676512100A036D736718012001280952036D736712270A03656E3118022001280E32152E7061636B6167696E672E53696D706C65456E756D5203656E3132F3030A0A68656C6C6F576F726C6412430A0568656C6C6F121A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75651A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75652801300112360A0668656C6C6F3112152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D65737361676512380A0668656C6C6F3212152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D657373616765300112380A0668656C6C6F3312152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D6573736167652801123A0A0668656C6C6F3412152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D65737361676528013001123C0A0668656C6C6F3512162E7061636B6167696E672E526F6F744D6573736167651A162E7061636B6167696E672E526F6F744D65737361676528013001123C0A0768656C6C6F313012162E7061636B6167696E672E526F6F744D6573736167651A152E7061636B6167696E672E5265734D65737361676528013001123C0A0768656C6C6F313112152E7061636B6167696E672E5265714D6573736167651A162E7061636B6167696E672E526F6F744D657373616765280130014218E24715746F6F6C5F746573745F7061636B6167696E675F32620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, PACKAGEWITHMESSAGEIMPORT_DESC);
    }

    isolated remote function hello1(message:ReqMessage|ContextReqMessage req) returns message:ResMessage|grpc:Error {
        map<string|string[]> headers = {};
        message:ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld/hello1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <message:ResMessage>result;
    }

    isolated remote function hello1Context(message:ReqMessage|ContextReqMessage req) returns ContextResMessage|grpc:Error {
        map<string|string[]> headers = {};
        message:ReqMessage message;
        if req is ContextReqMessage {
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

    isolated remote function hello2(message:ReqMessage|ContextReqMessage req) returns stream<message:ResMessage, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        message:ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld/hello2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ResMessageStream outputStream = new ResMessageStream(result);
        return new stream<message:ResMessage, grpc:Error?>(outputStream);
    }

    isolated remote function hello2Context(message:ReqMessage|ContextReqMessage req) returns ContextResMessageStream|grpc:Error {
        map<string|string[]> headers = {};
        message:ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld/hello2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ResMessageStream outputStream = new ResMessageStream(result);
        return {content: new stream<message:ResMessage, grpc:Error?>(outputStream), headers: respHeaders};
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

    isolated remote function sendReqMessage(message:ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(ContextReqMessage message) returns grpc:Error? {
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

    isolated remote function receiveContextResMessage() returns ContextResMessage|grpc:Error? {
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

public class ResMessageStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|message:ResMessage value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|message:ResMessage value;|} nextRecord = {value: <message:ResMessage>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
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

    isolated remote function sendReqMessage(message:ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(ContextReqMessage message) returns grpc:Error? {
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

    isolated remote function receiveContextResMessage() returns ContextResMessage|grpc:Error? {
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

    isolated remote function receiveResMessage() returns message:ResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <message:ResMessage>payload;
        }
    }

    isolated remote function receiveContextResMessage() returns ContextResMessage|grpc:Error? {
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

public client class Hello11StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendReqMessage(message:ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(ContextReqMessage message) returns grpc:Error? {
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

public client class HelloWorldResMessageCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendResMessage(message:ResMessage response) returns grpc:Error? {
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

public type ContextReqMessageStream record {|
    stream<message:ReqMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextResMessageStream record {|
    stream<message:ResMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextRootMessage record {|
    RootMessage content;
    map<string|string[]> headers;
|};

public type ContextReqMessage record {|
    message:ReqMessage content;
    map<string|string[]> headers;
|};

public type ContextResMessage record {|
    message:ResMessage content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: PACKAGEWITHMESSAGEIMPORT_DESC}
public type RootMessage record {|
    string msg = "";
    message:SimpleEnum en1 = message:x;
|};

