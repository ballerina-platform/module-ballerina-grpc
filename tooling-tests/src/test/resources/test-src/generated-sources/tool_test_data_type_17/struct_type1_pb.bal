import ballerina/grpc;
import ballerina/protobuf;
import ballerina/protobuf.types.struct;
import ballerina/protobuf.types.wrappers;
import ballerina/grpc.types.struct as sstruct;

const string STRUCT_TYPE1_DESC = "0A127374727563745F74797065312E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F22500A095374727563744D736712120A046E616D6518012001280952046E616D65122F0A0673747275637418022001280B32172E676F6F676C652E70726F746F6275662E537472756374520673747275637432D2020A0D53747275637448616E646C657212450A0A756E61727943616C6C31121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A172E676F6F676C652E70726F746F6275662E537472756374220012260A0A756E61727943616C6C32120A2E5374727563744D73671A0A2E5374727563744D73672200124C0A0F73657276657253747265616D696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A172E676F6F676C652E70726F746F6275662E53747275637422003001124C0A0F636C69656E7453747265616D696E6712172E676F6F676C652E70726F746F6275662E5374727563741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75652200280112360A166269646972656374696F6E616C53747265616D696E67120A2E5374727563744D73671A0A2E5374727563744D7367220028013001620670726F746F33";

public isolated client class StructHandlerClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, STRUCT_TYPE1_DESC);
    }

    isolated remote function unaryCall1(string|wrappers:ContextString req) returns map<anydata>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructHandler/unaryCall1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <map<anydata>>result;
    }

    isolated remote function unaryCall1Context(string|wrappers:ContextString req) returns struct:ContextStruct|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructHandler/unaryCall1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <map<anydata>>result, headers: respHeaders};
    }

    isolated remote function unaryCall2(StructMsg|ContextStructMsg req) returns StructMsg|grpc:Error {
        map<string|string[]> headers = {};
        StructMsg message;
        if req is ContextStructMsg {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructHandler/unaryCall2", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <StructMsg>result;
    }

    isolated remote function unaryCall2Context(StructMsg|ContextStructMsg req) returns ContextStructMsg|grpc:Error {
        map<string|string[]> headers = {};
        StructMsg message;
        if req is ContextStructMsg {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("StructHandler/unaryCall2", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <StructMsg>result, headers: respHeaders};
    }

    isolated remote function clientStreaming() returns ClientStreamingStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("StructHandler/clientStreaming");
        return new ClientStreamingStreamingClient(sClient);
    }

    isolated remote function serverStreaming(string|wrappers:ContextString req) returns stream<map<anydata>, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("StructHandler/serverStreaming", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        sstruct:StructStream outputStream = new sstruct:StructStream(result);
        return new stream<map<anydata>, grpc:Error?>(outputStream);
    }

    isolated remote function serverStreamingContext(string|wrappers:ContextString req) returns struct:ContextStructStream|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("StructHandler/serverStreaming", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        sstruct:StructStream outputStream = new sstruct:StructStream(result);
        return {content: new stream<map<anydata>, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function bidirectionalStreaming() returns BidirectionalStreamingStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("StructHandler/bidirectionalStreaming");
        return new BidirectionalStreamingStreamingClient(sClient);
    }
}

public client class ClientStreamingStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendStruct(map<anydata> message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextStruct(struct:ContextStruct message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveString() returns string|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return payload.toString();
        }
    }

    isolated remote function receiveContextString() returns wrappers:ContextString|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: payload.toString(), headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class BidirectionalStreamingStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendStructMsg(StructMsg message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextStructMsg(ContextStructMsg message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveStructMsg() returns StructMsg|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <StructMsg>payload;
        }
    }

    isolated remote function receiveContextStructMsg() returns ContextStructMsg|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <StructMsg>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class StructHandlerStringCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendString(string response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextString(wrappers:ContextString response) returns grpc:Error? {
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

public client class StructHandlerStructCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendStruct(map<anydata> response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextStruct(struct:ContextStruct response) returns grpc:Error? {
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

public client class StructHandlerStructMsgCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendStructMsg(StructMsg response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextStructMsg(ContextStructMsg response) returns grpc:Error? {
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

public type ContextStructMsgStream record {|
    stream<StructMsg, error?> content;
    map<string|string[]> headers;
|};

public type ContextStructMsg record {|
    StructMsg content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: STRUCT_TYPE1_DESC}
public type StructMsg record {|
    string name = "";
    map<anydata> struct = {};
|};

