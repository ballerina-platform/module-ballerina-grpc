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
import ballerina/filepath;
import ballerina/java;
import ballerina/test;

@test:Config {}
function testUnaryStubGeneration() {
    string protoFilePath = checkpanic filepath:build(PROTO_FILE_DIRECTORY, "helloWorld.proto");
    string outputDirPath = checkpanic filepath:build(GENERATED_SOURCES_DIRECTORY, "tool_test1");
    string stubFilePath = checkpanic filepath:build(outputDirPath, "helloWorld_pb.bal");
    string serviceFilePath = checkpanic filepath:build(outputDirPath, "helloWorld_sample_service.bal");
    string clientFilePath = checkpanic filepath:build(outputDirPath, "helloWorld_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {}
function testDirectoryWithSpace() {
    string protoFilePath = checkpanic filepath:build(PROTO_FILE_DIRECTORY, "a b", "helloWorld.proto");
    string outputDirPath = checkpanic filepath:build(GENERATED_SOURCES_DIRECTORY, "tool_test2");
    string stubFilePath = checkpanic filepath:build(outputDirPath, "helloWorld_pb.bal");
    string serviceFilePath = checkpanic filepath:build(outputDirPath, "helloWorld_sample_service.bal");
    string clientFilePath = checkpanic filepath:build(outputDirPath, "helloWorld_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {}
function testUnaryHelloWorldWithDependency() {
    string protoFilePath = checkpanic filepath:build(PROTO_FILE_DIRECTORY, "helloWorldWithDependency.proto");
    string outputDirPath = checkpanic filepath:build(GENERATED_SOURCES_DIRECTORY, "tool_test3");
    string stubFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithDependency_pb.bal");
    string serviceFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithDependency_sample_service.bal");
    string clientFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithDependency_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {}
function testUnaryHelloWorldWithEnum() {
    string protoFilePath = checkpanic filepath:build(PROTO_FILE_DIRECTORY, "helloWorldWithEnum.proto");
    string outputDirPath = checkpanic filepath:build(GENERATED_SOURCES_DIRECTORY, "tool_test4");
    string stubFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithEnum_pb.bal");
    string serviceFilePath = checkpanic filepath:build(outputDirPath, "helloWorld_sample_service.bal");
    string clientFilePath = checkpanic filepath:build(outputDirPath, "helloWorld_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {}
function testUnaryHelloWorldWithNestedEnum() {
    string protoFilePath = checkpanic filepath:build(PROTO_FILE_DIRECTORY, "helloWorldWithNestedEnum.proto");
    string outputDirPath = checkpanic filepath:build(GENERATED_SOURCES_DIRECTORY, "tool_test5");
    string stubFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithNestedEnum_pb.bal");
    string serviceFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithNestedEnum_sample_service.bal");
    string clientFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithNestedEnum_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {}
function testUnaryHelloWorldWithNestedMessage() {
    string protoFilePath = checkpanic filepath:build(PROTO_FILE_DIRECTORY, "helloWorldWithNestedMessage.proto");
    string outputDirPath = checkpanic filepath:build(GENERATED_SOURCES_DIRECTORY, "tool_test6");
    string stubFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithNestedMessage_pb.bal");
    string serviceFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithNestedMessage_sample_service.bal");
    string clientFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithNestedMessage_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {}
function testUnaryHelloWorldWithMaps() {
    string protoFilePath = checkpanic filepath:build(PROTO_FILE_DIRECTORY, "helloWorldWithMap.proto");
    string outputDirPath = checkpanic filepath:build(GENERATED_SOURCES_DIRECTORY, "tool_test7");
    string stubFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithMap_pb.bal");
    string serviceFilePath = checkpanic filepath:build(outputDirPath, "helloWorld_sample_service.bal");
    string clientFilePath = checkpanic filepath:build(outputDirPath, "helloWorld_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {}
function testUnaryHelloWorldWithReservedNames() {
    string protoFilePath = checkpanic filepath:build(PROTO_FILE_DIRECTORY, "helloWorldWithReservedNames.proto");
    string outputDirPath = checkpanic filepath:build(GENERATED_SOURCES_DIRECTORY, "tool_test8");
    string stubFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithReservedNames_pb.bal");
    string serviceFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithReservedNames_sample_service.bal");
    string clientFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithReservedNames_sample_client.bal");
    assertGeneratedSources(protoFilePath, outputDirPath, stubFilePath, serviceFilePath, clientFilePath);
}

@test:Config {}
function testUnaryHelloWorldWithInvalidDependency() {
    string protoFilePath = checkpanic filepath:build(PROTO_FILE_DIRECTORY, "helloWorldWithInvalidDependency.proto");
    string outputDirPath = checkpanic filepath:build(GENERATED_SOURCES_DIRECTORY, "tool_test9");
    string stubFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithInvalidDependency_pb.bal");
    string serviceFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithReservedNames_sample_service.bal");
    string clientFilePath = checkpanic filepath:build(outputDirPath, "helloWorldWithReservedNames_sample_client.bal");
    generateSourceCode(protoFilePath, outputDirPath);
    test:assertFalse(file:exists(stubFilePath));
}

function assertGeneratedSources(string protoFilePath, string outputDirPath, string stubFilePath, string
serviceFilePath, string clientFilePath) {
    generateSourceCode(protoFilePath, outputDirPath);
    test:assertTrue(file:exists(stubFilePath));
    _ = checkpanic file:remove(stubFilePath);
    generateSourceCode(protoFilePath, outputDirPath, "service");
    test:assertTrue(file:exists(serviceFilePath));
    generateSourceCode(protoFilePath, outputDirPath, "client");
    test:assertTrue(file:exists(clientFilePath));
    test:assertTrue(file:exists(stubFilePath));
}

public function generateSourceCode(string protoFilePath, string outputDirPath, string? mode = ()) = @java:Method {
    'class: "org.ballerinalang.net.grpc.testutils.CodeGeneratorUtils",
    name: "generateSourceCode"
} external;
