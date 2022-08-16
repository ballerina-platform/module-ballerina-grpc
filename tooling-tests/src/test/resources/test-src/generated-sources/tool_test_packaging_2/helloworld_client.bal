import ballerina/io;
import tool_test_packaging_2.message;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    message:ReqMessage request = {req: 1, value: "ballerina", enu: "x"};
    message:ResMessage response = check ep->hello1(request);
    io:println(response);
}

