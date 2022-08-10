import ballerina/io;

StructHandlerClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string request = "Hello";
    map<anydata> response = check ep->unaryCall1(request);
    io:println(response);
}

