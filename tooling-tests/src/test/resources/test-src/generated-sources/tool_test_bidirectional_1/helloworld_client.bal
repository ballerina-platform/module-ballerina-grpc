import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string helloRequest = "ballerina";
    HelloStreamingClient helloStreamingClient = check ep->hello();
    check helloStreamingClient->sendString(helloRequest);
    check helloStreamingClient->complete();
    string? helloResponse = check helloStreamingClient->receiveString();
    io:println(helloResponse);
}

