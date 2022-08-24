import ballerina/io;
import tool_test_packaging_3.message1;
import tool_test_packaging_3.message2;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    message1:ReqMessage1 hello1Request = {req: 1, value: "ballerina", enu: "x"};
    message2:ResMessage2 hello1Response = check ep->hello1(hello1Request);
    io:println(hello1Response);

    message1:ReqMessage1 hello2Request = {req: 1, value: "ballerina", enu: "x"};
    stream<message2:ResMessage2, error?> hello2Response = check ep->hello2(hello2Request);
    check hello2Response.forEach(function(message2:ResMessage2 value) {
        io:println(value);
    });

    message1:ReqMessage1 hello3Request = {req: 1, value: "ballerina", enu: "x"};
    Hello3StreamingClient hello3StreamingClient = check ep->hello3();
    check hello3StreamingClient->sendReqMessage1(hello3Request);
    check hello3StreamingClient->complete();
    message2:ResMessage2? hello3Response = check hello3StreamingClient->receiveResMessage2();
    io:println(hello3Response);

    message1:ReqMessage1 hello4Request = {req: 1, value: "ballerina", enu: "x"};
    Hello4StreamingClient hello4StreamingClient = check ep->hello4();
    check hello4StreamingClient->sendReqMessage1(hello4Request);
    check hello4StreamingClient->complete();
    message2:ResMessage2? hello4Response = check hello4StreamingClient->receiveResMessage2();
    io:println(hello4Response);

    RootMessage hello5Request = {msg: "ballerina", en1: "x", en2: "a"};
    Hello5StreamingClient hello5StreamingClient = check ep->hello5();
    check hello5StreamingClient->sendRootMessage(hello5Request);
    check hello5StreamingClient->complete();
    RootMessage? hello5Response = check hello5StreamingClient->receiveRootMessage();
    io:println(hello5Response);
}

