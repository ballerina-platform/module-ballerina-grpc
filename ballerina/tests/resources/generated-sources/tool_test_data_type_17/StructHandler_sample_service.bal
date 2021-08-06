import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR, descMap: getDescriptorMap()}
service "StructHandler" on ep {

    remote function unaryCall1(string value) returns map<anydata>|error {
    }
    remote function unaryCall2(StructMsg value) returns StructMsg|error {
    }
    remote function clientStreaming(stream<map<anydata>, grpc:Error?> clientStream) returns string|error {
    }
    remote function serverStreaming(string value) returns stream<map<anydata>, error?>|error {
    }
    remote function bidirectionalStreaming(stream<StructMsg, grpc:Error?> clientStream) returns stream<StructMsg, error?>|error {
    }
}

