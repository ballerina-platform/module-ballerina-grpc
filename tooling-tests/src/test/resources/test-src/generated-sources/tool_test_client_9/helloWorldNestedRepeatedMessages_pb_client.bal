import ballerina/grpc;
import ballerina/protobuf;

public const string HELLOWORLDNESTEDREPEATEDMESSAGES_DESC = "0A2668656C6C6F576F726C644E657374656452657065617465644D657373616765732E70726F746F22AA010A0A5265714D65737361676512180A0772657156616C31180120012809520772657156616C3112180A0772657156616C32180220012805520772657156616C3212180A0772657156616C33180320032809520772657156616C3312240A0772657156616C3418042003280B320A2E526571436F6E666967520772657156616C3412280A0772657156616C3518052001280B320E2E4D657373616765436F6E666967520772657156616C3522770A0D4D657373616765436F6E66696712320A14636F6E66696775726174696F6E456E61626C65641801200128085214636F6E66696775726174696F6E456E61626C656412180A07636F6E666967321802200328095207636F6E6669673212180A07636F6E666967331803200328095207636F6E6669673322D3010A09526571436F6E666967121E0A0A726571436F6E66696731180120012809520A726571436F6E66696731122B0A0A726571436F6E6669673218022003280B320B2E526571436F6E66696732520A726571436F6E66696732122C0A0A726571436F6E6669673318032001280B320C2E456D707479436F6E666967520A726571436F6E66696733122B0A0A726571436F6E6669673418042003280B320B2E526571436F6E66696734520A726571436F6E66696734121E0A0A726571436F6E66696735180520032809520A726571436F6E66696735220D0A0B456D707479436F6E66696722400A0A526571436F6E6669673412180A07636F6E666967311801200128095207636F6E6669673112180A07636F6E666967321802200128095207636F6E66696732225A0A0A526571436F6E6669673212180A07636F6E666967311801200128095207636F6E6669673112180A07636F6E666967321802200128095207636F6E6669673212180A07636F6E666967331803200328095207636F6E6669673322240A0A5265734D65737361676512160A06726573756C741801200128085206726573756C7432B2010A0A68656C6C6F576F726C6412210A0568656C6C6F120B2E5265714D6573736167651A0B2E5265734D65737361676512280A0A68656C6C6F576F726C64120B2E5265714D6573736167651A0B2E5265734D6573736167652801122C0A0E68656C6C6F42616C6C6572696E61120B2E5265714D6573736167651A0B2E5265734D657373616765300112290A0968656C6C6F47727063120B2E5265714D6573736167651A0B2E5265734D65737361676528013001620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, HELLOWORLDNESTEDREPEATEDMESSAGES_DESC);
    }

    isolated remote function hello(ReqMessage|ContextReqMessage req) returns ResMessage|grpc:Error {
        map<string|string[]> headers = {};
        ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/hello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ResMessage>result;
    }

    isolated remote function helloContext(ReqMessage|ContextReqMessage req) returns ContextResMessage|grpc:Error {
        map<string|string[]> headers = {};
        ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ResMessage>result, headers: respHeaders};
    }

    isolated remote function helloWorld() returns HelloWorldStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("helloWorld/helloWorld");
        return new HelloWorldStreamingClient(sClient);
    }

    isolated remote function helloBallerina(ReqMessage|ContextReqMessage req) returns stream<ResMessage, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("helloWorld/helloBallerina", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ResMessageStream outputStream = new ResMessageStream(result);
        return new stream<ResMessage, grpc:Error?>(outputStream);
    }

    isolated remote function helloBallerinaContext(ReqMessage|ContextReqMessage req) returns ContextResMessageStream|grpc:Error {
        map<string|string[]> headers = {};
        ReqMessage message;
        if req is ContextReqMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("helloWorld/helloBallerina", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ResMessageStream outputStream = new ResMessageStream(result);
        return {content: new stream<ResMessage, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function helloGrpc() returns HelloGrpcStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("helloWorld/helloGrpc");
        return new HelloGrpcStreamingClient(sClient);
    }
}

public client class HelloWorldStreamingClient {
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

public client class HelloGrpcStreamingClient {
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

@protobuf:Descriptor {value: HELLOWORLDNESTEDREPEATEDMESSAGES_DESC}
public type ReqConfig4 record {|
    string config1 = "";
    string config2 = "";
|};

@protobuf:Descriptor {value: HELLOWORLDNESTEDREPEATEDMESSAGES_DESC}
public type MessageConfig record {|
    boolean configurationEnabled = false;
    string[] config2 = [];
    string[] config3 = [];
|};

@protobuf:Descriptor {value: HELLOWORLDNESTEDREPEATEDMESSAGES_DESC}
public type ReqConfig record {|
    string reqConfig1 = "";
    ReqConfig2[] reqConfig2 = [];
    EmptyConfig reqConfig3 = {};
    ReqConfig4[] reqConfig4 = [];
    string[] reqConfig5 = [];
|};

@protobuf:Descriptor {value: HELLOWORLDNESTEDREPEATEDMESSAGES_DESC}
public type ReqConfig2 record {|
    string config1 = "";
    string config2 = "";
    string[] config3 = [];
|};

@protobuf:Descriptor {value: HELLOWORLDNESTEDREPEATEDMESSAGES_DESC}
public type ReqMessage record {|
    string reqVal1 = "";
    int reqVal2 = 0;
    string[] reqVal3 = [];
    ReqConfig[] reqVal4 = [];
    MessageConfig reqVal5 = {};
|};

@protobuf:Descriptor {value: HELLOWORLDNESTEDREPEATEDMESSAGES_DESC}
public type EmptyConfig record {|
|};

@protobuf:Descriptor {value: HELLOWORLDNESTEDREPEATEDMESSAGES_DESC}
public type ResMessage record {|
    boolean result = false;
|};

