package io.ballerina.stdlib.grpc.tools;

import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.projects.DiagnosticResult;
import io.ballerina.projects.Package;
import io.ballerina.projects.PackageCompilation;
import io.ballerina.projects.ProjectEnvironmentBuilder;
import io.ballerina.projects.directory.BuildProject;
import io.ballerina.projects.directory.SingleFileProject;
import io.ballerina.projects.environment.Environment;
import io.ballerina.projects.environment.EnvironmentBuilder;
import io.ballerina.stdlib.grpc.protobuf.cmd.GrpcCmd;
import io.ballerina.tools.text.TextDocument;
import io.ballerina.tools.text.TextDocuments;
import org.testng.Assert;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 * gRPC tool test Utils.
 */
public class ToolingTestUtils {

    public static final String PROTO_FILE_DIRECTORY = "proto-files/";
    public static final String BAL_FILE_DIRECTORY = "generated-sources/";
    public static final String GENERATED_SOURCES_DIRECTORY = "build/generated-sources/";

    public static final Path RESOURCE_DIRECTORY = Paths.get("src", "test", "resources", "test-src")
            .toAbsolutePath();
    private static final Path DISTRIBUTION_PATH = Paths.get("../", "target", "ballerina-runtime")
            .toAbsolutePath();
    private static final Path BALLERINA_TOML_PATH = Paths.get(RESOURCE_DIRECTORY.toString(), "Ballerina.toml");

    private static ProjectEnvironmentBuilder getEnvironmentBuilder() {
        Environment environment = EnvironmentBuilder.getBuilder().setBallerinaHome(DISTRIBUTION_PATH).build();
        return ProjectEnvironmentBuilder.getBuilder(environment);
    }

    public static void assertGeneratedSources(String subDir, String protoFile, String stubFile, String serviceFile,
                                              String clientFile, String outputDir) {
        Path protoFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), PROTO_FILE_DIRECTORY, subDir, protoFile);
        Path outputDirPath = Paths.get(GENERATED_SOURCES_DIRECTORY, outputDir);

        Path expectedStubFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY, outputDir, stubFile);
        Path expectedServiceFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                outputDir, serviceFile);
        Path expectedClientFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY,
                outputDir, clientFile);

        Path actualStubFilePath = Paths.get(outputDirPath.toString(), stubFile);
        Path actualServiceFilePath = Paths.get(outputDirPath.toString(), serviceFile);
        Path actualClientFilePath = Paths.get(outputDirPath.toString(), clientFile);

        generateSourceCode(protoFilePath.toString(), outputDirPath.toString(), null, null);
        Assert.assertTrue(Files.exists(actualStubFilePath));

        Path destTomlFile = Paths.get(GENERATED_SOURCES_DIRECTORY, outputDir, "Ballerina.toml");
        copyBallerinaToml(destTomlFile);

        Assert.assertFalse(hasSemanticDiagnostics(outputDirPath.toString(), false));
        Assert.assertEquals(readContent(expectedStubFilePath.toString()), readContent(actualStubFilePath.toString()));
        try {
            Files.deleteIfExists(actualStubFilePath);
        } catch (IOException e) {
            Assert.fail("Failed to delete stub file", e);
        }
        Assert.assertFalse(Files.exists(actualStubFilePath));

        generateSourceCode(protoFilePath.toString(), outputDirPath.toString(), "client", null);
        Assert.assertTrue(Files.exists(actualStubFilePath));
        Assert.assertTrue(Files.exists(actualClientFilePath));
        Assert.assertFalse(hasSemanticDiagnostics(outputDirPath.toString(), false));
        Assert.assertEquals(readContent(expectedStubFilePath.toString()), readContent(actualStubFilePath.toString()));
        Assert.assertEquals(readContent(expectedClientFilePath.toString()),
                readContent(actualClientFilePath.toString()));
        try {
            Files.deleteIfExists(actualStubFilePath);
        } catch (IOException e) {
            Assert.fail("Failed to delete stub file", e);
        }
        Assert.assertFalse(Files.exists(actualStubFilePath));

        generateSourceCode(protoFilePath.toString(), outputDirPath.toString(), "service", null);
        Assert.assertTrue(Files.exists(actualStubFilePath));
        Assert.assertTrue(Files.exists(actualServiceFilePath));
        Assert.assertFalse(hasSyntacticDiagnostics(actualStubFilePath.toString()));
        Assert.assertFalse(hasSyntacticDiagnostics(actualServiceFilePath.toString()));
        Assert.assertEquals(readContent(expectedStubFilePath.toString()), readContent(actualStubFilePath.toString()));
        Assert.assertEquals(readContent(expectedServiceFilePath.toString()),
                readContent(actualServiceFilePath.toString()));

        try {
            Files.deleteIfExists(actualServiceFilePath);
        } catch (IOException e) {
            Assert.fail("Failed to delete stub file", e);
        }
    }

    public static void assertGeneratedSourcesNegative(String input, String output, String outputDir, String mode) {
        Path protoFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), PROTO_FILE_DIRECTORY, input);
        Path outputDirPath = Paths.get(GENERATED_SOURCES_DIRECTORY, outputDir);
        Path stubFilePath = Paths.get(outputDirPath.toString(), output);

        generateSourceCode(protoFilePath.toString(), outputDirPath.toString(), mode, null);

        Assert.assertFalse(Files.exists(stubFilePath));
    }

    public static void assertGeneratedDataTypeSources(String subDir, String protoFile, String stubFile,
                                                      String outputDir) {
        Path protoFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), PROTO_FILE_DIRECTORY, subDir, protoFile);
        Path outputDirPath = Paths.get(GENERATED_SOURCES_DIRECTORY, outputDir);

        Path expectedStubFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), BAL_FILE_DIRECTORY, outputDir, stubFile);
        Path actualStubFilePath;
        if (outputDir.equals("")) {
            actualStubFilePath = Paths.get("temp", stubFile);
            generateSourceCode(protoFilePath.toString(), "", null, null);
            Assert.assertTrue(Files.exists(actualStubFilePath));

            Path destTomlFile = Paths.get("temp", "Ballerina.toml");
            copyBallerinaToml(destTomlFile);

            Assert.assertFalse(hasSemanticDiagnostics("temp", false));
            try {
                Files.deleteIfExists(actualStubFilePath);
                Files.deleteIfExists(destTomlFile);
                Files.deleteIfExists(Paths.get("temp"));
            } catch (IOException e) {
                Assert.fail("Failed to delete stub file", e);
            }
        } else {
            actualStubFilePath = Paths.get(outputDirPath.toString(), stubFile);
            generateSourceCode(protoFilePath.toString(), outputDirPath.toString(), null, null);
            Assert.assertTrue(Files.exists(actualStubFilePath));

            Path destTomlFile = Paths.get(GENERATED_SOURCES_DIRECTORY, outputDir, "Ballerina.toml");
            copyBallerinaToml(destTomlFile);

            Assert.assertFalse(hasSemanticDiagnostics(outputDirPath.toString(), false));
            Assert.assertEquals(readContent(expectedStubFilePath.toString()),
                    readContent(actualStubFilePath.toString()));
        }
    }

    public static void assertGeneratedDataTypeSourcesNegative(String subDir, String protoFile,
                                                              String stubFile, String outputDir) {
        Path protoFilePath = Paths.get(RESOURCE_DIRECTORY.toString(), PROTO_FILE_DIRECTORY, subDir, protoFile);
        Path outputDirPath = Paths.get(GENERATED_SOURCES_DIRECTORY, outputDir);
        Path actualStubFilePath = Paths.get(outputDirPath.toString(), stubFile);

        generateSourceCode(protoFilePath.toString(), outputDirPath.toString(), null, null);
        Assert.assertFalse(Files.exists(actualStubFilePath));
    }

    public static void generateSourceCode(String sProtoFilePath, String sOutputDirPath,
                                          Object mode, Object sImportDirPath) {

        Class<?> grpcCmdClass;
        try {
            grpcCmdClass = Class.forName("io.ballerina.stdlib.grpc.protobuf.cmd.GrpcCmd");
            GrpcCmd grpcCmd = (GrpcCmd) grpcCmdClass.getDeclaredConstructor().newInstance();
            Path protoFilePath = Paths.get(sProtoFilePath);
            grpcCmd.setProtoPath(protoFilePath.toAbsolutePath().toString());
            if (!sOutputDirPath.isBlank()) {
                Path outputDirPath = Paths.get(sOutputDirPath);
                grpcCmd.setBalOutPath(outputDirPath.toAbsolutePath().toString());
            }
            if (mode instanceof String) {
                grpcCmd.setMode((String) mode);
            }
            if (sImportDirPath instanceof String) {
                Path importPath = Paths.get((String) sImportDirPath);
                grpcCmd.setImportPath(importPath.toAbsolutePath().toString());
            }
            grpcCmd.execute();
        } catch (ClassNotFoundException | IllegalAccessException | InstantiationException |
                NoSuchMethodException | InvocationTargetException e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean hasSemanticDiagnostics(String projectPath, boolean isSingleFile) {
        Package currentPackage;
        if (isSingleFile) {
            SingleFileProject singleFileProject = SingleFileProject.load(getEnvironmentBuilder(),
                    Paths.get(projectPath));
            currentPackage = singleFileProject.currentPackage();
        } else {
            BuildProject buildProject = BuildProject.load(getEnvironmentBuilder(), Paths.get(projectPath));
            currentPackage = buildProject.currentPackage();
        }
        PackageCompilation compilation = currentPackage.getCompilation();
        DiagnosticResult diagnosticResult = compilation.diagnosticResult();
        return diagnosticResult.hasErrors();
    }

    public static boolean hasSyntacticDiagnostics(String filePath) {
        String content;
        Path path = Paths.get(filePath).toAbsolutePath();
        try {
            content = Files.readString(path);
        } catch (IOException e) {
            return false;
        }
        TextDocument textDocument = TextDocuments.from(content);
        return SyntaxTree.from(textDocument).hasDiagnostics();
    }

    public static String readContent(String filePath) {
        Path path = Paths.get(filePath);
        String content;
        try {
            content = Files.readString(path);
        } catch (IOException e) {
            return "";
        }
        return content.replaceAll("\\s+", "");
    }

    public static void copyBallerinaToml(Path destTomlPath) {
        try {
            Files.copy(BALLERINA_TOML_PATH, destTomlPath, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
