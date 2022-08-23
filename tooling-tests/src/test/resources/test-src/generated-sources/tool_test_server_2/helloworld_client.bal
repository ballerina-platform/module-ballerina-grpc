import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    int helloRequest = 1;
    stream<int, error?> helloResponse = check ep->hello(helloRequest);
    check helloResponse.forEach(function(int value) {
        io:println(value);
    });
}

