helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloRequest request = {name: "ballerina"};
    TestInputStructNoOutputStreamingClient streamingClient = check ep->testInputStructNoOutput();
    check streamingClient->sendHelloRequest(request);
    check streamingClient->complete();
    check streamingClient->receive();
}

