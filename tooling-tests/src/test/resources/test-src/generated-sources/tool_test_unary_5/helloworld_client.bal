import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    byte[] request = [72, 101, 108, 108, 111];
    byte[] response = check ep->hello(request);
    io:println(response);
}

