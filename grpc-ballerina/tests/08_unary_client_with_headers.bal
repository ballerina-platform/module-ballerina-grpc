// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

// Client endpoint configuration
final HelloWorld101Client helloWorld8BlockingEp = check new ("http://localhost:9098");

@test:Config {enable:true}
function testHeadersInUnaryClient() {

    //Working with custom headers
    ContextString requestMessage = {content: "WSO2", headers:  {"x-id": "0987654321"}};
    // Executing unary blocking call
    ContextString|Error unionResp = helloWorld8BlockingEp->helloContext(requestMessage);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        string result = unionResp.content;
        map<string|string[]> resHeaders = unionResp.headers;
        io:println("Client Got Response : ");
        io:println(result);
        if (resHeaders.hasKey("x-id")) {
            _ = resHeaders.remove("x-id");
        }
        test:assertEquals(result, "Hello WSO2");
    }
}

@test:Config {enable:true}
function testHeadersInBlockingClient() returns Error? {
    ContextString requestMessage = {content: "WSO2", headers: {"x-id": "0987654321"}};
    // Executing unary blocking call
    ContextString|Error unionResp = helloWorld8BlockingEp->helloContext(requestMessage);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        string result = unionResp.content;
        map<string|string[]> resHeaders = unionResp.headers;
        io:println("Client Got Response : ");
        io:println(result);
        test:assertEquals(check getHeader(resHeaders, "x-id"), "2233445677");
    }
}

// Blocking endpoint.
public client class HelloWorld101Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        // initialize client endpoint.
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_8, getDescriptorMap8());
    }

    isolated remote function hello(string|ContextString req) returns (string|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld101/hello", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function helloContext(string|ContextString req) returns (ContextString|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld101/hello", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

}
