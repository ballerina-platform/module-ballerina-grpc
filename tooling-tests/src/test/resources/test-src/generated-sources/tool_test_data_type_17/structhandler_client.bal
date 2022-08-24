import ballerina/io;

StructHandlerClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    string unaryCall1Request = "ballerina";
    map<anydata> unaryCall1Response = check ep->unaryCall1(unaryCall1Request);
    io:println(unaryCall1Response);

    StructMsg unaryCall2Request = {name: "ballerina", struct: {message: "Hello Ballerina"}};
    StructMsg unaryCall2Response = check ep->unaryCall2(unaryCall2Request);
    io:println(unaryCall2Response);

    string serverStreamingRequest = "ballerina";
    stream<map<anydata>, error?> serverStreamingResponse = check ep->serverStreaming(serverStreamingRequest);
    check serverStreamingResponse.forEach(function(map<anydata> value) {
        io:println(value);
    });

    map<anydata> clientStreamingRequest = {message: "Hello Ballerina"};
    ClientStreamingStreamingClient clientStreamingStreamingClient = check ep->clientStreaming();
    check clientStreamingStreamingClient->sendStruct(clientStreamingRequest);
    check clientStreamingStreamingClient->complete();
    string? clientStreamingResponse = check clientStreamingStreamingClient->receiveString();
    io:println(clientStreamingResponse);

    StructMsg bidirectionalStreamingRequest = {name: "ballerina", struct: {message: "Hello Ballerina"}};
    BidirectionalStreamingStreamingClient bidirectionalStreamingStreamingClient = check ep->bidirectionalStreaming();
    check bidirectionalStreamingStreamingClient->sendStructMsg(bidirectionalStreamingRequest);
    check bidirectionalStreamingStreamingClient->complete();
    StructMsg? bidirectionalStreamingResponse = check bidirectionalStreamingStreamingClient->receiveStructMsg();
    io:println(bidirectionalStreamingResponse);
}

