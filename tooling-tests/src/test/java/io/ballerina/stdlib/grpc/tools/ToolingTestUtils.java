/*
 *  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package io.ballerina.stdlib.grpc.tools;

import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.projects.DiagnosticResult;
import io.ballerina.projects.Package;
import io.ballerina.projects.PackageCompilation;
import io.ballerina.projects.ProjectEnvironmentBuilder;
import io.ballerina.projects.directory.BuildProject;
import io.ballerina.projects.directory.SingleFileProject;
import io.ballerina.projects.environment.Environment;
import io.ballerina.projects.environment.EnvironmentBuilder;
import io.ballerina.stdlib.grpc.protobuf.cmd.GrpcCmd;
import io.ballerina.tools.text.TextDocument;
import io.ballerina.tools.text.TextDocuments;
import org.testng.Assert;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 * gRPC tool test Utils.
 */
public class ToolingTestUtils {

    public static final String PROTO_FILE_DIRECTORY = "proto-files/";
    public static final String BAL_FILE_DIRECTORY = "generated-sources/";
    public static final String GENERATED_SOURCES_DIRECTORY = "build/generated-sources/";
    public static final String BALLERINA_TOML_FILE = "Ballerina.toml";

    public static final Path RESOURCE_DIRECTORY = Paths.get("src", "test", "resources", "test-src")
            .toAbsolutePath();
    private static final Path DISTRIBUTION_PATH = Paths.get("../", "target", "ballerina-runtime")
            .toAbsolutePath();
    private static final Path BALLERINA_TOML_PATH = Paths.get(RESOURCE_DIRECTORY.toString(), BALLERINA_TOML_FILE);

    private static ProjectEnvironmentBuilder getEnvironmentBuilder() {
        Environment environment = EnvironmentBuilder.getBuilder().setBallerinaHome(DISTRIBUTION_PATH).build();
        return ProjectEnvironmentBuilder.getBuilder(environment);
    }

    public static void assertGeneratedSources(String subDir, String protoFile, String stubFile, String serviceFile,
                                              String clientFile, String outputDir) {
        Path protoFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), PROTO_FILE_DIRECTORY, subDir, protoFile);
        Path outputDirPath = Paths.get(GENERATED_SOURCES_DIRECTORY, outputDir);

        Path expectedStubFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY, outputDir, stubFile);
        Path expectedServiceFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                outputDir, serviceFile);
        Path expectedClientFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                outputDir, clientFile);

        Path actualStubFilePath = outputDirPath.resolve(stubFile);
        Path actualServiceFilePath = outputDirPath.resolve(serviceFile);
        Path actualClientFilePath = outputDirPath.resolve(clientFile);

        generateSourceCode(protoFilePath, outputDirPath, null, null);
        Assert.assertTrue(Files.exists(actualStubFilePath));

        Path destTomlFile = Paths.get(GENERATED_SOURCES_DIRECTORY, outputDir, BALLERINA_TOML_FILE);
        copyBallerinaToml(destTomlFile);

        Assert.assertFalse(hasSemanticDiagnostics(outputDirPath, false));
        Assert.assertEquals(readContent(expectedStubFilePath), readContent(actualStubFilePath));
        try {
            Files.deleteIfExists(actualStubFilePath);
        } catch (IOException e) {
            Assert.fail("Failed to delete stub file", e);
        }
        Assert.assertFalse(Files.exists(actualStubFilePath));

        generateSourceCode(protoFilePath, outputDirPath, "client", null);
        Assert.assertTrue(Files.exists(actualStubFilePath));
        Assert.assertTrue(Files.exists(actualClientFilePath));
        Assert.assertFalse(hasSemanticDiagnostics(outputDirPath, false));
        Assert.assertEquals(readContent(expectedStubFilePath), readContent(actualStubFilePath));
        Assert.assertEquals(readContent(expectedClientFilePath),
                readContent(actualClientFilePath));
        try {
            Files.deleteIfExists(actualStubFilePath);
        } catch (IOException e) {
            Assert.fail("Failed to delete stub file", e);
        }
        Assert.assertFalse(Files.exists(actualStubFilePath));

        generateSourceCode(protoFilePath, outputDirPath, "service", null);
        Assert.assertTrue(Files.exists(actualStubFilePath));
        Assert.assertTrue(Files.exists(actualServiceFilePath));
        Assert.assertFalse(hasSyntacticDiagnostics(actualStubFilePath));
        Assert.assertFalse(hasSyntacticDiagnostics(actualServiceFilePath));
        Assert.assertEquals(readContent(expectedStubFilePath), readContent(actualStubFilePath));
        Assert.assertEquals(readContent(expectedServiceFilePath),
                readContent(actualServiceFilePath));

        try {
            Files.deleteIfExists(actualServiceFilePath);
        } catch (IOException e) {
            Assert.fail("Failed to delete stub file", e);
        }
    }

    public static void assertGeneratedDataTypeSources(String subDir, String protoFile, String stubFile,
                                                      String outputDir) {
        Path protoFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), PROTO_FILE_DIRECTORY, subDir, protoFile);
        Path outputDirPath = Paths.get(GENERATED_SOURCES_DIRECTORY, outputDir);

        Path expectedStubFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY, outputDir, stubFile);
        Path actualStubFilePath;
        if (outputDir.equals("")) {
            Path tempPath = Paths.get("temp");
            actualStubFilePath = tempPath.resolve(stubFile);
            generateSourceCode(protoFilePath, Paths.get(""), null, null);
            Assert.assertTrue(Files.exists(actualStubFilePath));

            Path destTomlFile = tempPath.resolve(BALLERINA_TOML_FILE);
            copyBallerinaToml(destTomlFile);

            Assert.assertFalse(hasSemanticDiagnostics(tempPath, false));
            try {
                Files.deleteIfExists(actualStubFilePath);
                Files.deleteIfExists(destTomlFile);
                Files.deleteIfExists(tempPath);
            } catch (IOException e) {
                Assert.fail("Failed to delete stub file", e);
            }
        } else {
            actualStubFilePath = outputDirPath.resolve(stubFile);
            generateSourceCode(protoFilePath, outputDirPath, null, null);
            Assert.assertTrue(Files.exists(actualStubFilePath));

            Path destTomlFile = Paths.get(GENERATED_SOURCES_DIRECTORY, outputDir, BALLERINA_TOML_FILE);
            copyBallerinaToml(destTomlFile);

            Assert.assertFalse(hasSemanticDiagnostics(outputDirPath, false));
            Assert.assertEquals(readContent(expectedStubFilePath), readContent(actualStubFilePath));
        }
    }

    public static void assertGeneratedDataTypeSourcesNegative(String subDir, String protoFile,
                                                              String stubFile, String outputDir) {
        Path protoFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), PROTO_FILE_DIRECTORY, subDir, protoFile);
        Path outputDirPath = Paths.get(GENERATED_SOURCES_DIRECTORY, outputDir);
        Path actualStubFilePath = outputDirPath.resolve(stubFile);

        generateSourceCode(protoFilePath, outputDirPath, null, null);
        Assert.assertFalse(Files.exists(actualStubFilePath));
    }

    public static void generateSourceCode(Path sProtoFilePath, Path sOutputDirPath, String mode, Path sImportDirPath) {
        Class<?> grpcCmdClass;
        try {
            grpcCmdClass = Class.forName("io.ballerina.stdlib.grpc.protobuf.cmd.GrpcCmd");
            GrpcCmd grpcCmd = (GrpcCmd) grpcCmdClass.getDeclaredConstructor().newInstance();
            grpcCmd.setProtoPath(sProtoFilePath.toAbsolutePath().toString());
            if (!sOutputDirPath.toString().isBlank()) {
                grpcCmd.setBalOutPath(sOutputDirPath.toAbsolutePath().toString());
            }
            if (mode != null) {
                grpcCmd.setMode(mode);
            }
            if (sImportDirPath != null) {
                grpcCmd.setImportPath(sImportDirPath.toAbsolutePath().toString());
            }
            grpcCmd.execute();
        } catch (ClassNotFoundException | IllegalAccessException | InstantiationException |
                NoSuchMethodException | InvocationTargetException e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean hasSemanticDiagnostics(Path projectPath, boolean isSingleFile) {
        Package currentPackage;
        if (isSingleFile) {
            SingleFileProject singleFileProject = SingleFileProject.load(getEnvironmentBuilder(), projectPath);
            currentPackage = singleFileProject.currentPackage();
        } else {
            BuildProject buildProject = BuildProject.load(getEnvironmentBuilder(), projectPath);
            currentPackage = buildProject.currentPackage();
        }
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        return diagnosticResult.hasErrors();
    }

    public static boolean hasSyntacticDiagnostics(Path filePath) {
        String content;
        try {
            content = Files.readString(filePath);
        } catch (IOException e) {
            return false;
        }
        TextDocument textDocument = TextDocuments.from(content);
        return SyntaxTree.from(textDocument).hasDiagnostics();
    }

    public static String readContent(Path filePath) {
        String content;
        try {
            content = Files.readString(filePath);
        } catch (IOException e) {
            return "";
        }
        return content.replaceAll("\\s+", "");
    }

    public static void copyBallerinaToml(Path destTomlPath) {
        try {
            Files.copy(BALLERINA_TOML_PATH, destTomlPath, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
