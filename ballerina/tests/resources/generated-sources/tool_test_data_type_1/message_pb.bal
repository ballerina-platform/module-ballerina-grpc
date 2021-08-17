import ballerina/time;

public type ByeResponse record {|
    string say = "";
|};

public type User record {|
    time:Utc created_at = [0, 0.0d];
    time:Utc expired_at = [0, 0.0d];
|};

public type ByeRequest record {|
    string greet = "";
|};

