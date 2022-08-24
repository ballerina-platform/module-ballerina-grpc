import ballerina/io;
import ballerina/time;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string getTimeRequest = "ballerina";
    GetTimeStreamingClient getTimeStreamingClient = check ep->getTime();
    check getTimeStreamingClient->sendString(getTimeRequest);
    check getTimeStreamingClient->complete();
    time:Utc? getTimeResponse = check getTimeStreamingClient->receiveTimestamp();
    io:println(getTimeResponse);

    time:Utc sendTimeRequest = [1659688553, 0.310073000d];
    SendTimeStreamingClient sendTimeStreamingClient = check ep->sendTime();
    check sendTimeStreamingClient->sendTimestamp(sendTimeRequest);
    check sendTimeStreamingClient->complete();
    string? sendTimeResponse = check sendTimeStreamingClient->receiveString();
    io:println(sendTimeResponse);

    time:Utc exchangeTimeRequest = [1659688553, 0.310073000d];
    ExchangeTimeStreamingClient exchangeTimeStreamingClient = check ep->exchangeTime();
    check exchangeTimeStreamingClient->sendTimestamp(exchangeTimeRequest);
    check exchangeTimeStreamingClient->complete();
    time:Utc? exchangeTimeResponse = check exchangeTimeStreamingClient->receiveTimestamp();
    io:println(exchangeTimeResponse);

    string getGreetingRequest = "ballerina";
    GetGreetingStreamingClient getGreetingStreamingClient = check ep->getGreeting();
    check getGreetingStreamingClient->sendString(getGreetingRequest);
    check getGreetingStreamingClient->complete();
    Greeting? getGreetingResponse = check getGreetingStreamingClient->receiveGreeting();
    io:println(getGreetingResponse);

    Greeting sendGreetingRequest = {name: "ballerina", time: [1659688553, 0.310073000d]};
    SendGreetingStreamingClient sendGreetingStreamingClient = check ep->sendGreeting();
    check sendGreetingStreamingClient->sendGreeting(sendGreetingRequest);
    check sendGreetingStreamingClient->complete();
    string? sendGreetingResponse = check sendGreetingStreamingClient->receiveString();
    io:println(sendGreetingResponse);

    Greeting exchangeGreetingRequest = {name: "ballerina", time: [1659688553, 0.310073000d]};
    ExchangeGreetingStreamingClient exchangeGreetingStreamingClient = check ep->exchangeGreeting();
    check exchangeGreetingStreamingClient->sendGreeting(exchangeGreetingRequest);
    check exchangeGreetingStreamingClient->complete();
    Greeting? exchangeGreetingResponse = check exchangeGreetingStreamingClient->receiveGreeting();
    io:println(exchangeGreetingResponse);
}

