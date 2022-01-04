// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

@test:Config {enable:true}
isolated function testClientTimeout() returns grpc:Error? {
    HelloWorld14Client ep = check new("http://localhost:9104", timeout = 1);
    string|grpc:Error err = ep->hello("Hello");
    test:assertTrue(err is grpc:Error);
    test:assertEquals((<grpc:Error>err).message(), "Idle timeout triggered before initiating inbound response");
}

@test:Config {}
isolated function testConnectionRefused() returns grpc:Error? {
    HelloWorld14Client ep = check new("http://localhost:1111", timeout = 1);
    string|grpc:Error err = ep->hello("Hello");
    test:assertTrue(err is grpc:Error);
    test:assertEquals((<grpc:Error>err).message(), "Connection refused: localhost/127.0.0.1:1111");
}

