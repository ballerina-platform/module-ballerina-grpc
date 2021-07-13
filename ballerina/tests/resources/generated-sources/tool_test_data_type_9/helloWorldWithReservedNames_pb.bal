import ballerina/grpc;

public isolated client class helloWorldWithReservedNamesClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function hello(HelloRequest|ContextHelloRequest req) returns (HelloResponse|grpc:Error) {
        map<string|string[]> headers = {};
        HelloRequest message;
        if (req is ContextHelloRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithReservedNames/hello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <HelloResponse>result;
    }

    isolated remote function helloContext(HelloRequest|ContextHelloRequest req) returns (ContextHelloResponse|grpc:Error) {
        map<string|string[]> headers = {};
        HelloRequest message;
        if (req is ContextHelloRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithReservedNames/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {
            content: <HelloResponse>result,
            headers: respHeaders
        };
    }

    isolated remote function bye(ByeRequest|ContextByeRequest req) returns (ByeResponse|grpc:Error) {
        map<string|string[]> headers = {};
        ByeRequest message;
        if (req is ContextByeRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithReservedNames/bye", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ByeResponse>result;
    }

    isolated remote function byeContext(ByeRequest|ContextByeRequest req) returns (ContextByeResponse|grpc:Error) {
        map<string|string[]> headers = {};
        ByeRequest message;
        if (req is ContextByeRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorldWithReservedNames/bye", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {
            content: <ByeResponse>result,
            headers: respHeaders
        };
    }
}

public client class HelloWorldWithReservedNamesHelloResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendHelloResponse(HelloResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextHelloResponse(ContextHelloResponse response) returns grpc:Error? {
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

public client class HelloWorldWithReservedNamesByeResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendByeResponse(ByeResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextByeResponse(ContextByeResponse response) returns grpc:Error? {
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

public type ContextByeResponse record {|
    ByeResponse content;
    map<string|string[]> headers;
|};

public type ContextByeRequest record {|
    ByeRequest content;
    map<string|string[]> headers;
|};

public type ContextHelloResponse record {|
    HelloResponse content;
    map<string|string[]> headers;
|};

public type ContextHelloRequest record {|
    HelloRequest content;
    map<string|string[]> headers;
|};

public type ByeResponse record {|
    string say = "";
|};

public type ByeRequest record {|
    string greet = "";
|};

public type HelloResponse record {|
    string message = "";
|};

public type HelloRequest record {|
    string name = "";
    string 'channel = "";
    boolean 'check = false;
    string 'json = "";
    string 'xml = "";
    string 'stream = "";
    string 'table = "";
    string 'break = "";
    string 'untaint = "";
    string 'future = "";
|};

const string ROOT_DESCRIPTOR = "0A2168656C6C6F576F726C645769746852657365727665644E616D65732E70726F746F22EE010A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6512180A076368616E6E656C18022001280952076368616E6E656C12140A05636865636B1803200128085205636865636B12120A046A736F6E18042001280952046A736F6E12100A03786D6C1805200128095203786D6C12160A0673747265616D180620012809520673747265616D12140A057461626C6518072001280952057461626C6512140A05627265616B1808200128095205627265616B12180A07756E7461696E741809200128095207756E7461696E7412160A06667574757265180A20012809520666757475726522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D65737361676522220A0A4279655265717565737412140A05677265657418012001280952056772656574221F0A0B427965526573706F6E736512100A03736179180120012809520373617932670A1B68656C6C6F576F726C645769746852657365727665644E616D657312260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E736512200A03627965120B2E427965526571756573741A0C2E427965526573706F6E7365620670726F746F33";

isolated function getDescriptorMap() returns map<string> {
    return {"helloWorldWithReservedNames.proto": "0A2168656C6C6F576F726C645769746852657365727665644E616D65732E70726F746F22EE010A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6512180A076368616E6E656C18022001280952076368616E6E656C12140A05636865636B1803200128085205636865636B12120A046A736F6E18042001280952046A736F6E12100A03786D6C1805200128095203786D6C12160A0673747265616D180620012809520673747265616D12140A057461626C6518072001280952057461626C6512140A05627265616B1808200128095205627265616B12180A07756E7461696E741809200128095207756E7461696E7412160A06667574757265180A20012809520666757475726522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D65737361676522220A0A4279655265717565737412140A05677265657418012001280952056772656574221F0A0B427965526573706F6E736512100A03736179180120012809520373617932670A1B68656C6C6F576F726C645769746852657365727665644E616D657312260A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E736512200A03627965120B2E427965526571756573741A0C2E427965526573706F6E7365620670726F746F33"};
}

