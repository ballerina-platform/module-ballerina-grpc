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

import ballerina/test;
import ballerina/lang.'string as langstring;

@test:Config {enable:true}
public isolated function testStringValueReturn() returns Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    var unionResp = helloWorldBlockingEp->testStringValueReturn("WSO2");
    if (unionResp is Error) {
        test:assertFail(msg = string `Error from Connector: ${unionResp.message()}`);
    } else {
        test:assertEquals(unionResp, "WSO2");
    }
}

@test:Config {enable:true}
public isolated function testFloatValueReturn() returns Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    float n = 4.5;
    var unionResp = helloWorldBlockingEp->testFloatValueReturn(n);
    if (unionResp is Error) {
        test:assertFail(msg = string `Error from Connector: ${unionResp.message()}`);
    } else {
        test:assertEquals(unionResp, n);
    }
}

@test:Config {enable:true}
public isolated function testDoubleValueReturn() returns Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    float n = 4.5;
    var unionResp = helloWorldBlockingEp->testDoubleValueReturn(n);
    if (unionResp is Error) {
        test:assertFail(msg = string `Error from Connector: ${unionResp.message()}`);
    } else {
        test:assertEquals(unionResp, n);
    }
}

@test:Config {enable:true}
public isolated function testInt64ValueReturn() returns Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    int n = 45;
    var unionResp = helloWorldBlockingEp->testInt64ValueReturn(n);
    if (unionResp is Error) {
        test:assertFail(msg = string `Error from Connector: ${unionResp.message()}`);
    } else {
        test:assertEquals(unionResp, n);
    }
}

@test:Config {enable:true}
public isolated function testBoolValueReturn() returns Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    boolean b = true;
    var unionResp = helloWorldBlockingEp->testBoolValueReturn(b);
    if (unionResp is Error) {
        test:assertFail(msg = string `Error from Connector: ${unionResp.message()}`);
    } else {
        test:assertTrue(unionResp);
    }
}

@test:Config {enable:true}
public isolated function testBytesValueReturn() returns Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    string s = "Ballerina";
    var unionResp = helloWorldBlockingEp->testBytesValueReturn(s.toBytes());
    if (unionResp is Error) {
        test:assertFail(msg = string `Error from Connector: ${unionResp.message()}`);
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
public isolated function testRecordValueReturn() returns Error? {
    HelloWorld24Client helloWorldBlockingEp = check new ("http://localhost:9114");
    var unionResp = helloWorldBlockingEp->testRecordValueReturn("WSO2");
    if (unionResp is Error) {
        test:assertFail(msg = string `Error from Connector: ${unionResp.message()}`);
    } else {
        test:assertEquals(unionResp.name, "Ballerina Language");
        test:assertEquals(unionResp.id, 0);
    }
}

@test:Config {enable:true}
public isolated function testRecordValueReturnStream() returns Error? {
    HelloWorld24Client helloWorldEp = check new ("http://localhost:9114");
    var unionResp = helloWorldEp->testRecordValueReturnStream("WSO2");
    if (unionResp is Error) {
        test:assertFail(msg = string `Error from Connector: ${unionResp.message()}`);
    }
}
