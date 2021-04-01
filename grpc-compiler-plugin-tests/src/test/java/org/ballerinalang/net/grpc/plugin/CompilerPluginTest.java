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

package org.ballerinalang.net.grpc.plugin;

import io.ballerina.projects.DiagnosticResult;
import io.ballerina.projects.Package;
import io.ballerina.projects.PackageCompilation;
import io.ballerina.projects.ProjectEnvironmentBuilder;
import io.ballerina.projects.directory.BuildProject;
import io.ballerina.projects.environment.Environment;
import io.ballerina.projects.environment.EnvironmentBuilder;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.io.PrintStream;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * gRPC Compiler plugin tests.
 */
public class CompilerPluginTest {

    private static final Path RESOURCE_DIRECTORY = Paths.get("src", "test", "resources", "test-src")
            .toAbsolutePath();
    private static final PrintStream OUT = System.out;
    private static final Path DISTRIBUTION_PATH = Paths.get("build", "target", "ballerina-distribution")
            .toAbsolutePath();

    @Test
    public void testCompilerPluginUnary() {

        Package currentPackage = loadPackage("package_01");
        PackageCompilation compilation = currentPackage.getCompilation();

        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 0);
    }

    @Test
    public void testCompilerPluginServerStreaming() {

        Package currentPackage = loadPackage("package_02");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 0);
    }

    @Test
    public void testCompilerPluginServerStreamingWithCaller() {

        Package currentPackage = loadPackage("package_03");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(27:4,38:5)] return types are not allowed with " +
         "the caller";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 1);
        Assert.assertTrue(diagnosticResult.diagnostics().stream().anyMatch(
                diagnostic -> errMsg.equals(diagnostic.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithExtraParams() {

        Package currentPackage = loadPackage("package_04");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(27:4,38:5)] when there are two parameters to " +
         "a remote function, the first one must be a caller type";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 1);
        Assert.assertTrue(diagnosticResult.diagnostics().stream().anyMatch(
                diagnostic -> errMsg.equals(diagnostic.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithoutAnnotations() {

        Package currentPackage = loadPackage("package_05");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(21:0,35:1)] undefined annotation: " +
         "grpc:ServiceDescriptor";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 1);
        Assert.assertTrue(diagnosticResult.diagnostics().stream().anyMatch(
                diagnostic -> errMsg.equals(diagnostic.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithResourceFunction() {

        Package currentPackage = loadPackage("package_06");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(40:4,42:5)] only remote functions are " +
         "allowed inside gRPC services";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 1);
        Assert.assertTrue(diagnosticResult.diagnostics().stream().anyMatch(
                diagnostic -> errMsg.equals(diagnostic.toString())));
    }

    private Package loadPackage(String path) {

        Path projectDirPath = RESOURCE_DIRECTORY.resolve(path);
        BuildProject project = BuildProject.load(getEnvironmentBuilder(), projectDirPath);
        return project.currentPackage();
    }

    private static ProjectEnvironmentBuilder getEnvironmentBuilder() {

        Environment environment = EnvironmentBuilder.getBuilder().setBallerinaHome(DISTRIBUTION_PATH).build();
        return ProjectEnvironmentBuilder.getBuilder(environment);
    }
}
