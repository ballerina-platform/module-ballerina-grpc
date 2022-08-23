import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    float helloRequest = 1;
    stream<float, error?> helloResponse = check ep->hello(helloRequest);
    check helloResponse.forEach(function(float value) {
        io:println(value);
    });
}

