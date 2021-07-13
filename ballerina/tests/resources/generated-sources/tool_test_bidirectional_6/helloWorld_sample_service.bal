import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR,
    descMap: getDescriptorMap()
}
service "helloWorld" on ep {

    remote function hello(stream<HelloRequest, grpc:Error?> clientStream) returns stream<HelloResponse, error?>|error {
    }
    remote function bye(stream<ByeRequest, grpc:Error?> clientStream) returns stream<ByeResponse, error?>|error {
    }
}

