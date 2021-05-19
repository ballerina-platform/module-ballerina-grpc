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
import ballerina/log;
import ballerina/io;

listener Listener ep40 = new (9140);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_40,
    descMap: getDescriptorMap40()
}
service "ChatWithCaller" on ep40 {

    isolated remote function call1(stream<ChatMessage40, Error?> clientStream) returns stream<string, error?>|error {
        log:printInfo("Invoke the call1 RPC");
        return error UnKnownError("Unknown gRPC error occured.");
    }
    isolated remote function call2(ContextChatMessage40Stream clientStreamContext) returns stream<string, error?>|error {
        log:printInfo("Invoke the call2 RPC");
        io:println(clientStreamContext);
        return (<string[]>clientStreamContext.headers.get("entry1")).toStream();
    }
    isolated remote function call3(stream<ChatMessage40, Error?> clientStream) returns stream<string, error?>|error {
        log:printInfo("Invoke the call1 RPC");
        return error UnKnownError("Unknown gRPC error occured.");
    }
}
