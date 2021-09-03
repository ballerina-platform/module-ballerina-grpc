import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_HELLOWORLDINT, descMap: getDescriptorMapHelloWorldInt()}
service "helloWorld" on ep {

    remote function hello(int value) returns stream<int, error?>|error {
    }
}

