import ballerina/grpc;
import ballerina/log;
import grpc_tests.message1;
import grpc_tests.message2;

listener grpc:Listener ep68 = new (9168);

@grpc:ServiceDescriptor {descriptor: PACKAGEWITHMULTIPLEIMPORTS_DESC}
service "packagingService" on ep68 {

    remote function hello1(message1:ReqMessage1 value) returns message2:ResMessage2|error {
        log:printInfo("Received unary message " + value.toString());
        message2:ResMessage2 response = {req: 1, value: "Hello"};
        return response;
    }

    remote function hello3(stream<message1:ReqMessage1, grpc:Error?> clientStream) returns message2:ResMessage2|error {
        check clientStream.forEach(function (message1:ReqMessage1 msg) {
            log:printInfo("Received client streaming message " + msg.toString());
        });
        message2:ResMessage2 response = {req: 1, value: "Hello"};
        return response;
    }

    remote function hello2(message1:ReqMessage1 value) returns stream<message2:ResMessage2, error?>|error {
        log:printInfo("Received server streaming message " + value.toString());
        message2:ResMessage2 response1 = {req: 1, value: "Hello"};
        message2:ResMessage2 response2 = {req: 2, value: "Hi"};
        return [response1, response2].toStream();
    }

    remote function hello4(stream<message1:ReqMessage1, grpc:Error?> clientStream) returns stream<message2:ResMessage2, error?>|error {
        check clientStream.forEach(function (message1:ReqMessage1 msg) {
            log:printInfo("Received bidi streaming message " + msg.toString());
        });
        message2:ResMessage2 response1 = {req: 1, value: "Hello"};
        message2:ResMessage2 response2 = {req: 2, value: "Hi"};
        return [response1, response2].toStream();
    }

    remote function hello5(stream<RootMessage, grpc:Error?> clientStream) returns stream<RootMessage, error?>|error {
        check clientStream.forEach(function (RootMessage msg) {
            log:printInfo("Received bidi streaming message " + msg.toString());
        });
        return [{msg: "Hello"}, {msg: "Hi"}].toStream();
    }
}
