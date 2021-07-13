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

listener Listener ep42 = new (9142);

@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_42, descMap: getDescriptorMap42()}
service "DataTypesService" on ep42 {

    remote function helloWithInt32Array(string value) returns stream<Int32ArrMsg, error?>|error {
        log:printInfo(value);
        Int32ArrMsg[] arr = [
            {note: "note1", arr: [1, 2, 3]},
            {note: "note2", arr: [1, 2, 3, 4]},
            {note: "note3", arr: [1, 2, 3, 4, 5]},
            {note: "note4", arr: [1, 2, 3, 4, 5, 6]},
            {note: "note5", arr: [1, 2, 3, 4, 5, 6, 7]}
        ];
        return arr.toStream();
    }
    remote function helloWithInt64Array(string value) returns stream<Int64ArrMsg, error?>|error {
        log:printInfo(value);
        Int64ArrMsg[] arr = [
            {note: "note1", arr: [1, 2, 3]},
            {note: "note2", arr: [1, 2, 3, 4]},
            {note: "note3", arr: [1, 2, 3, 4, 5]},
            {note: "note4", arr: [1, 2, 3, 4, 5, 6]},
            {note: "note5", arr: [1, 2, 3, 4, 5, 6, 7]}
        ];
        return arr.toStream();
    }
    remote function helloWithUnsignedInt64Array(string value) returns stream<UnsignedInt64ArrMsg, error?>|error {
        log:printInfo(value);
        UnsignedInt64ArrMsg[] arr = [
            {note: "note1", arr: [1, 2, 3]},
            {note: "note2", arr: [1, 2, 3, 4]},
            {note: "note3", arr: [1, 2, 3, 4, 5]},
            {note: "note4", arr: [1, 2, 3, 4, 5, 6]},
            {note: "note5", arr: [1, 2, 3, 4, 5, 6, 7]}
        ];
        return arr.toStream();
    }
    remote function helloWithFixed32Array(string value) returns stream<Fixed32ArrMsg, error?>|error {
        log:printInfo(value);
        Fixed32ArrMsg[] arr = [
            {note: "note1", arr: [1, 2, 3]},
            {note: "note2", arr: [1, 2, 3, 4]},
            {note: "note3", arr: [1, 2, 3, 4, 5]},
            {note: "note4", arr: [1, 2, 3, 4, 5, 6]},
            {note: "note5", arr: [1, 2, 3, 4, 5, 6, 7]}
        ];
        return arr.toStream();
    }
    remote function helloWithFixed64Array(string value) returns stream<Fixed64ArrMsg, error?>|error {
        log:printInfo(value);
        Fixed64ArrMsg[] arr = [
            {note: "note1", arr: [1, 2, 3]},
            {note: "note2", arr: [1, 2, 3, 4]},
            {note: "note3", arr: [1, 2, 3, 4, 5]},
            {note: "note4", arr: [1, 2, 3, 4, 5, 6]},
            {note: "note5", arr: [1, 2, 3, 4, 5, 6, 7]}
        ];
        return arr.toStream();
    }
    remote function helloWithFloatArray(string value) returns stream<FloatArrMsg, error?>|error {
        log:printInfo(value);
        FloatArrMsg[] arr = [
            {note: "note1", arr: [1.0, 2.0, 3.0]},
            {note: "note2", arr: [1.0, 2.0, 3.0, 4.0]},
            {note: "note3", arr: [1.0, 2.0, 3.0, 4.0, 5.0]},
            {note: "note4", arr: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]},
            {note: "note5", arr: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]}
        ];
        return arr.toStream();
    }
    remote function helloWithDoubleArray(string value) returns stream<DoubleArrMsg, error?>|error {
        log:printInfo(value);
        DoubleArrMsg[] arr = [
            {note: "note1", arr: [1.0, 2.0, 3.0]},
            {note: "note2", arr: [1.0, 2.0, 3.0, 4.0]},
            {note: "note3", arr: [1.0, 2.0, 3.0, 4.0, 5.0]},
            {note: "note4", arr: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]},
            {note: "note5", arr: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]}
        ];
        return arr.toStream();
    }
    remote function helloWithStringArray(string value) returns stream<StringArrMsg, error?>|error {
        log:printInfo(value);
        StringArrMsg[] arr = [
            {note: "note1", arr: ["A"]},
            {note: "note2", arr: ["A", "B"]},
            {note: "note3", arr: ["A", "B", "C"]},
            {note: "note4", arr: ["A", "B", "C", "D"]},
            {note: "note5", arr: ["A", "B", "C", "D", "E"]}
        ];
        return arr.toStream();
    }
    remote function helloWithBooleanArray(string value) returns stream<BooleanArrMsg, error?>|error {
        log:printInfo(value);
        BooleanArrMsg[] arr = [
            {note: "note1", arr: [true]},
            {note: "note2", arr: [true, false]},
            {note: "note3", arr: [true, false, true]},
            {note: "note4", arr: [true, false, true, false]},
            {note: "note5", arr: [true, false, true, false, true]}
        ];
        return arr.toStream();
    }
    remote function helloWithBytesArray(string value) returns stream<BytesArrMsg, error?>|error {
        log:printInfo(value);
        BytesArrMsg[] arr = [
            {note: "note1", arr: "A".toBytes()},
            {note: "note2", arr: "B".toBytes()},
            {note: "note3", arr: "C".toBytes()},
            {note: "note4", arr: "D".toBytes()},
            {note: "note5", arr: "E".toBytes()}
        ];
        return arr.toStream();
    }
}

