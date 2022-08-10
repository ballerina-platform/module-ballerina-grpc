import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    int request = 1;
    HelloStreamingClient streamingClient = check ep->hello();
    check streamingClient->sendInt(request);
    check streamingClient->complete();
    int? response = check streamingClient->receiveInt();
    io:println(response);
}

