import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string helloRequest = "ballerina";
    stream<string, error?> helloResponse = check ep->hello(helloRequest);
    check helloResponse.forEach(function(string value) {
        io:println(value);
    });
}

