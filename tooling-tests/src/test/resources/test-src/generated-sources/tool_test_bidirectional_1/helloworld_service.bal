import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: HELLOWORLDSTRING_DESC}
service "helloWorld" on ep {

    remote function hello(stream<string, grpc:Error?> clientStream) returns stream<string, error?>|error {
    }
}

