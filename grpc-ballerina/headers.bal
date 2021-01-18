// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# Returns the header value with the specified header name. If there are more than one header values for the
# specified header name, the first value is returned.
# ```ballerina
# string? result = grpc:getHeader("content-type");
# ```
#
# + headerMap - The header map instance.
# + headerName - The header name
# + return - First header value if exists or else error
public isolated function getHeader(map<string|string[]> headerMap, string headerName) returns string|Error {
    if (!headerMap.hasKey(headerName)) {
        return error NotFoundError("Header does not exist for " + headerName);
    }
    string|string[] headerValue = headerMap.get(headerName);
    if (headerValue is string) {
        return headerValue;
    } else if (headerValue.length() > 0) {
        return headerValue[0];
    } else {
        return error NotFoundError("Header value does not exist for " + headerName);
    }
}

# Gets all the transport headers with the specified header name.
# ```ballerina
# string[] result = grpc:getHeaders(map<string|string[]> headerMap, "content-type");
# ```
#
# + headerMap - The header map instance.
# + headerName - The header name
# + return - Header value array
public isolated function getHeaders(map<string|string[]> headerMap, string headerName) returns string[]|Error {
    if (!headerMap.hasKey(headerName)) {
        return error NotFoundError("Header does not exist for " + headerName);
    }
    string|string[] headerValue = headerMap.get(headerName);
    if (headerValue is string) {
        return [headerValue];
    } else {
        return headerValue;
    }
}
