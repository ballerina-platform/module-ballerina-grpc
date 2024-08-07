// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
// This is the server implementation of the unary blocking/unblocking scenario.
import ballerina/grpc;
import ballerina/log;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR,
    descMap: getDescriptorMap()
}
service "HelloWorld" on ep {

    function init() {
        log:printInfo("init");
    }

    remote function hello(ContextString request) returns ContextString|error {
        log:printInfo("Invoked the hello RPC call.");
        // Reads the request content.
        string message = "Hello " + request.content + self.foo();

        // Reads custom headers in request message.
        string reqHeader = check grpc:getHeader(request.headers, "client_header_key");
        log:printInfo("Server received header value: " + reqHeader);

        // Sends response with custom headers.
        return {
            content: message,
            headers: {server_header_key: "Response Header value"}
        };
    }

    function foo() returns string {
        return " msg";
    }
}
