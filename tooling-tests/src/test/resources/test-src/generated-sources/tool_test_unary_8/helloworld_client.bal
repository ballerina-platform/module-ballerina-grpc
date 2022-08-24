helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloRequest testInputStructNoOutputRequest = {name: "ballerina"};
    check ep->testInputStructNoOutput(testInputStructNoOutputRequest);
}

