/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package io.ballerina.stdlib.grpc.protobuf.cmd;

import com.google.protobuf.DescriptorProtos;
import io.ballerina.stdlib.grpc.protobuf.BalGenerationConstants;
import io.ballerina.stdlib.grpc.protobuf.descriptor.DescriptorMeta;
import io.ballerina.stdlib.grpc.protobuf.exception.CodeGeneratorException;
import io.ballerina.stdlib.grpc.protobuf.utils.BalFileGenerationUtils;
import io.ballerina.stdlib.grpc.protobuf.utils.ProtocCommandBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Class for generate file descriptors for proto files.
 */
class DescriptorsGenerator {

    private static final Logger LOG = LoggerFactory.getLogger(DescriptorsGenerator.class);
    private static final PrintStream outStream = System.out;

    static Set<DescriptorMeta> generateDependentDescriptor(String exePath, String protoFolderPath, String
            rootDescriptorPath) throws CodeGeneratorException {

        Set<DescriptorMeta> dependentDescSet = new HashSet<>();
        File tempDir = new File(BalGenerationConstants.TMP_DIRECTORY_PATH);
        File initialFile = new File(rootDescriptorPath);
        try (InputStream targetStream = new FileInputStream(initialFile)) {
            DescriptorProtos.FileDescriptorSet descSet = DescriptorProtos.FileDescriptorSet.parseFrom(targetStream);
            String originalProtoFolderPath = protoFolderPath;
            for (String dependentFilePath : descSet.getFile(0).getDependencyList()) {
                protoFolderPath = originalProtoFolderPath;
                if (BalFileGenerationUtils.isWindows()) {
                    dependentFilePath = dependentFilePath.replaceAll("/", "\\\\");
                }
                Path protoFilePath = Paths.get(dependentFilePath).getFileName();
                if (protoFilePath == null) {
                    throw new CodeGeneratorException("Error occurred while reading proto descriptor. Dependent " +
                            "filepath is not defined properly. Filepath: " + dependentFilePath);
                }
                String protoFilename = protoFilePath.toString();
                String descFilename = protoFilename.endsWith(BalGenerationConstants.PROTO_SUFFIX) ?
                        protoFilename.replace(BalGenerationConstants.PROTO_SUFFIX, BalGenerationConstants.DESC_SUFFIX)
                        : null;
                if (descFilename == null) {
                    throw new CodeGeneratorException("Error occurred while reading proto descriptor. Dependent " +
                            "filepath is not defined properly. Filepath: " + dependentFilePath);
                }
                // desc file path: desc_gen/dependencies + <filename>.desc
                String relativeDescFilepath = BalGenerationConstants.META_DEPENDENCY_LOCATION + descFilename;

                File dependentDescFile = new File(tempDir, relativeDescFilepath);
                boolean isDirectoryCreated = dependentDescFile.getParentFile().mkdirs();
                if (!isDirectoryCreated) {
                    LOG.debug("Parent directories didn't create for the file '" + relativeDescFilepath);
                }
                //Derive proto file path of the dependent library.
                String protoPath;
                if (!dependentFilePath.contains(BalGenerationConstants.GOOGLE_STANDARD_LIB_PROTOBUF) &&
                        !dependentFilePath.contains(BalGenerationConstants.GOOGLE_STANDARD_LIB_API)) {
                    protoPath = new File(protoFolderPath, dependentFilePath).getAbsolutePath();
                } else {
                    protoPath = new File(tempDir, dependentFilePath).getAbsolutePath();
                    protoFolderPath = tempDir.getAbsolutePath();
                }

                String command = new ProtocCommandBuilder(exePath, BalFileGenerationUtils.escapeSpaces(protoPath),
                        BalFileGenerationUtils.escapeSpaces(protoFolderPath),
                        BalFileGenerationUtils.escapeSpaces(dependentDescFile.getAbsolutePath())).build();
                ArrayList<String> protocOutput = BalFileGenerationUtils.generateDescriptor(command);
                File childFile = new File(tempDir, relativeDescFilepath);
                try (InputStream childStream = new FileInputStream(childFile)) {
                    DescriptorProtos.FileDescriptorSet childDescSet = DescriptorProtos.FileDescriptorSet
                            .parseFrom(childStream);
                    if (childDescSet.getFile(0).getDependencyCount() != 0) {
                        Set<DescriptorMeta> childList = generateDependentDescriptor(exePath, protoFolderPath,
                                childFile.getAbsolutePath());
                        dependentDescSet.addAll(childList);
                    }
                    byte[] dependentDesc = childDescSet.getFile(0).toByteArray();
                    if (dependentDesc.length == 0) {
                        throw new CodeGeneratorException("Error occurred at generating dependent proto " +
                                "descriptor for dependent proto '" + relativeDescFilepath + "'.");
                    }
                    dependentDescSet.add(new DescriptorMeta(BalFileGenerationUtils.escapeSpaces(protoPath),
                            dependentDesc, getUnusedImports(protocOutput)));
                } catch (IOException e) {
                    throw new CodeGeneratorException("Error extracting dependent bal. " + e.getMessage(), e);
                }
            }
        } catch (IOException e) {
            throw new CodeGeneratorException("Error parsing descriptor file " + initialFile + ". " + e.getMessage(), e);
        }
        return dependentDescSet;
    }

    /**
     * Generate proto file and convert it to byte array.
     *
     * @param exePath        protoc executor path
     * @param protoPath      .proto file path
     * @param protoFolderPath      path to the import directives
     * @param descriptorPath file descriptor path.
     * @return byte array of generated proto file.
     */
    static DescriptorMeta generateRootDescriptor(String exePath, String protoPath, String protoFolderPath,
                                                 String descriptorPath)
            throws CodeGeneratorException {

        String command = new ProtocCommandBuilder(
                exePath,
                BalFileGenerationUtils.escapeSpaces(protoPath),
                BalFileGenerationUtils.escapeSpaces(protoFolderPath),
                BalFileGenerationUtils.escapeSpaces(descriptorPath)
        ).build();
        ArrayList<String> protocOutput = BalFileGenerationUtils.generateDescriptor(command);
        File initialFile = new File(descriptorPath);
        try (InputStream targetStream = new FileInputStream(initialFile)) {
            DescriptorProtos.FileDescriptorSet set = DescriptorProtos.FileDescriptorSet.parseFrom(targetStream);
            if (set.getFileList().size() > 0) {
                return new DescriptorMeta(protoPath, set.getFile(0).toByteArray(), getUnusedImports(protocOutput));
            }
        } catch (IOException e) {
            throw new CodeGeneratorException("Error reading generated descriptor file '"
                    + descriptorPath + "'. " + e.getMessage(), e);
        }
        return new DescriptorMeta(protoPath, null, getUnusedImports(protocOutput));
    }

    private static List<String> getUnusedImports(ArrayList<String> protocOutput) {
        List<String> unusedImportList = new ArrayList<>();
        for (String line : protocOutput) {
            if (line.contains("warning: Import ") && line.contains(" but not used.")) {
                unusedImportList.add((line.split("warning: Import ")[1]).split(" but not used.")[0]);
                outStream.println(line);
            }
        }
        return unusedImportList;
    }
}
