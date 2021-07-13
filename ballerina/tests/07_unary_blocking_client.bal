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

final HelloWorld100Client helloWorld7BlockingEp = check new ("http://localhost:9097");

//type ResponseTypedesc typedesc<Response>;

@test:Config {enable:true}
function testUnaryBlockingClient() {
    string name = "WSO2";
    string|Error unionResp = helloWorld7BlockingEp->hello(name);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, "Hello WSO2");
    }
}

@test:Config {enable:true}
function testUnaryBlockingIntClient() {
    int age = 10;
    int|Error unionResp = helloWorld7BlockingEp->testInt(age);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client got response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, 8);
    }
}

@test:Config {enable:true}
function testUnaryBlockingFloatClient() {
    float salary = 1000.5;
    float|Error unionResp = helloWorld7BlockingEp->testFloat(salary);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client got response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, 880.44);
    }
}

@test:Config {enable:true}
function testUnaryBlockingBoolClient() {
    boolean isAvailable = false;
    boolean|Error unionResp = helloWorld7BlockingEp->testBoolean(isAvailable);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client got response : ");
        io:println(unionResp);
        test:assertTrue(unionResp);
    }
}

@test:Config {enable:true}
function testUnaryBlockingReceiveRecord() {
    string msg = "WSO2";
    Response|Error unionResp = helloWorld7BlockingEp->testResponseInsideMatch(msg);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client got response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.resp, "Acknowledge WSO2");
    }
}

@test:Config {enable:true}
function testUnaryBlockingStructClient() {
    Request req = {name:"Sam", message:"Testing."};
    Response|Error unionResp = helloWorld7BlockingEp->testStruct(req);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client got response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.resp, "Acknowledge Sam");
    }
}
