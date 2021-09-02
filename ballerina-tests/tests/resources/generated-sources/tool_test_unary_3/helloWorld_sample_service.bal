import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_HELLOWORLDFLOAT, descMap: getDescriptorMapHelloWorldFloat()}
service "helloWorld" on ep {

    remote function hello(float value) returns float|error {
    }
}

