# Change Log
This file contains all the notable changes done to the Ballerina gRPC package through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- [Address `CVE-2025-58056` and `CVE-2025-58057` security vulnerabilities in Netty](https://github.com/ballerina-platform/ballerina-library/issues/8214)

## [1.14.1] - 2025-08-21

### Fixed

- [Address `CVE-2025-55163` Netty vulnerability](https://github.com/ballerina-platform/ballerina-library/issues/8174)

## [1.14.0] - 2025-03-16

### Changed

- [Move SSL context creation to the client initialization](https://github.com/ballerina-platform/ballerina-library/issues/1798)
- [Update netty tcnative version](https://github.com/ballerina-platform/ballerina-library/issues/7650)
- [Update bouncy castle version to `1.80`](https://github.com/ballerina-platform/ballerina-library/issues/7683)

## [1.13.2] - 2025-02-14

### Changed

- [Downgrade netty tcnative version](https://github.com/ballerina-platform/ballerina-library/issues/7584)

## [1.13.1] - 2025-02-11

### Fixed

- [Address Netty security vulnerabilities: `CVE-2025-24970` and `CVE-2025-25193`](https://github.com/ballerina-platform/ballerina-library/issues/7571)

## [1.13.0] - 2025-02-07

### Fixed

- [Address CVE-2024-47535 vulnerability](https://github.com/ballerina-platform/ballerina-library/issues/7358)

## [1.12.1] - 2024-09-26

### Fixed

- [Address CVE-2024-7254 vulnerability](https://github.com/ballerina-platform/ballerina-library/issues/7013)

## [1.11.1] - 2024-06-27

### Fixed
- [Isolate `grpc:Caller` and `grpc:StreamingClient`](https://github.com/ballerina-platform/ballerina-library/issues/6656)

## [1.11.0] - 2024-05-03

### Fixed
- [Address CVE-2024-29025 netty's vulnerability](https://github.com/ballerina-platform/ballerina-library/issues/6242)
- [Fixed client headers getting forwarded back to client by the server](https://github.com/ballerina-platform/ballerina-library/issues/6334)

## [1.10.6] - 2024-02-01
### Added
- [Added `maxHeaderSize` in `grpc:ListenerConfiguration`](https://github.com/ballerina-platform/ballerina-library/issues/5969)

## [1.10.5] - 2024-01-22
### Fixed
- [Fixed the way of handling `grpc:RetryConfiguration`](https://github.com/ballerina-platform/ballerina-library/issues/5970)

## [1.10.4] - 2024-01-04
### Fixed
- [Fixed `grpc:ClientConfiguration` getting overwritten when mutliple clients are present](https://github.com/ballerina-platform/ballerina-library/issues/5892)

## [1.10.3] - 2023-11-21
### Fixed
- [Fixed serializing issue in repeated packed fields](https://github.com/ballerina-platform/ballerina-library/issues/5080)

### Changed
- [Make some of the Java classes proper utility classes](https://github.com/ballerina-platform/ballerina-standard-library/issues/4930)

## [1.10.2] - 2023-10-12
### Fixed
- [Address CVE-2023-4586 netty Vulnerability](https://github.com/ballerina-platform/ballerina-standard-library/issues/4908)

## [1.10.1] - 2023-10-02
### Fixed
- [Fixed error response from backend not getting properly propegated to the client](https://github.com/ballerina-platform/ballerina-standard-library/issues/4833)

## [1.9.1] - 2023-09-11
### Fixed
- [Address CVE-2023-33201 bouncy castle vulnerability](https://github.com/ballerina-platform/ballerina-standard-library/issues/4776)
- [Fixed performance issue due to `tcpnodelay` configuration](https://github.com/ballerina-platform/ballerina-standard-library/issues/4768)

## [1.9.0] - 2023-06-30
### Fixed
- [Add descriptor map to `grpc:Descriptor` and stub initialization](https://github.com/ballerina-platform/ballerina-standard-library/issues/4555)
- [Address CVE-2023-34462 netty Vulnerability](https://github.com/ballerina-platform/ballerina-standard-library/issues/4602)

## [1.8.1] - 2023-06-27
### Fixed
- [Address CVE-2023-34462 netty Vulnerability](https://github.com/ballerina-platform/ballerina-standard-library/issues/4602)

## [1.7.1] - 2023-06-30
### Fixed
- [Address CVE-2023-34462 netty Vulnerability](https://github.com/ballerina-platform/ballerina-standard-library/issues/4602)

## [1.6.1] - 2023-03-15
### Fixed
- [Fix SSL connection failure due to missing dependencies](https://github.com/ballerina-platform/ballerina-standard-library/issues/4197)

## [1.6.0] - 2023-02-20
### Added
- [Exit the application when panicking inside a service](https://github.com/ballerina-platform/ballerina-standard-library/issues/3604)
- [Log the errors returning from the service](https://github.com/ballerina-platform/ballerina-standard-library/issues/4047)

### Fixed
- [Java dependencies have not been included with group id & artifact id](https://github.com/ballerina-platform/ballerina-standard-library/issues/3789)

## [1.5.1] - 2022-12-22
### Fixed
- [Address CVE-2022-41915 netty Vulnerability](https://github.com/ballerina-platform/ballerina-standard-library/issues/3856)

## [1.5.0] - 2022-11-29
### Added
- [Added server reflection support for gRPC services](https://github.com/ballerina-platform/ballerina-standard-library/issues/399)
- [Added `gracefulStop` implementation for the `grpc:Listener`](https://github.com/ballerina-platform/ballerina-standard-library/issues/3527)

### Changed
- [Updated Protocol Buffers version to 3.21.7](https://github.com/ballerina-platform/ballerina-standard-library/issues/3478)
- [API Docs Updated](https://github.com/ballerina-platform/ballerina-standard-library/issues/3463)

### Fixed
- [Missing support for different int types](https://github.com/ballerina-platform/ballerina-standard-library/issues/3558)
- [Make descriptor const public in the generated stub file](https://github.com/ballerina-platform/ballerina-standard-library/issues/3653)

## [1.4.1] - 2022-10-06
### Fixed
- [Update protobuf-java version to fix protobuf vulnerability](https://github.com/ballerina-platform/ballerina-standard-library/issues/3493)
- [Fix no such record error when having the generated stub file in a separate module](https://github.com/ballerina-platform/ballerina-standard-library/issues/3655)

## [1.4.0] - 2022-09-08
### Added
- [Update gRPC ServiceDescriptor annotation to Descriptor](https://github.com/ballerina-platform/ballerina-standard-library/issues/3005)
- [Introduced message-level annotations for the proto descriptor instead of a centralized proto descriptor](https://github.com/ballerina-platform/ballerina-standard-library/issues/2796)
- [Introduced packaging support](https://github.com/ballerina-platform/ballerina-standard-library/issues/2798)
- [Removed caller client object when generating code in client mode](https://github.com/ballerina-platform/ballerina-standard-library/issues/3159)
- [Added sample client calls with dummy values to generated client files](https://github.com/ballerina-platform/ballerina-standard-library/issues/3131)

### Fixed
- [gRPC CLI unable to generate all files in nested directories](https://github.com/ballerina-platform/ballerina-standard-library/issues/2766)

## [1.2.3] - 2022-05-30
### Fixed
- [Incorrect stub generated for message with Any type field in gRPC tool](https://github.com/ballerina-platform/ballerina-standard-library/issues/2750)
- [Incorrect stub generation for repeated values of any, struct, timestamp, and duration messages](https://github.com/ballerina-platform/ballerina-standard-library/issues/2732)
- [Unable to pass protobuf predefined types as repeated values and values in messages](https://github.com/ballerina-platform/ballerina-standard-library/issues/2740)
- [Fixes incorrect caller type name validation in gRPC compiler plugin](https://github.com/ballerina-platform/ballerina-standard-library/issues/2867) 

### Added
- [Improve imports generation logic in gRPC tool](https://github.com/ballerina-platform/ballerina-standard-library/issues/2762)

## [1.2.1] - 2022-02-18
### Fixed
- [Fix issue in ordering of services with duplicate output types](https://github.com/ballerina-platform/ballerina-standard-library/issues/2637)
- [Improve the enum creation logic to escape case sensitivity](https://github.com/ballerina-platform/ballerina-standard-library/issues/2678)
- [Constraint the compiler plugin validations only for remote functions](https://github.com/ballerina-platform/ballerina-standard-library/issues/2695)
- [Fix name conflict - similar user defined messages as predefined Google types](https://github.com/ballerina-platform/ballerina-standard-library/issues/2692)

## [1.2.0] - 2022-01-29
### Fixed
- [Allow any function except `resource` function in gRPC services by the compiler plugin](https://github.com/ballerina-platform/ballerina-standard-library/issues/2617)

## [1.1.1] - 2021-12-15
### Changed
- [Pack HTTP library and remove repetitive JARs](https://github.com/ballerina-platform/module-ballerina-grpc/pull/598)

## [1.1.0] - 2021-12-13
### Added
- [Protobuf Any type support](https://github.com/ballerina-platform/module-ballerina-grpc/pull/509)

### Changed
- [Remove the start and stop logs of the listener](https://github.com/ballerina-platform/module-ballerina-grpc/pull/539)
- [Mark gRPC Service type distinct](https://github.com/ballerina-platform/ballerina-standard-library/issues/2398)
- [Make gRPC service type distinct](https://github.com/ballerina-platform/ballerina-standard-library/issues/2398)
- [Remove the start and stop logs of the listener](https://github.com/ballerina-platform/ballerina-standard-library/issues/2040)

## [1.0.0] - 2021-10-09
### Added
- [Add Timestamp record type generation and runtime support](https://github.com/ballerina-platform/ballerina-standard-library/issues/393)
- [Add gRPC Duration support](https://github.com/ballerina-platform/ballerina-standard-library/issues/1610)
- [Support a directory with protos as input in gRPC tool](https://github.com/ballerina-platform/ballerina-standard-library/issues/1626)
- [Support external import paths in gRPC tool](https://github.com/ballerina-platform/ballerina-standard-library/issues/1612)
- [Add OAuth2 JWT bearer grant type support](https://github.com/ballerina-platform/ballerina-standard-library/issues/1788)
- [Add authorization with JWTs with multiple scopes](https://github.com/ballerina-platform/ballerina-standard-library/issues/1801)
- [Enable gRPC trace and access logs for debugging](https://github.com/ballerina-platform/ballerina-standard-library/issues/1826)

### Changed
- [Change the group ID and rename the sub modules](https://github.com/ballerina-platform/ballerina-standard-library/issues/1623)

### Fixed 
- [Fix invalid string value for cert validation type in GrpcConstants.java](https://github.com/ballerina-platform/ballerina-standard-library/issues/1631)
- [Fix invalid int value conversion in GrpcUtil.java for cert validation](https://github.com/ballerina-platform/ballerina-standard-library/issues/1632)
- [Fix the gRPC backward incompatibility issue when adding a new field](https://github.com/ballerina-platform/ballerina-standard-library/issues/1572)
- [Fix Gzip compression at the server-side](https://github.com/ballerina-platform/ballerina-standard-library/issues/1899)
- [Fix initiating auth handlers per each request](https://github.com/ballerina-platform/ballerina-standard-library/issues/2394)

## [0.8.0-beta.2] - 2021-07-06
### Changed
- Rename `grpc:ListenerLdapUserStoreBasicAuthProvider` as `grpc:ListenerLdapUserStoreBasicAuthHandler`

### Fixed
- [Streaming services unable to resolve with context objects](https://github.com/ballerina-platform/ballerina-standard-library/issues/1504)
- [gRPC client streaming and bidirectional streaming fail to pass headers](https://github.com/ballerina-platform/ballerina-standard-library/issues/1458)
- [Function `isCancelled()` of caller is not generated in the stub file](https://github.com/ballerina-platform/ballerina-standard-library/issues/1503)
- [gRPC service and client cannot pass a header list](https://github.com/ballerina-platform/ballerina-standard-library/issues/1510)
- [Manual Service registration testcase is not working](https://github.com/ballerina-platform/ballerina-standard-library/issues/724)
- [CLI does not generate streaming context for client streaming services](https://github.com/ballerina-platform/ballerina-standard-library/issues/1457)
- [Context input parameter does not handle in server streaming client](https://github.com/ballerina-platform/ballerina-standard-library/issues/1531)
- [Server streaming stub generation does not allow empty parameters](https://github.com/ballerina-platform/ballerina-standard-library/issues/1536)
- [Bugs in streaming with Empty Type](https://github.com/ballerina-platform/ballerina-standard-library/issues/387)
- [File joinPath API fails for a path with space in Windows](https://github.com/ballerina-platform/ballerina-standard-library/issues/1267)

## [0.8.0-beta.1.1] - 2021-06-07
### Fixed 
- [Remove unnecessary Snake YAML JAR](https://github.com/ballerina-platform/ballerina-standard-library/issues/1432)

## [0.8.0-beta.1] - 2021-06-02
### Changed
- [Generate protobuf definition bal files using Ballerina syntax tree api](https://github.com/ballerina-platform/ballerina-standard-library/issues/1103)
- [Update the netty library version to 4.1.63.Final and the netty tc native to 2.0.31.Final](https://github.com/ballerina-platform/ballerina-standard-library/issues/1584)
- [Make file user store basic auth handler isolated](https://github.com/ballerina-platform/ballerina-standard-library/issues/584)

### Fixed
- [Illegal reflective access warning from handlebar](https://github.com/ballerina-platform/ballerina-standard-library/issues/385)
- [gRPC service function with caller param validates incorrectly](https://github.com/ballerina-platform/ballerina-standard-library/issues/1317)

## [0.8.0-alpha8] - 2021-04-23
### Added
- [compiler plugin validation for services in the gRPC package](https://github.com/ballerina-platform/ballerina-standard-library/issues/814)


## [0.8.0-alpha7] - 2021-04-06
### Fixed
- [Extra empty message received with gRPC bidirectional streaming](ballerina-platform/ballerina-standard-library/issues/1152)


## [0.8.0-alpha6] - 2021-04-02
### Changed
- [Make gRPC stream completion with nil](https://github.com/ballerina-platform/ballerina-standard-library/issues/1209).
