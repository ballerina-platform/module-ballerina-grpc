import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_HELLOWORLDINPUTEMPTYOUTPUTMESSAGE, descMap: getDescriptorMapHelloWorldInputEmptyOutputMessage()}
service "helloWorld" on ep {

    remote function testNoInputOutputStruct() returns stream<HelloResponse, error?>|error {
    }
}

