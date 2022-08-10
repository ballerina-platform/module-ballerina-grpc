import ballerina/io;
import ballerina/protobuf.types.'any;

AnyTypeServerClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    'any:Any request = check 'any:pack("Hello");
    'any:Any response = check ep->unaryCall1(request);
    io:println(response);
}

