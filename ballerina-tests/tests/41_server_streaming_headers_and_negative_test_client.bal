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
import ballerina/protobuf.types.wrappers;

@test:Config {enable: true}
isolated function testServerStreamingWithCustomHeaders() returns grpc:Error? {
    Chat41Client ep = check new ("http://localhost:9141");
    wrappers:ContextStringStream call1 = check ep->call1Context({name: "John", message: "Hi Bella"});
    test:assertEquals(call1.headers["h1"], "v1");
}

@test:Config {enable: true}
isolated function testServerStreamingWithCustomError() returns error? {
    Chat41Client ep = check new ("http://localhost:9141");
    stream<string, error?> strm = check ep->call2({name: "John", message: "Hi Bella"});
    var response = strm.next();
    test:assertTrue(response is grpc:Error);
    test:assertEquals((<grpc:Error>response).message(), "Unknown gRPC error occured.");
}
