import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: HELLOWORLDINT_DESC}
service "helloWorld" on ep {

    remote function hello(int value) returns int|error {
    }
}

