import ballerina/io;
import ballerina/time;

helloWorldClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string request = "ballerina";
    time:Utc response = check ep->getTime(request);
    io:println(response);
}

