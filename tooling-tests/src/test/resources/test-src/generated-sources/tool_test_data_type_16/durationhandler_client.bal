import ballerina/io;
import ballerina/time;

DurationHandlerClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    time:Seconds unaryCallRequest = 0.310073000d;
    time:Seconds unaryCallResponse = check ep->unaryCall(unaryCallRequest);
    io:println(unaryCallResponse);

    time:Seconds serverStreamingRequest = 0.310073000d;
    stream<time:Seconds, error?> serverStreamingResponse = check ep->serverStreaming(serverStreamingRequest);
    check serverStreamingResponse.forEach(function(time:Seconds value) {
        io:println(value);
    });

    time:Seconds clientStreamingRequest = 0.310073000d;
    ClientStreamingStreamingClient clientStreamingStreamingClient = check ep->clientStreaming();
    check clientStreamingStreamingClient->sendDuration(clientStreamingRequest);
    check clientStreamingStreamingClient->complete();
    time:Seconds? clientStreamingResponse = check clientStreamingStreamingClient->receiveDuration();
    io:println(clientStreamingResponse);

    time:Seconds bidirectionalStreamingRequest = 0.310073000d;
    BidirectionalStreamingStreamingClient bidirectionalStreamingStreamingClient = check ep->bidirectionalStreaming();
    check bidirectionalStreamingStreamingClient->sendDuration(bidirectionalStreamingRequest);
    check bidirectionalStreamingStreamingClient->complete();
    time:Seconds? bidirectionalStreamingResponse = check bidirectionalStreamingStreamingClient->receiveDuration();
    io:println(bidirectionalStreamingResponse);
}

