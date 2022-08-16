import ballerina/io;

StructHandlerClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    map<anydata> request = {message: "Hello Ballerina"};
    map<anydata> response = check ep->unaryCall(request);
    io:println(response);
}

