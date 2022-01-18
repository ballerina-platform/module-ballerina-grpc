import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_HELLOWORLDBYTES, descMap: getDescriptorMapHelloWorldBytes()}
service "helloWorld" on ep {

    remote function hello(stream<byte[], grpc:Error?> clientStream) returns byte[]|error {
    }
}

