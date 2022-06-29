import ballerina/grpc;
import ballerina/protobuf.types.'any;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: ANY_DESC}
service "AnyTypeServer" on ep {

    remote function unaryCall1('any:Any value) returns 'any:Any|error {
    }
    remote function unaryCall2('any:Any value) returns 'any:Any|error {
    }
    remote function unaryCall3('any:Any value) returns 'any:Any|error {
    }
    remote function clientStreamingCall(stream<'any:Any, grpc:Error?> clientStream) returns 'any:Any|error {
    }
    remote function serverStreamingCall('any:Any value) returns stream<'any:Any, error?>|error {
    }
    remote function bidirectionalStreamingCall(stream<'any:Any, grpc:Error?> clientStream) returns stream<'any:Any, error?>|error {
    }
}

