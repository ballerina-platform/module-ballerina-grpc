import ballerina/io;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloRequest helloRequest = {name: "ballerina"};
    HelloStreamingClient helloStreamingClient = check ep->hello();
    check helloStreamingClient->sendHelloRequest(helloRequest);
    check helloStreamingClient->complete();
    HelloResponse? helloResponse = check helloStreamingClient->receiveHelloResponse();
    io:println(helloResponse);

    ByeRequest byeRequest = {greet: "ballerina"};
    ByeStreamingClient byeStreamingClient = check ep->bye();
    check byeStreamingClient->sendByeRequest(byeRequest);
    check byeStreamingClient->complete();
    ByeResponse? byeResponse = check byeStreamingClient->receiveByeResponse();
    io:println(byeResponse);
}

