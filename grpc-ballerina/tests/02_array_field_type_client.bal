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

final HelloWorld3Client HelloWorld2BlockingEp = new ("http://localhost:9092");

@test:Config {enable:true}
function testSendIntArray() {
    TestInt req = {values: [1, 2, 3, 4, 5]};
    io:println("testIntArrayInput: input:");
    io:println(req);
    int|Error unionResp = HelloWorld2BlockingEp->testIntArrayInput(req);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, 15);
    }
}

@test:Config {enable:true}
function testSendStringArray() {
    TestString req = {values:["A", "B", "C"]};
    io:println("testStringArrayInput: input:");
    io:println(req);
    string|Error unionResp = HelloWorld2BlockingEp->testStringArrayInput(req);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, ",A,B,C");
    }
}

@test:Config {enable:true}
function testSendFloatArray() {
    TestFloat req = {values:[1.1, 1.2, 1.3, 1.4, 1.5]};
    io:println("testFloatArrayInput: input:");
    io:println(req);
    float|Error unionResp = HelloWorld2BlockingEp->testFloatArrayInput(req);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, 6.5);
    }
}

@test:Config {enable:true}
function testSendBooleanArray() {
    TestBoolean req = {values:[true, false, true]};
    io:println("testBooleanArrayInput: input:");
    io:println(req);
    boolean|Error unionResp = HelloWorld2BlockingEp->testBooleanArrayInput(req);
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertTrue(unionResp);
    }
}

@test:Config {enable:true}
function testSendStructArray() {
    TestStruct testStruct = {values: [{name: "Sam"}, {name: "John"}]};
    io:println("testStructArrayInput: input:");
    io:println(testStruct);
    string|Error unionResp = HelloWorld2BlockingEp->testStructArrayInput(testStruct);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, ",Sam,John");
    }
}

@test:Config {enable:true}
function testReceiveIntArray() {
    io:println("testIntArrayOutput: No input:");
    TestInt|Error unionResp = HelloWorld2BlockingEp->testIntArrayOutput();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.values.length(), 5);
        test:assertEquals(unionResp.values[0], 1);
        test:assertEquals(unionResp.values[1], 2);
        test:assertEquals(unionResp.values[2], 3);
        test:assertEquals(unionResp.values[3], 4);
        test:assertEquals(unionResp.values[4], 5);
    }
}

@test:Config {enable:true}
function testReceiveStringArray() {
    io:println("testStringArrayOutput: No input:");
    TestString|Error unionResp = HelloWorld2BlockingEp->testStringArrayOutput();
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.values.length(), 3);
        test:assertEquals(unionResp.values[0], "A");
        test:assertEquals(unionResp.values[1], "B");
        test:assertEquals(unionResp.values[2], "C");
    }
}

@test:Config {enable:true}
function testReceiveFloatArray() {
    io:println("testFloatArrayOutput: No input:");
    TestFloat|Error unionResp = HelloWorld2BlockingEp->testFloatArrayOutput();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.values.length(), 5);
        test:assertEquals(unionResp.values[0], 1.1);
        test:assertEquals(unionResp.values[1], 1.2);
        test:assertEquals(unionResp.values[2], 1.3);
    }
}

@test:Config {enable:true}
function testReceiveBooleanArray() {
    io:println("testBooleanArrayOutput: No input:");
    TestBoolean|Error unionResp = HelloWorld2BlockingEp->testBooleanArrayOutput();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.values.length(), 3);
        test:assertTrue(unionResp.values[0]);
        test:assertFalse(unionResp.values[1]);
        test:assertTrue(unionResp.values[2]);
    }
}

@test:Config {enable:true}
function testReceiveStructArray() {
    io:println("testStructArrayOutput: No input:");
    TestStruct|Error unionResp = HelloWorld2BlockingEp->testStructArrayOutput();
    io:println(unionResp);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp.values.length(), 2);
        test:assertEquals(unionResp.values[0].name, "Sam");
    }
}

public client class HelloWorld3Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_2, getDescriptorMap2());
    }

    isolated remote function testIntArrayInput(TestInt|ContextTestInt req) returns (int|Error) {
        
        map<string|string[]> headers = {};
        TestInt message;
        if (req is ContextTestInt) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testIntArrayInput", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <int>result;
        
    }
    isolated remote function testIntArrayInputContext(TestInt|ContextTestInt req) returns (ContextInt|Error) {
        
        map<string|string[]> headers = {};
        TestInt message;
        if (req is ContextTestInt) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testIntArrayInput", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <int>result, headers: respHeaders};
    }

    isolated remote function testStringArrayInput(TestString|ContextTestString req) returns (string|Error) {
        
        map<string|string[]> headers = {};
        TestString message;
        if (req is ContextTestString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStringArrayInput", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function testStringArrayInputContext(TestString|ContextTestString req) returns (ContextString|Error) {
        
        map<string|string[]> headers = {};
        TestString message;
        if (req is ContextTestString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStringArrayInput", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function testFloatArrayInput(TestFloat|ContextTestFloat req) returns (float|Error) {
        
        map<string|string[]> headers = {};
        TestFloat message;
        if (req is ContextTestFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testFloatArrayInput", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <float>result;
        
    }
    isolated remote function testFloatArrayInputContext(TestFloat|ContextTestFloat req) returns (ContextFloat|Error) {
        
        map<string|string[]> headers = {};
        TestFloat message;
        if (req is ContextTestFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testFloatArrayInput", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <float>result, headers: respHeaders};
    }

    isolated remote function testBooleanArrayInput(TestBoolean|ContextTestBoolean req) returns (boolean|Error) {
        
        map<string|string[]> headers = {};
        TestBoolean message;
        if (req is ContextTestBoolean) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testBooleanArrayInput", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <boolean>result;
        
    }
    isolated remote function testBooleanArrayInputContext(TestBoolean|ContextTestBoolean req) returns (ContextBoolean|Error) {
        
        map<string|string[]> headers = {};
        TestBoolean message;
        if (req is ContextTestBoolean) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testBooleanArrayInput", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <boolean>result, headers: respHeaders};
    }

    isolated remote function testStructArrayInput(TestStruct|ContextTestStruct req) returns (string|Error) {
        
        map<string|string[]> headers = {};
        TestStruct message;
        if (req is ContextTestStruct) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStructArrayInput", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function testStructArrayInputContext(TestStruct|ContextTestStruct req) returns (ContextString|Error) {
        
        map<string|string[]> headers = {};
        TestStruct message;
        if (req is ContextTestStruct) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStructArrayInput", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function testIntArrayOutput() returns (TestInt|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testIntArrayOutput", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <TestInt>result;
        
    }
    isolated remote function testIntArrayOutputContext() returns (ContextTestInt|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testIntArrayOutput", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <TestInt>result, headers: respHeaders};
    }

    isolated remote function testStringArrayOutput() returns (TestString|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStringArrayOutput", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <TestString>result;
        
    }
    isolated remote function testStringArrayOutputContext() returns (ContextTestString|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStringArrayOutput", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <TestString>result, headers: respHeaders};
    }

    isolated remote function testFloatArrayOutput() returns (TestFloat|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testFloatArrayOutput", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <TestFloat>result;
        
    }
    isolated remote function testFloatArrayOutputContext() returns (ContextTestFloat|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testFloatArrayOutput", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <TestFloat>result, headers: respHeaders};
    }

    isolated remote function testBooleanArrayOutput() returns (TestBoolean|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testBooleanArrayOutput", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <TestBoolean>result;
        
    }
    isolated remote function testBooleanArrayOutputContext() returns (ContextTestBoolean|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testBooleanArrayOutput", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <TestBoolean>result, headers: respHeaders};
    }

    isolated remote function testStructArrayOutput() returns (TestStruct|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStructArrayOutput", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <TestStruct>result;
        
    }
    isolated remote function testStructArrayOutputContext() returns (ContextTestStruct|Error) {
        Empty message = {};
        map<string|string[]> headers = {};
        
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.HelloWorld3/testStructArrayOutput", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <TestStruct>result, headers: respHeaders};
    }

}
