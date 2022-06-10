import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: HELLOWORLDINPUTMESSAGEOUTPUTEMPTY_DESC}
service "helloWorld" on ep {

    remote function testInputStructNoOutput(stream<HelloRequest, grpc:Error?> clientStream) returns error? {
    }
}

