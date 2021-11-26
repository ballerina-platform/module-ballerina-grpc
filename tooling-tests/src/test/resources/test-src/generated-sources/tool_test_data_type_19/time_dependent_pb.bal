import ballerina/time;

public type Greeting record {|
    string name = "";
    time:Utc time = [0, 0.0d];
|};

