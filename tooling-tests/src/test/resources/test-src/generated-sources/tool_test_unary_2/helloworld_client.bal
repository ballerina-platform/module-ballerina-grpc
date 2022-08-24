import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    int helloRequest = 1;
    int helloResponse = check ep->hello(helloRequest);
    io:println(helloResponse);
}

