/*
 * Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.grpc.plugin;

import io.ballerina.projects.BuildOptions;
import io.ballerina.projects.DiagnosticResult;
import io.ballerina.projects.PackageCompilation;
import io.ballerina.projects.ProjectEnvironmentBuilder;
import io.ballerina.projects.directory.BuildProject;
import io.ballerina.projects.environment.Environment;
import io.ballerina.projects.environment.EnvironmentBuilder;
import io.ballerina.projects.plugins.EndpointArtifact;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Comparator;
import java.util.stream.Stream;

public class EndpointDetailsExtractorTest {
    private static final Path RESOURCE_DIRECTORY = Paths.get("src", "test", "resources", "test-src")
            .toAbsolutePath();
    private static final Path DISTRIBUTION_PATH = Paths.get("../", "target", "ballerina-runtime")
            .toAbsolutePath();

    private static final String TARGET_DIR = "target";
    private static final String ARTIFACT_DIR = "artifact";

    @Test
    public void testHardcodedPortExtraction() throws IOException {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_10");
        try {
            BuildProject project = loadProject(projectDirPath, true);
            DiagnosticResult diagnosticResult = getDiagnosticResults(project);
            Path artifactDir = projectDirPath.resolve(TARGET_DIR).resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir));
            assertNoCompilationErrors(diagnosticResult);
            assertEndpointPort(project, "grpc_service_HelloWorld.proto", 9090);
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testConfigurablePortWithDefaultValue() throws IOException {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_24");
        try {
            BuildProject project = loadProject(projectDirPath, true);
            DiagnosticResult diagnosticResult = getDiagnosticResults(project);
            Path artifactDir = projectDirPath.resolve(TARGET_DIR).resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir));
            assertNoCompilationErrors(diagnosticResult);
            assertEndpointPort(project, "grpc_unary_blocking_service_HelloWorld.proto", 9090);
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testConfigurablePortWithRequiredValue()  throws IOException {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_25");
        try {
            BuildProject project = loadProject(projectDirPath, true);
            getDiagnosticResults(project);
            Path artifactDir = projectDirPath.resolve(TARGET_DIR).resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir));
            assertEndpointPort(project, "grpc_unary_blocking_service_HelloWorld.proto", 0);
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testServiceArtifactEndpointYamlContainsExpectedPortForMultipleServices() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_26");
        try {
            BuildProject project = loadProject(projectDirPath, true);
            DiagnosticResult diagnosticResult = getDiagnosticResults(project);
            Assert.assertEquals(diagnosticResult.errorCount(), 0);
            assertEndpointPort(project, "helloballerina_service_HelloBallerina.proto", 8091);
            assertEndpointPort(project, "helloworld_service_HelloWorld.proto", 9090);
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    private static BuildProject loadProject(Path projectDirPath, boolean isExportEndpoints) {
        BuildOptions buildOptions = BuildOptions.builder().setExportEndpoints(isExportEndpoints).build();
        return BuildProject.load(getEnvironmentBuilder(), projectDirPath, buildOptions);
    }

    private static DiagnosticResult getDiagnosticResults(BuildProject project) {
        PackageCompilation compilation = project.currentPackage().getCompilation();
        return compilation.diagnosticResult();
    }

    private static ProjectEnvironmentBuilder getEnvironmentBuilder() {
        Environment environment = EnvironmentBuilder.getBuilder().setBallerinaHome(DISTRIBUTION_PATH).build();
        return ProjectEnvironmentBuilder.getBuilder(environment);
    }

    private static void assertEndpointPort(BuildProject project, String schemaPath, int expectedPort) {
        EndpointArtifact endpointArtifact = project.endpointArtifacts().stream()
                .filter(artifact -> schemaPath.equals(artifact.schemaPath()))
                .findFirst()
                .orElseThrow(() -> new AssertionError("No endpoint artifact found for: " + schemaPath));
        Assert.assertEquals(endpointArtifact.port(), expectedPort, "Unexpected endpoint port in " + schemaPath);
    }

    private void deleteDirectories(Path projectDirPath) throws IOException {
        Path targetDir = projectDirPath.resolve(TARGET_DIR);
        if (Files.exists(targetDir)) {
            try (Stream<Path> paths = Files.walk(targetDir)) {
                paths.sorted(Comparator.reverseOrder()).forEach(path -> {
                    try {
                        Files.delete(path);
                    } catch (IOException e) {
                        Assert.fail("Failed to delete file: " + path, e);
                    }
                });
            }
        }

        Path dependenciesFile = projectDirPath.resolve("Dependencies.toml");
        if (Files.exists(dependenciesFile)) {
            Files.delete(dependenciesFile);
        }
    }

    private static void assertNoCompilationErrors(DiagnosticResult diagnosticResult) {
        Assert.assertEquals(diagnosticResult.errorCount(), 0,
                "Unexpected errors: " + diagnosticResult.errors());
    }
}
