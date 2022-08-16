import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    int request = 1;
    stream<int, error?> response = check ep->hello(request);
    check response.forEach(function(int value) {
        io:println(value);
    });
}

