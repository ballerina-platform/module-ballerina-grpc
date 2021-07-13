import ballerina/grpc;

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function hello() returns (HelloStreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("helloWorld/hello");
        return new HelloStreamingClient(sClient);
    }

    isolated remote function bye() returns (ByeStreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("helloWorld/bye");
        return new ByeStreamingClient(sClient);
    }
}

public client class HelloStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendHelloRequest(HelloRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextHelloRequest(ContextHelloRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveHelloResponse() returns HelloResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <HelloResponse>payload;
        }
    }

    isolated remote function receiveContextHelloResponse() returns ContextHelloResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {
                content: <HelloResponse>payload,
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

public client class ByeStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendByeRequest(ByeRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextByeRequest(ContextByeRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveByeResponse() returns ByeResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <ByeResponse>payload;
        }
    }

    isolated remote function receiveContextByeResponse() returns ContextByeResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {
                content: <ByeResponse>payload,
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

public client class HelloWorldByeResponseCaller {
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

public client class HelloWorldHelloResponseCaller {
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

public type ContextByeResponseStream record {|
    stream<ByeResponse, error?> content;
    map<string|string[]> headers;
|};

public type ContextByeRequestStream record {|
    stream<ByeRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextHelloResponseStream record {|
    stream<HelloResponse, error?> content;
    map<string|string[]> headers;
|};

public type ContextHelloRequestStream record {|
    stream<HelloRequest, error?> content;
    map<string|string[]> headers;
|};

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
|};

const string ROOT_DESCRIPTOR = "0A1768656C6C6F576F726C644D6573736167652E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D65737361676522220A0A4279655265717565737412140A05677265657418012001280952056772656574221F0A0B427965526573706F6E736512100A037361791801200128095203736179325E0A0A68656C6C6F576F726C64122A0A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E73652801300112240A03627965120B2E427965526571756573741A0C2E427965526573706F6E736528013001620670726F746F33";

isolated function getDescriptorMap() returns map<string> {
    return {"helloWorldMessage.proto": "0A1768656C6C6F576F726C644D6573736167652E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D65737361676522220A0A4279655265717565737412140A05677265657418012001280952056772656574221F0A0B427965526573706F6E736512100A037361791801200128095203736179325E0A0A68656C6C6F576F726C64122A0A0568656C6C6F120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E73652801300112240A03627965120B2E427965526571756573741A0C2E427965526573706F6E736528013001620670726F746F33"};
}

