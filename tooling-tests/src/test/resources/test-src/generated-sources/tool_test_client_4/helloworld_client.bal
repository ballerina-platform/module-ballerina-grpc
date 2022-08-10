import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    boolean request = true;
    HelloStreamingClient streamingClient = check ep->hello();
    check streamingClient->sendBoolean(request);
    check streamingClient->complete();
    boolean? response = check streamingClient->receiveBoolean();
    io:println(response);
}

