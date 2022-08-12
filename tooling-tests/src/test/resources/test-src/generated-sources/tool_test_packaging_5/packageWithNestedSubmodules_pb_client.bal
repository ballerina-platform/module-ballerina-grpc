import ballerina/grpc;
import ballerina/protobuf;
import tool_test_packaging_5.messages.message1;
import tool_test_packaging_5.messages.message2;

const string PACKAGEWITHNESTEDSUBMODULES_DESC = "0A217061636B616765576974684E65737465645375626D6F64756C65732E70726F746F12097061636B6167696E671A2362616C6C6572696E612F70726F746F6275662F64657363726970746F722E70726F746F1A0E6D657373616765312E70726F746F1A0E6D657373616765322E70726F746F22770A0B526F6F744D65737361676512100A036D736718012001280952036D7367122A0A04656E753118022001280E32162E7061636B6167696E672E53696D706C65456E756D315204656E7531122A0A04656E753218032001280E32162E7061636B6167696E672E53696D706C65456E756D325204656E753232B2020A0A68656C6C6F576F726C6412360A0668656C6C6F3112152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D65737361676512380A0668656C6C6F3212152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D657373616765300112380A0668656C6C6F3312152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D6573736167652801123A0A0668656C6C6F3412152E7061636B6167696E672E5265714D6573736167651A152E7061636B6167696E672E5265734D65737361676528013001123C0A0668656C6C6F3512162E7061636B6167696E672E526F6F744D6573736167651A162E7061636B6167696E672E526F6F744D657373616765280130014218E24715746F6F6C5F746573745F7061636B6167696E675F35620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, PACKAGEWITHNESTEDSUBMODULES_DESC);
    }

    isolated remote function hello1(message1:ReqMessage|ContextReqMessage req) returns message2:ResMessage|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld/hello1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <message2:ResMessage>result;
    }

    isolated remote function hello1Context(message1:ReqMessage|ContextReqMessage req) returns ContextResMessage|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld/hello1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <message2:ResMessage>result, headers: respHeaders};
    }

    isolated remote function hello3() returns Hello3StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("packaging.helloWorld/hello3");
        return new Hello3StreamingClient(sClient);
    }

    isolated remote function hello2(message1:ReqMessage|ContextReqMessage req) returns stream<message2:ResMessage, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld/hello2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ResMessageStream outputStream = new ResMessageStream(result);
        return new stream<message2:ResMessage, grpc:Error?>(outputStream);
    }

    isolated remote function hello2Context(message1:ReqMessage|ContextReqMessage req) returns ContextResMessageStream|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld/hello2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ResMessageStream outputStream = new ResMessageStream(result);
        return {content: new stream<message2:ResMessage, grpc:Error?>(outputStream), headers: respHeaders};
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

    isolated remote function sendReqMessage(message1:ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(ContextReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage() returns message2:ResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <message2:ResMessage>payload;
        }
    }

    isolated remote function receiveContextResMessage() returns ContextResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <message2:ResMessage>payload, headers: headers};
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

    public isolated function next() returns record {|message2:ResMessage value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|message2:ResMessage value;|} nextRecord = {value: <message2:ResMessage>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class Hello4StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendReqMessage(message1:ReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage(ContextReqMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage() returns message2:ResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <message2:ResMessage>payload;
        }
    }

    isolated remote function receiveContextResMessage() returns ContextResMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <message2:ResMessage>payload, headers: headers};
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

public type ContextReqMessageStream record {|
    stream<message1:ReqMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextResMessageStream record {|
    stream<message2:ResMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextRootMessage record {|
    RootMessage content;
    map<string|string[]> headers;
|};

public type ContextReqMessage record {|
    message1:ReqMessage content;
    map<string|string[]> headers;
|};

public type ContextResMessage record {|
    message2:ResMessage content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: PACKAGEWITHNESTEDSUBMODULES_DESC}
public type RootMessage record {|
    string msg = "";
    message1:SimpleEnum1 enu1 = message1:a;
    message2:SimpleEnum2 enu2 = message2:x;
|};

