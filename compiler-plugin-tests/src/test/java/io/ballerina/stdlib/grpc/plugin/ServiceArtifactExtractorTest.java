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
    private static final String PROTO_SUFFIX = ".proto";

    @Test
    public void testExportEndpointsForSimpleService() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_20");
        try {
            BuildProject project = loadProject(projectDirPath, true);
            DiagnosticResult diagnosticResult = getDiagnosticResults(project);
            assertNoCompilationErrors(diagnosticResult);

            Path artifactDir = projectDirPath.resolve("target").resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir), "Artifact directory should exist");
            assertEndpointArtifactCount(project, 1L, "Expected one endpoint artifact for package_20");
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
            BuildProject project = loadProject(projectDirPath, false);
            DiagnosticResult diagnosticResult = getDiagnosticResults(project);
            assertNoCompilationErrors(diagnosticResult);

            Path artifactDir = projectDirPath.resolve("target").resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.notExists(artifactDir),
                    "Artifact directory should not be generated without --export-endpoints");
            assertEndpointArtifactCount(project, 0L, "Endpoint artifacts should not be added without export flag");
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testExportEndpointsWithCompilationErrors() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_03");
        try {
            BuildProject project = loadProject(projectDirPath, true);
            DiagnosticResult diagnosticResult = getDiagnosticResults(project);
            Assert.assertNotEquals(diagnosticResult.errorCount(), 0);
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testExportEndpointsForMultipleGrpcServicesAcrossFiles() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_14");
        try {
            BuildProject project = loadProject(projectDirPath, true);
            DiagnosticResult diagnosticResult = getDiagnosticResults(project);
            assertNoInvalidServiceNameErrors(diagnosticResult);

            Path artifactDir = projectDirPath.resolve("target").resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir), "Artifact directory should exist");
            assertEndpointArtifactCount(project, 2L, "Expected endpoint artifacts for both services in package_14");
            assertArtifactCount(artifactDir, PROTO_SUFFIX, 2L,
                    "Expected proto artifacts for both services in package_14");
        } finally {
            deleteDirectories(projectDirPath);
        }
    }

    @Test
    public void testExportEndpointsForMultipleServicesInSingleFile() throws Exception {
        Path projectDirPath = RESOURCE_DIRECTORY.resolve("package_28");
        try {
            BuildProject project = loadProject(projectDirPath, true);
            DiagnosticResult diagnosticResult = getDiagnosticResults(project);
            assertNoCompilationErrors(diagnosticResult);

            Path artifactDir = projectDirPath.resolve("target").resolve(ARTIFACT_DIR);
            Assert.assertTrue(Files.exists(artifactDir), "Artifact directory should exist");
            assertEndpointArtifactCount(project, 1L,
                    "Expected one endpoint artifact from the single gRPC service in the file");
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
            BuildProject project = loadProject(projectDirPath, true);
            DiagnosticResult diagnosticResult = getDiagnosticResults(project);
            assertNoInvalidServiceNameErrors(diagnosticResult);

            List<String> endpointNames = project.endpointArtifacts().stream()
                    .map(EndpointArtifact::name)
                    .toList();

            Assert.assertEquals(endpointNames.size(), 2,
                    "Expected endpoint artifacts for both services with empty names");
            Assert.assertTrue(endpointNames.stream().allMatch(fileName -> fileName.matches(".+_[0-9]+")),
                    "Endpoint artifacts should use fallback hash-based naming for empty service names");
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

    private static BuildProject loadProject(Path projectDirPath, boolean isExportEndpoints) {
        BuildOptions buildOptions = BuildOptions.builder().setExportEndpoints(isExportEndpoints).build();
        return BuildProject.load(getEnvironmentBuilder(), projectDirPath, buildOptions);
    }

    private static DiagnosticResult getDiagnosticResults(BuildProject project) {
        PackageCompilation compilation = project.currentPackage().getCompilation();
        return compilation.diagnosticResult();
    }

    private static void assertEndpointArtifactCount(BuildProject project, long expectedCount, String message) {
        Assert.assertEquals(project.endpointArtifacts().size(), expectedCount, message);
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
