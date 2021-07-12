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

listener Listener ep43 = new (9143);

@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_43, descMap: getDescriptorMap43()}
service "NestedMsgService" on ep43 {

    isolated remote function nestedMsgUnary(string value) returns error|NestedMsg {
        return {name: "Name 01", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 1}}}};
    }

    isolated remote function nestedMsgServerStreaming(string value) returns error|stream<NestedMsg, error?> {
        NestedMsg[] messages = [
            {name: "Name 01", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 1}}}}, 
            {name: "Name 02", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 2}}}}, 
            {name: "Name 03", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 3}}}}, 
            {name: "Name 04", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 4}}}}, 
            {name: "Name 05", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 5}}}}
        ];
        return messages.toStream();
    }

    isolated remote function nestedMsgClientStreaming(stream<NestedMsg, Error?> clientStream) returns error|string {
        return "Ack 43";
    }

    isolated remote function nestedMsgBidirectionalStreaming(stream<NestedMsg, Error?> clientStream) returns error|stream<NestedMsg, error?> {
        NestedMsg[] messages = [
            {name: "Name 01", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 1}}}}, 
            {name: "Name 02", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 2}}}}, 
            {name: "Name 03", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 3}}}}, 
            {name: "Name 04", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 4}}}}, 
            {name: "Name 05", msg: {name1: "Level 01", msg1: {name2: "Level 02", msg2: {name3: "Level 03", id: 5}}}}
        ];
        return messages.toStream();
    }
}

