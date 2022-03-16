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
import ballerina/protobuf.types.'any;
import ballerina/time;

listener grpc:Listener ep65 = new (9165);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_65_REPEATED_TYPES, descMap: getDescriptorMap65RepeatedTypes()}
service "RepeatedTypesService" on ep65 {

    remote function anyCall(AnyArrayRequest value) returns AnyArrayResponse|error {
        AnyTypeMsg msg = {name: "Ballerina", code: 71};
        'any:Any[] details = [
            'any:pack("Hello Ballerina"),
            'any:pack(71),
            'any:pack(msg)
        ];
        return {name: "Ballerina", details: details};
    }
    remote function structCall(StructArrayRequest value) returns StructArrayResponse|error {
        map<anydata>[] details = [
            {"key1": "Hello", "key2": 25, "key3": false},
            {"key1": "WSO2", "key2": -25, "key3": [1, "Hello"]},
            {}
        ];
        return {name: "Ballerina", details: details};
    }
    remote function timestampCall(TimestampArrayRequest value) returns TimestampArrayResponse|error {
        time:Utc t1 = check time:utcFromString("2008-12-03T11:15:30.120Z");
        time:Utc t2 = check time:utcFromString("2008-12-03T11:16:30.120Z");
        time:Utc t3 = check time:utcFromString("2008-12-03T11:17:30.120Z");
        time:Utc[] details = [t1, t2, t3];
        return {name: "Ballerina", details: details};
    }
    remote function durationCall(DurationArrayRequest value) returns DurationArrayResponse|error {
        time:Seconds[] details = [1.11d, 2.22d, 3.33d, 4.44d];
        return {name: "Ballerina", details: details};
    }
}

