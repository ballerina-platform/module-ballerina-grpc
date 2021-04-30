import ballerina/grpc;

public type HelloResponse record {|
    string message = "";
|};

public type HelloRequest record {|
    string name = "";
|};

const string ROOT_DESCRIPTOR = "null";

isolated function getDescriptorMap() returns map<string> {
    return {};
}

