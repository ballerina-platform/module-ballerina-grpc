import ballerina/io;
import ballerina/time;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string getTimeRequest = "ballerina";
    time:Utc getTimeResponse = check ep->getTime(getTimeRequest);
    io:println(getTimeResponse);

    time:Utc sendTimeRequest = [1659688553, 0.310073000d];
    string sendTimeResponse = check ep->sendTime(sendTimeRequest);
    io:println(sendTimeResponse);

    time:Utc exchangeTimeRequest = [1659688553, 0.310073000d];
    time:Utc exchangeTimeResponse = check ep->exchangeTime(exchangeTimeRequest);
    io:println(exchangeTimeResponse);

    string getGreetingRequest = "ballerina";
    Greeting getGreetingResponse = check ep->getGreeting(getGreetingRequest);
    io:println(getGreetingResponse);

    Greeting sendGreetingRequest = {name: "ballerina", time: [1659688553, 0.310073000d]};
    string sendGreetingResponse = check ep->sendGreeting(sendGreetingRequest);
    io:println(sendGreetingResponse);

    Greeting exchangeGreetingRequest = {name: "ballerina", time: [1659688553, 0.310073000d]};
    Greeting exchangeGreetingResponse = check ep->exchangeGreeting(exchangeGreetingRequest);
    io:println(exchangeGreetingResponse);
}

