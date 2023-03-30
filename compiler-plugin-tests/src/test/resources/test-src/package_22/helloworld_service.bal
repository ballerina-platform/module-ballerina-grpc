import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: HELLOWORLDSTRING_DESC}
service "helloWorld" on ep {

    remote function hello(HelloWorldStringCaller caller, stream<string, grpc:Error?> clientStream, string x) returns error? {
        return ();
    }
}

