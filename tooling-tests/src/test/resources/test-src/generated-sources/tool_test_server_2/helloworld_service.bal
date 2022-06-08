import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: HELLOWORLDINT_DESC}
service "helloWorld" on ep {

    remote function hello(int value) returns stream<int, error?>|error {
    }
}

