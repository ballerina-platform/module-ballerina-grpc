import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    boolean request = true;
    stream<boolean, error?> response = check ep->hello(request);
    check response.forEach(function(boolean value) {
        io:println(value);
    });
}

