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
            DiagnosticResult diagnosticResult = getDiagnosticResults(projectDirPath, true);
            Path artifactDir = projectDirPath.resolve(TARGET_DIR).resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir));
            Path endpointYaml = artifactDir.resolve("grpc_service_HelloWorld_endpoint.yaml");
            assertNoCompilationErrors(diagnosticResult);
            assertEndpointPort(endpointYaml, 9090);
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testConfigurablePortWithDefaultValue() throws IOException {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_24");
        try {
            DiagnosticResult diagnosticResult = getDiagnosticResults(projectDirPath, true);
            Path artifactDir = projectDirPath.resolve(TARGET_DIR).resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir));
            Path endpointYaml = artifactDir.resolve("grpc_unary_blocking_service_HelloWorld_endpoint.yaml");
            assertNoCompilationErrors(diagnosticResult);
            assertEndpointPort(endpointYaml, 9090);
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testConfigurablePortWithRequiredValue()  throws IOException {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_25");
        try {
            getDiagnosticResults(projectDirPath, true);
            Path artifactDir = projectDirPath.resolve(TARGET_DIR).resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir));
            Path endpointYaml = artifactDir.resolve("grpc_unary_blocking_service_HelloWorld_endpoint.yaml");
            assertEndpointPort(endpointYaml, 0);
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testServiceArtifactEndpointYamlContainsExpectedPortForMultipleServices() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_26");
        try {
            DiagnosticResult diagnosticResult = getDiagnosticResults(projectDirPath, true);
            Assert.assertEquals(diagnosticResult.errorCount(), 0);
            assertEndpointPort(projectDirPath.resolve(TARGET_DIR).resolve(ARTIFACT_DIR)
                            .resolve("helloballerina_service_HelloBallerina_endpoint.yaml"),
                    8091);
            assertEndpointPort(projectDirPath.resolve(TARGET_DIR).resolve(ARTIFACT_DIR)
                    .resolve("helloworld_service_HelloWorld_endpoint.yaml"), 9090);
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    private static DiagnosticResult getDiagnosticResults(Path projectDirPath, boolean isExportEndpoints) {
        BuildOptions buildOptions = BuildOptions.builder().setExportEndpoints(isExportEndpoints).build();
        BuildProject project = BuildProject.load(getEnvironmentBuilder(), projectDirPath, buildOptions);
        PackageCompilation compilation = project.currentPackage().getCompilation();
        return compilation.diagnosticResult();
    }

    private static ProjectEnvironmentBuilder getEnvironmentBuilder() {
        Environment environment = EnvironmentBuilder.getBuilder().setBallerinaHome(DISTRIBUTION_PATH).build();
        return ProjectEnvironmentBuilder.getBuilder(environment);
    }

    private static void assertEndpointPort(Path endpointYaml, int expectedPort) throws IOException {
        try (Stream<String> lines = Files.lines(endpointYaml)) {
            String portLine = lines.map(String::trim)
                    .filter(line -> line.startsWith("port:"))
                    .findFirst()
                    .orElseThrow(() -> new AssertionError("No port field found in: " + endpointYaml));
            int actualPort = Integer.parseInt(portLine.substring("port:".length()).trim());
            Assert.assertEquals(actualPort, expectedPort, "Unexpected endpoint port in " + endpointYaml);
        }
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
