import ballerina/io;
import ballerina/time;

DurationHandlerClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string request = "Hello";
    time:Seconds response = check ep->unaryCall1(request);
    io:println(response);
}


