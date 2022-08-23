import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloRequest helloRequest = {name: "ballerina"};
    HelloResponse helloResponse = check ep->hello(helloRequest);
    io:println(helloResponse);

    ByeRequest byeRequest = {greet: "ballerina"};
    ByeResponse byeResponse = check ep->bye(byeRequest);
    io:println(byeResponse);
}

