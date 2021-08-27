import ballerina/grpc;
import ballerina/protobuf.types.struct;
import ballerina/protobuf.types.wrappers;

public isolated client class StructHandlerClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_STRUCT_TYPE1, getDescriptorMapStructType1());
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
        struct:StructStream outputStream = new struct:StructStream(result);
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
        struct:StructStream outputStream = new struct:StructStream(result);
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
            [anydata, map<string|string[]>] [payload, headers] = response;
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
            [anydata, map<string|string[]>] [payload, headers] = response;
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

public type StructMsg record {|
    string name = "";
    map<anydata> struct = {};
|};

const string ROOT_DESCRIPTOR_STRUCT_TYPE1 = "0A127374727563745F74797065312E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F22500A095374727563744D736712120A046E616D6518012001280952046E616D65122F0A0673747275637418022001280B32172E676F6F676C652E70726F746F6275662E537472756374520673747275637432D2020A0D53747275637448616E646C657212450A0A756E61727943616C6C31121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A172E676F6F676C652E70726F746F6275662E537472756374220012260A0A756E61727943616C6C32120A2E5374727563744D73671A0A2E5374727563744D73672200124C0A0F73657276657253747265616D696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A172E676F6F676C652E70726F746F6275662E53747275637422003001124C0A0F636C69656E7453747265616D696E6712172E676F6F676C652E70726F746F6275662E5374727563741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75652200280112360A166269646972656374696F6E616C53747265616D696E67120A2E5374727563744D73671A0A2E5374727563744D7367220028013001620670726F746F33";

public isolated function getDescriptorMapStructType1() returns map<string> {
    return {"google/protobuf/struct.proto": "0A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F120F676F6F676C652E70726F746F6275662298010A06537472756374123B0A066669656C647318012003280B32232E676F6F676C652E70726F746F6275662E5374727563742E4669656C6473456E74727952066669656C64731A510A0B4669656C6473456E74727912100A036B657918012001280952036B6579122C0A0576616C756518022001280B32162E676F6F676C652E70726F746F6275662E56616C7565520576616C75653A02380122B2020A0556616C7565123B0A0A6E756C6C5F76616C756518012001280E321A2E676F6F676C652E70726F746F6275662E4E756C6C56616C7565480052096E756C6C56616C756512230A0C6E756D6265725F76616C75651802200128014800520B6E756D62657256616C756512230A0C737472696E675F76616C75651803200128094800520B737472696E6756616C7565121F0A0A626F6F6C5F76616C756518042001280848005209626F6F6C56616C7565123C0A0C7374727563745F76616C756518052001280B32172E676F6F676C652E70726F746F6275662E5374727563744800520B73747275637456616C7565123B0A0A6C6973745F76616C756518062001280B321A2E676F6F676C652E70726F746F6275662E4C69737456616C7565480052096C69737456616C756542060A046B696E64223B0A094C69737456616C7565122E0A0676616C75657318012003280B32162E676F6F676C652E70726F746F6275662E56616C7565520676616C7565732A1B0A094E756C6C56616C7565120E0A0A4E554C4C5F56414C5545100042550A13636F6D2E676F6F676C652E70726F746F627566420B53747275637450726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "struct_type1.proto": "0A127374727563745F74797065312E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1C676F6F676C652F70726F746F6275662F7374727563742E70726F746F22500A095374727563744D736712120A046E616D6518012001280952046E616D65122F0A0673747275637418022001280B32172E676F6F676C652E70726F746F6275662E537472756374520673747275637432D2020A0D53747275637448616E646C657212450A0A756E61727943616C6C31121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A172E676F6F676C652E70726F746F6275662E537472756374220012260A0A756E61727943616C6C32120A2E5374727563744D73671A0A2E5374727563744D73672200124C0A0F73657276657253747265616D696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A172E676F6F676C652E70726F746F6275662E53747275637422003001124C0A0F636C69656E7453747265616D696E6712172E676F6F676C652E70726F746F6275662E5374727563741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75652200280112360A166269646972656374696F6E616C53747265616D696E67120A2E5374727563744D73671A0A2E5374727563744D7367220028013001620670726F746F33"};
}

