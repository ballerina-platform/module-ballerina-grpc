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
    var result = assertGeneratedDataTypeSources("data-types", "helloWorldWithDependency.proto", "helloWorldWithDependency_pb.bal", "tool_test_data_type_1");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testHelloWorldWithEnum() {
    var result = assertGeneratedDataTypeSources("data-types", "helloWorldWithEnum.proto", "helloWorldWithEnum_pb.bal", "tool_test_data_type_3");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testHelloWorldWithMap() {
    var result = assertGeneratedDataTypeSources("data-types", "helloWorldWithMap.proto", "helloWorldWithMap_pb.bal", "tool_test_data_type_5");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testHelloWorldWithNestedEnum() {
    var result = assertGeneratedDataTypeSources("data-types", "helloWorldWithNestedEnum.proto", "helloWorldWithNestedEnum_pb.bal", "tool_test_data_type_6");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testHelloWorldWithNestedMessage() {
    var result = assertGeneratedDataTypeSources("data-types", "helloWorldWithNestedMessage.proto", "helloWorldWithNestedMessage_pb.bal", "tool_test_data_type_7");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testHelloWorldWithPackage() {
    var result = assertGeneratedDataTypeSources("data-types", "helloWorldWithPackage.proto", "helloWorldWithPackage_pb.bal", "tool_test_data_type_8");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testHelloWorldWithReservedNames() {
    var result = assertGeneratedDataTypeSources("data-types", "helloWorldWithReservedNames.proto", "helloWorldWithReservedNames_pb.bal", "tool_test_data_type_9");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testMessage() {
    var result = assertGeneratedDataTypeSources("data-types", "message.proto", "message_pb.bal", "tool_test_data_type_10");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testOneofFieldService() {
    var result = assertGeneratedDataTypeSources("data-types", "oneof_field_service.proto", "oneof_field_service_pb.bal", "tool_test_data_type_11");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testTestMessage() {
    var result = assertGeneratedDataTypeSources("data-types", "testMessage.proto", "testMessage_pb.bal", "tool_test_data_type_12");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testWithoutOutputDir() {
    var result = assertGeneratedDataTypeSources("data-types", "message.proto", "message_pb.bal", "");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testHelloWorldErrorSyntax() {
    var result = assertGeneratedDataTypeSourcesNegative("negative", "helloWorldErrorSyntax.proto", "helloWorldErrorSyntax_pb.bal", "tool_test_data_type_2");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testHelloWorldWithInvalidDependency() {
    var result = assertGeneratedDataTypeSourcesNegative("negative", "helloWorldWithInvalidDependency.proto", "helloWorldWithInvalidDependency_pb.bal", "tool_test_data_type_4");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

function assertGeneratedDataTypeSources(string subDir, string protoFile, string stubFile, string outputDir) returns error? {
    string protoFilePath = check file:joinPath(PROTO_FILE_DIRECTORY, subDir, protoFile);
    string outputDirPath = check file:joinPath(GENERATED_SOURCES_DIRECTORY, outputDir);
    string tempDirPath = check file:joinPath(file:getCurrentDir(), "temp");

    string expectedStubFilePath = check file:joinPath(BAL_FILE_DIRECTORY, outputDir, stubFile);
    string actualStubFilePath;
    if (outputDir == "") {
        actualStubFilePath = check file:joinPath(tempDirPath, stubFile);
        generateSourceCode(protoFilePath, "");
        test:assertTrue(check file:test(actualStubFilePath, file:EXISTS));
        test:assertFalse(hasDiagnostics(actualStubFilePath));
    } else {
        actualStubFilePath = check file:joinPath(outputDirPath, stubFile);
        generateSourceCode(protoFilePath, outputDirPath);
        test:assertTrue(check file:test(actualStubFilePath, file:EXISTS));
        test:assertFalse(hasDiagnostics(actualStubFilePath));
        test:assertEquals(readContent(expectedStubFilePath), readContent(actualStubFilePath));
    }
}

function assertGeneratedDataTypeSourcesNegative(string subDir, string protoFile, string stubFile, string outputDir) returns error? {
    string protoFilePath = check file:joinPath(PROTO_FILE_DIRECTORY, subDir, protoFile);
    string outputDirPath = check file:joinPath(GENERATED_SOURCES_DIRECTORY, outputDir);

    string expectedStubFilePath = check file:joinPath(BAL_FILE_DIRECTORY, outputDir, stubFile);
    string actualStubFilePath = check file:joinPath(outputDirPath, stubFile);

    generateSourceCode(protoFilePath, outputDirPath);
    test:assertFalse(check file:test(actualStubFilePath, file:EXISTS));
}
