import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    int request = 1;
    int response = check ep->hello(request);
    io:println(response);
}

