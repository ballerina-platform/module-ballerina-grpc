Ballerina gRPC Library
===================

  [![Build](https://github.com/ballerina-platform/module-ballerina-grpc/workflows/Build/badge.svg)](https://github.com/ballerina-platform/module-ballerina-grpc/actions?query=workflow%3A"Build+master+branch")
  [![Daily build](https://github.com/ballerina-platform/module-ballerina-grpc/workflows/Daily%20build/badge.svg)](https://github.com/ballerina-platform/module-ballerina-grpc/actions?query=workflow%3A%22Daily+build%22)
  [![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerina-grpc.svg)](https://github.com/ballerina-platform/module-ballerina-grpc/commits/master)
  [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The gRPC library is one of the standard library modules of the<a target="_blank" href="https://ballerina.io/"> Ballerina</a> language.

This provides support for the gRPC messaging protocol. gRPC is an inter-process communication technology that allows you to connect, invoke and operate distributed heterogeneous applications as easily as making a local function call. The gRPC protocol is layered over HTTP/2 and It uses Protocol Buffers for marshaling/unmarshaling messages. This makes gRPC, highly efficient on wire and a simple service definition framework.

This Library supports below messaging patterns. For more information on the operations supported, go to [The gRPC Module](https://ballerina.io/swan-lake/learn/api-docs/ballerina/grpc/).

- Simple RPC (Unary RPC)
- Server streaming RPC
- Client streaming RPC
- Bidirectional Streaming RPC

For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/swan-lake/learn/by-example).

## Building from the Source

Execute the commands below to build from source.

1. To build the library:
        
        ./gradlew clean build

2. To run the integration tests:

        ./gradlew clean test

3. To build the module without the tests:

        ./gradlew clean build -x test

4. To debug the tests:

        ./gradlew clean build -Pdebug=<port>

## Contributing to Ballerina

As an open source project, Ballerina welcomes contributions from the community. 

You can also check for [open issues](https://github.com/ballerina-platform/module-ballerina-grpc/issues) that interest you. We look forward to receiving your contributions.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of Conduct

All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful Links

* Discuss about code changes of the Ballerina project in [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
* Chat live with us via our [Slack channel](https://ballerina.io/community/slack/).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
* View the [Ballerina performance test results](performance/benchmarks/summary.md).