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
import ballerina/test;

@test:Config {enable: true}
isolated function testStringValueReturnWithBasicAuth() returns Error? {
    HelloWorld28Client helloWorldEp = check new ("http://localhost:9118");
    map<string|string[]> requestHeaders = {};

    CredentialsConfig config = {
        username: "admin",
        password: "123"
    };

    ClientBasicAuthHandler handler = new (config);
    map<string|string[]>|ClientAuthError result = handler.enrich(requestHeaders);
    if result is ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    ContextString requestMessage = {
        content: "WSO2",
        headers: requestHeaders
    };
    var response = helloWorldEp->testStringValueReturn(requestMessage);
    if response is Error {
        test:assertFail(msg = response.message());
    } else {
        test:assertEquals(response, "Hello WSO2");
    }
}

@test:Config {enable: true}
isolated function testStringValueReturnWithInvalidBasicAuth() returns Error? {
    HelloWorld28Client helloWorldEp = check new ("http://localhost:9118");
    map<string|string[]> requestHeaders = {};

    CredentialsConfig config = {
        username: "admin",
        password: "1234"
    };

    ClientBasicAuthHandler handler = new (config);
    map<string|string[]>|ClientAuthError result = handler.enrich(requestHeaders);
    if result is ClientAuthError {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    ContextString requestMessage = {
        content: "WSO2",
        headers: requestHeaders
    };
    var response = helloWorldEp->testStringValueReturn(requestMessage);
    if response is Error {
        test:assertEquals(response.message(), "Failed to authenticate username 'admin' from file user store.");
    } else {
        test:assertFail(msg = "Expected grpc:Error not found.");
    }
}

@test:Config {enable: true}
isolated function testStringValueReturnWithBasicAuthWithEmpty() returns Error? {
    HelloWorld28Client helloWorldEp = check new ("http://localhost:9118");
    map<string|string[]> requestHeaders = {};

    CredentialsConfig config = {
        username: "",
        password: "1234"
    };

    ClientBasicAuthHandler handler = new (config);
    map<string|string[]>|ClientAuthError result = handler.enrich(requestHeaders);
    if result is ClientAuthError {
        test:assertEquals(result.message(), "Failed to enrich request with Basic Auth token. Username or password cannot be empty.");
    } else {
        test:assertFail(msg = "Expected grpc:Error not found.");
    }
}

@test:Config {enable: true}
isolated function testStringValueReturnWithBasicAuthWithInvalidHeader() returns Error? {
    HelloWorld28Client helloWorldEp = check new ("http://localhost:9118");
    map<string|string[]> requestHeaders = {
        "authorization": "Bearer "
    };

    ContextString requestMessage = {
        content: "WSO2",
        headers: requestHeaders
    };
    var response = helloWorldEp->testStringValueReturn(requestMessage);
    if response is Error {
        test:assertEquals(response.message(), "Empty authentication header.");
    } else {
        test:assertFail(msg = "Expected an error");
    }
}
