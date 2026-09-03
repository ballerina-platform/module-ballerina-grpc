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
import java.util.List;
import java.util.Objects;
import java.util.stream.Stream;

import static io.ballerina.stdlib.grpc.plugin.GrpcCompilerPluginConstants.CompilationErrors.INVALID_SERVICE_NAME;

public class ServiceArtifactExtractorTest {

    private static final Path RESOURCE_DIRECTORY = Paths.get("src", "test", "resources", "test-src")
            .toAbsolutePath();
    private static final Path DISTRIBUTION_PATH = Paths.get("../", "target", "ballerina-runtime")
            .toAbsolutePath();
    private static final String ARTIFACT_DIR = "artifact";
    private static final String ENDPOINTS_FILE_NAME = "endpoints.yaml";
    private static final String PROTO_SUFFIX = ".proto";

    @Test
    public void testExportEndpointsForSimpleService() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_20");
        try {
            DiagnosticResult diagnosticResult = buildProject(projectDirPath, true);
            assertNoCompilationErrors(diagnosticResult);

            Path artifactDir = projectDirPath.resolve("target").resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir), "Artifact directory should exist");
            Assert.assertTrue(Files.exists(artifactDir.resolve(ENDPOINTS_FILE_NAME)),
                    "Expected consolidated endpoints YAML for package_20");
            assertArtifactCount(artifactDir, PROTO_SUFFIX, 1L,
                    "Expected one proto file for package_20");
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testBuildWithoutExportEndpointsFlag() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_20");
        try {
            DiagnosticResult diagnosticResult = buildProject(projectDirPath, false);
            assertNoCompilationErrors(diagnosticResult);

            Path artifactDir = projectDirPath.resolve("target").resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.notExists(artifactDir),
                    "Artifact directory should not be generated without --export-endpoints");
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testExportEndpointsWithCompilationErrors() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_03");
        try {
            DiagnosticResult diagnosticResult = buildProject(projectDirPath, true);
            Assert.assertNotEquals(diagnosticResult.errorCount(), 0);
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testExportEndpointsForMultipleGrpcServicesAcrossFiles() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_14");
        try {
            DiagnosticResult diagnosticResult = buildProject(projectDirPath, true);
            assertNoInvalidServiceNameErrors(diagnosticResult);

            Path artifactDir = projectDirPath.resolve("target").resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir), "Artifact directory should exist");
            assertArtifactCount(artifactDir, PROTO_SUFFIX, 2L,
                    "Expected proto artifacts for both services in package_14");
            // Both services in package_14 have INVALID_SERVICE_NAME errors, so the package never reaches
            // code generation - the consolidated endpoints.yaml (written once codegen completes) is not produced.
            Assert.assertFalse(Files.exists(artifactDir.resolve(ENDPOINTS_FILE_NAME)),
                    "No consolidated endpoints YAML should be generated when the package has compilation errors");
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testExportEndpointsForMultipleServicesInSingleFile() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_28");
        try {
            DiagnosticResult diagnosticResult = buildProject(projectDirPath, true);
            assertNoCompilationErrors(diagnosticResult);

            Path artifactDir = projectDirPath.resolve("target").resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir), "Artifact directory should exist");
            Path endpointsYaml = artifactDir.resolve(ENDPOINTS_FILE_NAME);
            Assert.assertTrue(Files.exists(endpointsYaml),
                    "Expected one consolidated endpoints YAML from the single gRPC service in the file");
            assertArtifactCount(artifactDir, PROTO_SUFFIX, 1L,
                    "Expected one proto artifact from the single gRPC service in the file");
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testEndpointYamlFallbackNamingForEmptyServiceNames() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_14");
        try {
            DiagnosticResult diagnosticResult = buildProject(projectDirPath, true);
            assertNoInvalidServiceNameErrors(diagnosticResult);

            Path artifactDir = projectDirPath.resolve("target").resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir), "Artifact directory should exist");

            // Both services intentionally have empty/invalid names, exercising the same fallback
            // hash-based naming (FileNameGeneratorUtil) used for both the schemaPath and the proto file name.
            // The package never reaches code generation, so this is observed via the .proto files rather
            // than the consolidated endpoints.yaml (which is only written once codegen completes).
            List<String> protoFiles;
            try (Stream<Path> paths = Files.walk(artifactDir)) {
                protoFiles = paths
                        .map(this::safeFileName)
                        .filter(fileName -> fileName.endsWith(PROTO_SUFFIX))
                        .toList();
            }
            Assert.assertEquals(protoFiles.size(), 2,
                    "Expected proto artifacts for both services with empty names");
            Assert.assertTrue(protoFiles.stream()
                            .allMatch(fileName -> fileName.matches(".+_-?[0-9]+\\.proto")),
                    "Proto files should use fallback hash-based naming for empty service names");
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    private String safeFileName(Path path) {
        Path fileName = path == null ? null : path.getFileName();
        return Objects.toString(fileName, "");
    }

    private void assertArtifactCount(Path artifactDir, String suffix, long expectedCount, String message)
            throws IOException {
        try (Stream<Path> paths = Files.walk(artifactDir)) {
            long artifactCount = paths
                    .map(this::safeFileName)
                    .filter(fileName -> fileName.endsWith(suffix))
                    .count();
            Assert.assertEquals(artifactCount, expectedCount, message);
        }
    }

    private static ProjectEnvironmentBuilder getEnvironmentBuilder() {
        Environment environment = EnvironmentBuilder.getBuilder().setBallerinaHome(DISTRIBUTION_PATH).build();
        return ProjectEnvironmentBuilder.getBuilder(environment);
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

    private void deleteDirectories(Path projectDirPath) throws IOException {
        Path targetDir = projectDirPath.resolve("target");
        if (Files.exists(targetDir)) {
            try (Stream<Path> paths = Files.walk(targetDir)) {
                paths.sorted(Comparator.reverseOrder())
                        .forEach(path -> {
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

    private static void assertNoInvalidServiceNameErrors(DiagnosticResult diagnosticResult) {
        long nonInvalidServiceNameErrors = diagnosticResult.errors().stream()
                .filter(diagnostic -> !INVALID_SERVICE_NAME.getErrorCode()
                        .equals(diagnostic.diagnosticInfo().code()))
                .count();
        Assert.assertEquals(nonInvalidServiceNameErrors, 0,
                "Unexpected errors: " + diagnosticResult.errors());
    }

}
