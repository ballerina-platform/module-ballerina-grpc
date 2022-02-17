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

listener grpc:Listener ep64 = new (9164);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_64_PREDEFINED_RECORDS, descMap: getDescriptorMap64PredefinedRecords()}
service "PredefinedRecords" on ep64 {

    remote function CallAny('any:Any value) returns Any|error {
        if value == 'any:pack("Any") {
            return {name: "Any"};
        }
        return error(string `Incorrect input: ${value.toBalString()}`);
    }
    remote function CallStruct(map<anydata> value) returns Struct|error {
        if value == {name: "Struct"} {
            return {name: "Struct"};
        }
        return error(string `Incorrect input: ${value.toBalString()}`);
    }
    remote function CallDuration(time:Seconds value) returns Duration|error {
        if value == 12.23d {
            return {name: "Duration"};
        }
        return error(string `Incorrect input: ${value.toBalString()}`);
    }
    remote function CallTimestamp(time:Utc value) returns Timestamp|error {
        time:Utc utc = check time:utcFromString("2007-12-03T10:15:30.00Z");
        if value == utc {
            return {name: "Timestamp"};
        }
        return error(string `Incorrect input: ${value.toBalString()}`);
    }
    remote function CallEmpty() returns Empty|error {
        return {};
    }
}
