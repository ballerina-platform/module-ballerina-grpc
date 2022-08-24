import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    byte[] helloRequest = [72, 101, 108, 108, 111];
    byte[] helloResponse = check ep->hello(helloRequest);
    io:println(helloResponse);
}

