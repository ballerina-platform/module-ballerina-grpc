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

final HelloWorld98Client helloWorld5BlockingEp = check new ("http://localhost:9095");

@test:Config {enable: true}
function testInvalidRemoteMethod() {
    string name = "WSO2";
    string|grpc:Error result = helloWorld5BlockingEp->hello(name);
    test:assertTrue(result is grpc:Error);
    test:assertEquals((<grpc:Error>result).message(), "No registered method descriptor for 'grpcservices.HelloWorld98/hello1'");
}

@test:Config {enable: true}
function testInvalidInputParameter() returns grpc:Error? {
    string age = "";
    int response = check helloWorld5BlockingEp->testInt(age);
    test:assertEquals(response, -1);
}
