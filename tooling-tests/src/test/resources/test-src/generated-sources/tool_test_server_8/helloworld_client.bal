import ballerina/io;
import ballerina/time;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string getTimeRequest = "ballerina";
    stream<time:Utc, error?> getTimeResponse = check ep->getTime(getTimeRequest);
    check getTimeResponse.forEach(function(time:Utc value) {
        io:println(value);
    });

    time:Utc sendTimeRequest = [1659688553, 0.310073000d];
    stream<string, error?> sendTimeResponse = check ep->sendTime(sendTimeRequest);
    check sendTimeResponse.forEach(function(string value) {
        io:println(value);
    });

    time:Utc exchangeTimeRequest = [1659688553, 0.310073000d];
    stream<time:Utc, error?> exchangeTimeResponse = check ep->exchangeTime(exchangeTimeRequest);
    check exchangeTimeResponse.forEach(function(time:Utc value) {
        io:println(value);
    });

    string getGreetingRequest = "ballerina";
    stream<Greeting, error?> getGreetingResponse = check ep->getGreeting(getGreetingRequest);
    check getGreetingResponse.forEach(function(Greeting value) {
        io:println(value);
    });

    Greeting sendGreetingRequest = {name: "ballerina", time: [1659688553, 0.310073000d]};
    stream<string, error?> sendGreetingResponse = check ep->sendGreeting(sendGreetingRequest);
    check sendGreetingResponse.forEach(function(string value) {
        io:println(value);
    });

    Greeting exchangeGreetingRequest = {name: "ballerina", time: [1659688553, 0.310073000d]};
    stream<Greeting, error?> exchangeGreetingResponse = check ep->exchangeGreeting(exchangeGreetingRequest);
    check exchangeGreetingResponse.forEach(function(Greeting value) {
        io:println(value);
    });
}

