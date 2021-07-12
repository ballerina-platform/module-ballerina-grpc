import ballerina/grpc;
import ballerina/time;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR, descMap: getDescriptorMap()}
service "DurationHandler" on ep {

    remote function unaryCall1(string value) returns time:Seconds|error {
    }
    remote function unaryCall2(DurationMsg value) returns DurationMsg|error {
    }
    remote function clientStreaming(stream<time:Seconds, grpc:Error?> clientStream) returns string|error {
    }
    remote function serverStreaming(string value) returns stream<time:Seconds, error?>|error {
    }
    remote function bidirectionalStreaming(stream<DurationMsg, grpc:Error?> clientStream) returns stream<DurationMsg, error?>|error {
    }
}

