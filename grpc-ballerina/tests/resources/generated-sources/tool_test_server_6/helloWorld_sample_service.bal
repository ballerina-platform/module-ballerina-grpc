import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR,
    descMap: getDescriptorMap()
}
service "helloWorld" on ep {

    remote function hello(HelloRequest value) returns stream<HelloResponse, error?>|error {
    }
    remote function bye(ByeRequest value) returns stream<ByeResponse, error?>|error {
    }
}

