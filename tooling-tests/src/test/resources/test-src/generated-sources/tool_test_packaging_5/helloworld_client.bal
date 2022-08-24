import ballerina/io;
import tool_test_packaging_5.messages.message2;
import tool_test_packaging_5.messages.message1;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    message1:ReqMessage hello1Request = {req: 1, value: "ballerina", enu: "a"};
    message2:ResMessage hello1Response = check ep->hello1(hello1Request);
    io:println(hello1Response);

    message1:ReqMessage hello2Request = {req: 1, value: "ballerina", enu: "a"};
    stream<message2:ResMessage, error?> hello2Response = check ep->hello2(hello2Request);
    check hello2Response.forEach(function(message2:ResMessage value) {
        io:println(value);
    });

    message1:ReqMessage hello3Request = {req: 1, value: "ballerina", enu: "a"};
    Hello3StreamingClient hello3StreamingClient = check ep->hello3();
    check hello3StreamingClient->sendReqMessage(hello3Request);
    check hello3StreamingClient->complete();
    message2:ResMessage? hello3Response = check hello3StreamingClient->receiveResMessage();
    io:println(hello3Response);

    message1:ReqMessage hello4Request = {req: 1, value: "ballerina", enu: "a"};
    Hello4StreamingClient hello4StreamingClient = check ep->hello4();
    check hello4StreamingClient->sendReqMessage(hello4Request);
    check hello4StreamingClient->complete();
    message2:ResMessage? hello4Response = check hello4StreamingClient->receiveResMessage();
    io:println(hello4Response);

    RootMessage hello5Request = {msg: "ballerina", enu1: "a", enu2: "x"};
    Hello5StreamingClient hello5StreamingClient = check ep->hello5();
    check hello5StreamingClient->sendRootMessage(hello5Request);
    check hello5StreamingClient->complete();
    RootMessage? hello5Response = check hello5StreamingClient->receiveRootMessage();
    io:println(hello5Response);
}

