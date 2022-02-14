# Asynchronous Streaming

## Overview
The primary goal of this example is to demonstrate how to implement an asynchronous gRPC call in Ballerina. Here, the RPC call happens in one strand (i.e., a lightweight thread in Ballerina) while the other phone call processing happens in another strand simultaneously.

## Implementation
This example contains a bidirectional RPC. In Ballerina, the invocation of a bidirectional RPC (or even in a client streaming RPC) returns a streaming client, which can be used to receive or send messages.
```ballerina
StreamCallStreamingClient streamingClient = check ep->StreamCall();
// ...

// Send messages using the streaming client
check streamingClient->sendStreamCallRequest({phone_number: phoneNumber});

// Complete the message sending
check streamingClient->complete();

// Receive the messages from the server
StreamCallResponse? response = check streamCall->receiveStreamCallResponse();
```

There are two workers have been used in this example, one worker to handle the lifecycle of the phone call, and the other worker to handle the audio stream.
```ballerina
// Handle the audio stream
worker Caller returns error? {
    if waitPeer(phoneNumber) {
        audioSession();
    }
    [peerResponded, callFinished] = check <- CallStatusChecker;
}

// Handle the call status
worker CallStatusChecker returns [boolean, boolean]|error {
    check streamingClient->sendStreamCallRequest({phone_number: phoneNumber});
    check streamingClient->complete();
    check call(streamingClient);
    [peerResponded, callFinished] -> Caller;
    return [peerResponded, callFinished];
}
```

## Run the Example

First, clone this repository, and then run the following commands to run this example in your local machine.

```sh
// Run the aynchronous streaming server in port 8981
$ cd examples/async-streaming/server
$ bal run
```

In another terminal, run the client as follows.
```sh
// Run the aynchronous streaming client
$ cd examples/async-streaming/client
$ bal run
```
