import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    boolean helloRequest = true;
    boolean helloResponse = check ep->hello(helloRequest);
    io:println(helloResponse);

    HelloRequest hiRequest = {msg: "ballerina", id: 1};
    HelloResponse hiResponse = check ep->hi(hiRequest);
    io:println(hiResponse);
}

