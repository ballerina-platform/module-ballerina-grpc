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
import ballerina/time;
import ballerina/protobuf.types.'any;

listener grpc:Listener ep66 = new (9166);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_66_PREDEFINED_TYPES_IN_MESSAGES, descMap: getDescriptorMap66PredefinedTypesInMessages()}
service "PredefinedTypesInService" on ep66 {

    remote function anyCall(AnyMessageRequest value) returns AnyMessageResponse|error {
        AnyTypeMsgForAnyMessage msg = {name: "Ballerina", code: 71};
        return {name: "Ballerina", details: 'any:pack(msg)};
    }
    remote function structCall(StructMessageRequest value) returns StructMessageResponse|error {
        return {name: "Ballerina", details: {"key1": "Hello", "key2": 25, "key3": false}};
    }
    remote function timestampCall(TimestampMessageRequest value) returns TimestampMessageResponse|error {
        time:Utc t = check time:utcFromString("2008-12-03T11:15:30.120Z");
        return {name: "Ballerina", details: t};
    }
    remote function durationCall(DurationMessageRequest value) returns DurationMessageResponse|error {
        time:Seconds s = 4.44d;
        return {name: "Ballerina", details: s};
    }
}

