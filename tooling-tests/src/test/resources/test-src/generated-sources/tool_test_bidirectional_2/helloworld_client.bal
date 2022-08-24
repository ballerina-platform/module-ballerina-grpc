import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    int helloRequest = 1;
    HelloStreamingClient helloStreamingClient = check ep->hello();
    check helloStreamingClient->sendInt(helloRequest);
    check helloStreamingClient->complete();
    int? helloResponse = check helloStreamingClient->receiveInt();
    io:println(helloResponse);
}

