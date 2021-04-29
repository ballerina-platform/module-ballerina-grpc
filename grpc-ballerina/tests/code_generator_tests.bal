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
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/file;
import ballerina/jballerina.java;
import ballerina/io;
import ballerina/test;

@test:Config {enable:true}
function testUnaryStubGeneration() {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, "helloWorld.proto");
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, "tool_test1");
    string stubFilePath = checkpanic file:joinPath(outputDirPath, "helloWorld_pb.bal");
    string serviceFilePath = checkpanic file:joinPath(outputDirPath, "helloWorld_sample_service.bal");
    string clientFilePath = checkpanic file:joinPath(outputDirPath, "helloWorld_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {enable:false}
function testDirectoryWithSpace() {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, "a b", "helloWorld.proto");
    io:println("Proto file path: ");
    io:println(protoFilePath);
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, "tool_test2");
    string stubFilePath = checkpanic file:joinPath(outputDirPath, "helloWorld_pb.bal");
    string serviceFilePath = checkpanic file:joinPath(outputDirPath, "helloWorld_sample_service.bal");
    string clientFilePath = checkpanic file:joinPath(outputDirPath, "helloWorld_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {enable:true}
function testUnaryHelloWorldWithDependency() {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, "helloWorldWithDependency.proto");
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, "tool_test3");
    string stubFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithDependency_pb.bal");
    string serviceFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithDependency_sample_service.bal");
    string clientFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithDependency_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {enable:true}
function testUnaryHelloWorldWithEnum() {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, "helloWorldWithEnum.proto");
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, "tool_test4");
    string stubFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithEnum_pb.bal");
    string serviceFilePath = checkpanic file:joinPath(outputDirPath, "helloWorld_sample_service.bal");
    string clientFilePath = checkpanic file:joinPath(outputDirPath, "helloWorld_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {enable:true}
function testUnaryHelloWorldWithNestedEnum() {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, "helloWorldWithNestedEnum.proto");
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, "tool_test5");
    string stubFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithNestedEnum_pb.bal");
    string serviceFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithNestedEnum_sample_service.bal");
    string clientFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithNestedEnum_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {enable:true}
function testUnaryHelloWorldWithNestedMessage() {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, "helloWorldWithNestedMessage.proto");
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, "tool_test6");
    string stubFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithNestedMessage_pb.bal");
    string serviceFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithNestedMessage_sample_service.bal");
    string clientFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithNestedMessage_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {enable:true}
function testUnaryHelloWorldWithMaps() {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, "helloWorldWithMap.proto");
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, "tool_test7");
    string stubFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithMap_pb.bal");
    string serviceFilePath = checkpanic file:joinPath(outputDirPath, "helloWorld_sample_service.bal");
    string clientFilePath = checkpanic file:joinPath(outputDirPath, "helloWorld_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {enable:true}
function testUnaryHelloWorldWithReservedNames() {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, "helloWorldWithReservedNames.proto");
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, "tool_test8");
    string stubFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithReservedNames_pb.bal");
    string serviceFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithReservedNames_sample_service.bal");
    string clientFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithReservedNames_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {enable:true}
function testUnaryHelloWorldWithInvalidDependency() {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, "helloWorldWithInvalidDependency.proto");
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, "tool_test9");
    string stubFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithInvalidDependency_pb.bal");
    string serviceFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithReservedNames_sample_service.bal");
    string clientFilePath = checkpanic file:joinPath(outputDirPath, "helloWorldWithReservedNames_sample_client.bal");
    generateSourceCode(protoFilePath, outputDirPath);
    test:assertFalse(checkpanic file:test(stubFilePath, file:EXISTS));
}

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

function assertGeneratedSources(string protoFilePath, string outputDirPath, string stubFilePath, string
serviceFilePath, string clientFilePath) {
    generateSourceCode(protoFilePath, outputDirPath);
    test:assertTrue(checkpanic file:test(stubFilePath, file:EXISTS));
    _ = checkpanic file:remove(stubFilePath);
    generateSourceCode(protoFilePath, outputDirPath, "service");
    test:assertTrue(checkpanic file:test(serviceFilePath, file:EXISTS));
    generateSourceCode(protoFilePath, outputDirPath, "client");
    test:assertTrue(checkpanic file:test(clientFilePath, file:EXISTS));
    test:assertTrue(checkpanic file:test(stubFilePath, file:EXISTS));
}

public function generateSourceCode(string protoFilePath, string outputDirPath, string? mode = ()) = @java:Method {
    'class: "org.ballerinalang.net.grpc.testutils.CodeGeneratorUtils",
    name: "generateSourceCode"
} external;
