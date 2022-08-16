import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string request = "ballerina";
    HelloStreamingClient streamingClient = check ep->hello();
    check streamingClient->sendString(request);
    check streamingClient->complete();
    string? response = check streamingClient->receiveString();
    io:println(response);
}

