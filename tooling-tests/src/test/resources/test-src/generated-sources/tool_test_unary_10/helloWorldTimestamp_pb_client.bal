import ballerina/grpc;
import ballerina/protobuf;
import ballerina/time;
import ballerina/protobuf.types.timestamp;
import ballerina/protobuf.types.wrappers;

public const string HELLOWORLDTIMESTAMP_DESC = "0A1968656C6C6F576F726C6454696D657374616D702E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F224E0A084772656574696E6712120A046E616D6518012001280952046E616D65122E0A0474696D6518022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520474696D6532FA020A0A68656C6C6F576F726C6412430A0767657454696D65121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1A2E676F6F676C652E70726F746F6275662E54696D657374616D7012440A0873656E6454696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512460A0C65786368616E676554696D65121A2E676F6F676C652E70726F746F6275662E54696D657374616D701A1A2E676F6F676C652E70726F746F6275662E54696D657374616D7012360A0B6765744772656574696E67121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A092E4772656574696E6712370A0C73656E644772656574696E6712092E4772656574696E671A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512280A1065786368616E67654772656574696E6712092E4772656574696E671A092E4772656574696E67620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, HELLOWORLDTIMESTAMP_DESC);
    }

    isolated remote function getTime(string|wrappers:ContextString req) returns time:Utc|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/getTime", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <time:Utc>result.cloneReadOnly();
    }

    isolated remote function getTimeContext(string|wrappers:ContextString req) returns timestamp:ContextTimestamp|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/getTime", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <time:Utc>result.cloneReadOnly(), headers: respHeaders};
    }

    isolated remote function sendTime(time:Utc|timestamp:ContextTimestamp req) returns string|grpc:Error {
        map<string|string[]> headers = {};
        time:Utc message;
        if req is timestamp:ContextTimestamp {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/sendTime", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function sendTimeContext(time:Utc|timestamp:ContextTimestamp req) returns wrappers:ContextString|grpc:Error {
        map<string|string[]> headers = {};
        time:Utc message;
        if req is timestamp:ContextTimestamp {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/sendTime", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function exchangeTime(time:Utc|timestamp:ContextTimestamp req) returns time:Utc|grpc:Error {
        map<string|string[]> headers = {};
        time:Utc message;
        if req is timestamp:ContextTimestamp {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/exchangeTime", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <time:Utc>result.cloneReadOnly();
    }

    isolated remote function exchangeTimeContext(time:Utc|timestamp:ContextTimestamp req) returns timestamp:ContextTimestamp|grpc:Error {
        map<string|string[]> headers = {};
        time:Utc message;
        if req is timestamp:ContextTimestamp {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/exchangeTime", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <time:Utc>result.cloneReadOnly(), headers: respHeaders};
    }

    isolated remote function getGreeting(string|wrappers:ContextString req) returns Greeting|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/getGreeting", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Greeting>result;
    }

    isolated remote function getGreetingContext(string|wrappers:ContextString req) returns ContextGreeting|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/getGreeting", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Greeting>result, headers: respHeaders};
    }

    isolated remote function sendGreeting(Greeting|ContextGreeting req) returns string|grpc:Error {
        map<string|string[]> headers = {};
        Greeting message;
        if req is ContextGreeting {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/sendGreeting", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function sendGreetingContext(Greeting|ContextGreeting req) returns wrappers:ContextString|grpc:Error {
        map<string|string[]> headers = {};
        Greeting message;
        if req is ContextGreeting {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/sendGreeting", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function exchangeGreeting(Greeting|ContextGreeting req) returns Greeting|grpc:Error {
        map<string|string[]> headers = {};
        Greeting message;
        if req is ContextGreeting {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/exchangeGreeting", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Greeting>result;
    }

    isolated remote function exchangeGreetingContext(Greeting|ContextGreeting req) returns ContextGreeting|grpc:Error {
        map<string|string[]> headers = {};
        Greeting message;
        if req is ContextGreeting {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/exchangeGreeting", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Greeting>result, headers: respHeaders};
    }
}

public type ContextGreeting record {|
    Greeting content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: HELLOWORLDTIMESTAMP_DESC}
public type Greeting record {|
    string name = "";
    time:Utc time = [0, 0.0d];
|};

