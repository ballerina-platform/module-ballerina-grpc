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

import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.BALLERINA_TOML_FILE;
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

        generateSourceCode(protoFilePath, outputDirPath, null, null);

        Path expectedStubFilePath1 = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_proto_dir", "helloWorldBoolean_pb.bal");
        Path expectedStubFilePath2 = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_proto_dir", "helloWorldInt_pb.bal");
        Path expectedStubFilePath3 = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_proto_dir", "helloWorldString_pb.bal");
        Path expectedStubFilePath4 = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_proto_dir", "helloWorldWithDependency_pb.bal");

        Path actualStubFilePath1 = Paths.get(outputDirPath.toString(), "helloWorldBoolean_pb.bal");
        Path actualStubFilePath2 = Paths.get(outputDirPath.toString(), "helloWorldInt_pb.bal");
        Path actualStubFilePath3 = Paths.get(outputDirPath.toString(), "helloWorldString_pb.bal");
        Path actualStubFilePath4 = Paths.get(outputDirPath.toString(), "helloWorldWithDependency_pb.bal");

        Assert.assertTrue(Files.exists(actualStubFilePath1));
        Assert.assertFalse(hasSemanticDiagnostics(actualStubFilePath1, true));
        Assert.assertEquals(readContent(expectedStubFilePath1), readContent(actualStubFilePath1));

        Assert.assertTrue(Files.exists(actualStubFilePath2));
        Assert.assertFalse(hasSemanticDiagnostics(actualStubFilePath2, true));
        Assert.assertEquals(readContent(expectedStubFilePath2), readContent(actualStubFilePath2));

        Assert.assertTrue(Files.exists(actualStubFilePath3));
        Assert.assertFalse(hasSemanticDiagnostics(actualStubFilePath3, true));
        Assert.assertEquals(readContent(expectedStubFilePath3), readContent(actualStubFilePath3));

        Assert.assertTrue(Files.exists(actualStubFilePath4));
        Assert.assertFalse(hasSyntacticDiagnostics(actualStubFilePath4));
        Assert.assertEquals(readContent(expectedStubFilePath4), readContent(actualStubFilePath4));
    }

    @Test
    public void testExternalImportPaths() {
        Path protoFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), PROTO_FILE_DIRECTORY, "external-imports",
                "myproj", "foo", "bar", "child.proto");
        Path importDirPath = Paths.get(RESOURCE_DIRECTORY.toString(), PROTO_FILE_DIRECTORY, "external-imports",
                "myproj");
        Path outputDirPath = Paths.get(GENERATED_SOURCES_DIRECTORY, "tool_test_external_imports");

        Path actualRootStubFilePath = outputDirPath.resolve("child_pb.bal");
        Path actualDependentStubFilePath = outputDirPath.resolve("parent_pb.bal");
        Path expectedRootStubFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_external_imports", "child_pb.bal");
        Path expectedDependentStubFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                "tool_test_external_imports", "parent_pb.bal");

        generateSourceCode(protoFilePath, outputDirPath, "stubs", importDirPath);

        Path destTomlFile = outputDirPath.resolve(BALLERINA_TOML_FILE);
        copyBallerinaToml(destTomlFile);

        Assert.assertTrue(Files.exists(actualRootStubFilePath));
        Assert.assertFalse(hasSemanticDiagnostics(outputDirPath, false));
        Assert.assertEquals(readContent(expectedRootStubFilePath), readContent(actualRootStubFilePath));

        Assert.assertTrue(Files.exists(actualDependentStubFilePath));
        Assert.assertFalse(hasSemanticDiagnostics(outputDirPath, false));
        Assert.assertEquals(readContent(expectedDependentStubFilePath), readContent(actualDependentStubFilePath));
    }

    @Test(enabled = false, description = "This test case is to generate stub files for all grpc tests. " +
            "We can use this to verify the generated output files manually.")
    public void generateStubFilesForBallerinaTests() {
        Path outputDirPath = Paths.get("../ballerina-tests/tests/");
        // First stub file should not be regenerated since it was generated by an older tool version
        // (To ensure backwards compatibility).
//        generateSourceCode(outputDirPath.resolve("01_advanced_type_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("02_array_field_type_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("03_bidirectional_streaming_service.proto"), outputDirPath,
                null, null);
        generateSourceCode(outputDirPath.resolve("04_client_streaming_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("05_invalid_resource_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("06_server_streaming_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("07_unary_server.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("08_unary_service_with_headers.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("09_grpc_secured_unary_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("10_grpc_ssl_server.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("11_grpc_byte_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("12_grpc_enum_test_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("13_grpc_service_with_error_return.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("14_grpc_client_socket_timeout.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("15_grpc_oneof_field_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("16_unavailable_service_client.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("18_grpc_optional_field_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("19_grpc_map_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("20_unary_client_for_anonymous_service.proto"), outputDirPath,
                null, null);
        generateSourceCode(outputDirPath.resolve("21_grpc_gzip_encoding_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("22_retry_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("23_server_streaming_with_record_service.proto"), outputDirPath,
                null, null);
        generateSourceCode(outputDirPath.resolve("24_return_data_unary.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("25_return_data_streaming.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("26_return_data_client_streaming.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("27_bidirectional_streaming_service.proto"), outputDirPath,
                null, null);
        generateSourceCode(outputDirPath.resolve("28_unary_basic_auth.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("29_unary_jwt.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("30_unary_oauth2.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("31_return_unary.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("32_return_record_server_streaming.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("33_return_record_client_streaming.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("34_return_record_bidi_streaming.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("35_unary_service_with_deadline.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("36_unary_service_with_deadline_propagation.proto"), outputDirPath,
                null, null);
        generateSourceCode(outputDirPath.resolve("37_streaming_with_deadline.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("38_bidi_streaming_with_caller.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("39_unary_bearer_auth.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("40_bidirectional_streaming_negative_test.proto"), outputDirPath,
                null, null);
        generateSourceCode(outputDirPath.resolve("41_server_streaming_headers_and_negative_test.proto"),
                outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("42_repeated_data_types_test.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("43_nested_record_with_streams.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("44_route_guide.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("45_services_with_headers.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("46_empty_values.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("47_unary_timestamp.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("48_bidi_timestamp.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("49_duration.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("50_bidi_caller_cancel_status.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("51_client_function_utils_negative_cases.proto"), outputDirPath,
                null, null);
        generateSourceCode(outputDirPath.resolve("52_unary_ldap_auth.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("53_server_streaming_negative.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("54_backward_compatible_client_proto.proto"), outputDirPath,
                null, null);
        generateSourceCode(outputDirPath.resolve("55_declarative_authentication.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("56_service_panic_after_send_error.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("57_struct_type.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("58_nested_message_nested_enum.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("59_simple_rpc_with_go_service.proto"), outputDirPath, null, null);
        generateSourceCode(outputDirPath.resolve("60_client_send_error_in_client_bidi_streaming.proto"),
                outputDirPath, null, null);
    }
}
