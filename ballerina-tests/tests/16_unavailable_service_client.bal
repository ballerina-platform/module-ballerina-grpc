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

import ballerina/grpc;
import ballerina/test;

// TODO: enable after fixing this issue - https://github.com/ballerina-platform/ballerina-library/issues/7436
@test:Config {enable: false}
isolated function testInvokeUnavailableService() returns grpc:Error? {
    HelloWorld16Client helloWorld16BlockingEp = check new ("http://localhost:9106");
    string name = "WSO2";
    string|grpc:Error response = helloWorld16BlockingEp->hello(name);
    test:assertTrue(response is grpc:Error);
    test:assertTrue((<grpc:Error>response).message().startsWith("Connection refused:"), msg = "Failed with error: " +
        (<grpc:Error>response).message());
}
