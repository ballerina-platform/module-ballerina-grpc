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
import ballerina/io;
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
function testHelloWorldWithDuplicateInputOutput() {
    var result = assertGeneratedDataTypeSources("data-types", "helloWorldWithDuplicateInputOutput.proto", "helloWorldWithDuplicateInputOutput_pb.bal", "tool_test_data_type_13");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testHelloWorldWithDurationType1() {
    var result = assertGeneratedSources("data-types", "duration_type1.proto", "duration_type1_pb.bal", "DurationHandler_sample_service.bal", "DurationHandler_sample_client.bal", "tool_test_data_type_15");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testHelloWorldWithDurationType2() {
    var result = assertGeneratedSources("data-types", "duration_type2.proto", "duration_type2_pb.bal", "DurationHandler_sample_service.bal", "DurationHandler_sample_client.bal", "tool_test_data_type_16");
    if (result is error) {
        test:assertFail("Failed to assert generated sources");
    }
}

@test:Config {enable:true}
function testHelloWorldChild() {
    var result1 = assertGeneratedDataTypeSources("data-types", "child.proto", "child_pb.bal", "tool_test_data_type_14");
    if result1 is error {
        test:assertFail("Failed to assert generated child_pb.bal");
    }
    var result2 = assertGeneratedDataTypeSources("data-types", "child.proto", "child_pb.bal", "tool_test_data_type_14");
    if result2 is error {
        test:assertFail("Failed to assert generated child_pb.bal");
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

@test:Config {enable:true}
function testProtoDirectory() returns error? {
    string protoFilePath = check file:joinPath(PROTO_FILE_DIRECTORY, "proto-dir");
    string outputDirPath = check file:joinPath(GENERATED_SOURCES_DIRECTORY, "tool_test_proto_dir");

    generateSourceCode(protoFilePath, outputDirPath);

    string expectedStubFilePath1 = check file:joinPath(BAL_FILE_DIRECTORY, "tool_test_proto_dir", "helloWorldBoolean_pb.bal");
    string expectedStubFilePath2 = check file:joinPath(BAL_FILE_DIRECTORY, "tool_test_proto_dir", "helloWorldInt_pb.bal");
    string expectedStubFilePath3 = check file:joinPath(BAL_FILE_DIRECTORY, "tool_test_proto_dir", "helloWorldString_pb.bal");
    string expectedStubFilePath4 = check file:joinPath(BAL_FILE_DIRECTORY, "tool_test_proto_dir", "helloWorldWithDependency_pb.bal");
    string expectedStubFilePath5 = check file:joinPath(BAL_FILE_DIRECTORY, "tool_test_proto_dir", "message_pb.bal");

    string actualStubFilePath1 = check file:joinPath(outputDirPath, "helloWorldBoolean_pb.bal");
    string actualStubFilePath2 = check file:joinPath(outputDirPath, "helloWorldInt_pb.bal");
    string actualStubFilePath3 = check file:joinPath(outputDirPath, "helloWorldString_pb.bal");
    string actualStubFilePath4 = check file:joinPath(outputDirPath, "helloWorldWithDependency_pb.bal");
    string actualStubFilePath5 = check file:joinPath(outputDirPath, "message_pb.bal");

    test:assertTrue(check file:test(actualStubFilePath1, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualStubFilePath1));
    test:assertEquals(readContent(expectedStubFilePath1), readContent(actualStubFilePath1));

    test:assertTrue(check file:test(actualStubFilePath2, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualStubFilePath2));
    test:assertEquals(readContent(expectedStubFilePath2), readContent(actualStubFilePath2));

    test:assertTrue(check file:test(actualStubFilePath3, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualStubFilePath3));
    test:assertEquals(readContent(expectedStubFilePath3), readContent(actualStubFilePath3));

    test:assertTrue(check file:test(actualStubFilePath4, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualStubFilePath4));

    test:assertTrue(check file:test(actualStubFilePath5, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualStubFilePath5));
    io:println("Expected:");
    io:println(readContent(expectedStubFilePath5));
    io:println("Actual");
    io:println(readContent(actualStubFilePath5));
    test:assertEquals(readContent(expectedStubFilePath5), readContent(actualStubFilePath5));
}

@test:Config {enable:true}
function testExternalImportPaths() returns error? {
    string protoFilePath = check file:joinPath(PROTO_FILE_DIRECTORY, "external-imports", "myproj", "foo", "bar", "child.proto");
    string importDirPath = check file:joinPath(PROTO_FILE_DIRECTORY, "external-imports", "myproj");
    string outputDirPath = check file:joinPath(GENERATED_SOURCES_DIRECTORY, "tool_test_external_imports");

    string actualRootStubFilePath = check file:joinPath(outputDirPath, "child_pb.bal");
    string actualDependentStubFilePath = check file:joinPath(outputDirPath, "parent_pb.bal");
    string expectedRootStubFilePath = check file:joinPath(BAL_FILE_DIRECTORY, "tool_test_external_imports", "child_pb.bal");
    string expectedDependentStubFilePath = check file:joinPath(BAL_FILE_DIRECTORY, "tool_test_external_imports", "parent_pb.bal");

    generateSourceCode(protoFilePath, outputDirPath, "stubs", importDirPath);

    test:assertTrue(check file:test(actualRootStubFilePath, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualRootStubFilePath));
    test:assertEquals(readContent(expectedRootStubFilePath), readContent(actualRootStubFilePath));

    test:assertTrue(check file:test(actualDependentStubFilePath, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualDependentStubFilePath));
    test:assertEquals(readContent(expectedDependentStubFilePath), readContent(actualDependentStubFilePath));
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
        check file:remove(tempDirPath, option = file:RECURSIVE);
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
