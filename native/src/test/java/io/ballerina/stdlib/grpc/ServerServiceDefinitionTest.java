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

package io.ballerina.stdlib.grpc;

import io.ballerina.stdlib.grpc.exception.GrpcServerException;
import org.testng.annotations.Test;

import static org.testng.Assert.assertEquals;

/**
 * A test class to test ServerServiceDefinition class functions.
 */
public class ServerServiceDefinitionTest {

    @Test()
    public void testServerServiceDefinitionNullServiceName() {
        try {
            ServerServiceDefinition.Builder builder = ServerServiceDefinition.builder(null);
        } catch (GrpcServerException e) {
            assertEquals(e.getMessage(), "Service Name cannot be null");
        }
    }

    @Test()
    public void testServerServiceDefinitionNullServiceDescriptor() {
        try {
            ServerServiceDefinition.Builder builder = ServerServiceDefinition.builder("TestService");
            builder.addMethod(null, null);
        } catch (GrpcServerException e) {
            assertEquals(e.getMessage(), "Method Descriptor cannot be null");
        }
    }

    @Test()
    public void testServerServiceDefinitionNullServerCallHandler() {
        try {
            ServerServiceDefinition.Builder builder = ServerServiceDefinition.builder("TestService");
            MethodDescriptor.Builder methodBuilder = MethodDescriptor.newBuilder();
            methodBuilder = methodBuilder.setFullMethodName("TestMethod");
            MethodDescriptor descriptor = methodBuilder.build();
            builder.addMethod(descriptor, null);
        } catch (GrpcServerException e) {
            assertEquals(e.getMessage(), "Server call handler cannot be null");
        }
    }
}
