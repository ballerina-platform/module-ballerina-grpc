import ballerina/grpc;

public client class helloWorldServerStreamingClient {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function lotsOfReplies(HelloRequest req) returns stream<HelloResponse, grpc:Error?>|grpc:Error {
        
        var payload = check self.grpcClient->executeServerStreaming("helloWorldServerStreaming/lotsOfReplies", req);
        [stream<anydata, grpc:Error?>, map<string|string[]>][result, _] = payload;
        HelloResponseStream outputStream = new HelloResponseStream(result);
        return new stream<HelloResponse, grpc:Error?>(outputStream);
    }

    isolated remote function lotsOfRepliesContext(HelloRequest req) returns ContextHelloResponseStream|grpc:Error {
    
        var payload = check self.grpcClient->executeServerStreaming("helloWorldServerStreaming/lotsOfReplies", req);
        [stream<anydata, grpc:Error?>, map<string|string[]>][result, headers] = payload;
        HelloResponseStream outputStream = new HelloResponseStream(result);
        return {content: new stream<HelloResponse, grpc:Error?>(outputStream), headers: headers};
    }

}



public class HelloResponseStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {| HelloResponse value; |}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {| HelloResponse value; |} nextRecord = {value: <HelloResponse>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class HelloWorldServerStreamingHelloResponseCaller {
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


public type ContextHelloResponseStream record {|
    stream<HelloResponse, error?> content;
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
public type HelloResponse record {|
    string message = "";
    
|};


public type HelloRequest record {|
    string name = "";
    
|};



const string ROOT_DESCRIPTOR = "0A1F68656C6C6F576F726C6453657276657253747265616D696E672E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D657373616765324D0A1968656C6C6F576F726C6453657276657253747265616D696E6712300A0D6C6F74734F665265706C696573120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E73653001620670726F746F33";
isolated function getDescriptorMap() returns map<string> {
    return {
        "helloWorldServerStreaming.proto":"0A1F68656C6C6F576F726C6453657276657253747265616D696E672E70726F746F22220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522290A0D48656C6C6F526573706F6E736512180A076D65737361676518012001280952076D657373616765324D0A1968656C6C6F576F726C6453657276657253747265616D696E6712300A0D6C6F74734F665265706C696573120D2E48656C6C6F526571756573741A0E2E48656C6C6F526573706F6E73653001620670726F746F33"
        
    };
}

