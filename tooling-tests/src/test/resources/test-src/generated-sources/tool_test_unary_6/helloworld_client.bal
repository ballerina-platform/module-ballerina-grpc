import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloRequest request = {name: "Hello"};
    HelloResponse response = check ep->hello(request);
    io:println(response);
}

