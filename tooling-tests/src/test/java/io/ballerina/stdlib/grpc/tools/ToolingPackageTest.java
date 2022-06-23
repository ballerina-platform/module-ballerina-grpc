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

import org.testng.annotations.Test;

import static io.ballerina.stdlib.grpc.tools.ToolingTestUtils.assertGeneratedSources;

/**
 * gRPC packaging related tests.
 */
public class ToolingPackageTest {

    @Test
    public void testSimplePackage() {
        assertGeneratedSources("packaging", "simplePackage.proto", "simplePackage_pb.bal",
                "helloworld_service.bal", "helloworld_client.bal", "tool_test_packaging_1");
    }

    @Test
    public void testPackagingWithMessageImports() {
        assertGeneratedSources("packaging", "packageWithMessageImport.proto", "packageWithMessageImport_pb.bal",
                "helloworld_service.bal", "helloworld_client.bal", "tool_test_packaging_2");
    }

    @Test
    public void testPackagingWithMultipleImports() {
        assertGeneratedSources("packaging", "packageWithMultipleImports.proto", "packageWithMultipleImports_pb.bal",
                "helloworld_service.bal", "helloworld_client.bal", "tool_test_packaging_3");
    }

}
