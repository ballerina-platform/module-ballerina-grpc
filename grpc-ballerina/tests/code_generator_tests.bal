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
import ballerina/test;

@test:Config {enable:true}
function testHelloWorld() {
    assertGeneratedSources("helloWorld.proto", "helloWorld_pb.bal", "tool_test1");
}

@test:Config {enable:true}
function testHelloWorldBytes() {
    assertGeneratedSources("helloWorldBytes.proto", "helloWorldBytes_pb.bal", "tool_test2");
}

@test:Config {enable:true}
function testHelloWorldClientStreaming() {
    assertGeneratedSources("helloWorldClientStreaming.proto", "helloWorldClientStreaming_pb.bal", "tool_test3");
}

@test:Config {enable:true}
function testHelloWorldClientStreamingNoOutput() {
    assertGeneratedSources("helloWorldClientStreamingNoOutput.proto", "helloWorldClientStreamingNoOutput_pb.bal", "tool_test4");
}

@test:Config {enable:true}
function testHelloWorldClientStreamingString() {
    assertGeneratedSources("helloWorldClientStreamingString.proto", "helloWorldClientStreamingString_pb.bal", "tool_test5");
}

@test:Config {enable:true}
function testHelloWorldErrorSyntax() {
    assertGeneratedSourcesNegative("helloWorldErrorSyntax.proto", "helloWorldErrorSyntax_pb.bal", "tool_test6");
}

@test:Config {enable:true}
function testHelloWorldNoInput() {
    assertGeneratedSources("helloWorldNoInput.proto", "helloWorldNoInput_pb.bal", "tool_test7");
}

@test:Config {enable:true}
function testHelloWorldNoOutput() {
    assertGeneratedSources("helloWorldNoOutput.proto", "helloWorldNoOutput_pb.bal", "tool_test8");
}

@test:Config {enable:true}
function testHelloWorldServerStreaming() {
    assertGeneratedSources("helloWorldServerStreaming.proto", "helloWorldServerStreaming_pb.bal", "tool_test9");
}

@test:Config {enable:true}
function testHelloWorldServerStreamingNoInput() {
    assertGeneratedSources("helloWorldServerStreamingNoInput.proto", "helloWorldServerStreamingNoInput_pb.bal", "tool_test10");
}

@test:Config {enable:true}
function testHelloWorldServerStreamingString() {
    assertGeneratedSources("helloWorldServerStreamingString.proto", "helloWorldServerStreamingString_pb.bal", "tool_test11");
}

@test:Config {enable:true}
function testHelloWorldString() {
    assertGeneratedSources("helloWorldString.proto", "helloWorldString_pb.bal", "tool_test12");
}

@test:Config {enable:true}
function testHelloWorldWithDependency() {
    assertGeneratedSources("helloWorldWithDependency.proto", "helloWorldWithDependency_pb.bal", "tool_test13");
}

@test:Config {enable:true}
function testHelloWorldWithEnum() {
    assertGeneratedSources("helloWorldWithEnum.proto", "helloWorldWithEnum_pb.bal", "tool_test14");
}

@test:Config {enable:true}
function testHelloWorldWithInvalidDependency() {
    assertGeneratedSourcesNegative("helloWorldWithInvalidDependency.proto", "helloWorldWithInvalidDependency_pb.bal", "tool_test15");
}

@test:Config {enable:true}
function testHelloWorldWithMap() {
    assertGeneratedSources("helloWorldWithMap.proto", "helloWorldWithMap_pb.bal", "tool_test16");
}

@test:Config {enable:true}
function testHelloWorldWithNestedEnum() {
    assertGeneratedSources("helloWorldWithNestedEnum.proto", "helloWorldWithNestedEnum_pb.bal", "tool_test17");
}

@test:Config {enable:true}
function testHelloWorldWithNestedMessage() {
    assertGeneratedSources("helloWorldWithNestedMessage.proto", "helloWorldWithNestedMessage_pb.bal", "tool_test18");
}

@test:Config {enable:true}
function testHelloWorldWithPackage() {
    assertGeneratedSources("helloWorldWithPackage.proto", "helloWorldWithPackage_pb.bal", "tool_test19");
}

@test:Config {enable:true}
function testHelloWorldWithReservedNames() {
    assertGeneratedSources("helloWorldWithReservedNames.proto", "helloWorldWithReservedNames_pb.bal", "tool_test20");
}

@test:Config {enable:true}
function testMessage() {
    assertGeneratedSources("message.proto", "message_pb.bal", "tool_test21");
}

@test:Config {enable:true}
function testOneofFieldService() {
    assertGeneratedSources("oneof_field_service.proto", "oneof_field_service_pb.bal", "tool_test22");
}

@test:Config {enable:true}
function testTestMessage() {
    assertGeneratedSources("testMessage.proto", "testMessage_pb.bal", "tool_test23");
}

function assertGeneratedSources(string input, string output, string outputDir) {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, input);
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, outputDir);
    string expectedFilePath = checkpanic file:joinPath(OUTPUT_BAL_FILE_DIRECTORY, output);
    string actualFilePath = checkpanic file:joinPath(outputDirPath, output);

    generateSourceCode(protoFilePath, outputDirPath);
    test:assertTrue(checkpanic file:test(actualFilePath, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualFilePath));
    test:assertEquals(readContent(expectedFilePath), readContent(actualFilePath));
    _ = checkpanic file:remove(actualFilePath);
    test:assertFalse(checkpanic file:test(actualFilePath, file:EXISTS));

    generateSourceCode(protoFilePath, outputDirPath, "service");
    test:assertTrue(checkpanic file:test(actualFilePath, file:EXISTS));
    _ = checkpanic file:remove(actualFilePath);
    test:assertFalse(checkpanic file:test(actualFilePath, file:EXISTS));

    generateSourceCode(protoFilePath, outputDirPath, "client");
    test:assertTrue(checkpanic file:test(actualFilePath, file:EXISTS));
}

function assertGeneratedSourcesNegative(string input, string output, string outputDir, string? mode = ()) {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, input);
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, outputDir);
    string actualFilePath = checkpanic file:joinPath(outputDirPath, output);

    generateSourceCode(protoFilePath, outputDirPath, mode);

    test:assertFalse(checkpanic file:test(actualFilePath, file:EXISTS));
}

public function generateSourceCode(string protoFilePath, string outputDirPath, string? mode = ()) = @java:Method {
    'class: "org.ballerinalang.net.grpc.testutils.CodeGeneratorUtils",
    name: "generateSourceCode"
} external;

public function hasDiagnostics(string filePath) returns boolean = @java:Method {
    'class: "org.ballerinalang.net.grpc.testutils.CodeGeneratorUtils",
    name: "hasDiagnostics"
} external;

public function readContent(string filePath) returns string = @java:Method {
    'class: "org.ballerinalang.net.grpc.testutils.CodeGeneratorUtils",
    name: "readContent"
} external;

