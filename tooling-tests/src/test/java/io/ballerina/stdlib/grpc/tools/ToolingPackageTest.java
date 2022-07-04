/*
 *  Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package io.ballerina.stdlib.grpc.tools;

import org.testng.Assert;
import org.testng.annotations.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.GENERATED_SOURCES_DIRECTORY;
import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.assertGeneratedSources;

/**
 * gRPC packaging related tests.
 */
public class ToolingPackageTest {

    @Test
    public void testSimplePackage() {
        try {
            Files.createDirectories(Paths.get(GENERATED_SOURCES_DIRECTORY, "tool_test_packaging_1"));
        } catch (IOException e) {
            Assert.fail("Could not create target directories", e);
        }
        assertGeneratedSources("packaging", "tool_test_packaging_1/simplePackage.proto",
                "simplePackage_pb.bal", "helloworld_service.bal", "helloworld_client.bal",
                "tool_test_packaging_1");
    }

    @Test
    public void testPackagingWithMessageImports() {
        try {
            Files.createDirectories(Paths.get(GENERATED_SOURCES_DIRECTORY, "tool_test_packaging_2"));
        } catch (IOException e) {
            Assert.fail("Could not create target directories", e);
        }
        assertGeneratedSources("packaging", "tool_test_packaging_2/packageWithMessageImport.proto",
                "packageWithMessageImport_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_packaging_2", "modules/message/message_pb.bal");
    }

    @Test
    public void testPackagingWithMultipleImports() {
        try {
            Files.createDirectories(Paths.get(GENERATED_SOURCES_DIRECTORY, "tool_test_packaging_3"));
        } catch (IOException e) {
            Assert.fail("Could not create target directories", e);
        }
        assertGeneratedSources("packaging", "tool_test_packaging_3/packageWithMultipleImports.proto",
                "packageWithMultipleImports_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_packaging_3",
                "modules/message1/message1_pb.bal", "modules/message2/message2_pb.bal");
    }

    @Test
    public void testPackagingWithImportsContainingService() {
        try {
            Files.createDirectories(Paths.get(GENERATED_SOURCES_DIRECTORY, "tool_test_packaging_4"));
        } catch (IOException e) {
            Assert.fail("Could not create target directories", e);
        }
        assertGeneratedSources("packaging", "tool_test_packaging_4/packageWithImportContainingService.proto",
                "packageWithImportContainingService_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_packaging_4", "modules/message/messageWithService_pb.bal");
    }

    @Test
    public void testPackagingWithNestedSubmodules() {
        try {
            Files.createDirectories(Paths.get(GENERATED_SOURCES_DIRECTORY, "tool_test_packaging_5"));
        } catch (IOException e) {
            Assert.fail("Could not create target directories", e);
        }
        assertGeneratedSources("packaging", "tool_test_packaging_5/packageWithNestedSubmodules.proto",
                "packageWithNestedSubmodules_pb.bal", "helloworld_service.bal",
                "helloworld_client.bal", "tool_test_packaging_5",
                "modules/messages.message1/message1_pb.bal", "modules/messages.message2/message2_pb.bal");
    }

}
