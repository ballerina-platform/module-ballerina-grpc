import ballerina/grpc;
import tool_test_packaging_5.messages.message2;
import tool_test_packaging_5.messages.message1;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: PACKAGEWITHNESTEDSUBMODULES_DESC}
service "helloWorld" on ep {

    remote function hello1(message1:ReqMessage value) returns message2:ResMessage|error {
    }
    remote function hello3(stream<message1:ReqMessage, grpc:Error?> clientStream) returns message2:ResMessage|error {
    }
    remote function hello2(message1:ReqMessage value) returns stream<message2:ResMessage, error?>|error {
    }
    remote function hello4(stream<message1:ReqMessage, grpc:Error?> clientStream) returns stream<message2:ResMessage, error?>|error {
    }
    remote function hello5(stream<RootMessage, grpc:Error?> clientStream) returns stream<RootMessage, error?>|error {
    }
}

