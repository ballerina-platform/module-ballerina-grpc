import ballerina/io;
import ballerina/time;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string request = "Hello";
    stream<time:Utc, error?> response = check ep->getTime(request);
    check response.forEach(function(time:Utc value) {
        io:println(value);
    });
}

