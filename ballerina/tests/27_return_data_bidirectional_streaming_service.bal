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

import ballerina/io;

listener Listener ep27 = new (9117);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_27,
    descMap: getDescriptorMap27()
}
service "ChatFromReturn" on ep27 {

    remote function chat27(stream<ChatMessage27,error?> clientStream) returns stream<string, error?> {
        string[] messages = [];
        int i = 0;
        error? e = clientStream.forEach(function(ChatMessage27 reqMsg) {
            io:println(reqMsg);
            messages[i] = reqMsg.message + " " + reqMsg.name;
            i += 1;
        });
        return messages.toStream();
    }
}
