import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_HELLOWORLDINPUTMESSAGEOUTPUTEMPTY, descMap: getDescriptorMapHelloWorldInputMessageOutputEmpty()}
service "helloWorld" on ep {

    remote function testInputStructNoOutput(HelloRequest value) returns error? {
    }
}

