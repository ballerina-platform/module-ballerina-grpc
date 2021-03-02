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

final HelloWorld100Client helloWorld7BlockingEp = new ("http://localhost:9097");

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
    Request req = {name:"Sam", age:10, message:"Testing."};
    Response|Error unionResp = helloWorld7BlockingEp->testStruct(req);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client got response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.resp, "Acknowledge Sam");
    }
}

public client class HelloWorld100Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_7, getDescriptorMap7());
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
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/hello", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/hello", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function testInt(int|ContextInt req) returns (int|Error) {
        
        map<string|string[]> headers = {};
        int message;
        if (req is ContextInt) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testInt", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <int>result;
        
    }
    isolated remote function testIntContext(int|ContextInt req) returns (ContextInt|Error) {
        
        map<string|string[]> headers = {};
        int message;
        if (req is ContextInt) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testInt", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <int>result, headers: respHeaders};
    }

    isolated remote function testFloat(float|ContextFloat req) returns (float|Error) {
        
        map<string|string[]> headers = {};
        float message;
        if (req is ContextFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testFloat", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <float>result;
        
    }
    isolated remote function testFloatContext(float|ContextFloat req) returns (ContextFloat|Error) {
        
        map<string|string[]> headers = {};
        float message;
        if (req is ContextFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testFloat", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <float>result, headers: respHeaders};
    }

    isolated remote function testBoolean(boolean|ContextBoolean req) returns (boolean|Error) {
        
        map<string|string[]> headers = {};
        boolean message;
        if (req is ContextBoolean) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testBoolean", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <boolean>result;
        
    }
    isolated remote function testBooleanContext(boolean|ContextBoolean req) returns (ContextBoolean|Error) {
        
        map<string|string[]> headers = {};
        boolean message;
        if (req is ContextBoolean) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testBoolean", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <boolean>result, headers: respHeaders};
    }

    isolated remote function testStruct(Request|ContextRequest req) returns (Response|Error) {
        
        map<string|string[]> headers = {};
        Request message;
        if (req is ContextRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testStruct", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <Response>result;
        
    }
    isolated remote function testStructContext(Request|ContextRequest req) returns (ContextResponse|Error) {
        
        map<string|string[]> headers = {};
        Request message;
        if (req is ContextRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testStruct", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <Response>result, headers: respHeaders};
    }

    isolated remote function testNoRequest() returns (string|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testNoRequest", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function testNoRequestContext() returns (ContextString|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testNoRequest", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function testNoResponse(string|ContextString req) returns (Error?) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testNoResponse", message, headers);
        
    }
    isolated remote function testNoResponseContext(string|ContextString req) returns (ContextNil|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testNoResponse", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {headers: respHeaders};
    }

    isolated remote function testResponseInsideMatch(string|ContextString req) returns (Response|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testResponseInsideMatch", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <Response>result;
        
    }
    isolated remote function testResponseInsideMatchContext(string|ContextString req) returns (ContextResponse|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld100/testResponseInsideMatch", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <Response>result, headers: respHeaders};
    }

}
