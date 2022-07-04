import ballerina/grpc;
import ballerina/log;
import grpc_tests.messageWithService;

listener grpc:Listener ep71 = new (9171);

@grpc:Descriptor {value: PACKAGE_WITH_SERVICE_IN_SUBMODULE_DESC}
service "helloWorld71" on ep71 {

    remote function helloWorld71Unary(messageWithService:ReqMessage value) returns messageWithService:ResMessage|error {
        log:printInfo("Received unary message " + value.toString());
        messageWithService:ResMessage response = {req: 1, value: "Hello"};
        return response;
    }

    remote function helloWorld71ClientStream(stream<messageWithService:ReqMessage, grpc:Error?> clientStream) returns messageWithService:ResMessage|error {
        check clientStream.forEach(function (messageWithService:ReqMessage msg) {
            log:printInfo("Received client streaming message " + msg.toString());
        });
        messageWithService:ResMessage response = {req: 1, value: "Hello"};
        return response;
    }

    remote function helloWorld71ServerStream(messageWithService:ReqMessage value) returns stream<messageWithService:ResMessage, error?>|error {
        log:printInfo("Received server streaming message " + value.toString());
        messageWithService:ResMessage res1 = {req: 1, value: "Hello"};
        messageWithService:ResMessage res2 = {req: 2, value: "Hi"};
        return [res1, res2].toStream();
    }

    remote function helloWorld71BidiStream(stream<messageWithService:ReqMessage, grpc:Error?> clientStream) returns stream<messageWithService:ResMessage, error?>|error {
        check clientStream.forEach(function (messageWithService:ReqMessage msg) {
            log:printInfo("Received bidi streaming message " + msg.toString());
        });
        messageWithService:ResMessage res1 = {req: 1, value: "Hello"};
        messageWithService:ResMessage res2 = {req: 2, value: "Hi"};
        return [res1, res2].toStream();
    }
}
