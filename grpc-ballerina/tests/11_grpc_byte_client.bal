// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/test;

type ByteArrayTypedesc typedesc<byte[]>;

@test:Config {enable:true}
isolated function testByteArray() returns Error? {
    byteServiceClient blockingEp  = check new ("http://localhost:9101");
    string statement = "Lion in Town.";
    byte[] bytes = statement.toBytes();
    var addResponse = blockingEp->checkBytes(bytes);
    if (addResponse is Error) {
        test:assertFail(string `Error from Connector: ${addResponse.message()}`);
    } else {
        test:assertEquals(addResponse, bytes);
    }
}

@test:Config {enable:true}
isolated function testLargeByteArray() returns Error? {
    string filePath = "tests/resources/sample_bytes.txt";
    byteServiceClient blockingEp  = check new ("http://localhost:9101");
    var rch = <@untainted> io:openReadableFile(filePath);
    if (rch is error) {
        test:assertFail("Error while reading the file.");
    } else {
        var resultBytes = rch.read(10000);
        if (resultBytes is byte[]) {
            var addResponse = blockingEp->checkBytes(resultBytes);
            if (addResponse is Error) {
                test:assertFail(string `Error from Connector: ${addResponse.message()}`);
            } else {
                test:assertEquals(addResponse, resultBytes);
            }
        } else {
            test:assertFail(string `File read error: ${resultBytes.message()}`);
        }
    }
}
