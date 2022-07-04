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

import ballerina/grpc;
import ballerina/log;
import grpc_tests.messages.message1;
import grpc_tests.messages.message2;

listener grpc:Listener ep70 = new (9170);

@grpc:Descriptor {value: PACKAGE_WITH_NESTED_MODULES_DESC}
service "helloWorld70" on ep70 {

    remote function helloWorld70Unary(message1:ReqMessage value) returns message2:ResMessage|error {
        log:printInfo("Received unary message " + value.toString());
        message2:ResMessage response = {req: 1, value: "Hello"};
        return response;
    }

    remote function helloWorld70ClientStream(stream<message1:ReqMessage, grpc:Error?> clientStream) returns message2:ResMessage|error {
        check clientStream.forEach(function (message1:ReqMessage msg) {
            log:printInfo("Received client streaming message " + msg.toString());
        });
        message2:ResMessage response = {req: 1, value: "Hello"};
        return response;
    }

    remote function helloWorld70ServerStream(message1:ReqMessage value) returns stream<message2:ResMessage, error?>|error {
        log:printInfo("Received server streaming message " + value.toString());
        message2:ResMessage res1 = {req: 1, value: "Hello"};
        message2:ResMessage res2 = {req: 2, value: "Hi"};
        return [res1, res2].toStream();
    }

    remote function helloWorld70BidiStream(stream<message1:ReqMessage, grpc:Error?> clientStream) returns stream<message2:ResMessage, error?>|error {
        check clientStream.forEach(function (message1:ReqMessage msg) {
            log:printInfo("Received bidi streaming message " + msg.toString());
        });
        message2:ResMessage res1 = {req: 1, value: "Hello"};
        message2:ResMessage res2 = {req: 2, value: "Hi"};
        return [res1, res2].toStream();
    }
}
