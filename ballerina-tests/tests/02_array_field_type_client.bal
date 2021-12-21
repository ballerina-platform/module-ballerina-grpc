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

final HelloWorld3Client helloWorld3Client = check new ("http://localhost:9092");

@test:Config {enable: true}
function testSendIntArray() returns grpc:Error? {
    TestInt request = {values: [1, 2, 3, 4, 5]};
    int response = check helloWorld3Client->testIntArrayInput(request);
    test:assertEquals(response, 15);
}

@test:Config {enable: true}
function testSendStringArray() returns grpc:Error? {
    TestString request = {values: ["A", "B", "C"]};
    string response = check helloWorld3Client->testStringArrayInput(request);
    test:assertEquals(response, ",A,B,C");
}

@test:Config {enable: true}
function testSendFloatArray() returns grpc:Error? {
    TestFloat request = {values: [1.1, 1.2, 1.3, 1.4, 1.5]};
    float response = check helloWorld3Client->testFloatArrayInput(request);
    test:assertEquals(response, 6.5);
}

@test:Config {enable: true}
function testSendBooleanArray() returns grpc:Error? {
    TestBoolean request = {values: [true, false, true]};
    boolean response = check helloWorld3Client->testBooleanArrayInput(request);
    test:assertTrue(response);
}

@test:Config {enable: true}
function testSendStructArray() returns grpc:Error? {
    TestStruct testStruct = {values: [{name: "Sam"}, {name: "John"}]};
    string response = check helloWorld3Client->testStructArrayInput(testStruct);
    test:assertEquals(response, ",Sam,John");
}

@test:Config {enable: true}
function testReceiveIntArray() returns grpc:Error? {
    TestInt response = check helloWorld3Client->testIntArrayOutput();
    test:assertEquals(response.values.length(), 5);
    test:assertEquals(response.values[0], 1);
    test:assertEquals(response.values[1], 2);
    test:assertEquals(response.values[2], 3);
    test:assertEquals(response.values[3], 4);
    test:assertEquals(response.values[4], 5);
}

@test:Config {enable: true}
function testReceiveStringArray() returns grpc:Error? {
    TestString response = check helloWorld3Client->testStringArrayOutput();
    test:assertEquals(response.values.length(), 3);
    test:assertEquals(response.values[0], "A");
    test:assertEquals(response.values[1], "B");
    test:assertEquals(response.values[2], "C");
}

@test:Config {enable: true}
function testReceiveFloatArray() returns grpc:Error? {
    TestFloat response = check helloWorld3Client->testFloatArrayOutput();
    test:assertEquals(response.values.length(), 5);
    test:assertEquals(response.values[0], 1.1);
    test:assertEquals(response.values[1], 1.2);
    test:assertEquals(response.values[2], 1.3);
}

@test:Config {enable: true}
function testReceiveBooleanArray() returns grpc:Error? {
    TestBoolean response = check helloWorld3Client->testBooleanArrayOutput();
    test:assertEquals(response.values.length(), 3);
    test:assertTrue(response.values[0]);
    test:assertFalse(response.values[1]);
    test:assertTrue(response.values[2]);
}

@test:Config {enable: true}
function testReceiveStructArray() returns grpc:Error? {
    TestStruct response = check helloWorld3Client->testStructArrayOutput();
    test:assertEquals(response.values.length(), 2);
    test:assertEquals(response.values[0].name, "Sam");
}
