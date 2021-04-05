# Change Log
This file contains all the notable changes done to the Ballerina gRPC package through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.0-alpha6] - 2021-04-02

### Added
- [Make gRPC stream completion with nil](https://github.com/ballerina-platform/ballerina-standard-library/issues/1209)
    Migrate to new streaming changes which changed stream<string, error> to stream<string, error?> and change gRPC stream
 completion to return nil value.