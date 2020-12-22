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
import ballerina/log;
import ballerina/lang.'string as langstring;

@test:Config {}
public function testStringValueReturn() {
    HelloWorld24BlockingClient helloWorldBlockingEp = new ("http://localhost:9114");
    var unionResp = helloWorldBlockingEp->testStringValueReturn("WSO2");
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        string result = "";
        [result, _] = unionResp;
        test:assertEquals(result, "WSO2");
    }
}

@test:Config {}
public function testFloatValueReturn() {
    HelloWorld24BlockingClient helloWorldBlockingEp = new ("http://localhost:9114");
    float n = 4.5;
    var unionResp = helloWorldBlockingEp->testFloatValueReturn(n);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        float result = 0.0;
        [result, _] = unionResp;
        test:assertEquals(result, n);
    }
}

@test:Config {}
public function testDoubleValueReturn() {
    HelloWorld24BlockingClient helloWorldBlockingEp = new ("http://localhost:9114");
    float n = 4.5;
    var unionResp = helloWorldBlockingEp->testDoubleValueReturn(n);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        float result = 0.0;
        [result, _] = unionResp;
        test:assertEquals(result, n);
    }
}

@test:Config {}
public function testInt64ValueReturn() {
    HelloWorld24BlockingClient helloWorldBlockingEp = new ("http://localhost:9114");
    int n = 45;
    var unionResp = helloWorldBlockingEp->testInt64ValueReturn(n);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        int result = 0;
        [result, _] = unionResp;
        test:assertEquals(result, n);
    }
}

@test:Config {}
public function testBoolValueReturn() {
    HelloWorld24BlockingClient helloWorldBlockingEp = new ("http://localhost:9114");
    boolean b = true;
    var unionResp = helloWorldBlockingEp->testBoolValueReturn(b);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        boolean result = false;
        [result, _] = unionResp;
        test:assertTrue(result);
    }
}

@test:Config {}
public function testBytesValueReturn() {
    HelloWorld24BlockingClient helloWorldBlockingEp = new ("http://localhost:9114");
    string s = "Ballerina";
    var unionResp = helloWorldBlockingEp->testBytesValueReturn(s.toBytes());
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        byte[] result = [];
        [result, _] = unionResp;
        string|error returnedString = langstring:fromBytes(result);
        if (returnedString is string) {
            test:assertEquals(returnedString, s);
        } else {
            test:assertFail(msg = returnedString.message());
        }
    }
}

@test:Config {}
public function testRecordValueReturn() {
    HelloWorld24BlockingClient helloWorldBlockingEp = new ("http://localhost:9114");
    var unionResp = helloWorldBlockingEp->testRecordValueReturn("WSO2");
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        SampleMsg24 result;
        [result, _] = unionResp;
        test:assertEquals(result.name, "Ballerina Language");
        test:assertEquals(result.id, 0);
    }
}

@test:Config {}
public function testRecordValueReturnStream() {
    HelloWorld24Client helloWorldEp = new ("http://localhost:9114");
    var unionResp = helloWorldEp->testRecordValueReturnStream("WSO2", messageListener24);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    }
}

service object {} messageListener24 = service object {

    function onMessage(SampleMsg24 msg) {
        log:print("Response received from server: " + msg.name);
    }

    function onError(error err) {
        log:printError("Error from Connector: " + err.message());
    }

    function onComplete() {
        log:print("Server Complete Sending Responses.");
    }
};

public client class HelloWorld24BlockingClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new (url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR_24, getDescriptorMap24());
    }

    isolated remote function testStringValueReturn(string req, Headers? headers = ()) returns ([string, 
    Headers]|Error) {

        var payload = check self.grpcClient->blockingExecute("HelloWorld24/testStringValueReturn", req, headers);
        Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        return [result.toString(), resHeaders];
    }

    isolated remote function testFloatValueReturn(float req, Headers? headers = ()) returns ([float, Headers]|
    Error) {

        var payload = check self.grpcClient->blockingExecute("HelloWorld24/testFloatValueReturn", req, headers);
        Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;

        return [<float>result, resHeaders];

    }

    isolated remote function testDoubleValueReturn(float req, Headers? headers = ()) returns ([float, Headers]|
    Error) {

        var payload = check self.grpcClient->blockingExecute("HelloWorld24/testDoubleValueReturn", req, headers);
        Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;

        return [<float>result, resHeaders];

    }

    isolated remote function testInt64ValueReturn(int req, Headers? headers = ()) returns ([int, Headers]|
    Error) {

        var payload = check self.grpcClient->blockingExecute("HelloWorld24/testInt64ValueReturn", req, headers);
        Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;

        return [<int>result, resHeaders];

    }

    isolated remote function testBoolValueReturn(boolean req, Headers? headers = ()) returns ([boolean, 
    Headers]|Error) {

        var payload = check self.grpcClient->blockingExecute("HelloWorld24/testBoolValueReturn", req, headers);
        Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;

        return [<boolean>result, resHeaders];

    }

    isolated remote function testBytesValueReturn(byte[] req, Headers? headers = ()) returns ([byte[], Headers]|
    Error) {

        var payload = check self.grpcClient->blockingExecute("HelloWorld24/testBytesValueReturn", req, headers);
        Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;

        return [<byte[]>result, resHeaders];

    }

    isolated remote function testRecordValueReturn(string req, Headers? headers = ()) returns ([SampleMsg24, 
    Headers]|Error) {

        var payload = check self.grpcClient->blockingExecute("HelloWorld24/testRecordValueReturn", req, headers);
        Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;

        return [<SampleMsg24>result, resHeaders];

    }

    isolated remote function testRecordValueReturnStream(string req, service object {} msgListener, 
                                                         Headers? headers = ()) returns (Error?) {

        return self.grpcClient->nonBlockingExecute("HelloWorld24/testRecordValueReturnStream", req, msgListener, headers);
    }
}

public client class HelloWorld24Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new (url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_24, getDescriptorMap24());
    }

    isolated remote function testStringValueReturn(string req, service object {} msgListener, Headers? headers = ()) returns (
    Error?) {

        return self.grpcClient->nonBlockingExecute("HelloWorld24/testStringValueReturn", req, msgListener, headers);
    }

    isolated remote function testFloatValueReturn(float req, service object {} msgListener, Headers? headers = ()) returns (
    Error?) {

        return self.grpcClient->nonBlockingExecute("HelloWorld24/testFloatValueReturn", req, msgListener, headers);
    }

    isolated remote function testDoubleValueReturn(float req, service object {} msgListener, Headers? headers = ()) returns (
    Error?) {

        return self.grpcClient->nonBlockingExecute("HelloWorld24/testDoubleValueReturn", req, msgListener, headers);
    }

    isolated remote function testInt64ValueReturn(int req, service object {} msgListener, Headers? headers = ()) returns (
    Error?) {

        return self.grpcClient->nonBlockingExecute("HelloWorld24/testInt64ValueReturn", req, msgListener, headers);
    }

    isolated remote function testBoolValueReturn(boolean req, service object {} msgListener, Headers? headers = ()) returns (
    Error?) {

        return self.grpcClient->nonBlockingExecute("HelloWorld24/testBoolValueReturn", req, msgListener, headers);
    }

    isolated remote function testBytesValueReturn(byte[] req, service object {} msgListener, Headers? headers = ()) returns (
    Error?) {

        return self.grpcClient->nonBlockingExecute("HelloWorld24/testBytesValueReturn", req, msgListener, headers);
    }

    isolated remote function testRecordValueReturn(string req, service object {} msgListener, Headers? headers = ()) returns (
    Error?) {

        return self.grpcClient->nonBlockingExecute("HelloWorld24/testRecordValueReturn", req, msgListener, headers);
    }

    isolated remote function testRecordValueReturnStream(string req, service object {} msgListener, 
                                                         Headers? headers = ()) returns (Error?) {

        return self.grpcClient->nonBlockingExecute("HelloWorld24/testRecordValueReturnStream", req, msgListener, headers);
    }
}


