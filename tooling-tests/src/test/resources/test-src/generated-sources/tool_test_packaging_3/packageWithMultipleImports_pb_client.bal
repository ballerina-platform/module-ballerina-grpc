import ballerina/grpc;
import ballerina/protobuf;
import tool_test_packaging_3.message1;
import tool_test_packaging_3.message2;

const string PACKAGEWITHMULTIPLEIMPORTS_DESC = "0A207061636B616765576974684D756C7469706C65496D706F7274732E70726F746F12097061636B6167696E671A2362616C6C6572696E612F70726F746F6275662F64657363726970746F722E70726F746F1A0E6D657373616765312E70726F746F1A0E6D657373616765322E70726F746F22730A0B526F6F744D65737361676512100A036D736718012001280952036D736712280A03656E3118022001280E32162E7061636B6167696E672E53696D706C65456E756D315203656E3112280A03656E3218032001280E32162E7061636B6167696E672E53696D706C65456E756D325203656E3232BA020A0A68656C6C6F576F726C6412380A0668656C6C6F3112162E7061636B6167696E672E5265714D657373616765311A162E7061636B6167696E672E5265734D65737361676532123A0A0668656C6C6F3212162E7061636B6167696E672E5265714D657373616765311A162E7061636B6167696E672E5265734D657373616765323001123A0A0668656C6C6F3312162E7061636B6167696E672E5265714D657373616765311A162E7061636B6167696E672E5265734D657373616765322801123C0A0668656C6C6F3412162E7061636B6167696E672E5265714D657373616765311A162E7061636B6167696E672E5265734D6573736167653228013001123C0A0668656C6C6F3512162E7061636B6167696E672E526F6F744D6573736167651A162E7061636B6167696E672E526F6F744D657373616765280130014218E24715746F6F6C5F746573745F7061636B6167696E675F33620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, PACKAGEWITHMULTIPLEIMPORTS_DESC);
    }

    isolated remote function hello1(message1:ReqMessage1|ContextReqMessage1 req) returns message2:ResMessage2|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage1 message;
        if req is ContextReqMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld/hello1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <message2:ResMessage2>result;
    }

    isolated remote function hello1Context(message1:ReqMessage1|ContextReqMessage1 req) returns ContextResMessage2|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage1 message;
        if req is ContextReqMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("packaging.helloWorld/hello1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <message2:ResMessage2>result, headers: respHeaders};
    }

    isolated remote function hello3() returns Hello3StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("packaging.helloWorld/hello3");
        return new Hello3StreamingClient(sClient);
    }

    isolated remote function hello2(message1:ReqMessage1|ContextReqMessage1 req) returns stream<message2:ResMessage2, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage1 message;
        if req is ContextReqMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld/hello2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ResMessage2Stream outputStream = new ResMessage2Stream(result);
        return new stream<message2:ResMessage2, grpc:Error?>(outputStream);
    }

    isolated remote function hello2Context(message1:ReqMessage1|ContextReqMessage1 req) returns ContextResMessage2Stream|grpc:Error {
        map<string|string[]> headers = {};
        message1:ReqMessage1 message;
        if req is ContextReqMessage1 {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("packaging.helloWorld/hello2", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ResMessage2Stream outputStream = new ResMessage2Stream(result);
        return {content: new stream<message2:ResMessage2, grpc:Error?>(outputStream), headers: respHeaders};
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

    isolated remote function sendReqMessage1(message1:ReqMessage1 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage1(ContextReqMessage1 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage2() returns message2:ResMessage2|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <message2:ResMessage2>payload;
        }
    }

    isolated remote function receiveContextResMessage2() returns ContextResMessage2|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <message2:ResMessage2>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class ResMessage2Stream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|message2:ResMessage2 value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|message2:ResMessage2 value;|} nextRecord = {value: <message2:ResMessage2>streamValue.value};
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

    isolated remote function sendReqMessage1(message1:ReqMessage1 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextReqMessage1(ContextReqMessage1 message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResMessage2() returns message2:ResMessage2|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <message2:ResMessage2>payload;
        }
    }

    isolated remote function receiveContextResMessage2() returns ContextResMessage2|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <message2:ResMessage2>payload, headers: headers};
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

public type ContextResMessage2Stream record {|
    stream<message2:ResMessage2, error?> content;
    map<string|string[]> headers;
|};

public type ContextRootMessageStream record {|
    stream<RootMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextReqMessage1Stream record {|
    stream<message1:ReqMessage1, error?> content;
    map<string|string[]> headers;
|};

public type ContextResMessage2 record {|
    message2:ResMessage2 content;
    map<string|string[]> headers;
|};

public type ContextRootMessage record {|
    RootMessage content;
    map<string|string[]> headers;
|};

public type ContextReqMessage1 record {|
    message1:ReqMessage1 content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: PACKAGEWITHMULTIPLEIMPORTS_DESC}
public type RootMessage record {|
    string msg = "";
    message1:SimpleEnum1 en1 = message1:x;
    message2:SimpleEnum2 en2 = message2:a;
|};

