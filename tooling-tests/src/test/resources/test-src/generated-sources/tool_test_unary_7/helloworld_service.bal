import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: HELLOWORLDINPUTEMPTYOUTPUTMESSAGE_DESC}
service "helloWorld" on ep {

    remote function testNoInputOutputStruct() returns HelloResponse|error {
    }
}

