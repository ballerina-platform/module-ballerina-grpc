import ballerina/io;
import ballerina/time;

DurationHandlerClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string unaryCall1Request = "ballerina";
    time:Seconds unaryCall1Response = check ep->unaryCall1(unaryCall1Request);
    io:println(unaryCall1Response);

    DurationMsg unaryCall2Request = {name: "ballerina", duration: 0.310073000d};
    DurationMsg unaryCall2Response = check ep->unaryCall2(unaryCall2Request);
    io:println(unaryCall2Response);

    string serverStreamingRequest = "ballerina";
    stream<time:Seconds, error?> serverStreamingResponse = check ep->serverStreaming(serverStreamingRequest);
    check serverStreamingResponse.forEach(function(time:Seconds value) {
        io:println(value);
    });

    time:Seconds clientStreamingRequest = 0.310073000d;
    ClientStreamingStreamingClient clientStreamingStreamingClient = check ep->clientStreaming();
    check clientStreamingStreamingClient->sendDuration(clientStreamingRequest);
    check clientStreamingStreamingClient->complete();
    string? clientStreamingResponse = check clientStreamingStreamingClient->receiveString();
    io:println(clientStreamingResponse);

    DurationMsg bidirectionalStreamingRequest = {name: "ballerina", duration: 0.310073000d};
    BidirectionalStreamingStreamingClient bidirectionalStreamingStreamingClient = check ep->bidirectionalStreaming();
    check bidirectionalStreamingStreamingClient->sendDurationMsg(bidirectionalStreamingRequest);
    check bidirectionalStreamingStreamingClient->complete();
    DurationMsg? bidirectionalStreamingResponse = check bidirectionalStreamingStreamingClient->receiveDurationMsg();
    io:println(bidirectionalStreamingResponse);
}

