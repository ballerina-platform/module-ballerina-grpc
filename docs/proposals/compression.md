# Proposal: gRPC Compression

_Ownes_: @shafreenAnfar @daneshk @BuddhiWathsala @MadhukaHarith92 @dilanSachi  
_Reviewers_: @shafreenAnfar @daneshk  
_Created_: 2021/09/23  
_Issues_: [#1899](https://github.com/ballerina-platform/ballerina-standard-library/issues/1899) [#1952](https://github.com/ballerina-platform/ballerina-standard-library/issues/1952)

## Summary
Add gRPC compression support for Ballerina gRPC client and server. Currently, Ballerina client to server compression works without an issue. Here, we are going to improve the server-side support for gRPC compression by implementing the compression mechanism and improving the compressor selection logic.

## Goals
To support message compression between gRPC client and server communication.

## Non-Goals
Support message compression for each gRPC channel.

## Motivation
- To reduce the bandwidth consumed by the communication between gRPC server and client using message compressing.
- To pass large messages between the gRPC client and server.

## Description

Both the gRPC client and server can support message compression independently without interfering with each other. Therefore, we have to handle four main scenarios as described in the following table. Here, we assume both client and server support a similar set of compression algorithms.

|Scenario|Client|Server|Request|Response|Status|
|---|---|---|---|---|---|
|1|Compression disabled|Compression disabled|Not compressed|Not compressed|Successful|
|2|Compression enabled|Compression disabled|Compressed|Not compressed|Successful|
|3|Compression disabled|Compression enabled|Not compressed|Compressed|Successful|
|4|Compression enabled|Compression enabled|Compressed|Compressed|Successful|

The client and the server behaviour should be as follows when they support a different set of compression algorithms [1].
- If a client sent a message which is compressed by an algorithm that the server does not support, then the server must fail with the status `UNIMPLEMENTED`.
- If a server sent a message which is compressed by an algorithm that the client does not support, then the client must fail with an `INTERNAL` error.

There should be an API to enable the compression at the client and server sides. To do that, we introduce the following API that takes the inputs as compression type and optional header map and returns a header map. This API sets the `grpc-encoding` header with the relevant value that corresponds to the given compression type. For example, in Gzip case, the `grpc-encoding` header value sets as `gzip`.

### Case 01
```ballerina
map<string|string[]> headers = grpc:setCompression(grpc:GZIP);
```

### Case 02
```ballerina
map<string|string[]> headers = {};
// Update headers according to the requirements
headers = grpc:setCompression(grpc:GZIP, headers);
```

## Testing
We have to test this functionality based on the following scenarios.
- A server must return the status `UNIMPLEMENTED` when the client sent a message which is compressed by an algorithm that the server does not support.
- A client must return an `INTERNAL` error at the client-side when the server sent a message which is compressed by an algorithm that the client does not support.
- Verify the message compression at the client and the server sides.


## References
[1] https://github.com/grpc/grpc/blob/v1.40.0/doc/compression.md
