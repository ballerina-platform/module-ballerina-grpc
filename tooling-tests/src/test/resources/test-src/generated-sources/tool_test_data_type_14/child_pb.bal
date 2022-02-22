import ballerina/grpc;
import ballerina/protobuf.types.wrappers;

public isolated client class ChildTestClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_CHILD, getDescriptorMapChild());
    }

    isolated remote function callChild1(ParentMessage|ContextParentMessage req) returns ChildMessage|grpc:Error {
        map<string|string[]> headers = {};
        ParentMessage message;
        if req is ContextParentMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ChildTest/callChild1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ChildMessage>result;
    }

    isolated remote function callChild1Context(ParentMessage|ContextParentMessage req) returns ContextChildMessage|grpc:Error {
        map<string|string[]> headers = {};
        ParentMessage message;
        if req is ContextParentMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ChildTest/callChild1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ChildMessage>result, headers: respHeaders};
    }

    isolated remote function callChild5(string|wrappers:ContextString req) returns ParentMessage|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ChildTest/callChild5", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ParentMessage>result;
    }

    isolated remote function callChild5Context(string|wrappers:ContextString req) returns ContextParentMessage|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ChildTest/callChild5", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ParentMessage>result, headers: respHeaders};
    }

    isolated remote function callChild2() returns CallChild2StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("ChildTest/callChild2");
        return new CallChild2StreamingClient(sClient);
    }

    isolated remote function callChild3(ParentMessage|ContextParentMessage req) returns stream<ParentMessage, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ParentMessage message;
        if req is ContextParentMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("ChildTest/callChild3", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ParentMessageStream outputStream = new ParentMessageStream(result);
        return new stream<ParentMessage, grpc:Error?>(outputStream);
    }

    isolated remote function callChild3Context(ParentMessage|ContextParentMessage req) returns ContextParentMessageStream|grpc:Error {
        map<string|string[]> headers = {};
        ParentMessage message;
        if req is ContextParentMessage {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("ChildTest/callChild3", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ParentMessageStream outputStream = new ParentMessageStream(result);
        return {content: new stream<ParentMessage, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function callChild4() returns CallChild4StreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("ChildTest/callChild4");
        return new CallChild4StreamingClient(sClient);
    }
}

public client class CallChild2StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendParentMessage(ParentMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextParentMessage(ContextParentMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveChildMessage() returns ChildMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <ChildMessage>payload;
        }
    }

    isolated remote function receiveContextChildMessage() returns ContextChildMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <ChildMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class CallChild4StreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendParentMessage(ParentMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextParentMessage(ContextParentMessage message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveParentMessage() returns ParentMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <ParentMessage>payload;
        }
    }

    isolated remote function receiveContextParentMessage() returns ContextParentMessage|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <ParentMessage>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class ChildTestChildMessageCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendChildMessage(ChildMessage response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextChildMessage(ContextChildMessage response) returns grpc:Error? {
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

public client class ChildTestParentMessageCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendParentMessage(ParentMessage response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextParentMessage(ContextParentMessage response) returns grpc:Error? {
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

public type ContextChildMessage record {|
    ChildMessage content;
    map<string|string[]> headers;
|};

public type ChildMessage record {|
    int msg = 0;
|};

const string ROOT_DESCRIPTOR_CHILD = "0A13666F6F2F6261722F6368696C642E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A0C706172656E742E70726F746F22200A0C4368696C644D65737361676512100A036D736718012001280552036D73673285020A094368696C6454657374122B0A0A63616C6C4368696C6431120E2E506172656E744D6573736167651A0D2E4368696C644D657373616765122D0A0A63616C6C4368696C6432120E2E506172656E744D6573736167651A0D2E4368696C644D6573736167652801122E0A0A63616C6C4368696C6433120E2E506172656E744D6573736167651A0E2E506172656E744D657373616765300112300A0A63616C6C4368696C6434120E2E506172656E744D6573736167651A0E2E506172656E744D65737361676528013001123A0A0A63616C6C4368696C6435121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E506172656E744D657373616765620670726F746F33";

public isolated function getDescriptorMapChild() returns map<string> {
    return {"foo/bar/child.proto": "0A13666F6F2F6261722F6368696C642E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A0C706172656E742E70726F746F22200A0C4368696C644D65737361676512100A036D736718012001280552036D73673285020A094368696C6454657374122B0A0A63616C6C4368696C6431120E2E506172656E744D6573736167651A0D2E4368696C644D657373616765122D0A0A63616C6C4368696C6432120E2E506172656E744D6573736167651A0D2E4368696C644D6573736167652801122E0A0A63616C6C4368696C6433120E2E506172656E744D6573736167651A0E2E506172656E744D657373616765300112300A0A63616C6C4368696C6434120E2E506172656E744D6573736167651A0E2E506172656E744D65737361676528013001123A0A0A63616C6C4368696C6435121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A0E2E506172656E744D657373616765620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33", "parent.proto": "0A0C706172656E742E70726F746F22210A0D506172656E744D65737361676512100A036D736718012001280952036D736732D0010A0A506172656E7454657374122D0A0B63616C6C506172656E7431120E2E506172656E744D6573736167651A0E2E506172656E744D657373616765122F0A0B63616C6C506172656E7432120E2E506172656E744D6573736167651A0E2E506172656E744D6573736167652801122F0A0B63616C6C506172656E7433120E2E506172656E744D6573736167651A0E2E506172656E744D657373616765300112310A0B63616C6C506172656E7434120E2E506172656E744D6573736167651A0E2E506172656E744D65737361676528013001620670726F746F33"};
}

