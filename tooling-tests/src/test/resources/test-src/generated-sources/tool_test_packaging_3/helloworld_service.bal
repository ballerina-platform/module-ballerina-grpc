import ballerina/grpc;
import tool_test_packaging_3.message1;
import tool_test_packaging_3.message2;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: PACKAGEWITHMULTIPLEIMPORTS_DESC}
service "helloWorld" on ep {

    remote function hello1(message1:ReqMessage1 value) returns message2:ResMessage2|error {
    }
    remote function hello3(stream<message1:ReqMessage1, grpc:Error?> clientStream) returns message2:ResMessage2|error {
    }
    remote function hello2(message1:ReqMessage1 value) returns stream<message2:ResMessage2, error?>|error {
    }
    remote function hello4(stream<message1:ReqMessage1, grpc:Error?> clientStream) returns stream<message2:ResMessage2, error?>|error {
    }
    remote function hello5(stream<RootMessage, grpc:Error?> clientStream) returns stream<RootMessage, error?>|error {
    }
}

