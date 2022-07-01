import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: HELLOWORLDINPUTEMPTYOUTPUTMESSAGE_DESC}
service "helloWorld" on ep {

    remote function testNoInputOutputStruct() returns HelloResponse|error {
    }
}

