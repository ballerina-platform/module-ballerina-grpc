import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: HELLOWORLDINPUTMESSAGEOUTPUTEMPTY_DESC}
service "helloWorld" on ep {

    remote function testInputStructNoOutput(HelloRequest value) returns error? {
    }
}

