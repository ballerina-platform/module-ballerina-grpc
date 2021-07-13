import ballerina/grpc;

public isolated client class ParentTestClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function callParent1(ParentMessage|ContextParentMessage req) returns (ParentMessage|grpc:Error) {
        map<string|string[]> headers = {};
        ParentMessage message;
        if (req is ContextParentMessage) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ParentTest/callParent1", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ParentMessage>result;
    }

    isolated remote function callParent1Context(ParentMessage|ContextParentMessage req) returns (ContextParentMessage|grpc:Error) {
        map<string|string[]> headers = {};
        ParentMessage message;
        if (req is ContextParentMessage) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ParentTest/callParent1", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ParentMessage>result, headers: respHeaders};
    }

    isolated remote function callParent2() returns (CallParent2StreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("ParentTest/callParent2");
        return new CallParent2StreamingClient(sClient);
    }

    isolated remote function callParent3(ParentMessage|ContextParentMessage req) returns stream<ParentMessage, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ParentMessage message;
        if (req is ContextParentMessage) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("ParentTest/callParent3", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ParentMessageStream outputStream = new ParentMessageStream(result);
        return new stream<ParentMessage, grpc:Error?>(outputStream);
    }

    isolated remote function callParent3Context(ParentMessage|ContextParentMessage req) returns ContextParentMessageStream|grpc:Error {
        map<string|string[]> headers = {};
        ParentMessage message;
        if (req is ContextParentMessage) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("ParentTest/callParent3", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ParentMessageStream outputStream = new ParentMessageStream(result);
        return {content: new stream<ParentMessage, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function callParent4() returns (CallParent4StreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("ParentTest/callParent4");
        return new CallParent4StreamingClient(sClient);
    }
}

public client class CallParent2StreamingClient {
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
            [anydata, map<string|string[]>] [payload, headers] = response;
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

public class ParentMessageStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|ParentMessage value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|ParentMessage value;|} nextRecord = {value: <ParentMessage>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class CallParent4StreamingClient {
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
            [anydata, map<string|string[]>] [payload, headers] = response;
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

public client class ParentTestParentMessageCaller {
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

public type ContextParentMessageStream record {|
    stream<ParentMessage, error?> content;
    map<string|string[]> headers;
|};

public type ContextParentMessage record {|
    ParentMessage content;
    map<string|string[]> headers;
|};

public type ParentMessage record {|
    string msg = "";
|};
