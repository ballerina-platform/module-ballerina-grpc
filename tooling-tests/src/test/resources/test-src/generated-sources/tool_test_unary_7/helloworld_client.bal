import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloResponse testNoInputOutputStructResponse = check ep->testNoInputOutputStruct();
    io:println(testNoInputOutputStructResponse);
}

