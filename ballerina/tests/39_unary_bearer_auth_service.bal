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

listener Listener ep39 = new (9129);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_39,
    descMap: getDescriptorMap39()
}
service "HelloWorld39" on ep39 {

    isolated remote function testStringValueReturn(ContextString request) returns string|error {
        if !request.headers.hasKey(AUTH_HEADER) {
            return error AbortedError("AUTH_HEADER header is missing");
        } else if request.headers.get(AUTH_HEADER) == "Bearer eyJhbGciOiJSUzI1NiIsICJ0eXAiOiJKV1QifQ" {
            return "Hello WSO2";
        } else {
            return error UnauthenticatedError(string `Invalid basic auth token: ${<string>request.headers.get(
            AUTH_HEADER)}`);
        }
    }
}
