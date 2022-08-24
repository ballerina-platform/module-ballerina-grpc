import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    byte[] helloRequest = [72, 101, 108, 108, 111];
    stream<byte[], error?> helloResponse = check ep->hello(helloRequest);
    check helloResponse.forEach(function(byte[] value) {
        io:println(value);
    });
}

