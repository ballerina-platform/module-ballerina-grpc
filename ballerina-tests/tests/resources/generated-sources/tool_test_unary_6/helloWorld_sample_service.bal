import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_HELLOWORLDMESSAGE, descMap: getDescriptorMapHelloWorldMessage()}
service "helloWorld" on ep {

    remote function hello(HelloRequest value) returns HelloResponse|error {
    }
    remote function bye(ByeRequest value) returns ByeResponse|error {
    }
}

