# Proposal: gRPC Message Size Configuration

_Owners_: @shafreenAnfar @daneshk @BuddhiWathsala @MadhukaHarith92 @dilanSachi  
_Reviewers_: @shafreenAnfar @daneshk  
_Created_: 2021/11/30   
_Issues_: [#2052](https://github.com/ballerina-platform/ballerina-standard-library/issues/2052) [#2444](https://github.com/ballerina-platform/ballerina-standard-library/issues/2444)

## Summary
Add configurations to change the default gRPC message size. Currently, Ballerina gRPC default message size is 4 MB. This size is enough for most use cases, but better to have a configuration to change the default message size in case a user want to receive a large payload.

## Goals
To provide configurations to change the default message size.

## Non-Goals
Provide a mechanism to help prevent gRPC from consuming excessive resources.

## Motivation
To pass large messages between the gRPC client and server.

## Description

Currently, Ballerina gPRC supports receiving messages of size up to 4 MB and there is no size limit on outbound messages. By limiting the inbound message size, a protection is provided to clients who haven't considered the possibility of receiving large messages while trying to be large enough to not be hit in normal usage. No limit is provided for outbound messages since it is the decision of the user to send large messages. This default behaviour can be seen in other existing implementations too. But those implementations provide the user with the facility to limit both the outbound message size, and the inbound message size [1,2,3,4].

This feature needs to be introduced in Ballerina gRPC implementation as well. For that, two additional configurations will be added in both client and listener configurations as follows which allows to change the outbound message size (`maxOutboundMessageSize`) and inbound message size (`maxInboundMessageSize`). `maxInboundMessageSize` will have a default value of 4 MB while `maxOutboundMessageSize` will be unlimited.

### Listener Configurations
```ballerina
# Configurations for managing the gRPC server endpoint.
#
# + maxOutboundMessageSize - The maximum message size to be permitted for outbound messages
# + maxInboundMessageSize - The maximum message size to be permitted for inbound messages
public type ListenerConfiguration record {|
    int maxOutboundMessageSize = -1;
    int maxInboundMessageSize = 4194304;
|};
```

### Client Configurations
```ballerina
# Configurations for managing the gRPC client endpoint.
#
# + maxOutboundMessageSize - The maximum message size to be permitted for outbound messages
# + maxInboundMessageSize - The maximum message size to be permitted for inbound messages
public type ClientConfiguration record {|
    int maxOutboundMessageSize = -1;
    int maxInboundMessageSize = 4194304;
|};
```

The client and the server behaviour should be as follows when supporting dynamic message sizes.
- If a Server/Client sends a message which is larger than the specified `maxOutboundMessageSize` size, the Server/Client must fail with `RESOURCE_EXHAUSTED` error.
- If a Server/Client sends a message which is larger than the specified `maxInboundMessageSize` size, the Client/Server must fail with `RESOURCE_EXHAUSTED` error.


## Testing
We have to test this functionality based on the following scenarios.
- Server/Client must return a `RESOURCE_EXHAUSTED` error when trying to send a message with a size larger than the specified `maxOutboundMessageSize` size.
- Server/Client must return a `RESOURCE_EXHAUSTED` error when the Client/Server sends a message which is larger than the specified `maxInboundMessageSize` size.
- Server/Client must communicate successfully when sending and receiving messages with the specified `maxOutboundMessageSize` and `maxInboundMessageSize` sizes.


## References
[1] https://pkg.go.dev/google.golang.org/grpc#MaxRecvMsgSize    
[2] https://pkg.go.dev/google.golang.org/grpc#MaxSendMsgSize    
[3] https://grpc.github.io/grpc-java/javadoc/io/grpc/stub/AbstractStub.html#withMaxOutboundMessageSize-int-     
[4] https://docs.microsoft.com/en-us/aspnet/core/grpc/security?view=aspnetcore-6.0#message-size-limits  
