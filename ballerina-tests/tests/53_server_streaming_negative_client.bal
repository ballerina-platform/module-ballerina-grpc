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

import ballerina/grpc;
import ballerina/test;

@test:Config {enable: true}
isolated function testServerStreamingNegative() returns error? {
    HelloWorld53Client ep = check new ("http://localhost:9153");
    stream<string, error?> strm = check ep->hello53("hey");
    record {|string value;|}|error? content = strm.next();
    if content is error {
        test:assertFail(content.message());
    } else {
        test:assertEquals(content["value"], "a");
    }

    check strm.close();
    record {|string value;|}|error? result = strm.next();
    if result is grpc:Error {
        test:assertEquals(result.message(), "Stream is closed. Therefore, no operations are allowed further on the stream.");
    } else {
        test:assertFail("Expected an error");
    }

    error? response = strm.close();
    test:assertTrue(response is grpc:Error);
    test:assertEquals((<grpc:Error>response).message(), "Stream is closed. Therefore, no operations are allowed further on the stream.");
}
