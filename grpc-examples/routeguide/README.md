# Route Guide

## Overview

Route guide is the standard example that has been used in the gRPC documentation to explain the overall gRPC usage. It contains all four RPCs (Remote Procedure Calls); simple, server streaming, client streaming, and bidirectional streaming. To understand gRPC concepts in detail, refer to the [gRPC core concepts documentation](https://grpc.io/docs/what-is-grpc/core-concepts/).

## Implementation

The server and client implementation of this example implemented using Ballerina gRPC package. The four RPC calls in this example are as follows:

1. GetFeature
    - This is a simple RPC call. It returns the feature description for a given point. Here, the client sends a request to the server, and the server responds with a single response, similar to a typical function call.
2. ListFeatures
    - This server streaming RPC call returns a set of features related to a given rectangular area. Here, the client sends the rectangular area coordinates as a single request, and the server returns a stream of features.
3. RecordRoute
    - This client streaming RPC call accepts a set of points that someone has traversed and return the summary of the route as a single response. Here, the client sends a stream of points to the server, and the server returns the route summary as a single response.
4. RouteChat
    - This bidirectional RPC call accepts a set of route notes and returns a set of route notes. Here, the client sends a stream of route notes to the server, and the server returns a stream of route notes related to a particular route. When the server sends the notes, it will take the notes that have sent by the other users.

## Run the Example

First, clone this repository, and then run the following commands to run this example in your local machine.

```sh
// Run the route guide server in port 8980
$ cd grpc-examples/routeguide/server
$ bal run
```

In another terminal, run the client as follows.
```
// Run the route guide client
$ cd grpc-examples/routeguide/client
$ bal run
```
