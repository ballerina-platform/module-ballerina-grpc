helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloRequest testInputStructNoOutputRequest = {name: "ballerina"};
    TestInputStructNoOutputStreamingClient testInputStructNoOutputStreamingClient = check ep->testInputStructNoOutput();
    check testInputStructNoOutputStreamingClient->sendHelloRequest(testInputStructNoOutputRequest);
    check testInputStructNoOutputStreamingClient->complete();
    check testInputStructNoOutputStreamingClient->receive();
}

