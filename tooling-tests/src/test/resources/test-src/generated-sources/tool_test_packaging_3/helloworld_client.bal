import ballerina/io;
import tool_test_packaging_3.message1;
import tool_test_packaging_3.message2;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    message1:ReqMessage1 request = {req: 1, value: "ballerina", enu: "x"};
    message2:ResMessage2 response = check ep->hello1(request);
    io:println(response);
}

