import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string request = "ballerina";
    stream<string, error?> response = check ep->hello(request);
    check response.forEach(function(string value) {
        io:println(value);
    });
}

