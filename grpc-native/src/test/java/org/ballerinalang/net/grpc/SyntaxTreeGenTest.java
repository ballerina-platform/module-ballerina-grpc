package org.ballerinalang.net.grpc;

import org.ballerinalang.net.grpc.protobuf.cmd.GrpcCmd;
import org.testng.Assert;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Tests Syntax tree generation.
 *
 * @since 0.8.0
 */
public class SyntaxTreeGenTest {

    private static final Path RES_DIR = Paths.get("src/test/resources/input/").toAbsolutePath();
    private Path tempDir;

    @BeforeMethod
    public void setup() throws IOException {
        this.tempDir = Files.createTempDirectory("syntax-tree-gen-" + System.nanoTime());
    }

    @Test(description = "Generate syntax tree")
    public void testHelloWorld() {
        Path protoFilePath = RES_DIR.resolve("helloWorld.proto");
        Path outputDirPath = tempDir.resolve("stubs");
        generateSourceCode(protoFilePath.toString(), outputDirPath.toString(), "");

        Assert.assertTrue(Files.exists(outputDirPath.resolve("helloWorld_pb.bal")));
    }

    private static void generateSourceCode(String sProtoFilePath, String sOutputDirPath, String mode) {

        Class<?> grpcCmdClass;
        try {
            grpcCmdClass = Class.forName("org.ballerinalang.net.grpc.protobuf.cmd.GrpcCmd");
            GrpcCmd grpcCmd = (GrpcCmd) grpcCmdClass.newInstance();
            Path protoFilePath = Paths.get(sProtoFilePath);
            Path outputDirPath = Paths.get(sOutputDirPath);
            grpcCmd.setBalOutPath(outputDirPath.toAbsolutePath().toString());
            grpcCmd.setProtoPath(protoFilePath.toAbsolutePath().toString());
            if (!mode.equals("")) {
                grpcCmd.setMode(mode);
            }
            grpcCmd.execute();
        } catch (ClassNotFoundException | IllegalAccessException | InstantiationException e) {
            throw new RuntimeException(e);
        }
    }
}
