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

final HelloWorld100Client helloWorld7BlockingEp = check new ("http://localhost:9097");

//type ResponseTypedesc typedesc<Response>;

@test:Config {enable: true}
function testUnaryBlockingClient() returns grpc:Error? {
    string name = "WSO2";
    string response = check helloWorld7BlockingEp->hello(name);
    test:assertEquals(response, "Hello WSO2");
}

@test:Config {enable: true}
function testUnaryBlockingIntClient() returns grpc:Error? {
    int age = 10;
    int response = check helloWorld7BlockingEp->testInt(age);
    test:assertEquals(response, 8);
}

@test:Config {enable: true}
function testUnaryBlockingFloatClient() returns grpc:Error? {
    float salary = 1000.5;
    float response = check helloWorld7BlockingEp->testFloat(salary);
    test:assertEquals(response, 880.44);
}

@test:Config {enable: true}
function testUnaryBlockingBoolClient() returns grpc:Error? {
    boolean isAvailable = false;
    boolean response = check helloWorld7BlockingEp->testBoolean(isAvailable);
    test:assertTrue(response);
}

@test:Config {enable: true}
function testUnaryBlockingReceiveRecord() returns grpc:Error? {
    string msg = "WSO2";
    Response response = check helloWorld7BlockingEp->testResponseInsideMatch(msg);
    test:assertEquals(response.resp, "Acknowledge WSO2");
}

@test:Config {enable: true}
function testUnaryBlockingStructClient() returns grpc:Error? {
    Request req = {name: "Sam", message: "Testing."};
    Response response = check helloWorld7BlockingEp->testStruct(req);
    test:assertEquals(response.resp, "Acknowledge Sam");
}

@test:Config {enable: true}
isolated function testUnaryClientWithNegativeTimeout() returns grpc:Error? {
    HelloWorld100Client hClient = check new ("http://localhost:9097", {
        timeout: -10
    });
    string name = "WSO2";
    string response = check hClient->hello(name);
    test:assertEquals(response, "Hello WSO2");
}

@test:Config {enable: true}
isolated function testUnaryClientWithOverflowingTimeout() returns grpc:Error? {
    HelloWorld100Client hClient = check new ("http://localhost:9097", {
        timeout: 2147483699
    });
    string name = "WSO2";
    string response = check hClient->hello(name);
    test:assertEquals(response, "Hello WSO2");
}
