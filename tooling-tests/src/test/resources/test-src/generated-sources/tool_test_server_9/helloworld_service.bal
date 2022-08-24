import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: DEPENDINGSERVICE_DESC}
service "helloWorld" on ep {

    remote function hello(ReqMessage value) returns stream<ResMessage, error?>|error {
    }
}

