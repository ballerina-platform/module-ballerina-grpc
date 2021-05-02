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
function testHelloWorldErrorSyntax() {
    assertGeneratedDataTypeSourcesNegative("negative", "helloWorldErrorSyntax.proto", "helloWorldErrorSyntax_pb.bal", "tool_test_data_type_2");
}

@test:Config {enable:true}
function testHelloWorldWithInvalidDependency() {
    assertGeneratedDataTypeSourcesNegative("negative", "helloWorldWithInvalidDependency.proto", "helloWorldWithInvalidDependency_pb.bal", "tool_test_data_type_4");
}

function assertGeneratedDataTypeSourcesNegative(string subDir, string protoFile, string stubFile, string outputDir) {
    string protoFilePath = checkpanic file:joinPath(PROTO_FILE_DIRECTORY, subDir, protoFile);
    string outputDirPath = checkpanic file:joinPath(GENERATED_SOURCES_DIRECTORY, outputDir);

    string expectedStubFilePath = checkpanic file:joinPath(BAL_FILE_DIRECTORY, outputDir, stubFile);
    string actualStubFilePath = checkpanic file:joinPath(outputDirPath, stubFile);

    generateSourceCode(protoFilePath, outputDirPath);
    test:assertFalse(checkpanic file:test(actualStubFilePath, file:EXISTS));
}
