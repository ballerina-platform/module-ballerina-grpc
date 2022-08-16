helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloRequest request = {name: "ballerina"};
    check ep->testInputStructNoOutput(request);
}

