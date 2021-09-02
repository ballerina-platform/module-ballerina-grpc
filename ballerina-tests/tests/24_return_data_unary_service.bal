// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/io;

listener grpc:Listener  ep24 = new (9114);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_24_RETURN_DATA_UNARY,
    descMap: getDescriptorMap24ReturnDataUnary()
}
service /HelloWorld24 on ep24 {

    remote isolated function testStringValueReturn(string value) returns string {
        io:print("Received input for testStringValueReturn: ");
        io:println(value);
        return value;
    }
    remote isolated function testFloatValueReturn(float value) returns float {
        io:print("Received input for testFloatValueReturn: ");
        io:println(value);
        return value;
    }
    remote isolated function testDoubleValueReturn(float value) returns float {
        io:print("Received input for testDoubleValueReturn: ");
        io:println(value);
        return value;
    }
    remote isolated function testInt64ValueReturn(int value) returns int {
        io:print("Received input for testInt64ValueReturn: ");
        io:println(value);
        return value;
    }
    remote isolated function testBoolValueReturn(boolean value) returns boolean {
        io:print("Received input for testBoolValueReturn: ");
        io:println(value);
        return value;
    }
    remote isolated function testBytesValueReturn(byte[] value) returns byte[] {
        io:print("Received input for testBytesValueReturn: ");
        io:println(value);
        return value;
    }
    remote isolated function testRecordValueReturn(string value) returns SampleMsg24 {
        io:print("Received input for testRecordValueReturn: ");
        io:println(value);
        SampleMsg24 msg = {
            name: "Ballerina Language",
            id: 0
        };
        return msg;
    }
    remote isolated function testRecordValueReturnStream(string value) returns stream<SampleMsg24, error?> {
        io:print("Received input for testRecordValueReturnStream: ");
        io:println(value);
        SampleMsg24[] arr = [
            { name: "WSO2", id: 0},
            { name: "Microsoft", id: 1},
            { name: "Google", id: 2},
            { name: "IBM", id: 3}
        ];
        return arr.toStream();
    }
}
