import ballerina/io;
import ballerina/time;

DurationHandlerClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    time:Seconds request = 0.310073000d;
    time:Seconds response = check ep->unaryCall(request);
    io:println(response);
}

