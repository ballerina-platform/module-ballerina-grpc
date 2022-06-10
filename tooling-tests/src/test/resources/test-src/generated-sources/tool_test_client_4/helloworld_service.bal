import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: HELLOWORLDBOOLEAN_DESC}
service "helloWorld" on ep {

    remote function hello(stream<boolean, grpc:Error?> clientStream) returns boolean|error {
    }
}

