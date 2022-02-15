import ballerina/grpc;
import ballerina/protobuf.types.wrappers;

public isolated client class ServiceWithEmptyClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_EMPTY_MESSAGE_TYPES, getDescriptorMapEmptyMessageTypes());
    }

    isolated remote function UnaryCallEmpty(string|wrappers:ContextString req) returns Empty|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ServiceWithEmpty/UnaryCallEmpty", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Empty>result;
    }

    isolated remote function UnaryCallEmptyContext(string|wrappers:ContextString req) returns ContextEmpty|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ServiceWithEmpty/UnaryCallEmpty", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Empty>result, headers: respHeaders};
    }

    isolated remote function UnaryCallAny(string|wrappers:ContextString req) returns Any|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ServiceWithEmpty/UnaryCallAny", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Any>result;
    }

    isolated remote function UnaryCallAnyContext(string|wrappers:ContextString req) returns ContextAny|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ServiceWithEmpty/UnaryCallAny", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Any>result, headers: respHeaders};
    }

    isolated remote function UnaryCallDuration(string|wrappers:ContextString req) returns Empty|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ServiceWithEmpty/UnaryCallDuration", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Empty>result;
    }

    isolated remote function UnaryCallDurationContext(string|wrappers:ContextString req) returns ContextEmpty|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ServiceWithEmpty/UnaryCallDuration", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Empty>result, headers: respHeaders};
    }
}

public client class ServiceWithEmptyEmptyCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendEmpty(Empty response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextEmpty(ContextEmpty response) returns grpc:Error? {
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

public client class ServiceWithEmptyAnyCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAny(Any response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAny(ContextAny response) returns grpc:Error? {
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

public type ContextEmpty record {|
    Empty content;
    map<string|string[]> headers;
|};

public type ContextAny record {|
    Any content;
    map<string|string[]> headers;
|};

public type Empty record {|
|};

public type Duration record {|
|};

public type Any record {|
|};

const string ROOT_DESCRIPTOR_EMPTY_MESSAGE_TYPES = "0A19656D7074795F6D6573736167655F74797065732E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22070A05456D70747922050A03416E79220A0A084475726174696F6E32BF010A105365727669636557697468456D70747912380A0E556E61727943616C6C456D707479121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A062E456D707479220012340A0C556E61727943616C6C416E79121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A042E416E792200123B0A11556E61727943616C6C4475726174696F6E121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A062E456D7074792200620670726F746F33";

public isolated function getDescriptorMapEmptyMessageTypes() returns map<string> {
    return {"empty_message_types.proto": "0A19656D7074795F6D6573736167655F74797065732E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22070A05456D70747922050A03416E79220A0A084475726174696F6E32BF010A105365727669636557697468456D70747912380A0E556E61727943616C6C456D707479121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A062E456D707479220012340A0C556E61727943616C6C416E79121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A042E416E792200123B0A11556E61727943616C6C4475726174696F6E121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A062E456D7074792200620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

