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
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/file;
import ballerina/jballerina.java;
import ballerina/test;

function assertGeneratedSources(string subDir, string protoFile, string stubFile, string serviceFile, string clientFile, string outputDir) returns error? {
    string protoFilePath = check file:joinPath(PROTO_FILE_DIRECTORY, subDir, protoFile);
    string outputDirPath = check file:joinPath(GENERATED_SOURCES_DIRECTORY, outputDir);

    string expectedStubFilePath = check file:joinPath(BAL_FILE_DIRECTORY, outputDir, stubFile);
    string expectedServiceFilePath = check file:joinPath(BAL_FILE_DIRECTORY, outputDir, serviceFile);
    string expectedClientFilePath = check file:joinPath(BAL_FILE_DIRECTORY, outputDir, clientFile);

    string actualStubFilePath = check file:joinPath(outputDirPath, stubFile);
    string actualServiceFilePath = check file:joinPath(outputDirPath, serviceFile);
    string actualClientFilePath = check file:joinPath(outputDirPath, clientFile);

    generateSourceCode(protoFilePath, outputDirPath);
    test:assertTrue(check file:test(actualStubFilePath, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualStubFilePath));
    test:assertEquals(readContent(expectedStubFilePath), readContent(actualStubFilePath));
    _ = check file:remove(actualStubFilePath);
    test:assertFalse(check file:test(actualStubFilePath, file:EXISTS));

    generateSourceCode(protoFilePath, outputDirPath, "service");
    test:assertTrue(check file:test(actualStubFilePath, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualStubFilePath));
    test:assertEquals(readContent(expectedStubFilePath), readContent(actualStubFilePath));
    test:assertTrue(check file:test(actualServiceFilePath, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualServiceFilePath));
    test:assertEquals(readContent(expectedServiceFilePath), readContent(actualServiceFilePath));
    _ = check file:remove(actualStubFilePath);
    //_ = check file:remove(actualServiceFilePath);
    test:assertFalse(check file:test(actualStubFilePath, file:EXISTS));
    //test:assertFalse(check file:test(actualServiceFilePath, file:EXISTS));

    generateSourceCode(protoFilePath, outputDirPath, "client");
    test:assertTrue(check file:test(actualStubFilePath, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualStubFilePath));
    test:assertEquals(readContent(expectedStubFilePath), readContent(actualStubFilePath));
    test:assertTrue(check file:test(actualClientFilePath, file:EXISTS));
    test:assertFalse(hasDiagnostics(actualClientFilePath));
    test:assertEquals(readContent(expectedClientFilePath), readContent(actualClientFilePath));
}

function assertGeneratedSourcesNegative(string input, string output, string outputDir, string? mode = ()) returns error? {
    string protoFilePath = check file:joinPath(PROTO_FILE_DIRECTORY, input);
    string outputDirPath = check file:joinPath(GENERATED_SOURCES_DIRECTORY, outputDir);
    string stubFilePath = check file:joinPath(outputDirPath, output);

    generateSourceCode(protoFilePath, outputDirPath, mode);

    test:assertFalse(check file:test(stubFilePath, file:EXISTS));
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
