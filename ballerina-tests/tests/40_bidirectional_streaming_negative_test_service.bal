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

import ballerina/grpc;
import ballerina/log;

listener grpc:Listener ep40 = new (9140);

@grpc:Descriptor {
    value: BIDIRECTIONAL_STREAMING_NEGATIVE_TEST_DESC
}
service "ChatWithCaller" on ep40 {

    isolated remote function call(stream<ChatMessage40, grpc:Error?> clientStream) returns stream<string, error?>|error {
        log:printInfo("Invoke the call1 RPC");
        return error grpc:UnKnownError("Unknown gRPC error occured.");
    }
}
