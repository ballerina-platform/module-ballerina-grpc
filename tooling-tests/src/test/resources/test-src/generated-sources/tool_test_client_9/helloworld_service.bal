import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: HELLOWORLDNESTEDREPEATEDMESSAGES_DESC}
service "helloWorld" on ep {

    remote function hello(ReqMessage value) returns ResMessage|error {
    }
    remote function helloWorld(stream<ReqMessage, grpc:Error?> clientStream) returns ResMessage|error {
    }
    remote function helloBallerina(ReqMessage value) returns stream<ResMessage, error?>|error {
    }
    remote function helloGrpc(stream<ReqMessage, grpc:Error?> clientStream) returns stream<ResMessage, error?>|error {
    }
}

