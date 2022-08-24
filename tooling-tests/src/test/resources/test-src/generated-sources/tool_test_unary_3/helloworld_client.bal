import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    float helloRequest = 1;
    float helloResponse = check ep->hello(helloRequest);
    io:println(helloResponse);
}

