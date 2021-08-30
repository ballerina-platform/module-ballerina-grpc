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

import ballerina/test;

@test:Config {enable: true}
function testHello56BiDi() returns error? {
    HelloWorld56Client hClient = check new ("http://localhost:9156");
    Hello56BiDiStreamingClient strClient = check hClient->hello56BiDi();
    check strClient->sendString("Hello from client");
    Error|string? result = strClient->receiveString();
    if result is Error {
        test:assertEquals(result.message(), "Test error from service");
    } else {
        test:assertFail(msg = "Expected an error");
    }
}

@test:Config {enable: true}
function testHello56Unary() returns error? {
    HelloWorld56Client hClient = check new ("http://localhost:9156");
    Error|string? result = hClient->hello56Unary("Hello from client");
    if result is Error {
        test:assertEquals(result.message(), "Test error from service");
    } else {
        test:assertFail(msg = "Expected an error");
    }
}
