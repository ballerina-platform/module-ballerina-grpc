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

listener Listener ep46 = new (9146);

@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_46, descMap: getDescriptorMap46()}
service "EmptyHandler" on ep46 {

    remote function unaryWithEmpty() returns error? {
        log:printInfo("Unary call with empty");
    }
    remote function clientStrWithEmpty(stream<string, Error?> clientStream) returns error? {
        log:printInfo("Client streaming call with empty");
        error? e = clientStream.forEach(function(string s) {
            log:printInfo(s);
        });
        return;
    }
    remote function serverStrWithEmpty() returns stream<string, error?>|error {
        log:printInfo("Server streaming call with empty");
        string[] arr = ["WSO2", "Ballerina", "Microsoft", "Azure"];
        return arr.toStream();
    }
}

