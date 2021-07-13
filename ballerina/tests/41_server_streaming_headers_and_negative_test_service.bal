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

listener Listener ep41 = new (9141);

@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_41, descMap: getDescriptorMap41()}
service "Chat41" on ep41 {

    remote function call1(ChatMessage41 value) returns ContextStringStream|error {
        log:printInfo(value.toString());
        string[] arr = ["a", "b", "c"];
        map<string> headers = {
            h1: "v1"
        };
        return {content: arr.toStream(), headers: headers};
    }

    remote function call2(ChatMessage41 value) returns ContextStringStream|error {
        return error UnKnownError("Unknown gRPC error occured.");
    }
}
