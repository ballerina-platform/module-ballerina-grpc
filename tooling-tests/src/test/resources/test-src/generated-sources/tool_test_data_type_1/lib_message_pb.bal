import ballerina/protobuf;

const string LIB_MESSAGE_DESC = "null";

@protobuf:Descriptor {value: LIB_MESSAGE_DESC}
public type HelloResponse record {|
    string message = "";
|};

@protobuf:Descriptor {value: LIB_MESSAGE_DESC}
public type HelloRequest record {|
    string name = "";
|};

