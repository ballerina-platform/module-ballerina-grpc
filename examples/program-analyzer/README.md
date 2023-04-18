[![Star on Github](https://img.shields.io/badge/-Star%20on%20Github-blue?style=social&logo=github)](https://github.com/ballerina-platform/module-ballerina-grpc)

_Authors_: @BuddhiWathsala  
_Reviewers_: @shafreenAnfar @daneshK  
_Created_: 2022/01/11  
_Updated_: 2023/04/18

# Program Analyzer

## Overview

This example demonstrates how to send a large payload in gRPC by enabling Gzip compression. It also shows how to change the default message size on the client-side.

## Implementation

The server implementation of the program analyzer example returns a sample syntax tree of a Ballerina program as a string payload. This payload is more than 7MB large, and therefore, directly sending the raw data is difficult and inefficient. To address these problems, Gzip compression is enabled in this example using the following API.

```ballerina
map<string|string[]> compression = grpc:setCompression(grpc:GZIP);
```

Also, this example demonstrates how to change the maximum inbound message on the client-side.

```ballerina
BalProgramAnalyzerClient ep = check new ("http://localhost:8981", maxInboundMessageSize = 424193);
```


## Run the Example

First, clone this repository, and then run the following commands to run this example in your local machine.

```sh
// Run the program analyzer server in port 8981
$ cd examples/program-analyzer/server
$ bal run
```

In another terminal, run the client as follows.
```sh
// Run the program analyzer client
$ cd examples/program-analyzer/client
$ bal run
```
