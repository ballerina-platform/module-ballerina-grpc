import ballerina/protobuf;
import ballerina/time;

@protobuf:Descriptor {value: TIME_DEPENDENT_DESC}
public type Greeting record {|
    string name = "";
    time:Utc time = [0, 0.0d];
|};

