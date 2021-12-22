// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/lang.'string as langstring;

@test:Config {enable: true}
isolated function testStringValueReturn() returns grpc:Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    string response = check helloWorldBlockingEp->testStringValueReturn("WSO2");
    test:assertEquals(response, "WSO2");
}

@test:Config {enable: true}
isolated function testFloatValueReturn() returns grpc:Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    float n = 4.5;
    float response = check helloWorldBlockingEp->testFloatValueReturn(n);
    test:assertEquals(response, n);
}

@test:Config {enable: true}
public isolated function testDoubleValueReturn() returns grpc:Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    float n = 4.5;
    float response = check helloWorldBlockingEp->testDoubleValueReturn(n);
    test:assertEquals(response, n);
}

@test:Config {enable: true}
public isolated function testInt64ValueReturn() returns grpc:Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    int n = 45;
    int response = check helloWorldBlockingEp->testInt64ValueReturn(n);
    test:assertEquals(response, n);
}

@test:Config {enable: true}
public isolated function testBoolValueReturn() returns grpc:Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    boolean b = true;
    boolean response = check helloWorldBlockingEp->testBoolValueReturn(b);
    test:assertTrue(response);
}

@test:Config {enable: true}
public isolated function testBytesValueReturn() returns error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    string s = "Ballerina";
    byte[] response = check helloWorldBlockingEp->testBytesValueReturn(s.toBytes());
    string returnedString = check langstring:fromBytes(response);
    test:assertEquals(returnedString, s);
}

@test:Config {enable: true}
public isolated function testRecordValueReturn() returns grpc:Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    SampleMsg24 response = check helloWorldBlockingEp->testRecordValueReturn("WSO2");
    test:assertEquals(response.name, "Ballerina Language");
    test:assertEquals(response.id, 0);
}

@test:Config {enable: true}
public isolated function testRecordValueReturnStream() returns grpc:Error? {
    HelloWorld24Client helloWorldEp = check new ("http://localhost:9114");
    _ = check helloWorldEp->testRecordValueReturnStream("WSO2");
}
