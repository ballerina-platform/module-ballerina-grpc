import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    byte[] helloRequest = [72, 101, 108, 108, 111];
    HelloStreamingClient helloStreamingClient = check ep->hello();
    check helloStreamingClient->sendBytes(helloRequest);
    check helloStreamingClient->complete();
    byte[]? helloResponse = check helloStreamingClient->receiveBytes();
    io:println(helloResponse);
}

