import ballerina/grpc;

public client class helloWorldClientStreamingClient {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function LotsOfGreetings() returns (LotsOfGreetingsStreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("helloWorldClientStreaming/LotsOfGreetings");
        return new LotsOfGreetingsStreamingClient(sClient);
    }
}


public client class LotsOfGreetingsStreamingClient {
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
            
            return {content: <HelloResponse>payload, headers: headers};
            
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}


public client class HelloWorldClientStreamingHelloResponseCaller {
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
}


public type ContextHelloResponse record {|
    HelloResponse content;
    map<string|string[]> headers;
|};

public type ContextHelloRequestStream record {|
    stream<HelloRequest, error?> content;
    map<string|string[]> headers;
|};
public type ContextHelloRequest record {|
    HelloRequest content;
    map<string|string[]> headers;
|};

public type HelloResponse record {|
    string message = "";
    
|};


public type HelloRequest record {|
    string name = "";
    
|};



const string ROOT_DESCRIPTOR = "0A1F68656C6C6F576F726C64436C69656E7453747265616D696E672E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D657373616765324F0A1968656C6C6F576F726C64436C69656E7453747265616D696E6712320A0F4C6F74734F664772656574696E6773120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E73652801620670726F746F33";
isolated function getDescriptorMap() returns map<string> {
    return {
        "helloWorldClientStreaming.proto":"0A1F68656C6C6F576F726C64436C69656E7453747265616D696E672E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D657373616765324F0A1968656C6C6F576F726C64436C69656E7453747265616D696E6712320A0F4C6F74734F664772656574696E6773120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E73652801620670726F746F33"
        
    };
}

