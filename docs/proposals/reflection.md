# Proposal: gRPC Reflection Support

_Owners_: @shafreenAnfar @daneshk @MadhukaHarith92 @dilanSachi  
_Reviewers_: @shafreenAnfar @daneshk  
_Created_: 2022/09/01  
_Updated_: 2022/10/14  
_Issues_: [#399](https://github.com/ballerina-platform/ballerina-standard-library/issues/399) [#3306](https://github.com/ballerina-platform/ballerina-standard-library/issues/3306)

## Summary
Server reflection is an optional gRPC feature for servers to assist clients in runtime construction of requests without having stub information precompiled into the client. With the user defined service, a predefined standard service is started to provide service information to the clients. This proposal discusses how to implement gRPC server reflection to the existing Ballerina gRPC implementation.

## Goals
To add gRPC server reflection feature into the current Ballerina gRPC implementation.

## Motivation
Currently, to interact with a Ballerina gRPC service, the client needs to have access the protobuf service definition. But with the reflection support debugging tools like gRPC CLI [1], gRPCurl [2] can talk to a Ballerina gRPC service without precompiled service information.

## Description
Server reflection is a gRPC feature that allows clients such as command-line tools for debugging, to discover the protocol used by a gRPC server at run time. It provides information about publicly-accessible gRPC services on a server, and assists clients at runtime to construct RPC requests and responses without precompiled service information. This feature is currently implemented by most of the popular gRPC implementations [3, 4, 5].

For the implementation, there is an already defined protocol published here [6]. In both `go` and `java` reflection implementations, when a user needs to enable reflection in their service, they need to register another `ServerReflection` reflection service which will handle the reflection requests from external clients.

In Ballerina context, what we need to implement is, when a gRPC service is up and running, another `ServerReflection` service has to run attached to the same listener which listens to reflection requests from clients and respond with the service metadata.

The `ServerReflection` service has a bidirectional rpc method which accepts `ServerReflectionRequest` requests and responds with `ServerReflectionResponse` responses.

```protobuf
message ServerReflectionRequest {
  string host = 1;
  // To use reflection service, the client should set one of the following
  // fields in message_request. The server distinguishes requests by their
  // defined field and then handles them using corresponding methods.
  oneof message_request {
    // Find a proto file by the file name.
    string file_by_filename = 3;

    // Find the proto file that declares the given fully-qualified symbol name.
    // This field should be a fully-qualified symbol name
    // (e.g. <package>.<service>[.<method>] or <package>.<type>).
    string file_containing_symbol = 4;

    // Find the proto file which defines an extension extending the given
    // message type with the given field number.
    ExtensionRequest file_containing_extension = 5;

    // Finds the tag numbers used by all known extensions of the given message
    // type, and appends them to ExtensionNumberResponse in an undefined order.
    // Its corresponding method is best-effort: it's not guaranteed that the
    // reflection service will implement this method, and it's not guaranteed
    // that this method will provide all extensions. Returns
    // StatusCode::UNIMPLEMENTED if it's not implemented.
    // This field should be a fully-qualified type name. The format is
    // <package>.<type>
    string all_extension_numbers_of_type = 6;

    // List the full names of registered services. The content will not be
    // checked.
    string list_services = 7;
  }
}
```

```protobuf
message ServerReflectionResponse {
  string valid_host = 1;
  ServerReflectionRequest original_request = 2;
  // The server set one of the following fields accroding to the message_request
  // in the request.
  oneof message_response {
    // This message is used to answer file_by_filename, file_containing_symbol,
    // file_containing_extension requests with transitive dependencies. As
    // the repeated label is not allowed in oneof fields, we use a
    // FileDescriptorResponse message to encapsulate the repeated fields.
    // The reflection service is allowed to avoid sending FileDescriptorProtos
    // that were previously sent in response to earlier requests in the stream.
    FileDescriptorResponse file_descriptor_response = 4;

    // This message is used to answer all_extension_numbers_of_type requst.
    ExtensionNumberResponse all_extension_numbers_response = 5;

    // This message is used to answer list_services request.
    ListServiceResponse list_services_response = 6;

    // This message is used when an error occurs.
    ErrorResponse error_response = 7;
  }
}
```

This is a standard protobuf definition, and the complete service definition can be found here [7].

Since supporting reflection in a service is optional, user will be given a config to enable or disable server reflection in their listener.
```ballerina
public type ListenerConfiguration record {|
    string host = "0.0.0.0";
    ListenerSecureSocket? secureSocket = ();
    decimal timeout = DEFAULT_LISTENER_TIMEOUT;
    int maxInboundMessageSize = 4194304;
    boolean reflectionEnabled = false;
|};
```
If enabled, all the services attached to the listener will be reflected to external clients. In the runtime, a `ServerReflection` service will be created dynamically which will handle the reflection requests and respond with the required metadata.

## Testing
Since what reflection does is basically expose a gRPC service which communicates service metadata, we can test this using a simple Ballerina gRPC client. If it is needed, we can use the gRPC CLI [1] to test the implementation too.

## Risks and Assumptions
Since all the services attached to a listener are exposed via reflection, internal services that are not needed to be exposed will also be exposed.

## References
[1] https://github.com/grpc/grpc/blob/master/doc/command_line_tool.md#grpc-command-line-tool
[2] https://github.com/fullstorydev/grpcurl
[3] https://github.com/grpc/grpc-java/blob/master/documentation/server-reflection-tutorial.md#enable-server-reflection
[4] https://github.com/grpc/grpc-go/blob/master/Documentation/server-reflection-tutorial.md#enable-server-reflection
[5] https://grpc.github.io/grpc/cpp/md_doc_server_reflection_tutorial.html
[6] https://github.com/grpc/grpc/blob/master/doc/server-reflection.md
[7] https://github.com/grpc/grpc/blob/master/src/proto/grpc/reflection/v1alpha/reflection.proto

