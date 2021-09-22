// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

# Compression types that are supported.
# GZIP - Gzip compression
public enum CompressionType {
   GZIP = "gzip"
}

# Enables the compression support by adding the `grpc-encoding` header to the given headers.
# ```ballerina
# map<string|string[]> headers = grpc:setCompression(grpc:GZIP);
# ```
#
# + compressionType - The compression type.
# + headerMap - Optional header map (if this is not specified, it creates a new header set)
# + return - The header map that includes the compression headers
public isolated function setCompression(CompressionType compressionType, map<string|string[]> headerMap = {}) returns map<string|string[]> {
    headerMap["grpc-encoding"] = compressionType;
    return headerMap;
}

