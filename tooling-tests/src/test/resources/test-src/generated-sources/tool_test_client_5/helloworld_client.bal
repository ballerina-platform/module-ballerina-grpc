import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    byte[] request = [72, 101, 108, 108, 111];
    HelloStreamingClient streamingClient = check ep->hello();
    check streamingClient->sendBytes(request);
    check streamingClient->complete();
    byte[]? response = check streamingClient->receiveBytes();
    io:println(response);
}

