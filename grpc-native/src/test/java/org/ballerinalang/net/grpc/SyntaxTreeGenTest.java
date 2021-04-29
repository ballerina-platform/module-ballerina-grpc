/*
 *  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package org.ballerinalang.net.grpc;

import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.tools.text.TextDocument;
import io.ballerina.tools.text.TextDocuments;
import org.ballerinalang.net.grpc.protobuf.cmd.GrpcCmd;
import org.testng.Assert;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Tests Syntax tree generation.
 *
 * @since 0.8.0
 */
public class SyntaxTreeGenTest {

    private static final Path RES_DIR = Paths.get("src/test/resources/").toAbsolutePath();
    private static Path tempDir;
    private static Path inputDir;
    private static Path outputDir;

    @BeforeMethod
    public void setup() throws IOException {
        tempDir = Files.createTempDirectory("syntax-tree-gen-" + System.nanoTime());
        inputDir = RES_DIR.resolve("input");
        outputDir = RES_DIR.resolve("output");
    }

    @Test(description = "Tests the output for a unary protobuf definition file with message types")
    public void testHelloWorld() {
        assertOutput("helloWorld.proto", "helloWorld_pb.bal", "");
    }

    @Test(description = "Tests the output for a client streaming protobuf definition file")
    public void testHelloWorldClientStreaming() {
        assertOutput("helloWorldClientStreaming.proto", "helloWorldClientStreaming_pb.bal", "");
    }

    @Test(description = "Tests the output for a client streaming protobuf definition file")
    public void testHelloWorldClientStreamingNoOutput() {
        assertOutput("helloWorldClientStreamingNoOutput.proto", "helloWorldClientStreamingNoOutput_pb.bal", "");
    }

    @Test(description = "Tests the output for a client streaming protobuf definition with string input/output types")
    public void testHelloWorldClientStreamingString() {
        assertOutput("helloWorldClientStreamingString.proto", "helloWorldClientStreamingString_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with syntax errors")
    public void testHelloWorldErrorSyntax() {
        assertOutputNegative("helloWorldErrorSyntax.proto", "helloWorldErrorSyntax_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with a service without input")
    public void testHelloWorldNoInput() {
        assertOutput("helloWorldNoInput.proto", "helloWorldNoInput_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with a service without output")
    public void testHelloWorldNoOutput() {
        assertOutput("helloWorldNoOutput.proto", "helloWorldNoOutput_pb.bal", "");
    }

    @Test(description = "Tests the output for a server streaming protobuf definition file")
    public void testHelloWorldServerStreaming() {
        assertOutput("helloWorldServerStreaming.proto", "helloWorldServerStreaming_pb.bal", "");
    }

    @Test(description = "Tests the output for a server streaming protobuf definition with string input/output types")
    public void testHelloWorldServerStreamingString() {
        assertOutput("helloWorldServerStreamingString.proto", "helloWorldServerStreamingString_pb.bal", "");
    }

    @Test(description = "Tests the output for a unary protobuf definition file of string types")
    public void testHelloWorldString() {
        assertOutput("helloWorldString.proto", "helloWorldString_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with dependency")
    public void testHelloWorldWithDependency() {
        assertOutput("helloWorldWithDependency.proto", "helloWorldWithDependency_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with enum types")
    public void testHelloWorldWithEnum() {
        assertOutput("helloWorldWithEnum.proto", "helloWorldWithEnum_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with invalid dependency")
    public void testHelloWorldWithInvalidDependency() {
        assertOutputNegative("helloWorldWithInvalidDependency.proto", "helloWorldWithInvalidDependency_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with map types")
    public void testHelloWorldWithMap() {
        assertOutput("helloWorldWithMap.proto", "helloWorldWithMap_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with nested enums")
    public void testHelloWorldWithNestedEnum() {
        assertOutput("helloWorldWithNestedEnum.proto", "helloWorldWithNestedEnum_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with nested messages")
    public void testHelloWorldWithNestedMessage() {
        assertOutput("helloWorldWithNestedMessage.proto", "helloWorldWithNestedMessage_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with package")
    public void testHelloWorldWithPackage() {
        assertOutput("helloWorldWithPackage.proto", "helloWorldWithPackage_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with reserved names")
    public void testHelloWorldWithReservedNames() {
        assertOutput("helloWorldWithReservedNames.proto", "helloWorldWithReservedNames_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with only message types")
    public void testMessage() {
        assertOutput("message.proto", "message_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with one of fields")
    public void testOneOfFieldService() {
        assertOutput("oneof_field_service.proto", "oneof_field_service_pb.bal", "");
    }

    @Test(description = "Tests the output for a protobuf definition file with message types with all field types")
    public void testTestMessage() {
        assertOutput("testMessage.proto", "testMessage_pb.bal", "");
    }

    private static void generateSourceCode(String sProtoFilePath, String sOutputDirPath, String mode) {

        Class<?> grpcCmdClass;
        try {
            grpcCmdClass = Class.forName("org.ballerinalang.net.grpc.protobuf.cmd.GrpcCmd");
            GrpcCmd grpcCmd = (GrpcCmd) grpcCmdClass.newInstance();
            Path protoFilePath = Paths.get(sProtoFilePath);
            Path outputDirPath = Paths.get(sOutputDirPath);
            grpcCmd.setBalOutPath(outputDirPath.toAbsolutePath().toString());
            grpcCmd.setProtoPath(protoFilePath.toAbsolutePath().toString());
            if (!mode.equals("")) {
                grpcCmd.setMode(mode);
            }
            grpcCmd.execute();
        } catch (ClassNotFoundException | IllegalAccessException | InstantiationException e) {
            throw new RuntimeException(e);
        }
    }

    private static void assertOutput(String input, String output, String mode) {
        Path protoFilePath = inputDir.resolve(input);
        Path expectedOutPath = outputDir.resolve(output);
        Path outputDirPath = tempDir.resolve("stubs");
        Path actualOutPath = outputDirPath.resolve(output);

        generateSourceCode(protoFilePath.toString(), outputDirPath.toString(), mode);

        Assert.assertTrue(Files.exists(actualOutPath));
        String expectedContent = null;
        try {
            expectedContent = Files.readString(expectedOutPath);
        } catch (IOException e) {
            Assert.fail("failed to read content of expected bal file", e);
        }
        String actualContent = null;
        try {
            actualContent = Files.readString(actualOutPath);
        } catch (IOException e) {
            Assert.fail("failed to read content of actual bal file", e);
        }
        TextDocument textDocument = TextDocuments.from(actualContent);
        Assert.assertFalse(SyntaxTree.from(textDocument).hasDiagnostics());

        Assert.assertEquals(
                actualContent.replaceAll("\\s+", ""),
                expectedContent.replaceAll("\\s+", "")
        );
    }

    private static void assertOutputNegative(String input, String output, String mode) {
        Path protoFilePath = inputDir.resolve(input);
        Path outputDirPath = tempDir.resolve("stubs");
        Path outPath = outputDirPath.resolve(output);

        generateSourceCode(protoFilePath.toString(), outputDirPath.toString(), mode);

        Assert.assertFalse(Files.exists(outPath));
    }
}
