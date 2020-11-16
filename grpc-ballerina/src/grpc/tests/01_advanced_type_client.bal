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

final HelloWorld1BlockingClient HelloWorld1BlockingEp = new("http://localhost:9091");

type PersonTypedesc typedesc<Person>;
type StockQuoteTypedesc typedesc<StockQuote>;
type StockQuotesTypedesc typedesc<StockQuotes>;
type StockNamesTypedesc typedesc<StockNames>;

@test:Config {enable:true}
function testSendNestedStruct() {
    Person p = {name:"Sam", address:{postalCode:10300, state:"Western", country:"Sri Lanka"}};
    io:println("testInputNestedStruct: input:");
    io:println(p);
    [string, Headers]|error unionResp = HelloWorld1BlockingEp->testInputNestedStruct(p);
    io:println(unionResp);
    if (unionResp is error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println("Client Got Response : ");
        string result = "";
        [result, _] = unionResp;
        io:println(result);
        test:assertEquals(result, "Submitted name: Sam");
    }
}

@test:Config {enable:true}
function testReceiveNestedStruct() {
    string name  = "WSO2";
    io:println("testOutputNestedStruct: input: " + name);
    [Person, Headers]|Error unionResp = HelloWorld1BlockingEp->testOutputNestedStruct(name);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println("Client Got Response : ");
        Person result = {};
        [result, _] = unionResp;
        io:println(result.toString());
        test:assertEquals(result.name, "Sam");
        test:assertEquals(result.address.postalCode, 10300);
        test:assertEquals(result.address.state, "CA");
        test:assertEquals(result.address.country, "USA");
    }
}

@test:Config {enable:true}
function testSendStructReceiveStruct() {
    StockRequest request = {name: "WSO2"};
    io:println("testInputStructOutputStruct: input:");
    io:println(request);
    [StockQuote, Headers]|Error unionResp = HelloWorld1BlockingEp->testInputStructOutputStruct(request);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println("Client Got Response : ");
        StockQuote result = {};
        [result, _] = unionResp;
        io:println(result.toString());
        test:assertEquals(result.symbol, "WSO2");
        test:assertEquals(result.name, "WSO2.com");
        test:assertEquals(result.last, 149.52);
        test:assertEquals(result.low, 150.70);
        test:assertEquals(result.high, 149.18);
    }
}

@test:Config {enable:true}
function testSendNoReceiveStruct() {
    io:println("testNoInputOutputStruct: No input:");
    [StockQuotes, Headers]|Error unionResp = HelloWorld1BlockingEp->testNoInputOutputStruct();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println("Client Got Response : ");
        StockQuotes result = {};
        [result, _] = unionResp;
        io:println(result);
        test:assertEquals(result.stock.length(), 2);
        test:assertEquals(result.stock[0].symbol, "WSO2");
        test:assertEquals(result.stock[1].symbol, "Google");
    }
}

@test:Config {enable:true}
function testSendNoReceiveArray() {
    io:println("testNoInputOutputStruct: No input:");
    [StockNames, Headers]|Error unionResp = HelloWorld1BlockingEp->testNoInputOutputArray();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println("Client Got Response : ");
        StockNames result = {};
        [result, _] = unionResp;
        io:println(result);
        test:assertEquals(result.names.length(), 2);
        test:assertEquals(result.names[0], "WSO2");
        test:assertEquals(result.names[1], "Google");
    }
}

@test:Config {enable:true}
function testSendStructNoReceive() {
    StockQuote quote = {symbol: "Ballerina", name:"ballerina/io", last:1.0, low:0.5, high:2.0};
    io:println("testNoInputOutputStruct: input:");
    io:println(quote);
    (Headers)|Error unionResp = HelloWorld1BlockingEp->testInputStructNoOutput(quote);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    }
}

public client class HelloWorld1BlockingClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR_1, getDescriptorMap1());
    }

    public isolated remote function testInputNestedStruct(Person req, Headers? headers = ()) returns ([string,
    Headers]|Error) {
        [anydata, Headers] payload = check self.grpcClient->blockingExecute("grpcservices.HelloWorld/testInputNestedStruct", req, headers);
        anydata result = ();
        Headers resHeaders;
        io:println(payload);
        [result, resHeaders] = payload;
        return [result.toString(), resHeaders];
    }

    public isolated remote function testOutputNestedStruct(string req, Headers? headers = ()) returns ([Person,
    Headers]|Error) {
        [anydata, Headers] payload = check self.grpcClient->blockingExecute("grpcservices.HelloWorld/testOutputNestedStruct", req, headers);
        anydata result = ();
        Headers resHeaders;
        [result, resHeaders] = payload;
        var value = result.cloneWithType(PersonTypedesc);
        if (value is Person) {
            return [value, resHeaders];
        } else {
            return InternalError("Error while constructing the message", value);
        }
    }

    public isolated remote function testInputStructOutputStruct(StockRequest req, Headers? headers = ()) returns
    ([StockQuote, Headers]|Error) {
        [anydata, Headers] payload = check self.grpcClient->blockingExecute("grpcservices.HelloWorld/testInputStructOutputStruct", req, headers);
        anydata result = ();
        Headers resHeaders;
        [result, resHeaders] = payload;
        var value = result.cloneWithType(StockQuoteTypedesc);
        if (value is StockQuote) {
            return [value, resHeaders];
        } else {
            return InternalError("Error while constructing the message", value);
        }
    }

    public isolated remote function testInputStructNoOutput(StockQuote req, Headers? headers = ()) returns ((Headers)
    |Error) {
        [anydata, Headers] payload = check self.grpcClient->blockingExecute("grpcservices.HelloWorld/testInputStructNoOutput", req, headers);
        anydata result = ();
        Headers resHeaders;
        [_, resHeaders] = payload;
        return resHeaders;
    }

    public isolated remote function testNoInputOutputStruct(Headers? headers = ()) returns ([StockQuotes,
    Headers]|Error) {
        Empty req = {};
        [anydata, Headers] payload = check self.grpcClient->blockingExecute("grpcservices.HelloWorld/testNoInputOutputStruct", req, headers);
        anydata result = ();
        Headers resHeaders;
        [result, resHeaders] = payload;
        var value = result.cloneWithType(StockQuotesTypedesc);
        if (value is StockQuotes) {
            return [value, resHeaders];
        } else {
            return InternalError("Error while constructing the message", value);
        }
    }

    public isolated remote function testNoInputOutputArray(Headers? headers = ()) returns ([StockNames,
    Headers]|Error) {
        Empty req = {};
        [anydata, Headers] payload = check self.grpcClient->blockingExecute("grpcservices.HelloWorld/testNoInputOutputArray", req, headers);
        anydata result = ();
        Headers resHeaders;
        [result, resHeaders] = payload;
        var value = result.cloneWithType(StockNamesTypedesc);
        if (value is StockNames) {
            return [value, resHeaders];
        } else {
            return InternalError("Error while constructing the message", value);
        }
    }
}

public client class HelloWorldClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_1, getDescriptorMap1());
    }

    public isolated remote function testInputNestedStruct(Person req, service msgListener, Headers? headers = ())
    returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld/testInputNestedStruct", req, msgListener,
         headers);
    }

    public isolated remote function testOutputNestedStruct(string req, service msgListener, Headers? headers = ())
    returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld/testOutputNestedStruct", req, msgListener,
            headers);
    }

    public isolated remote function testInputStructOutputStruct(StockRequest req, service msgListener, Headers?
    headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld/testInputStructOutputStruct", req, msgListener,
            headers);
    }

    public isolated remote function testInputStructNoOutput(StockQuote req, service msgListener, Headers? headers =
    ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld/testInputStructNoOutput", req, msgListener,
            headers);
    }

    public isolated remote function testNoInputOutputStruct(Empty req, service msgListener, Headers? headers = ())
    returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld/testNoInputOutputStruct", req, msgListener,
            headers);
    }

    public isolated remote function testNoInputOutputArray(Empty req, service msgListener, Headers? headers = ())
    returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld/testNoInputOutputArray", req, msgListener,
            headers);
    }
}
