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

// Client endpoint configuration
HelloWorld8BlockingClient helloWorld8BlockingEp = new ("http://localhost:9098");

@test:Config {}
function testHeadersInUnaryClient() {

    //Working with custom headers
    Headers headers = new;
    headers.setEntry("x-id", "0987654321");
    // Executing unary blocking call
    [string, Headers]|Error unionResp = helloWorld8BlockingEp->hello("WSO2", headers);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        string result = "";
        Headers resHeaders = new;
        [result, resHeaders] = unionResp;
        io:println("Client Got Response : ");
        io:println(result);
        if (resHeaders.exists("x-id")) {
            resHeaders.remove("x-id");
        }
        test:assertEquals(result, "Hello WSO2");
    }
}

@test:Config {}
function testHeadersInBlockingClient() {

    Headers headers = new;
    headers.setEntry("x-id", "0987654321");
    // Executing unary blocking call
    [string, Headers]|Error unionResp = helloWorld8BlockingEp->hello("WSO2", headers);
    if (unionResp is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        string result = "";
        Headers resHeaders = new;
        [result, resHeaders] = unionResp;
        io:println("Client Got Response : ");
        io:println(result);
        string headerValue = resHeaders.get("x-id") ?: "none";
        test:assertEquals(headerValue, "2233445677");
    }
}

// Blocking endpoint.
public client class HelloWorld8BlockingClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR_8, getDescriptorMap8());
    }

    public remote function hello(string req, Headers? headers = ()) returns ([string, Headers]|Error) {
        var unionResp = check self.grpcClient->blockingExecute("grpcservices.HelloWorld101/hello", req, headers);
        anydata result = ();
        Headers resHeaders = new;
        [result, resHeaders] = unionResp;
        return [result.toString(), resHeaders];
    }
}

//Non-blocking endpoint
public client class HelloWorld8Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_8, getDescriptorMap8());
    }

    public remote function hello(string req, service msgListener, Headers? headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld101/hello", req, msgListener, headers);
    }
}
