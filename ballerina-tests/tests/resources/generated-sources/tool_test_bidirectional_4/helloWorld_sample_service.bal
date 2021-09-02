import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_HELLOWORLDBOOLEAN, descMap: getDescriptorMapHelloWorldBoolean()}
service "helloWorld" on ep {

    remote function hello(stream<boolean, grpc:Error?> clientStream) returns stream<boolean, error?>|error {
    }
}

