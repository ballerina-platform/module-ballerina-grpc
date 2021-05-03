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
        checkpanic file:remove(tempDirPath, option = file:RECURSIVE);
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

// This test case is to generate stub files for all grpc tests. we can use this to verify the generated output files
// manually.
//@test:Config {enable:true}
//function testGenerateSourceCode() {
//    string outputDirPath = "tests/";
//    generateSourceCode(outputDirPath + "01_advanced_type_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "02_array_field_type_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "03_bidirectional_streaming_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "04_client_streaming_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "05_invalid_resource_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "06_server_streaming_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "07_unary_server.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "08_unary_service_with_headers.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "09_grpc_secured_unary_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "10_grpc_ssl_server.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "11_grpc_byte_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "12_grpc_enum_test_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "13_grpc_service_with_error_return.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "14_grpc_client_socket_timeout.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "15_grpc_oneof_field_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "16_unavailable_service_client.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "18_grpc_optional_field_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "19_grpc_map_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "20_unary_client_for_anonymous_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "21_grpc_gzip_encoding_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "22_retry_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "23_server_streaming_with_record_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "24_return_data_unary.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "25_return_data_streaming.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "26_return_data_client_streaming.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "27_bidirectional_streaming_service.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "29_unary_jwt.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "30_unary_oauth2.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "31_return_unary.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "32_return_record_server_streaming.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "33_return_record_client_streaming.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "34_return_record_bidi_streaming.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "35_unary_service_with_deadline.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "36_unary_service_with_deadline_propagation.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "37_streaming_with_deadline.proto", outputDirPath);
//    generateSourceCode(outputDirPath + "38_bidi_streaming_with_caller.proto", outputDirPath);
//}
