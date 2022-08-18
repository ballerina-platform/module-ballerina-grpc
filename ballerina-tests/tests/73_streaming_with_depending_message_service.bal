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

listener grpc:Listener ep73 = new (9173);

@grpc:Descriptor {value: STREAMING_WITH_DEPENDING_MESSAGE_DESC}
service "HelloWorld73" on ep73 {

    remote function hello73Unary(string value) returns ReplyMessage|error {
        log:printInfo("Received : " + value);
        return {id: 1, value: "Hello"};
    }

    remote function hello73Server(string value) returns stream<ReplyMessage, error?>|error {
        log:printInfo("Received : " + value);
        return [{id: 1, value: "Hello"}, {id: 2, value: "Hi"}].toStream();
    }

    remote function hello73Client(stream<ReplyMessage, error?> value) returns ReplyMessage|error {
        log:printInfo("Received : " + value.toString());
        return {id: 1, value: "Hello"};
    }

    remote function hello73Bidi(stream<ReplyMessage, error?> value) returns stream<ReplyMessage, error?>|error {
        log:printInfo("Received : " + value.toString());
        return [{id: 1, value: "Hello"}, {id: 2, value: "Hi"}].toStream();
    }
}

