import ballerina/grpc;
import tool_test_packaging_4.message;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: PACKAGEWITHIMPORTCONTAININGSERVICE_DESC}
service "helloWorld" on ep {

    remote function hello1(message:ReqMessage value) returns message:ResMessage|error {
    }
    remote function hello3(stream<message:ReqMessage, grpc:Error?> clientStream) returns message:ResMessage|error {
    }
    remote function hello2(message:ReqMessage value) returns stream<message:ResMessage, error?>|error {
    }
    remote function hello4(stream<message:ReqMessage, grpc:Error?> clientStream) returns stream<message:ResMessage, error?>|error {
    }
    remote function hello5(stream<RootMessage, grpc:Error?> clientStream) returns stream<RootMessage, error?>|error {
    }
}

