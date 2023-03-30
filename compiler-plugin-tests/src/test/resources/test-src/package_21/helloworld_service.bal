import ballerina/grpc;

listener grpc:Listener ep = new (9090);

public type Caller1 record {|
    string x;
|};

public type Caller2 record {|
    *Caller1;
    string y;
|};

@grpc:Descriptor {value: HELLOWORLDSTRING_DESC}
service "helloWorld" on ep {

    remote function hello(Caller2 caller, stream<string, grpc:Error?> clientStream) returns error? {
        return ();
    }
}

