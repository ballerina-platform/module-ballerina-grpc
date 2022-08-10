import ballerina/io;
import ballerina/time;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string request = "Hello";
    GetTimeStreamingClient streamingClient = check ep->getTime();
    check streamingClient->sendString(request);
    check streamingClient->complete();
    time:Utc? response = check streamingClient->receiveTimestamp();
    io:println(response);
}

