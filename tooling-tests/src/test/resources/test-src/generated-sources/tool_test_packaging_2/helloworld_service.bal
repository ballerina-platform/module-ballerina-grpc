import ballerina/grpc;
import tool_test_packaging_2.message1;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: PACKAGEWITHMESSAGEIMPORT_DESC}
service "helloWorld" on ep {

    remote function hello1(message1:ReqMessage1 value) returns message1:ResMessage1|error {
    }
    remote function hello3(stream<message1:ReqMessage1, grpc:Error?> clientStream) returns message1:ResMessage1|error {
    }
    remote function hello2(message1:ReqMessage1 value) returns stream<message1:ResMessage1, error?>|error {
    }
    remote function hello(stream<boolean, grpc:Error?> clientStream) returns stream<boolean, error?>|error {
    }
    remote function hello4(stream<message1:ReqMessage1, grpc:Error?> clientStream) returns stream<message1:ResMessage1, error?>|error {
    }
    remote function hello5(stream<RootMessage, grpc:Error?> clientStream) returns stream<RootMessage, error?>|error {
    }
    remote function hello10(stream<RootMessage, grpc:Error?> clientStream) returns stream<message1:ResMessage1, error?>|error {
    }
    remote function hello11(stream<message1:ReqMessage1, grpc:Error?> clientStream) returns stream<RootMessage, error?>|error {
    }
}

