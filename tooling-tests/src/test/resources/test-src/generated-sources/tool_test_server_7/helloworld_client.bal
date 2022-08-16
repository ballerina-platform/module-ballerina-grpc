import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    stream<HelloResponse, error?> response = check ep->testNoInputOutputStruct();
    check response.forEach(function(HelloResponse value) {
        io:println(value);
    });
}

