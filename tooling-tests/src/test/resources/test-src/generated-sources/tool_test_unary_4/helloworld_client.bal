import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    boolean request = true;
    boolean response = check ep->hello(request);
    io:println(response);
}

