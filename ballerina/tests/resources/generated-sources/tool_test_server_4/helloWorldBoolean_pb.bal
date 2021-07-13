import ballerina/grpc;

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function hello(boolean|ContextBoolean req) returns stream<boolean, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        boolean message;
        if (req is ContextBoolean) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("helloWorld/hello", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        BooleanStream outputStream = new BooleanStream(result);
        return new stream<boolean, grpc:Error?>(outputStream);
    }

    isolated remote function helloContext(boolean|ContextBoolean req) returns ContextBooleanStream|grpc:Error {
        map<string|string[]> headers = {};
        boolean message;
        if (req is ContextBoolean) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("helloWorld/hello", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        BooleanStream outputStream = new BooleanStream(result);
        return {
            content: new stream<boolean, grpc:Error?>(outputStream),
            headers: respHeaders
        };
    }
}

public class BooleanStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {| boolean value; |}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {| boolean value; |} nextRecord = {value: <boolean>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
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

    isolated remote function sendContextBoolean(ContextBoolean response) returns grpc:Error? {
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

public type ContextBooleanStream record {|
    stream<boolean, error?> content;
    map<string|string[]> headers;
|};

public type ContextBoolean record {|
    boolean content;
    map<string|string[]> headers;
|};

const string ROOT_DESCRIPTOR = "0A1768656C6C6F576F726C64426F6F6C65616E2E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F324F0A0A68656C6C6F576F726C6412410A0568656C6C6F121A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75651A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75653001620670726F746F33";

isolated function getDescriptorMap() returns map<string> {
    return {
        "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33",
        "helloWorldBoolean.proto": "0A1768656C6C6F576F726C64426F6F6C65616E2E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F324F0A0A68656C6C6F576F726C6412410A0568656C6C6F121A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75651A1A2E676F6F676C652E70726F746F6275662E426F6F6C56616C75653001620670726F746F33"
    };
}

