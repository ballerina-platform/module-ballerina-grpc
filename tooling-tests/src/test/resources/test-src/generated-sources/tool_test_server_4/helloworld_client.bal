import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    boolean helloRequest = true;
    stream<boolean, error?> helloResponse = check ep->hello(helloRequest);
    check helloResponse.forEach(function(boolean value) {
        io:println(value);
    });
}

