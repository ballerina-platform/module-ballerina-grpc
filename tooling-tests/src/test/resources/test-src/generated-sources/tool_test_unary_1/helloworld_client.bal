import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string helloRequest = "ballerina";
    string helloResponse = check ep->hello(helloRequest);
    io:println(helloResponse);
}

