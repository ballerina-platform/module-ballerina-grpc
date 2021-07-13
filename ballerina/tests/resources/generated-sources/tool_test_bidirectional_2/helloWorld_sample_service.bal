import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR,
    descMap: getDescriptorMap()
}
service "helloWorld" on ep {

    remote function hello(stream<int, grpc:Error?> clientStream) returns stream<int, error?>|error {
    }
}

