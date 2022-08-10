import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloRequest request = {name: "Hello"};
    TestInputStructNoOutputStreamingClient streamingClient = check ep->testInputStructNoOutput();
    check streamingClient->sendHelloRequest(request);
    check streamingClient->complete();
    null? response = check streamingClient->receive();
    io:println(response);
}

