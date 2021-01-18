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
final HelloWorld8BlockingClient helloWorld8BlockingEp = new ("http://localhost:9098");

@test:Config {enable:true}
function testHeadersInUnaryClient() {

    //Working with custom headers
    map<string[]> requestHeaders = {};
    requestHeaders["x-id"] = ["0987654321"];
    ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    // Executing unary blocking call
    ContextString|Error unionResp = helloWorld8BlockingEp->helloContext(requestMessage);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        string result = unionResp.content;
        map<string[]> resHeaders = unionResp.headers;
        io:println("Client Got Response : ");
        io:println(result);
        if (resHeaders.hasKey("x-id")) {
            _ = resHeaders.remove("x-id");
        }
        test:assertEquals(result, "Hello WSO2");
    }
}

@test:Config {enable:true}
function testHeadersInBlockingClient() {
    map<string[]> requestHeaders = {};
    requestHeaders["x-id"] = ["0987654321"];
    ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    // Executing unary blocking call
    ContextString|Error unionResp = helloWorld8BlockingEp->helloContext(requestMessage);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        string result = unionResp.content;
        map<string[]> resHeaders = unionResp.headers;
        io:println("Client Got Response : ");
        io:println(result);
        string[] headerValues = resHeaders.get("x-id");
        test:assertEquals(headerValues[0], "2233445677");
    }
}

// Blocking endpoint.
public client class HelloWorld8BlockingClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_8, getDescriptorMap8());
    }

    isolated remote function hello(string|ContextString req) returns string|Error {
        string message;
        map<string[]> headers = {};
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        [anydata, map<string[]>][result, requestHeaders] = check self.grpcClient->executeSimpleRPC("HelloWorld101/hello", message, headers);
        return result.toString();
    }

    isolated remote function helloContext(string|ContextString req) returns ContextString|Error {
        string message;
        map<string[]> headers = {};
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        [anydata, map<string[]>][result, requestHeaders] = check self.grpcClient->executeSimpleRPC("HelloWorld101/hello", message, headers);
        return  {content: result.toString(), headers: requestHeaders};
    }
}
