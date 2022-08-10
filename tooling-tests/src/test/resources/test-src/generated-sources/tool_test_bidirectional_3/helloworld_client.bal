import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    float request = 1;
    HelloStreamingClient streamingClient = check ep->hello();
    check streamingClient->sendFloat(request);
    check streamingClient->complete();
    float? response = check streamingClient->receiveFloat();
    io:println(response);
}

