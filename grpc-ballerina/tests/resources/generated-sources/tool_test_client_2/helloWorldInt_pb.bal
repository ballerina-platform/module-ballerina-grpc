import ballerina/grpc;

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function hello() returns (HelloStreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("helloWorld/hello");
        return new HelloStreamingClient(sClient);
    }
}

public client class HelloStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendInt(int message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextInt(ContextInt message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveInt() returns int|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <int>payload;
        }
    }

    isolated remote function receiveContextInt() returns ContextInt|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {
                content: <int>payload,
                headers: headers
            };
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class HelloWorldIntCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendInt(int response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextInt(ContextInt response) returns grpc:Error? {
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

public type ContextIntStream record {|
    stream<int, error?> content;
    map<string|string[]> headers;
|};

public type ContextInt record {|
    int content;
    map<string|string[]> headers;
|};

const string ROOT_DESCRIPTOR = "0A1368656C6C6F576F726C64496E742E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32510A0A68656C6C6F576F726C6412430A0568656C6C6F121B2E676F6F676C652E70726F746F6275662E496E74333256616C75651A1B2E676F6F676C652E70726F746F6275662E496E74333256616C75652801620670726F746F33";

isolated function getDescriptorMap() returns map<string> {
    return {
        "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33",
        "helloWorldInt.proto": "0A1368656C6C6F576F726C64496E742E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32510A0A68656C6C6F576F726C6412430A0568656C6C6F121B2E676F6F676C652E70726F746F6275662E496E74333256616C75651A1B2E676F6F676C652E70726F746F6275662E496E74333256616C75652801620670726F746F33"
    };
}

