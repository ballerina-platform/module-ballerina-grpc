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

listener Listener ep57 = new (9157);

@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_57, descMap: getDescriptorMap57()}
service "StructService" on ep57 {

    remote function getStructType1(string value) returns map<anydata>|error {
        return sendingStruct;
    }

    remote function getStructType2(string value) returns StructMsg|error {
        return sendingStructMsg;
    }

    remote function sendStructType1(map<anydata> value) returns string|error {
        if expectedStruct == value {
            return "OK";
        }
        return error Error("Type mismatch");
    }

    remote function sendStructType2(StructMsg value) returns string|error {
        if expectedStructMsg == value {
            return "OK";
        }
        return error Error("Type mismatch");
    }

    remote function exchangeStructType1(map<anydata> value) returns map<anydata>|error {
        if expectedStruct == value {
            return sendingStruct;
        }
        return error Error("Type mismatch");
    }

    remote function exchangeStructType2(StructMsg value) returns StructMsg|error {
        if expectedStructMsg == value {
            return sendingStructMsg;
        }
        return error Error("Type mismatch");
    }

    remote function serverStreamStructType1(map<anydata> value) returns stream<map<anydata>, error?> {
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
            value,
            sendingStruct
        ];
        return structArr.toStream();
    }

    remote function serverStreamStructType2(StructMsg value) returns stream<StructMsg, error?> {
        StructMsg structmsg1 = {
            name: "SM2",
            struct: {
                "key1": "WSO2",
                "key2": -25,
                "key3": [1, "Hello"]
            }
        };
        StructMsg structmsg2 = {
            name: "SM3",
            struct: {}
        };
        StructMsg[] structArr = [
            structmsg1,
            structmsg2,
            value,
            sendingStructMsg
        ];
        return structArr.toStream();
    }

    remote function clientStreamStructType1(stream<map<anydata>, error?> clientStream) returns map<anydata>|error {
        int count = 0;
        map<anydata> response = {};
        error? e = clientStream.forEach(function(map<anydata> val) {
            response[count.toString()] = val;
            count += 1;
        });
        if e is error {
            return error Error("Incorrect request data");
        } else {
            return response;
        }
    }

    remote function clientStreamStructType2(stream<StructMsg, error?> clientStream) returns StructMsg|error {
        int count = 0;
        StructMsg response = {
            name: "Response",
            struct: {}
        };
        error? e = clientStream.forEach(function(map<anydata> val) {
            response.struct[count.toString()] = val;
            count += 1;
        });
        if e is error {
            return error Error("Incorrect request data");
        } else {
            return response;
        }
    }

    remote function bidirectionalStreamStructType1(stream<map<anydata>, error?> clientStream) returns stream<map<anydata>, error?> {
        map<anydata>[] response = [];
        error? e = clientStream.forEach(function(map<anydata> val) {
            response.push(val);
        });
        return response.toStream();
    }

    remote function bidirectionalStreamStructType2(stream<StructMsg, error?> clientStream) returns stream<StructMsg, error?> {
        StructMsg[] response = [];
        error? e = clientStream.forEach(function(StructMsg val) {
            response.push(val);
        });
        return response.toStream();
    }
}
