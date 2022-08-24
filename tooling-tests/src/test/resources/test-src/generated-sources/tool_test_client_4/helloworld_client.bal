import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    boolean helloRequest = true;
    HelloStreamingClient helloStreamingClient = check ep->hello();
    check helloStreamingClient->sendBoolean(helloRequest);
    check helloStreamingClient->complete();
    boolean? helloResponse = check helloStreamingClient->receiveBoolean();
    io:println(helloResponse);
}

