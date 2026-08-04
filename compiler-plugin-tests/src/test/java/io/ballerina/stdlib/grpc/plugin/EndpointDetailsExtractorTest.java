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
import io.ballerina.projects.JBallerinaBackend;
import io.ballerina.projects.JvmTarget;
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
    private static final String ENDPOINTS_FILE_NAME = "endpoints.yaml";

    @Test
    public void testHardcodedPortExtraction() throws IOException {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_10");
        try {
            DiagnosticResult diagnosticResult = buildProject(projectDirPath, true);
            Path artifactDir = projectDirPath.resolve(TARGET_DIR).resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir));
            Path endpointsYaml = artifactDir.resolve(ENDPOINTS_FILE_NAME);
            assertNoCompilationErrors(diagnosticResult);
            assertEndpointPort(endpointsYaml, 9090);
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testConfigurablePortWithDefaultValue() throws IOException {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_24");
        try {
            DiagnosticResult diagnosticResult = buildProject(projectDirPath, true);
            Path artifactDir = projectDirPath.resolve(TARGET_DIR).resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir));
            Path endpointsYaml = artifactDir.resolve(ENDPOINTS_FILE_NAME);
            assertNoCompilationErrors(diagnosticResult);
            assertEndpointPort(endpointsYaml, 9090);
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testConfigurablePortWithRequiredValue() throws IOException {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_25");
        try {
            DiagnosticResult diagnosticResult = buildProject(projectDirPath, true);
            assertNoCompilationErrors(diagnosticResult);

            Path endpointsYaml = projectDirPath.resolve(TARGET_DIR).resolve(ARTIFACT_DIR)
                    .resolve(ENDPOINTS_FILE_NAME);
            Assert.assertTrue(Files.notExists(endpointsYaml),
                    "No endpoints YAML should be generated when the required port cannot be resolved "
                            + "(no bogus port-0 entry)");
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testServiceArtifactEndpointYamlContainsExpectedPortForMultipleServices() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_26");
        try {
            DiagnosticResult diagnosticResult = buildProject(projectDirPath, true);
            Assert.assertEquals(diagnosticResult.errorCount(), 0);
            Path endpointsYaml = projectDirPath.resolve(TARGET_DIR).resolve(ARTIFACT_DIR)
                    .resolve(ENDPOINTS_FILE_NAME);
            Assert.assertTrue(Files.exists(endpointsYaml), "Consolidated endpoints YAML should be generated");
            String content = Files.readString(endpointsYaml);
            Assert.assertTrue(content.contains("port: 8091"), "Expected port 8091 for HelloBallerina service");
            Assert.assertTrue(content.contains("port: 9090"), "Expected port 9090 for HelloWorld service");
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    private static DiagnosticResult buildProject(Path projectDirPath, boolean isExportEndpoints)
            throws IOException {
        System.setProperty("ballerina.home", DISTRIBUTION_PATH.toString());
        BuildOptions buildOptions = BuildOptions.builder().setExportEndpoints(isExportEndpoints).build();
        BuildProject project = BuildProject.load(getEnvironmentBuilder(), projectDirPath, buildOptions);
        PackageCompilation compilation = project.currentPackage().getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        if (diagnosticResult.errorCount() == 0) {
            JBallerinaBackend jBallerinaBackend = JBallerinaBackend.from(compilation, JvmTarget.JAVA_21);
            Path binDir = project.targetDir().resolve("bin");
            Files.createDirectories(binDir);
            jBallerinaBackend.emit(JBallerinaBackend.OutputType.EXEC, binDir.resolve("output.jar"));
        }
        return diagnosticResult;
    }

    private static ProjectEnvironmentBuilder getEnvironmentBuilder() {
        Environment environment = EnvironmentBuilder.getBuilder().setBallerinaHome(DISTRIBUTION_PATH).build();
        return ProjectEnvironmentBuilder.getBuilder(environment);
    }

    private static void assertEndpointPort(Path endpointsYaml, int expectedPort) throws IOException {
        try (Stream<String> lines = Files.lines(endpointsYaml)) {
            String portLine = lines.map(String::trim)
                    .filter(line -> line.startsWith("port:"))
                    .findFirst()
                    .orElseThrow(() -> new AssertionError("No port field found in: " + endpointsYaml));
            int actualPort = Integer.parseInt(portLine.substring("port:".length()).trim());
            Assert.assertEquals(actualPort, expectedPort, "Unexpected endpoint port in " + endpointsYaml);
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
