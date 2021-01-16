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

final HelloWorldClient HelloWorld1BlockingEp = new("http://localhost:9091");

type PersonTypedesc typedesc<Person>;
type StockQuoteTypedesc typedesc<StockQuote>;
type StockQuotesTypedesc typedesc<StockQuotes>;
type StockNamesTypedesc typedesc<StockNames>;

@test:Config {enable:true}
function testSendNestedStruct() {
    Person p = {name:"Sam", address:{postalCode:10300, state:"Western", country:"Sri Lanka"}};
    io:println("testInputNestedStruct: input:");
    io:println(p);
    string|error unionResp = HelloWorld1BlockingEp->testInputNestedStruct(p);
    io:println(unionResp);
    if (unionResp is error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println(unionResp);
        test:assertEquals(unionResp, "Submitted name: Sam");
    }
}

@test:Config {enable:true}
function testReceiveNestedStruct() {
    string name  = "WSO2";
    io:println("testOutputNestedStruct: input: " + name);
    Person|Error unionResp = HelloWorld1BlockingEp->testOutputNestedStruct(name);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
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
    StockQuote|Error unionResp = HelloWorld1BlockingEp->testInputStructOutputStruct(request);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
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
    StockQuotes|Error unionResp = HelloWorld1BlockingEp->testNoInputOutputStruct();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
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
    StockNames|Error unionResp = HelloWorld1BlockingEp->testNoInputOutputArray();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
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
    Error? unionResp = HelloWorld1BlockingEp->testInputStructNoOutput(quote);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    }
}

public client class HelloWorldClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_1, getDescriptorMap1());
    }

    isolated remote function testInputNestedStruct(Person|ContextPerson req) returns (string|Error) {
        
        map<string[]> headers = {};
        Person message;
        if (req is ContextPerson) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld/testInputNestedStruct", message, headers);
        
        [anydata, map<string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function testInputNestedStructContext(Person|ContextPerson req) returns (ContextString|Error) {
        
        map<string[]> headers = {};
        Person message;
        if (req is ContextPerson) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld/testInputNestedStruct", message, headers);
        [anydata, map<string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function testOutputNestedStruct(string|ContextString req) returns (Person|Error) {
        
        map<string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld/testOutputNestedStruct", message, headers);
        
        [anydata, map<string[]>][result, _] = payload;
        
        return <Person>result;
        
    }
    isolated remote function testOutputNestedStructContext(string|ContextString req) returns (ContextPerson|Error) {
        
        map<string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld/testOutputNestedStruct", message, headers);
        [anydata, map<string[]>][result, respHeaders] = payload;
        
        return {content: <Person>result, headers: respHeaders};
        
    }

    isolated remote function testInputStructOutputStruct(StockRequest|ContextStockRequest req) returns (StockQuote|Error) {
        
        map<string[]> headers = {};
        StockRequest message;
        if (req is ContextStockRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld/testInputStructOutputStruct", message, headers);
        
        [anydata, map<string[]>][result, _] = payload;
        
        return <StockQuote>result;
        
    }
    isolated remote function testInputStructOutputStructContext(StockRequest|ContextStockRequest req) returns (ContextStockQuote|Error) {
        
        map<string[]> headers = {};
        StockRequest message;
        if (req is ContextStockRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld/testInputStructOutputStruct", message, headers);
        [anydata, map<string[]>][result, respHeaders] = payload;
        
        return {content: <StockQuote>result, headers: respHeaders};
        
    }

    isolated remote function testInputStructNoOutput(StockQuote|ContextStockQuote req) returns (Error?) {
        
        map<string[]> headers = {};
        StockQuote message;
        if (req is ContextStockQuote) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld/testInputStructNoOutput", message, headers);
        
    }
    isolated remote function testInputStructNoOutputContext(StockQuote|ContextStockQuote req) returns (Error?) {
        
        map<string[]> headers = {};
        StockQuote message;
        if (req is ContextStockQuote) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld/testInputStructNoOutput", message, headers);
        
    }

    isolated remote function testNoInputOutputStruct() returns (StockQuotes|Error) {
        Empty message = {};
        map<string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld/testNoInputOutputStruct", message, headers);
        
        [anydata, map<string[]>][result, _] = payload;
        
        return <StockQuotes>result;
        
    }
    isolated remote function testNoInputOutputStructContext() returns (ContextStockQuotes|Error) {
        Empty message = {};
        map<string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld/testNoInputOutputStruct", message, headers);
        [anydata, map<string[]>][result, respHeaders] = payload;
        
        return {content: <StockQuotes>result, headers: respHeaders};
        
    }

    isolated remote function testNoInputOutputArray() returns (StockNames|Error) {
        Empty message = {};
        map<string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld/testNoInputOutputArray", message, headers);
        
        [anydata, map<string[]>][result, _] = payload;
        
        return <StockNames>result;
        
    }
    isolated remote function testNoInputOutputArrayContext() returns (ContextStockNames|Error) {
        Empty message = {};
        map<string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld/testNoInputOutputArray", message, headers);
        [anydata, map<string[]>][result, respHeaders] = payload;
        
        return {content: <StockNames>result, headers: respHeaders};
        
    }
}

