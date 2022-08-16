import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloRequest request = {name: "ballerina"};
    stream<HelloResponse, error?> response = check ep->hello(request);
    check response.forEach(function(HelloResponse value) {
        io:println(value);
    });
}

