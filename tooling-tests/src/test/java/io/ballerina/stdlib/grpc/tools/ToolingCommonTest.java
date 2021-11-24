/*
 * Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.grpc.tools;

import org.testng.Assert;
import org.testng.annotations.Test;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.BAL_FILE_DIRECTORY;
import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.GENERATED_SOURCES_DIRECTORY;
import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.PROTO_FILE_DIRECTORY;
import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.RESOURCE_DIRECTORY;
import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.assertGeneratedDataTypeSources;
import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.assertGeneratedDataTypeSourcesNegative;
import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.assertGeneratedSources;
import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.copyBallerinaToml;
import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.generateSourceCode;
import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.hasSemanticDiagnostics;
import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.hasSyntacticDiagnostics;
import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.readContent;

/**
 * gRPC tool common tests.
 */
public class ToolingCommonTest {

    @Test(enabled = false)
    public void testHelloWorldWithDependency() {
        assertGeneratedDataTypeSources("data-types", "helloWorldWithDependency.proto",
                "helloWorldWithDependency_pb.bal", "tool_test_data_type_1");
    }
    @Test
    public void testHelloWorldWithEnum() {
        assertGeneratedDataTypeSources("data-types", "helloWorldWithEnum.proto",
                "helloWorldWithEnum_pb.bal", "tool_test_data_type_3");
    }

    @Test
    public void testHelloWorldWithMap() {
        assertGeneratedDataTypeSources("data-types", "helloWorldWithMap.proto",
                "helloWorldWithMap_pb.bal", "tool_test_data_type_5");
    }

    @Test
    public void testHelloWorldWithNestedEnum() {
        assertGeneratedDataTypeSources("data-types", "helloWorldWithNestedEnum.proto",
                "helloWorldWithNestedEnum_pb.bal", "tool_test_data_type_6");
    }

    @Test
    public void testHelloWorldWithNestedMessage() {
        assertGeneratedDataTypeSources("data-types", "helloWorldWithNestedMessage.proto",
                "helloWorldWithNestedMessage_pb.bal", "tool_test_data_type_7");
    }

    @Test
    public void testHelloWorldWithPackage() {
        assertGeneratedDataTypeSources("data-types", "helloWorldWithPackage.proto",
                "helloWorldWithPackage_pb.bal", "tool_test_data_type_8");
    }

    @Test(enabled = false)
    public void testHelloWorldWithReservedNames() {
        assertGeneratedDataTypeSources("data-types", "helloWorldWithReservedNames.proto",
                "helloWorldWithReservedNames_pb.bal", "tool_test_data_type_9");
    }

    @Test
    public void testMessage() {
        assertGeneratedDataTypeSources("data-types", "message.proto", "message_pb.bal",
                "tool_test_data_type_10");
    }

    @Test
    public void testOneofFieldService() {
        assertGeneratedDataTypeSources("data-types", "oneof_field_service.proto",
                "oneof_field_service_pb.bal", "tool_test_data_type_11");
    }

    @Test
    public void testTestMessage() {
        assertGeneratedDataTypeSources("data-types", "testMessage.proto",
                "testMessage_pb.bal", "tool_test_data_type_12");
    }

    @Test
    public void testHelloWorldWithDuplicateInputOutput() {
        assertGeneratedDataTypeSources("data-types", "helloWorldWithDuplicateInputOutput.proto",
        "helloWorldWithDuplicateInputOutput_pb.bal", "tool_test_data_type_13");
    }

    @Test
    public void testHelloWorldWithDurationType1() {
        assertGeneratedSources("data-types", "duration_type1.proto", "duration_type1_pb.bal",
        "DurationHandler_sample_service.bal", "DurationHandler_sample_client.bal", "tool_test_data_type_15");
    }

    @Test
    public void testHelloWorldWithDurationType2() {
        assertGeneratedSources("data-types", "duration_type2.proto", "duration_type2_pb.bal",
        "DurationHandler_sample_service.bal", "DurationHandler_sample_client.bal", "tool_test_data_type_16");
    }

    @Test
    public void testHelloWorldWithStructType1() {
        assertGeneratedSources("data-types", "struct_type1.proto", "struct_type1_pb.bal",
        "StructHandler_sample_service.bal", "StructHandler_sample_client.bal", "tool_test_data_type_17");
    }

    @Test
    public void testHelloWorldWithStructType2() {
        assertGeneratedSources("data-types", "struct_type2.proto", "struct_type2_pb.bal",
        "StructHandler_sample_service.bal", "StructHandler_sample_client.bal", "tool_test_data_type_18");
    }

    @Test
    public void testHelloWorldWithAnyType() {
        assertGeneratedSources("data-types", "any.proto", "any_pb.bal", "AnyTypeServer_sample_service.bal",
        "AnyTypeServer_sample_client.bal", "tool_test_data_type_21");
    }

    @Test
    public void testHelloWorldChild() {
        assertGeneratedDataTypeSources("data-types", "child.proto", "parent_pb.bal",
                "tool_test_data_type_14");
        assertGeneratedDataTypeSources("data-types", "child.proto", "child_pb.bal",
                "tool_test_data_type_14");
    }

    @Test
    public void testTimeWithDependency() {
        assertGeneratedDataTypeSources("data-types", "time_root.proto", "time_root_pb.bal",
        "tool_test_data_type_19");
        assertGeneratedDataTypeSources("data-types", "time_root.proto", "time_dependent_pb.bal",
        "tool_test_data_type_19");
    }

    @Test
    public void testWithoutOutputDir() {
        assertGeneratedDataTypeSources("data-types", "message.proto",
                "message_pb.bal", "");
    }

    @Test
    public void testHelloWorldErrorSyntax() {
        assertGeneratedDataTypeSourcesNegative("negative", "helloWorldErrorSyntax.proto",
                "helloWorldErrorSyntax_pb.bal", "tool_test_data_type_2");
    }

    @Test
    public void testHelloWorldWithInvalidDependency() {
        assertGeneratedDataTypeSourcesNegative("negative", "helloWorldWithInvalidDependency.proto",
                "helloWorldWithInvalidDependency_pb.bal", "tool_test_data_type_4");
    }

    @Test
    public void testMultipleWrapperTypes() {
        assertGeneratedDataTypeSources("data-types", "multiple_wrapper_types.proto",
                "multiple_wrapper_types_pb.bal", "tool_test_data_type_20");
    }

    @Test
    public void testProtoDirectory() {
        Path protoFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), PROTO_FILE_DIRECTORY, "proto-dir");
        Path outputDirPath = Paths.get(GENERATED_SOURCES_DIRECTORY, "tool_test_proto_dir");

        generateSourceCode(protoFilePath.toString(), outputDirPath.toString(), null, null);

        Path expectedStubFilePath1 = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_proto_dir", "helloWorldBoolean_pb.bal");
        Path expectedStubFilePath2 = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_proto_dir", "helloWorldInt_pb.bal");
        Path expectedStubFilePath3 = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_proto_dir", "helloWorldString_pb.bal");
        Path expectedStubFilePath4 = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_proto_dir", "helloWorldWithDependency_pb.bal");
        Path expectedStubFilePath5 = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_proto_dir", "message_pb.bal");

        Path actualStubFilePath1 = Paths.get(outputDirPath.toString(), "helloWorldBoolean_pb.bal");
        Path actualStubFilePath2 = Paths.get(outputDirPath.toString(), "helloWorldInt_pb.bal");
        Path actualStubFilePath3 = Paths.get(outputDirPath.toString(), "helloWorldString_pb.bal");
        Path actualStubFilePath4 = Paths.get(outputDirPath.toString(), "helloWorldWithDependency_pb.bal");
        Path actualStubFilePath5 = Paths.get(outputDirPath.toString(), "message_pb.bal");

        Assert.assertTrue(Files.exists(actualStubFilePath1));
        Assert.assertFalse(hasSemanticDiagnostics(actualStubFilePath1.toString(), true));
        Assert.assertEquals(readContent(expectedStubFilePath1.toString()), readContent(actualStubFilePath1.toString()));

        Assert.assertTrue(Files.exists(actualStubFilePath2));
        Assert.assertFalse(hasSemanticDiagnostics(actualStubFilePath2.toString(), true));
        Assert.assertEquals(readContent(expectedStubFilePath2.toString()), readContent(actualStubFilePath2.toString()));

        Assert.assertTrue(Files.exists(actualStubFilePath3));
        Assert.assertFalse(hasSemanticDiagnostics(actualStubFilePath3.toString(), true));
        Assert.assertEquals(readContent(expectedStubFilePath3.toString()), readContent(actualStubFilePath3.toString()));

        Assert.assertTrue(Files.exists(actualStubFilePath4));
        Assert.assertFalse(hasSyntacticDiagnostics(actualStubFilePath4.toString()));
        Assert.assertEquals(readContent(expectedStubFilePath4.toString()), readContent(actualStubFilePath4.toString()));

//        Assert.assertTrue(Files.exists(actualStubFilePath5));
//        Assert.assertFalse(hasSemanticDiagnostics(actualStubFilePath5.toString(), true));
//        Assert.assertEquals(readContent(expectedStubFilePath5.toString()),
//        readContent(actualStubFilePath5.toString()));
    }

    @Test
    public void testExternalImportPaths() {
        Path protoFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), PROTO_FILE_DIRECTORY, "external-imports",
                "myproj", "foo", "bar", "child.proto");
        Path importDirPath = Paths.get(RESOURCE_DIRECTORY.toString(), PROTO_FILE_DIRECTORY, "external-imports",
                "myproj");
        Path outputDirPath = Paths.get(GENERATED_SOURCES_DIRECTORY, "tool_test_external_imports");

        Path actualRootStubFilePath = Paths.get(outputDirPath.toString(), "child_pb.bal");
        Path actualDependentStubFilePath = Paths.get(outputDirPath.toString(), "parent_pb.bal");
        Path expectedRootStubFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_external_imports", "child_pb.bal");
        Path expectedDependentStubFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_external_imports", "parent_pb.bal");

        generateSourceCode(protoFilePath.toString(), outputDirPath.toString(), "stubs", importDirPath.toString());

        Path destTomlFile = Paths.get(outputDirPath.toString(), "Ballerina.toml");
        copyBallerinaToml(destTomlFile);

        Assert.assertTrue(Files.exists(actualRootStubFilePath));
        Assert.assertFalse(hasSemanticDiagnostics(outputDirPath.toString(), false));
        Assert.assertEquals(readContent(expectedRootStubFilePath.toString()),
                readContent(actualRootStubFilePath.toString()));

        Assert.assertTrue(Files.exists(actualDependentStubFilePath));
        Assert.assertFalse(hasSemanticDiagnostics(outputDirPath.toString(), false));
        Assert.assertEquals(readContent(expectedDependentStubFilePath.toString()),
                readContent(actualDependentStubFilePath.toString()));
    }
}
