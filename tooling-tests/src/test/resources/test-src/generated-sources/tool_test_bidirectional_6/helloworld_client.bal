import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloRequest request = {name: "ballerina"};
    HelloStreamingClient streamingClient = check ep->hello();
    check streamingClient->sendHelloRequest(request);
    check streamingClient->complete();
    HelloResponse? response = check streamingClient->receiveHelloResponse();
    io:println(response);
}

