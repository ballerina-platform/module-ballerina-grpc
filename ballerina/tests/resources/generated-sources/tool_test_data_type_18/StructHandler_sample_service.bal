import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR, descMap: getDescriptorMap()}
service "StructHandler" on ep {

    remote function unaryCall(map<anydata> value) returns map<anydata>|error {
    }
    remote function clientStreaming(stream<map<anydata>, grpc:Error?> clientStream) returns map<anydata>|error {
    }
    remote function serverStreaming(map<anydata> value) returns stream<map<anydata>, error?>|error {
    }
    remote function bidirectionalStreaming(stream<map<anydata>, grpc:Error?> clientStream) returns stream<map<anydata>, error?>|error {
    }
}

