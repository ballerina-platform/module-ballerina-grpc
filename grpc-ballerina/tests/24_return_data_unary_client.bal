// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/lang.'string as langstring;

@test:Config {enable:true}
public function testStringValueReturn() {
    HelloWorld24Client helloWorldBlockingEp = new ("http://localhost:9114");
    var unionResp = helloWorldBlockingEp->testStringValueReturn("WSO2");
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        test:assertEquals(unionResp, "WSO2");
    }
}

@test:Config {enable:true}
public function testFloatValueReturn() {
    HelloWorld24Client helloWorldBlockingEp = new ("http://localhost:9114");
    float n = 4.5;
    var unionResp = helloWorldBlockingEp->testFloatValueReturn(n);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        test:assertEquals(unionResp, n);
    }
}

@test:Config {enable:true}
public function testDoubleValueReturn() {
    HelloWorld24Client helloWorldBlockingEp = new ("http://localhost:9114");
    float n = 4.5;
    var unionResp = helloWorldBlockingEp->testDoubleValueReturn(n);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        test:assertEquals(unionResp, n);
    }
}

@test:Config {enable:true}
public function testInt64ValueReturn() {
    HelloWorld24Client helloWorldBlockingEp = new ("http://localhost:9114");
    int n = 45;
    var unionResp = helloWorldBlockingEp->testInt64ValueReturn(n);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        test:assertEquals(unionResp, n);
    }
}

@test:Config {enable:true}
public function testBoolValueReturn() {
    HelloWorld24Client helloWorldBlockingEp = new ("http://localhost:9114");
    boolean b = true;
    var unionResp = helloWorldBlockingEp->testBoolValueReturn(b);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        test:assertTrue(unionResp);
    }
}

@test:Config {enable:true}
public function testBytesValueReturn() {
    HelloWorld24Client helloWorldBlockingEp = new ("http://localhost:9114");
    string s = "Ballerina";
    var unionResp = helloWorldBlockingEp->testBytesValueReturn(s.toBytes());
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        string|error returnedString = langstring:fromBytes(unionResp);
        if (returnedString is string) {
            test:assertEquals(returnedString, s);
        } else {
            test:assertFail(msg = returnedString.message());
        }
    }
}

@test:Config {enable:true}
public function testRecordValueReturn() {
    HelloWorld24Client helloWorldBlockingEp = new ("http://localhost:9114");
    var unionResp = helloWorldBlockingEp->testRecordValueReturn("WSO2");
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        test:assertEquals(unionResp.name, "Ballerina Language");
        test:assertEquals(unionResp.id, 0);
    }
}

@test:Config {enable:true}
public function testRecordValueReturnStream() {
    HelloWorld24Client helloWorldEp = new ("http://localhost:9114");
    var unionResp = helloWorldEp->testRecordValueReturnStream("WSO2");
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    }
}

public client class HelloWorld24Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_24, getDescriptorMap24());
    }

    isolated remote function testStringValueReturn(string|ContextString req) returns (string|Error) {

        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testStringValueReturn", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function testStringValueReturnContext(string|ContextString req) returns (ContextString|Error) {

        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testStringValueReturn", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function testFloatValueReturn(float|ContextFloat req) returns (float|Error) {

        map<string|string[]> headers = {};
        float message;
        if (req is ContextFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testFloatValueReturn", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;

        return <float>result;

    }
    isolated remote function testFloatValueReturnContext(float|ContextFloat req) returns (ContextFloat|Error) {

        map<string|string[]> headers = {};
        float message;
        if (req is ContextFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testFloatValueReturn", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;

        return {content: <float>result, headers: respHeaders};
    }

    isolated remote function testDoubleValueReturn(float|ContextFloat req) returns (float|Error) {

        map<string|string[]> headers = {};
        float message;
        if (req is ContextFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testDoubleValueReturn", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;

        return <float>result;

    }
    isolated remote function testDoubleValueReturnContext(float|ContextFloat req) returns (ContextFloat|Error) {

        map<string|string[]> headers = {};
        float message;
        if (req is ContextFloat) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testDoubleValueReturn", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;

        return {content: <float>result, headers: respHeaders};
    }

    isolated remote function testInt64ValueReturn(int|ContextInt req) returns (int|Error) {

        map<string|string[]> headers = {};
        int message;
        if (req is ContextInt) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testInt64ValueReturn", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;

        return <int>result;

    }
    isolated remote function testInt64ValueReturnContext(int|ContextInt req) returns (ContextInt|Error) {

        map<string|string[]> headers = {};
        int message;
        if (req is ContextInt) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testInt64ValueReturn", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;

        return {content: <int>result, headers: respHeaders};
    }

    isolated remote function testBoolValueReturn(boolean|ContextBoolean req) returns (boolean|Error) {

        map<string|string[]> headers = {};
        boolean message;
        if (req is ContextBoolean) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testBoolValueReturn", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;

        return <boolean>result;

    }
    isolated remote function testBoolValueReturnContext(boolean|ContextBoolean req) returns (ContextBoolean|Error) {

        map<string|string[]> headers = {};
        boolean message;
        if (req is ContextBoolean) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testBoolValueReturn", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;

        return {content: <boolean>result, headers: respHeaders};
    }

    isolated remote function testBytesValueReturn(byte[]|ContextByte req) returns (byte[]|Error) {

        map<string|string[]> headers = {};
        byte[] message;
        if (req is ContextByte) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testBytesValueReturn", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;

        return <byte[]>result;

    }
    isolated remote function testBytesValueReturnContext(byte[]|ContextByte req) returns (ContextByte|Error) {

        map<string|string[]> headers = {};
        byte[] message;
        if (req is ContextByte) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testBytesValueReturn", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;

        return {content: <byte[]>result, headers: respHeaders};
    }

    isolated remote function testRecordValueReturn(string|ContextString req) returns (SampleMsg24|Error) {

        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testRecordValueReturn", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;

        return <SampleMsg24>result;

    }
    isolated remote function testRecordValueReturnContext(string|ContextString req) returns (ContextSampleMsg24|Error) {

        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld24/testRecordValueReturn", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;

        return {content: <SampleMsg24>result, headers: respHeaders};
    }

    isolated remote function testRecordValueReturnStream(string req) returns stream<anydata>|Error {

        return self.grpcClient->executeServerStreaming("HelloWorld24/testRecordValueReturnStream", req);
    }

}




