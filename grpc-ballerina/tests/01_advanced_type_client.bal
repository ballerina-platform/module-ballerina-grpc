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


final HelloWorldClient helloWorldClient = check new("http://localhost:9091", poolConfig = {});

type PersonTypedesc typedesc<Person>;
type StockQuoteTypedesc typedesc<StockQuote>;
type StockQuotesTypedesc typedesc<StockQuotes>;
type StockNamesTypedesc typedesc<StockNames>;

@test:Config {enable:true}
function testHttpsClientInitWithoutSecureSocketConfig() {
    HelloWorldClient|Error errorClient = new("https://localhost:9091");
    if (errorClient is Error) {
        test:assertEquals(errorClient.message(), "To enable https you need to configure secureSocket record");
    } else {
        test:assertFail("Secure client initialization without secure socket should fail.");
    }
}



@test:Config {enable:true}
function testSendNestedStruct() {
    Person p = {name:"Sam", address:{postalCode:10300, state:"Western", country:"Sri Lanka"}};
    io:println("testInputNestedStruct: input:");
    io:println(p);
    string|error unionResp = helloWorldClient->testInputNestedStruct(p);
    io:println(unionResp);
    if (unionResp is error) {
        test:assertFail(msg = string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println(unionResp);
        test:assertEquals(unionResp, "Submitted name: Sam");
    }
}

@test:Config {enable:true}
function testReceiveNestedStruct() {
    string name  = "WSO2";
    io:println("testOutputNestedStruct: input: " + name);
    Person|Error unionResp = helloWorldClient->testOutputNestedStruct(name);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(msg = string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println(unionResp.toString());
        test:assertEquals(unionResp.name, "Sam");
        test:assertEquals(unionResp.address.postalCode, 10300);
        test:assertEquals(unionResp.address.state, "CA");
        test:assertEquals(unionResp.address.country, "USA");
    }
}

@test:Config {enable:true}
function testSendStructReceiveStruct() {
    StockRequest request = {name: "WSO2"};
    io:println("testInputStructOutputStruct: input:");
    io:println(request);
    StockQuote|Error unionResp = helloWorldClient->testInputStructOutputStruct(request);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(msg = string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        test:assertEquals(unionResp.symbol, "WSO2");
        test:assertEquals(unionResp.name, "WSO2.com");
        test:assertEquals(unionResp.last, 149.52);
        test:assertEquals(unionResp.low, 150.70);
        test:assertEquals(unionResp.high, 149.18);
    }
}

@test:Config {enable:true}
function testSendNoReceiveStruct() {
    io:println("testNoInputOutputStruct: No input:");
    StockQuotes|Error unionResp = helloWorldClient->testNoInputOutputStruct();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println(unionResp);
        test:assertEquals(unionResp.stock.length(), 2);
        test:assertEquals(unionResp.stock[0].symbol, "WSO2");
        test:assertEquals(unionResp.stock[1].symbol, "Google");
    }
}

@test:Config {enable:true}
function testSendNoReceiveArray() {
    io:println("testNoInputOutputStruct: No input:");
    StockNames|Error unionResp = helloWorldClient->testNoInputOutputArray();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.names.length(), 2);
        test:assertEquals(unionResp.names[0], "WSO2");
        test:assertEquals(unionResp.names[1], "Google");
    }
}

@test:Config {enable:true}
function testSendStructNoReceive() {
    StockQuote quote = {symbol: "Ballerina", name:"ballerina/io", last:1.0, low:0.5, high:2.0};
    io:println("testNoInputOutputStruct: input:");
    io:println(quote);
    Error? unionResp = helloWorldClient->testInputStructNoOutput(quote);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    }
}
