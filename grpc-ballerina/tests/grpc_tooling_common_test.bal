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
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/file;
import ballerina/test;

@test:Config {enable:true}
function testHelloWorldWithDependency() {
    assertGeneratedDataTypeSources("data-types", "helloWorldWithDependency.proto", "helloWorldWithDependency_pb.bal", "tool_test_data_type_1");
}

@test:Config {enable:true}
function testHelloWorldWithEnum() {
    assertGeneratedDataTypeSources("data-types", "helloWorldWithEnum.proto", "helloWorldWithEnum_pb.bal", "tool_test_data_type_3");
}

@test:Config {enable:true}
function testHelloWorldWithMap() {
    assertGeneratedDataTypeSources("data-types", "helloWorldWithMap.proto", "helloWorldWithMap_pb.bal", "tool_test_data_type_5");
}

@test:Config {enable:true}
function testHelloWorldWithNestedEnum() {
    assertGeneratedDataTypeSources("data-types", "helloWorldWithNestedEnum.proto", "helloWorldWithNestedEnum_pb.bal", "tool_test_data_type_6");
}

@test:Config {enable:true}
function testHelloWorldWithNestedMessage() {
    assertGeneratedDataTypeSources("data-types", "helloWorldWithNestedMessage.proto", "helloWorldWithNestedMessage_pb.bal", "tool_test_data_type_7");
}

@test:Config {enable:true}
function testHelloWorldWithPackage() {
    assertGeneratedDataTypeSources("data-types", "helloWorldWithPackage.proto", "helloWorldWithPackage_pb.bal", "tool_test_data_type_8");
}

@test:Config {enable:true}
function testHelloWorldWithReservedNames() {
    assertGeneratedDataTypeSources("data-types", "helloWorldWithReservedNames.proto", "helloWorldWithReservedNames_pb.bal", "tool_test_data_type_9");
}

@test:Config {enable:true}
function testMessage() {
    assertGeneratedDataTypeSources("data-types", "message.proto", "message_pb.bal", "tool_test_data_type_10");
}

@test:Config {enable:true}
function testOneofFieldService() {
    assertGeneratedDataTypeSources("data-types", "oneof_field_service.proto", "oneof_field_service_pb.bal", "tool_test_data_type_11");
}

@test:Config {enable:true}
function testTestMessage() {
    assertGeneratedDataTypeSources("data-types", "testMessage.proto", "testMessage_pb.bal", "tool_test_data_type_12");
}

@test:Config {enable:true}
function testWithoutOutputDir() {
    assertGeneratedDataTypeSources("data-types", "message.proto", "message_pb.bal", "");
}

@test:Config {enable:true}
function testHelloWorldErrorSyntax() {
    assertGeneratedDataTypeSourcesNegative("negative", "helloWorldErrorSyntax.proto", "helloWorldErrorSyntax_pb.bal", "tool_test_data_type_2");
}

@test:Config {enable:true}
function testHelloWorldWithInvalidDependency() {
    assertGeneratedDataTypeSourcesNegative("negative", "helloWorldWithInvalidDependency.proto", "helloWorldWithInvalidDependency_pb.bal", "tool_test_data_type_4");
}

function assertGeneratedDataTypeSources(string subDir, string protoFile, string stubFile, string outputDir) {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, subDir, protoFile);
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, outputDir);
    string tempDirPath = checkpanic file:joinPath(file:getCurrentDir(), "temp");

    string expectedStubFilePath = checkpanic file:joinPath(BAL_FILE_DIRECTORY, outputDir, stubFile);
    string actualStubFilePath;
    if (outputDir == "") {
        actualStubFilePath = checkpanic file:joinPath(tempDirPath, stubFile);
        generateSourceCode(protoFilePath, "");
        test:assertTrue(checkpanic file:test(actualStubFilePath, file:EXISTS));
        test:assertFalse(hasDiagnostics(actualStubFilePath));
    } else {
        actualStubFilePath = checkpanic file:joinPath(outputDirPath, stubFile);
        generateSourceCode(protoFilePath, outputDirPath);
        test:assertTrue(checkpanic file:test(actualStubFilePath, file:EXISTS));
        test:assertFalse(hasDiagnostics(actualStubFilePath));
        test:assertEquals(readContent(expectedStubFilePath), readContent(actualStubFilePath));
    }
}

function assertGeneratedDataTypeSourcesNegative(string subDir, string protoFile, string stubFile, string outputDir) {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, subDir, protoFile);
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, outputDir);

    string expectedStubFilePath = checkpanic file:joinPath(BAL_FILE_DIRECTORY, outputDir, stubFile);
    string actualStubFilePath = checkpanic file:joinPath(outputDirPath, stubFile);

    generateSourceCode(protoFilePath, outputDirPath);
    test:assertFalse(checkpanic file:test(actualStubFilePath, file:EXISTS));
}
