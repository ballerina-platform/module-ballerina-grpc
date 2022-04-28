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

package io.ballerina.stdlib.grpc.plugin;

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
import java.util.stream.Stream;

/**
 * gRPC Compiler plugin tests.
 */
public class CompilerPluginTest {

    private static final Path RESOURCE_DIRECTORY = Paths.get("src", "test", "resources", "test-src")
            .toAbsolutePath();
    private static final Path DISTRIBUTION_PATH = Paths.get("../", "target", "ballerina-runtime")
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
        Assert.assertEquals(diagnosticResult.errors().size(), 0);
    }

    @Test
    public void testCompilerPluginServerStreaming() {

        Package currentPackage = loadPackage("package_02");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.errors().size(), 0);
    }

    @Test
    public void testCompilerPluginServerStreamingWithCaller() {

        Package currentPackage = loadPackage("package_03");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(28:5,39:6)] only `error?` return type is allowed " +
                "with the caller";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.errors().toArray()[0];
        Assert.assertEquals(diagnosticResult.errors().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.RETURN_WITH_CALLER.getErrorCode());
        Assert.assertTrue(diagnosticResult.errors().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithExtraParams() {

        Package currentPackage = loadPackage("package_04");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(28:5,39:6)] when there are two parameters to " +
                "a remote function, the first one must be a caller type";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.errors().toArray()[0];
        Assert.assertEquals(diagnosticResult.errors().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.TWO_PARAMS_WITHOUT_CALLER.getErrorCode());
        Assert.assertTrue(diagnosticResult.errors().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithoutAnnotations() {

        Package currentPackage = loadPackage("package_05");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(30:1,43:2)] undefined annotation: " +
                "grpc:ServiceDescriptor";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Stream<Diagnostic> grpcErrorDiagnostic = diagnosticResult.errors().stream().filter(
                diagnostic -> diagnostic.diagnosticInfo().code().equals(
                        GrpcCompilerPluginConstants.CompilationErrors.UNDEFINED_ANNOTATION.getErrorCode()));
        Assert.assertTrue(grpcErrorDiagnostic.anyMatch(d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithResourceFunction() {

        Package currentPackage = loadPackage("package_06");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(41:5,43:6)] resource methods are not allowed " +
         "inside gRPC services";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.errors().toArray()[0];
        Assert.assertEquals(diagnosticResult.errors().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.RESOURCES_NOT_ALLOWED.getErrorCode());
        Assert.assertTrue(diagnosticResult.errors().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithInvalidCaller() {

        Package currentPackage = loadPackage("package_07");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_server_streaming_service.bal:(28:5,40:6)] expected caller type " +
                "\"HelloWorld<RPC_RETURN_TYPE>Caller\" but found \"CustomCaller\"";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.errors().toArray()[0];
        Assert.assertEquals(diagnosticResult.errors().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.INVALID_CALLER_TYPE.getErrorCode());
        Assert.assertTrue(diagnosticResult.errors().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginServerStreamingWithAlias() {

        Package currentPackage = loadPackage("package_08");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.errors().size(), 0);
    }

    @Test
    public void testCompilerPluginUnaryWithInvalidCaller() {

        Package currentPackage = loadPackage("package_09");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_service.bal:(26:5,38:6)] expected caller type " +
                "\"HelloWorld<RPC_RETURN_TYPE>Caller\" but found \"HelloWStringCaller\"";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.errors().toArray()[0];
        Assert.assertEquals(diagnosticResult.errors().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.INVALID_CALLER_TYPE.getErrorCode());
        Assert.assertTrue(diagnosticResult.errors().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginUnaryWithValidCaller() {

        Package currentPackage = loadPackage("package_10");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.errors().size(), 0);
    }

    @Test
    public void testCompilerPluginBidiWithInvalidCaller() {

        Package currentPackage = loadPackage("package_11");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [grpc_service.bal:(26:5,38:6)] expected caller type " +
         "\"HelloWorld<RPC_RETURN_TYPE>Caller\" but found \"HelloStringCaller\"";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.errors().toArray()[0];
        Assert.assertEquals(diagnosticResult.errors().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.INVALID_CALLER_TYPE.getErrorCode());
        Assert.assertTrue(diagnosticResult.errors().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    @Test
    public void testCompilerPluginBidiWithValidCallerErrorReturn() {
        Package currentPackage = loadPackage("package_13");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.errors().size(), 0);
    }

    @Test
    public void testCompilerPluginBidiWithValidCaller() {

        Package currentPackage = loadPackage("package_12");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.errors().size(), 0);
    }

    @Test
    public void testCompilerPluginUnaryWithEmptyServiceName() {

        Package currentPackage = loadPackage("package_14");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.errors().size(), 2);

        Diagnostic diagnostic1 = (Diagnostic) diagnosticResult.errors().toArray()[0];
        Assert.assertEquals(diagnostic1.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.INVALID_SERVICE_NAME.getErrorCode());
        Diagnostic diagnostic2 = (Diagnostic) diagnosticResult.errors().toArray()[1];
        Assert.assertEquals(diagnostic2.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.INVALID_SERVICE_NAME.getErrorCode());

        String errMsg1 = "ERROR [helloballerina_service.bal:(19:1,28:2)] invalid service name. " +
                "Service name cannot be nil";
        String errMsg2 = "ERROR [helloworld_service.bal:(25:9,25:11)] invalid service name. " +
                "Service name cannot be nil";
        String[] actualErrors  = {diagnostic1.toString(), diagnostic2.toString()};
        String[] expectedErrors  = {errMsg1, errMsg2};
        Assert.assertEqualsNoOrder(actualErrors, expectedErrors);
    }

    @Test
    public void testCompilerPluginUnaryWithHierarchicalServiceName() {

        Package currentPackage = loadPackage("package_15");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.errors().size(), 2);


        Diagnostic diagnostic1 = (Diagnostic) diagnosticResult.errors().toArray()[0];
        Assert.assertEquals(diagnostic1.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.INVALID_SERVICE_NAME.getErrorCode());
        Diagnostic diagnostic2 = (Diagnostic) diagnosticResult.errors().toArray()[1];
        Assert.assertEquals(diagnostic2.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.INVALID_SERVICE_NAME.getErrorCode());

        String errMsg1 = "ERROR [helloballerina_service.bal:(20:9,20:26)] invalid service name " +
         "/HelloBallerina. Service name should not be a hierarchical name";
        String errMsg2 = "ERROR [helloworld_service.bal:(22:9,22:10)] invalid service name " +
         "/HelloWorld. Service name should not be a hierarchical name";
        String[] actualErrors  = {diagnostic1.toString(), diagnostic2.toString()};
        String[] expectedErrors  = {errMsg1, errMsg2};
        Assert.assertEqualsNoOrder(actualErrors, expectedErrors);
    }

    @Test
    public void testCompilerPluginWithInitAndNormalFunctions1() {
        Package currentPackage = loadPackage("package_16");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.errors().size(), 0);
    }

    @Test
    public void testCompilerPluginWithInitAndNormalFunctions2() {
        Package currentPackage = loadPackage("package_17");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.errors().size(), 0);
    }

    @Test
    public void testCompilerPluginServiceNameStartingWithSimpleCase() {

        Package currentPackage = loadPackage("package_18");
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Assert.assertEquals(diagnosticResult.errors().size(), 0);
    }

    @Test
    public void testCompilerPluginServiceNameStartingWithSimpleCaseInvalidCaller() {

        Package currentPackage = loadPackage("package_19");
        PackageCompilation compilation = currentPackage.getCompilation();
        String errMsg = "ERROR [helloworld_service.bal:(23:5,26:6)] expected caller type " +
                "\"HelloWorld<RPC_RETURN_TYPE>Caller\" but found \"helloWorldStringCaller\"";
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        Diagnostic diagnostic = (Diagnostic) diagnosticResult.errors().toArray()[0];
        Assert.assertEquals(diagnosticResult.errors().size(), 1);
        Assert.assertEquals(diagnostic.diagnosticInfo().code(),
                GrpcCompilerPluginConstants.CompilationErrors.INVALID_CALLER_TYPE.getErrorCode());
        Assert.assertTrue(diagnosticResult.errors().stream().anyMatch(
                d -> errMsg.equals(d.toString())));
    }

    private Package loadPackage(String path) {

        Path projectDirPath = RESOURCE_DIRECTORY.resolve(path);
        BuildProject project = BuildProject.load(getEnvironmentBuilder(), projectDirPath);
        return project.currentPackage();
    }
}
