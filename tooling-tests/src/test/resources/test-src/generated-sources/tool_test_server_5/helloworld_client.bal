import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    byte[] request = [72, 101, 108, 108, 111];
    stream<byte[], error?> response = check ep->hello(request);
    check response.forEach(function(byte[] value) {
        io:println(value);
    });
}

