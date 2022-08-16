import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: SERVICE_WITH_NESTED_MESSAGES_DESC}
service "ServiceWithNestedMessage" on ep {

    remote function hello(NestedRequestMessage value) returns NestedResponseMessage|error {
    }
}

