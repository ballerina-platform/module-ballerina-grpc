import ballerina/protobuf;

@protobuf:Descriptor {value: LIB_MESSAGE_DESC}
public type HelloResponse record {|
    string message = "";
|};

@protobuf:Descriptor {value: LIB_MESSAGE_DESC}
public type HelloRequest record {|
    string name = "";
|};

