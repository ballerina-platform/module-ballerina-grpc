import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    float request = 1;
    float response = check ep->hello(request);
    io:println(response);
}

