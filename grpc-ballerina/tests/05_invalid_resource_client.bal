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

final HelloWorld98Client helloWorld5BlockingEp = new ("http://localhost:9095");

@test:Config {enable:true}
function testInvalidRemoteMethod() {
    string name = "WSO2";
    string|Error unionResp = helloWorld5BlockingEp->hello(name);
    if (unionResp is Error) {
        test:assertEquals(unionResp.message(), "No registered method descriptor for " +
                                                               "'grpcservices.HelloWorld98/hello1'");
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertFail("Client got response: " + unionResp);
    }
}

@test:Config {enable:true}
function testInvalidInputParameter() {
    string age = "";
    int|Error unionResp = helloWorld5BlockingEp->testInt(age);
    if (unionResp is Error) {
        test:assertFail(io:sprintf("Error from Connector: %s", unionResp.message()));
    } else {
        io:println("Client got response : ");
        test:assertEquals(unionResp, -1);
    }
}

public client class HelloWorld98Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_5, getDescriptorMap5());
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
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld98/hello1", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld98/hello", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function testInt(string|ContextString req) returns (int|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld98/testInt", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <int>result;
        
    }
    isolated remote function testIntContext(string|ContextString req) returns (ContextInt|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld98/testInt", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <int>result, headers: respHeaders};
    }

}
