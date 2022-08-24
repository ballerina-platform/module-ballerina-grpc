import ballerina/io;
import ballerina/protobuf.types.'any;

AnyTypeServerClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    'any:Any unaryCall1Request = check 'any:pack("ballerina");
    'any:Any unaryCall1Response = check ep->unaryCall1(unaryCall1Request);
    io:println(unaryCall1Response);

    'any:Any unaryCall2Request = check 'any:pack("ballerina");
    'any:Any unaryCall2Response = check ep->unaryCall2(unaryCall2Request);
    io:println(unaryCall2Response);

    'any:Any unaryCall3Request = check 'any:pack("ballerina");
    'any:Any unaryCall3Response = check ep->unaryCall3(unaryCall3Request);
    io:println(unaryCall3Response);

    'any:Any serverStreamingCallRequest = check 'any:pack("ballerina");
    stream<'any:Any, error?> serverStreamingCallResponse = check ep->serverStreamingCall(serverStreamingCallRequest);
    check serverStreamingCallResponse.forEach(function('any:Any value) {
        io:println(value);
    });

    'any:Any clientStreamingCallRequest = check 'any:pack("ballerina");
    ClientStreamingCallStreamingClient clientStreamingCallStreamingClient = check ep->clientStreamingCall();
    check clientStreamingCallStreamingClient->sendAny(clientStreamingCallRequest);
    check clientStreamingCallStreamingClient->complete();
    'any:Any? clientStreamingCallResponse = check clientStreamingCallStreamingClient->receiveAny();
    io:println(clientStreamingCallResponse);

    'any:Any bidirectionalStreamingCallRequest = check 'any:pack("ballerina");
    BidirectionalStreamingCallStreamingClient bidirectionalStreamingCallStreamingClient = check ep->bidirectionalStreamingCall();
    check bidirectionalStreamingCallStreamingClient->sendAny(bidirectionalStreamingCallRequest);
    check bidirectionalStreamingCallStreamingClient->complete();
    'any:Any? bidirectionalStreamingCallResponse = check bidirectionalStreamingCallStreamingClient->receiveAny();
    io:println(bidirectionalStreamingCallResponse);
}

