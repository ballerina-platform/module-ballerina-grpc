import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string request = "ballerina";
    string response = check ep->hello(request);
    io:println(response);
}

