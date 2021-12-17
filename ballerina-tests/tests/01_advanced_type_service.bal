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
import ballerina/log;

listener grpc:Listener ep = new (9091, {
    host: "localhost"
});

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_1,
    descMap: getDescriptorMap1()
}
service "HelloWorld" on ep {

    isolated remote function testInputNestedStruct(HelloWorldStringCaller caller, Person req) returns grpc:Error? {
        log:printInfo("name: " + req.name);
        string message = "Submitted name: " + req.name;
        check caller->sendString(message);
        check caller->complete();
    }

    isolated remote function testOutputNestedStruct(HelloWorldPersonCaller caller, string name) returns grpc:Error? {
        log:printInfo("requested name: " + name);
        Person person = {name: "Sam", address: {postalCode: 10300, state: "CA", country: "USA"}};
        check caller->sendPerson(person);
        check caller->complete();
    }

    isolated remote function testInputStructOutputStruct(HelloWorldStockQuoteCaller caller, StockRequest req) returns grpc:Error? {
        log:printInfo("Getting stock details for symbol: " + req.name);
        StockQuote res = {symbol: "WSO2", name: "WSO2.com", last: 149.52, low: 150.70, high: 149.18};
        check caller->sendStockQuote(res);
        check caller->complete();
    }

    isolated remote function testInputStructNoOutput(HelloWorldNilCaller caller, StockQuote req) {
        log:printInfo("Symbol: " + req.symbol);
        log:printInfo("Name: " + req.name);
        log:printInfo("Last: " + req.last.toString());
        log:printInfo("Low: " + req.low.toString());
        log:printInfo("High: " + req.high.toString());
    }

    isolated remote function testNoInputOutputStruct(HelloWorldStockQuotesCaller caller) returns grpc:Error? {
        StockQuote res = {symbol: "WSO2", name: "WSO2 Inc.", last: 14.0, low: 15.0, high: 16.0};
        StockQuote res1 = {symbol: "Google", name: "Google Inc.", last: 100.0, low: 101.0, high: 102.0};
        StockQuotes quotes = {stock: [res, res1]};
        check caller->sendStockQuotes(quotes);
        check caller->complete();
    }

    isolated remote function testNoInputOutputArray(HelloWorldStockNamesCaller caller) returns grpc:Error? {
        string[] names = ["WSO2", "Google"];
        StockNames stockNames = {names: names};
        check caller->sendStockNames(stockNames);
        check caller->complete();
    }
}
