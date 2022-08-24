import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    float helloRequest = 1;
    HelloStreamingClient helloStreamingClient = check ep->hello();
    check helloStreamingClient->sendFloat(helloRequest);
    check helloStreamingClient->complete();
    float? helloResponse = check helloStreamingClient->receiveFloat();
    io:println(helloResponse);
}

