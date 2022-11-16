import ballerina/protobuf;
import ballerina/time;

public const string TIME_DEPENDENT_DESC = "";

@protobuf:Descriptor {value: MESSAGE_DESC}
public type ByeResponse record {|
    string say = "";
|};

@protobuf:Descriptor {value: MESSAGE_DESC}
public type User record {|
    time:Utc created_at = [0, 0.0d];
    time:Utc expired_at = [0, 0.0d];
|};

@protobuf:Descriptor {value: MESSAGE_DESC}
public type ByeRequest record {|
    string greet = "";
|};

