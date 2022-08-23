import ballerina/io;

StructHandlerClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    map<anydata> unaryCallRequest = {message: "Hello Ballerina"};
    map<anydata> unaryCallResponse = check ep->unaryCall(unaryCallRequest);
    io:println(unaryCallResponse);

    map<anydata> serverStreamingRequest = {message: "Hello Ballerina"};
    stream<map<anydata>, error?> serverStreamingResponse = check ep->serverStreaming(serverStreamingRequest);
    check serverStreamingResponse.forEach(function(map<anydata> value) {
        io:println(value);
    });

    map<anydata> clientStreamingRequest = {message: "Hello Ballerina"};
    ClientStreamingStreamingClient clientStreamingStreamingClient = check ep->clientStreaming();
    check clientStreamingStreamingClient->sendStruct(clientStreamingRequest);
    check clientStreamingStreamingClient->complete();
    map<anydata>? clientStreamingResponse = check clientStreamingStreamingClient->receiveStruct();
    io:println(clientStreamingResponse);

    map<anydata> bidirectionalStreamingRequest = {message: "Hello Ballerina"};
    BidirectionalStreamingStreamingClient bidirectionalStreamingStreamingClient = check ep->bidirectionalStreaming();
    check bidirectionalStreamingStreamingClient->sendStruct(bidirectionalStreamingRequest);
    check bidirectionalStreamingStreamingClient->complete();
    map<anydata>? bidirectionalStreamingResponse = check bidirectionalStreamingStreamingClient->receiveStruct();
    io:println(bidirectionalStreamingResponse);
}

