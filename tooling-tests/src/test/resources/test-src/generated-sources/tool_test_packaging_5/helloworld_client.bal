import ballerina/io;
import tool_test_packaging_5.messages.message2;
import tool_test_packaging_5.messages.message1;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    message1:ReqMessage request = {req: 1, value: "Hello", enu: "a"};
    message2:ResMessage response = check ep->hello1(request);
    io:println(response);
}

