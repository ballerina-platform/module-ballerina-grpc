# Asynchronous Streaming

## Overview
The primary goal of this example is to demonstrate how to implement an asynchronous gRPC call in Ballerina. Here, the RPC call happens in one strand (i.e., a lightweight thread in Ballerina) while the other phone call processing happens in another strand simultaneously. This is the Ballerina implementation of [this asynchronous streaming Python example](https://github.com/grpc/grpc/blob/v1.43.2/examples/python/async_streaming/phone.proto).

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

There are two workers used in this example, one worker to handle the lifecycle of the phone call, and the other worker to handle the audio stream.
```ballerina
// Handle the audio stream
worker Streamer returns error? {
    log:printInfo(string `Waiting for peer to connect [${phoneNumber}]...`);
    while !isResponded() {
    }
}

// Handle the call status
worker Caller returns error? {
    StreamCallResponse? response = check streamCall->receiveStreamCallResponse();
    while response != () {
        if response?.call_info is CallInfo {
            CallInfo callInfo = <CallInfo>response?.call_info;
            sessionId = callInfo.session_id;
            media = callInfo.media;
        } else if response?.call_state is CallState {
            CallState currentState = <CallState>(response?.call_state);
            callState = currentState.state;
            onCallState(phoneNumber);
        }
        response = check streamCall->receiveStreamCallResponse();
    }
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

### Server-Side Output
```sh
time = 2022-03-07T14:25:26.880+05:30 level = INFO module = ballerina/async_server message = "Received a phone call request for number 94771234567"
time = 2022-03-07T14:25:28.910+05:30 level = INFO module = ballerina/async_server message = "Created a call session => session ID: 0, media: https://link.to.audio.resources"
time = 2022-03-07T14:25:29.915+05:30 level = INFO module = ballerina/async_server message = "Call finished [94771234567]"
time = 2022-03-07T14:25:29.916+05:30 level = INFO module = ballerina/async_server message = "Call session cleaned => session ID: 0, media: https://link.to.audio.resources"
```

### Client-Side Output
```sh
time = 2022-03-07T14:25:26.663+05:30 level = INFO module = ballerina/async_client message = "Waiting for peer to connect [94771234567]..."
time = 2022-03-07T14:25:27.954+05:30 level = INFO module = ballerina/async_client message = "Call toward [94771234567] enters [NEW] state"
time = 2022-03-07T14:25:28.916+05:30 level = INFO module = ballerina/async_client message = "Call toward [94771234567] enters [ACTIVE] state"
time = 2022-03-07T14:25:28.919+05:30 level = INFO module = ballerina/async_client message = "Consuming audio resource [https://link.to.audio.resources]"
time = 2022-03-07T14:25:29.917+05:30 level = INFO module = ballerina/async_client message = "Call toward [94771234567] enters [ENDED] state"
time = 2022-03-07T14:25:29.918+05:30 level = INFO module = ballerina/async_client message = "Audio session finished [https://link.to.audio.resources]"
time = 2022-03-07T14:25:29.920+05:30 level = INFO module = ballerina/async_client message = "Call finished"
```
