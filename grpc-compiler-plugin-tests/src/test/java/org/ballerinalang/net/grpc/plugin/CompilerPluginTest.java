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
import io.ballerina.tools.diagnostics.Diagnostic;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * gRPC Compiler plugin tests.
 */
public class CompilerPluginTest {

    private static final Path RESOURCE_DIRECTORY = Paths.get("src", "test", "resources", "test-src")
            .toAbsolutePath();
    private static final Path DISTRIBUTION_PATH = Paths.get("build", "target", "ballerina-distribution")
            .toAbsolutePath();

    private static ProjectEnvironmentBuilder getEnvironmentBuilder() {

        Environment environment = EnvironmentBuilder.getBuilder().setBallerinaHome(DISTRIBUTION_PATH).build();
        return ProjectEnvironmentBuilder.getBuilder(environment);
    }

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
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(27:4,38:5)] only `error?` return type is allowed " +
                "with the caller";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.diagnostics().toArray()[0];
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.RETURN_WITH_CALLER.getErrorCode());
        Assert.assertTrue(diagnosticResult.diagnostics().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithExtraParams() {

        Package currentPackage = loadPackage("package_04");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(27:4,38:5)] when there are two parameters to " +
                "a remote function, the first one must be a caller type";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.diagnostics().toArray()[0];
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.TWO_PARAMS_WITHOUT_CALLER.getErrorCode());
        Assert.assertTrue(diagnosticResult.diagnostics().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithoutAnnotations() {

        Package currentPackage = loadPackage("package_05");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(29:0,42:1)] undefined annotation: " +
                "grpc:ServiceDescriptor";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.diagnostics().toArray()[0];
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.UNDEFINED_ANNOTATION.getErrorCode());
        Assert.assertTrue(diagnosticResult.diagnostics().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithResourceFunction() {

        Package currentPackage = loadPackage("package_06");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(40:4,42:5)] only remote functions are " +
                "allowed inside gRPC services";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.diagnostics().toArray()[0];
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.ONLY_REMOTE_FUNCTIONS.getErrorCode());
        Assert.assertTrue(diagnosticResult.diagnostics().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithInvalidCaller() {

        Package currentPackage = loadPackage("package_07");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(27:4,39:5)] expected caller type " +
                "\"HelloWorld<RPC_RETURN_TYPE>Caller\" but found \"CustomCaller\"";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.diagnostics().toArray()[0];
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.INVALID_CALLER_TYPE.getErrorCode());
        Assert.assertTrue(diagnosticResult.diagnostics().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithAlias() {

        Package currentPackage = loadPackage("package_08");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 0);
    }

    @Test
    public void testCompilerPluginUnaryWithInvalidCaller() {

        Package currentPackage = loadPackage("package_09");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_service.bal:(25:4,37:5)] expected caller type " +
         "\"HelloWorld<RPC_RETURN_TYPE>Caller\" but found \"HelloWStringCaller\"";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.diagnostics().toArray()[0];
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.INVALID_CALLER_TYPE.getErrorCode());
        Assert.assertTrue(diagnosticResult.diagnostics().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginUnaryWithValidCaller() {

        Package currentPackage = loadPackage("package_10");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 0);
    }

    @Test
    public void testCompilerPluginBidiWithInvalidCaller() {

        Package currentPackage = loadPackage("package_11");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_service.bal:(25:4,37:5)] expected caller type " +
         "\"HelloWorld<RPC_RETURN_TYPE>Caller\" but found \"HelloStringCaller\"";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.diagnostics().toArray()[0];
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.INVALID_CALLER_TYPE.getErrorCode());
        Assert.assertTrue(diagnosticResult.diagnostics().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginBidiWithValidCallerErrorReturn() {
        Package currentPackage = loadPackage("package_13");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 0);
    }

    @Test
    public void testCompilerPluginBidiWithValidCaller() {

        Package currentPackage = loadPackage("package_12");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.diagnostics().size(), 0);
    }

    private Package loadPackage(String path) {

        Path projectDirPath = RESOURCE_DIRECTORY.resolve(path);
        BuildProject project = BuildProject.load(getEnvironmentBuilder(), projectDirPath);
        return project.currentPackage();
    }
}
