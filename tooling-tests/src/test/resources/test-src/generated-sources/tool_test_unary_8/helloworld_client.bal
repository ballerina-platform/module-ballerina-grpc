import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloRequest request = {name: "Hello"};
    null response = check ep->testInputStructNoOutput(request);
    io:println(response);
}

