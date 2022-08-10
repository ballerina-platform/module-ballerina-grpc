import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    float request = 1;
    stream<float, error?> response = check ep->hello(request);
    check response.forEach(function(float value) {
        io:println(value);
    });
}

