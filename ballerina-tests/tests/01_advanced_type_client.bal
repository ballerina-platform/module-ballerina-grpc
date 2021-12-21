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

final HelloWorldClient helloWorldClient = check new ("http://localhost:9091", poolConfig = {});

type PersonTypedesc typedesc<Person>;

type StockQuoteTypedesc typedesc<StockQuote>;

type StockQuotesTypedesc typedesc<StockQuotes>;

type StockNamesTypedesc typedesc<StockNames>;

@test:Config {enable: true}
function testHttpsClientInitWithoutSecureSocketConfig() {
    HelloWorldClient|grpc:Error errorClient = new ("https://localhost:9091");
    test:assertTrue(errorClient is grpc:Error);
    test:assertEquals((<grpc:Error>errorClient).message(), "The secureSocket configuration should be provided to establish an HTTPS connection");
}

@test:Config {enable: true}
function testSendNestedStruct() returns grpc:Error? {
    Person p = {name: "Sam", address: {postalCode: 10300, state: "Western", country: "Sri Lanka"}};
    string response = check helloWorldClient->testInputNestedStruct(p);
    test:assertEquals(response, "Submitted name: Sam");
}

@test:Config {enable: true}
function testReceiveNestedStruct() returns grpc:Error? {
    string name = "WSO2";
    Person response = check helloWorldClient->testOutputNestedStruct(name);
    test:assertEquals(response.name, "Sam");
    test:assertEquals(response.address.postalCode, 10300);
    test:assertEquals(response.address.state, "CA");
    test:assertEquals(response.address.country, "USA");
}

@test:Config {enable: true}
function testSendStructReceiveStruct() returns grpc:Error? {
    StockRequest request = {name: "WSO2"};
    StockQuote sq = check helloWorldClient->testInputStructOutputStruct(request);
    test:assertEquals(sq.symbol, "WSO2");
    test:assertEquals(sq.name, "WSO2.com");
    test:assertEquals(sq.last, 149.52);
    test:assertEquals(sq.low, 150.70);
    test:assertEquals(sq.high, 149.18);
}

@test:Config {enable: true}
function testSendNoReceiveStruct() returns grpc:Error? {
    StockQuotes sq = check helloWorldClient->testNoInputOutputStruct();
    test:assertEquals(sq.stock.length(), 2);
    test:assertEquals(sq.stock[0].symbol, "WSO2");
    test:assertEquals(sq.stock[1].symbol, "Google");
}

@test:Config {enable: true}
function testSendNoReceiveArray() returns grpc:Error? {
    StockNames sq = check helloWorldClient->testNoInputOutputArray();
    test:assertEquals(sq.names.length(), 2);
    test:assertEquals(sq.names[0], "WSO2");
    test:assertEquals(sq.names[1], "Google");
}

@test:Config {enable: true}
function testSendStructNoReceive() returns grpc:Error? {
    StockQuote quote = {symbol: "Ballerina", name: "ballerina/io", last: 1.0, low: 0.5, high: 2.0};
    _ = check helloWorldClient->testInputStructNoOutput(quote);
}
