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

import ballerina/grpc;
import ballerina/io;
import ballerina/test;

type ByteArrayTypedesc typedesc<byte[]>;

@test:Config {enable: true}
isolated function testByteArray() returns grpc:Error? {
    ByteServiceClient blockingEp = check new ("http://localhost:9101");
    string statement = "Lion in Town.";
    byte[] bytes = statement.toBytes();

    byte[] response = check blockingEp->checkBytes(bytes);
    test:assertEquals(response, bytes);
}

@test:Config {enable: true}
isolated function testLargeByteArray() returns error? {
    string filePath = "tests/resources/sample_bytes.txt";
    ByteServiceClient blockingEp = check new ("http://localhost:9101");
    io:ReadableByteChannel rch = check io:openReadableFile(filePath);

    byte[] resultBytes = check rch.read(10000);
    byte[] response = check blockingEp->checkBytes(resultBytes);
    test:assertEquals(response, resultBytes);
}
