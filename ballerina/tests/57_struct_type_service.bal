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

listener Listener ep57 = new (9157);

@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_57, descMap: getDescriptorMap57()}
service "StructService" on ep57 {

    remote function getStruct(string value) returns map<anydata>|error {
        map<anydata> res = {
            "r": -242.214,
            "t": false,
            "u": 123473623,
            "v": true,
            "w": 12.085,
            "x": "Test String",
            "y": 150,
            "z": [10, "Test String 2", true, -102.354, [1, "Test String 3", ["Test String 4", false, -1249.124]]]
        };
        return res;
    }

    remote function sendStruct(map<anydata> value) returns string|error {
        map<anydata> expected = {
            "r": -242.214,
            "t": false,
            "u": 123473623.0,
            "v": true,
            "w": 12.085,
            "x": "Test String",
            "y": 150.0,
            "z": [10.0, "Test String 2", true, -102.354, [1.0, "Test String 3", ["Test String 4", false, -1249.124]]]
        };
        if expected == value {
            return "OK";
        }
        return value.toString();
    }

    remote function exchangeStruct(map<anydata> value) returns map<anydata>|error {
        map<anydata> expected = {
            "r": -242.214,
            "t": false,
            "u": 123473623.0,
            "v": true,
            "w": 12.085,
            "x": "Test String",
            "y": 150.0,
            "z": [10.0, "Test String 2", true, -102.354, [1.0, "Test String 3", ["Test String 4", false, -1249.124]]]
        };
        if expected == value {
            map<anydata> sending = {
                "r": -242.214,
                "t": false,
                "u": 123473623,
                "v": true,
                "w": 12.085,
                "x": "Test String",
                "y": 150,
                "z": [10, "Test String 2", true, -102.354, [1, "Test String 3", ["Test String 4", false, -1249.124]]]
            };
            return sending;
        }
        return value;
    }

    remote function serverStreamStruct(map<anydata> value) returns stream<map<anydata>, error?> {
        map<anydata>[] structArr = [
            {
                "key1": "Hello",
                "key2": 25,
                "key3": false
            },
            {
                "key1": "WSO2",
                "key2": -25,
                "key3": [1, "Hello"]
            },
            {},
            value
        ];
        return structArr.toStream();
    }

    remote function clientStreamStruct(stream<map<anydata>, error?> clientStream) returns map<anydata>|error {
        int count = 0;
        map<anydata> response = {};
        error? e = clientStream.forEach(function(map<anydata> val) {
            response[count.toString()] = val;
            count += 1;
        });
        if e is error {
            return error Error("Incorrect request data");
        } else {
            return <map<anydata>>response["0"];
        }
    }

    remote function bidirectionalStreamStruct(stream<map<anydata>, error?> clientStream) returns stream<map<anydata>, error?> {
        map<anydata>[] response = [];
        error? e = clientStream.forEach(function(map<anydata> val) {
            response.push(val);
        });
        return response.toStream();
    }
}
