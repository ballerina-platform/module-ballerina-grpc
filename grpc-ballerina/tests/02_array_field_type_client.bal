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

import ballerina/io;
import ballerina/test;

final HelloWorld3Client helloWorld3Client = check new ("http://localhost:9092");

@test:Config {enable:true}
function testSendIntArray() {
    TestInt req = {values: [1, 2, 3, 4, 5]};
    io:println("testIntArrayInput: input:");
    io:println(req);
    int|Error unionResp = helloWorld3Client->testIntArrayInput(req);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, 15);
    }
}

@test:Config {enable:true}
function testSendStringArray() {
    TestString req = {values:["A", "B", "C"]};
    io:println("testStringArrayInput: input:");
    io:println(req);
    string|Error unionResp = helloWorld3Client->testStringArrayInput(req);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, ",A,B,C");
    }
}

@test:Config {enable:true}
function testSendFloatArray() {
    TestFloat req = {values:[1.1, 1.2, 1.3, 1.4, 1.5]};
    io:println("testFloatArrayInput: input:");
    io:println(req);
    float|Error unionResp = helloWorld3Client->testFloatArrayInput(req);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, 6.5);
    }
}

@test:Config {enable:true}
function testSendBooleanArray() {
    TestBoolean req = {values:[true, false, true]};
    io:println("testBooleanArrayInput: input:");
    io:println(req);
    boolean|Error unionResp = helloWorld3Client->testBooleanArrayInput(req);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertTrue(unionResp);
    }
}

@test:Config {enable:true}
function testSendStructArray() {
    TestStruct testStruct = {values: [{name: "Sam"}, {name: "John"}]};
    io:println("testStructArrayInput: input:");
    io:println(testStruct);
    string|Error unionResp = helloWorld3Client->testStructArrayInput(testStruct);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, ",Sam,John");
    }
}

@test:Config {enable:true}
function testReceiveIntArray() {
    io:println("testIntArrayOutput: No input:");
    TestInt|Error unionResp = helloWorld3Client->testIntArrayOutput();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.values.length(), 5);
        test:assertEquals(unionResp.values[0], 1);
        test:assertEquals(unionResp.values[1], 2);
        test:assertEquals(unionResp.values[2], 3);
        test:assertEquals(unionResp.values[3], 4);
        test:assertEquals(unionResp.values[4], 5);
    }
}

@test:Config {enable:true}
function testReceiveStringArray() {
    io:println("testStringArrayOutput: No input:");
    TestString|Error unionResp = helloWorld3Client->testStringArrayOutput();
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.values.length(), 3);
        test:assertEquals(unionResp.values[0], "A");
        test:assertEquals(unionResp.values[1], "B");
        test:assertEquals(unionResp.values[2], "C");
    }
}

@test:Config {enable:true}
function testReceiveFloatArray() {
    io:println("testFloatArrayOutput: No input:");
    TestFloat|Error unionResp = helloWorld3Client->testFloatArrayOutput();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.values.length(), 5);
        test:assertEquals(unionResp.values[0], 1.1);
        test:assertEquals(unionResp.values[1], 1.2);
        test:assertEquals(unionResp.values[2], 1.3);
    }
}

@test:Config {enable:true}
function testReceiveBooleanArray() {
    io:println("testBooleanArrayOutput: No input:");
    TestBoolean|Error unionResp = helloWorld3Client->testBooleanArrayOutput();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.values.length(), 3);
        test:assertTrue(unionResp.values[0]);
        test:assertFalse(unionResp.values[1]);
        test:assertTrue(unionResp.values[2]);
    }
}

@test:Config {enable:true}
function testReceiveStructArray() {
    io:println("testStructArrayOutput: No input:");
    TestStruct|Error unionResp = helloWorld3Client->testStructArrayOutput();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.values.length(), 2);
        test:assertEquals(unionResp.values[0].name, "Sam");
    }
}
