import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    stream<HelloResponse, error?> testNoInputOutputStructResponse = check ep->testNoInputOutputStruct();
    check testNoInputOutputStructResponse.forEach(function(HelloResponse value) {
        io:println(value);
    });
}

