/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package io.ballerina.stdlib.grpc.builder;

import com.google.api.AnnotationsProto;
import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.ExtensionRegistry;
import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.projects.TomlDocument;
import io.ballerina.stdlib.grpc.builder.balgen.BalGenConstants;
import io.ballerina.stdlib.grpc.builder.stub.Descriptor;
import io.ballerina.stdlib.grpc.builder.stub.EnumMessage;
import io.ballerina.stdlib.grpc.builder.stub.Message;
import io.ballerina.stdlib.grpc.builder.stub.Method;
import io.ballerina.stdlib.grpc.builder.stub.ServiceFile;
import io.ballerina.stdlib.grpc.builder.stub.ServiceStub;
import io.ballerina.stdlib.grpc.builder.stub.StubFile;
import io.ballerina.stdlib.grpc.builder.syntaxtree.SyntaxTreeGenerator;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Class;
import io.ballerina.stdlib.grpc.exception.CodeBuilderException;
import io.ballerina.stdlib.grpc.protobuf.descriptor.DescriptorMeta;
import io.ballerina.stdlib.grpc.protobuf.exception.CodeGeneratorException;
import io.ballerina.toml.api.Toml;
import io.ballerina.toml.semantic.ast.TomlValueNode;
import org.apache.commons.lang3.StringUtils;
import org.ballerinalang.formatter.core.Formatter;
import org.ballerinalang.formatter.core.FormatterException;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;

import static io.ballerina.stdlib.grpc.builder.balgen.BalGenConstants.BALLERINA_STANDARD_LIB;
import static io.ballerina.stdlib.grpc.builder.balgen.BalGenConstants.BALLERINA_TOML_FILE_NAME;
import static io.ballerina.stdlib.grpc.builder.balgen.BalGenConstants.DEFAULT_PACKAGE;
import static io.ballerina.stdlib.grpc.builder.balgen.BalGenConstants.FILE_SEPARATOR;
import static io.ballerina.stdlib.grpc.builder.balgen.BalGenConstants.GOOGLE_API_LIB;
import static io.ballerina.stdlib.grpc.builder.balgen.BalGenConstants.GOOGLE_STANDARD_LIB;
import static io.ballerina.stdlib.grpc.builder.balgen.BalGenConstants.PACKAGE_SEPARATOR;
import static io.ballerina.stdlib.grpc.protobuf.utils.BalFileGenerationUtils.delete;
import static io.ballerina.stdlib.grpc.protobuf.utils.BalFileGenerationUtils.handleProcessExecutionErrors;
import static io.ballerina.stdlib.grpc.protobuf.utils.BalFileGenerationUtils.runProcess;

/**
 * Class is responsible of generating the ballerina stub which is mapping proto definition.
 */
public class BallerinaFileBuilder {

    private final DescriptorMeta rootDescriptor;
    private final Set<DescriptorMeta> dependentDescriptors;
    private String balOutPath;
    private Optional<String> currentPackageName;

    // Proto file extension
    private static final String PROTO_FILE_EXTENSION = ".proto";
    private static final int EXTENSION = 1148;
    public static Map<String, String> enumDefaultValueMap = new HashMap<>();
    public static Map<String, Boolean> dependentValueTypeMap;
    // Contains the filename and its related module name
    public static Map<String, String> protofileModuleMap;
    // Contains the related module names of all the records, context records and enums
    public static Map<String, String> componentsModuleMap;
    public static Map<String, Class> streamClassMap;

    public BallerinaFileBuilder(DescriptorMeta rootDescriptor, Set<DescriptorMeta> dependentDescriptors) {
        this.rootDescriptor = rootDescriptor;
        this.dependentDescriptors = dependentDescriptors;
        streamClassMap = new HashMap<>();
        currentPackageName = Optional.empty();
        dependentValueTypeMap = new HashMap<>();
        protofileModuleMap = new HashMap<>();
        componentsModuleMap = new HashMap<>();
    }

    public BallerinaFileBuilder(DescriptorMeta rootDescriptor, Set<DescriptorMeta> dependentDescriptors,
                                String balOutPath) throws IOException {
        this.rootDescriptor = rootDescriptor;
        this.dependentDescriptors = dependentDescriptors;
        this.balOutPath = balOutPath;
        streamClassMap = new HashMap<>();
        currentPackageName = Optional.ofNullable(getExistingPackageName(this.balOutPath));
        dependentValueTypeMap = new HashMap<>();
        protofileModuleMap = new HashMap<>();
        componentsModuleMap = new HashMap<>();
    }

    public void build(String mode) throws CodeBuilderException, CodeGeneratorException {
        // compute dependent descriptor source code.
        for (byte[] descriptorData : getDependentDescriptorSet(dependentDescriptors)) {
            computeSourceContent(descriptorData, null, false);
        }
        // compute root descriptor source code.
        computeSourceContent(rootDescriptor.getDescriptor(), mode, true);
    }

    private void computeSourceContent(byte[] descriptor, String mode, boolean isRoot) throws CodeBuilderException,
            CodeGeneratorException {
        Map<String, List<String>> unusedImports = new HashMap<>();
        if (rootDescriptor.getUnusedImports().size() > 0) {
            unusedImports.put(rootDescriptor.getProtoName(), rootDescriptor.getUnusedImports());
        }
        unusedImports.putAll(getUnusedImportsInDependentDescriptorSet(dependentDescriptors));

        try (InputStream targetStream = new ByteArrayInputStream(descriptor)) {
            // define extension register and register custom option
            ExtensionRegistry extensionRegistry = ExtensionRegistry.newInstance();
            AnnotationsProto.registerAllExtensions(extensionRegistry);
            DescriptorProtos.FileDescriptorProto fileDescriptorSet = DescriptorProtos.FileDescriptorProto
                    .parseFrom(targetStream, extensionRegistry);

            if (fileDescriptorSet.getPackage().contains(GOOGLE_STANDARD_LIB) ||
                    fileDescriptorSet.getPackage().contains(GOOGLE_API_LIB) ||
                    fileDescriptorSet.getPackage().contains(BALLERINA_STANDARD_LIB)) {
                return;
            }
            List<DescriptorProtos.ServiceDescriptorProto> serviceDescriptorList = fileDescriptorSet.getServiceList();
            List<DescriptorProtos.DescriptorProto> messageTypeList = fileDescriptorSet.getMessageTypeList();
            List<DescriptorProtos.EnumDescriptorProto> enumDescriptorProtos = fileDescriptorSet.getEnumTypeList();
            List<Message> messageList = new ArrayList<>();
            List<EnumMessage> enumList = new ArrayList<>();
            Set<Descriptor> descriptors = new TreeSet<>((descriptor1, descriptor2) -> {
                if (descriptor1.getKey().equalsIgnoreCase(descriptor2.getKey())) {
                    return 0;
                }
                return 1;
            });
            String stubRootDescriptor = "";
            String filename;
            if (isRoot) {
                File protoFile = new File(fileDescriptorSet.getName());
                filename = protoFile.getName().replace(PROTO_FILE_EXTENSION, "");
            } else {
                filename = fileDescriptorSet.getName().replace(PROTO_FILE_EXTENSION, "")
                        .replace("/", "_");
            }

            String moduleName = getModuleName(fileDescriptorSet);
            if (!moduleName.isEmpty() && Objects.isNull(balOutPath)) {
                // todo: test this (probably not working)
                balOutPath = moduleName;
                currentPackageName = Optional.ofNullable(getExistingPackageName(balOutPath));
            }
            if (!moduleName.isEmpty()) {
                if (currentPackageName.isPresent()) {
                    validateDirectoryWithPackageName(moduleName, currentPackageName.get());
                } else {
                    currentPackageName = Optional.of(createBallerinaPackage(moduleName));
                }
                if (!isRoot) {
                    fileDescriptorSet.getMessageTypeList().forEach(descriptorProto ->
                            componentsModuleMap.put(descriptorProto.getName(), moduleName));
                    fileDescriptorSet.getEnumTypeList().forEach(descriptorProto ->
                            componentsModuleMap.put(descriptorProto.getName(), moduleName));
                }
                protofileModuleMap.put(filename, moduleName);
            }
            String filePackage = fileDescriptorSet.getPackage();
            StubFile stubFileObject = new StubFile(filename);

            // Add imports
            for (String protobufImport : fileDescriptorSet.getDependencyList()) {
                if (unusedImports.containsKey(fileDescriptorSet.getName())) {
                    if (!unusedImports.get(fileDescriptorSet.getName()).contains(protobufImport)) {
                        stubFileObject.addImport(protobufImport);
                    }
                } else {
                    stubFileObject.addImport(protobufImport);
                }
            }

            if (descriptor == rootDescriptor.getDescriptor() || serviceDescriptorList.size() > 0) {
                // Add root descriptor.
                Descriptor rootDesc = Descriptor.newBuilder(descriptor).build();
                stubRootDescriptor = rootDesc.getData();
                descriptors.add(rootDesc);

                // Add dependent descriptors.
                for (byte[] descriptorData : getDependentDescriptorSet(dependentDescriptors)) {
                    Descriptor dependentDescriptor = Descriptor.newBuilder(descriptorData).build();
                    descriptors.add(dependentDescriptor);
                }
            }

            // read enum types.
            for (DescriptorProtos.EnumDescriptorProto descriptorProto : enumDescriptorProtos) {
                EnumMessage enumMessage = EnumMessage.newBuilder(descriptorProto).build();
                enumList.add(enumMessage);
            }

            // read message types.
            for (DescriptorProtos.DescriptorProto descriptorProto : messageTypeList) {
                Message message = Message.newBuilder(descriptorProto, filePackage).build();
                messageList.add(message);
            }

            // write definition objects to ballerina files.
            if (this.balOutPath == null && moduleName.isEmpty()) {
                this.balOutPath = StringUtils.isNotBlank(filePackage) ?
                        filePackage.replace(PACKAGE_SEPARATOR, FILE_SEPARATOR) : DEFAULT_PACKAGE;
            }

            // update message types in stub file object
            stubFileObject.setMessageMap(messageList.stream().collect(Collectors.toMap(Message::getMessageName,
                    message -> message)));

            for (DescriptorProtos.ServiceDescriptorProto serviceDescriptor : serviceDescriptorList) {
                ServiceStub.Builder serviceStubBuilder = ServiceStub.newBuilder(serviceDescriptor.getName());
                ServiceFile.Builder sampleServiceBuilder = ServiceFile.newBuilder(serviceDescriptor.getName());
                List<DescriptorProtos.MethodDescriptorProto> methodList = serviceDescriptor.getMethodList();

                for (DescriptorProtos.MethodDescriptorProto methodDescriptorProto : methodList) {
                    String methodID;
                    if (!filePackage.isEmpty()) {
                        methodID = filePackage + PACKAGE_SEPARATOR + serviceDescriptor.getName() + "/" +
                                methodDescriptorProto.getName();
                    } else {
                        methodID = serviceDescriptor.getName() + "/" + methodDescriptorProto.getName();
                    }

                    Method method = Method.newBuilder(methodID).setMethodDescriptor(methodDescriptorProto).
                            setMessageMap(stubFileObject.getMessageMap()).build();
                    serviceStubBuilder.addMethod(method);
                    sampleServiceBuilder.addMethod(method);
                }
                ServiceStub serviceStub = serviceStubBuilder.build();
                stubFileObject.addServiceStub(serviceStub);
                if (!isRoot) {
                    dependentValueTypeMap.putAll(serviceStub.getValueTypeMap());
                }
            }
            // update enum message types in stub file object
            stubFileObject.setEnumList(enumList);
            // update descriptors in stub file object
            stubFileObject.setDescriptors(descriptors);
            if (!stubRootDescriptor.isEmpty()) {
                stubFileObject.setRootDescriptor(stubRootDescriptor);
            }

            int serviceIndex = 0;
            for (ServiceStub serviceStub : stubFileObject.getStubList()) {
                if (BalGenConstants.GRPC_SERVICE.equals(mode)) {
                    String serviceFilePath = generateOutputFile(this.balOutPath,
                            serviceStub.getServiceName().toLowerCase() +
                                    BalGenConstants.SAMPLE_SERVICE_FILE_PREFIX);
                    writeOutputFile(
                            SyntaxTreeGenerator.generateSyntaxTreeForServiceSample(
                                    serviceStub,
                                    serviceIndex == 0,
                                    stubFileObject.getFileName()
                            ),
                            serviceFilePath
                    );
                } else if (BalGenConstants.GRPC_CLIENT.equals(mode)) {
                    String clientFilePath = generateOutputFile(this.balOutPath,
                            serviceStub.getServiceName().toLowerCase() + BalGenConstants.SAMPLE_FILE_PREFIX
                    );
                    writeOutputFile(SyntaxTreeGenerator.generateSyntaxTreeForClientSample(serviceStub), clientFilePath);
                }
                serviceIndex++;
            }
            String stubFilePath;
            if (moduleName.contains(PACKAGE_SEPARATOR)) {
                stubFilePath = generateOutputFile(this.balOutPath,
                        "modules/" + moduleName.substring(moduleName.indexOf(PACKAGE_SEPARATOR) + 1) + "/" +
                                filename + BalGenConstants.STUB_FILE_PREFIX);
            } else {
                stubFilePath = generateOutputFile(this.balOutPath, filename + BalGenConstants.STUB_FILE_PREFIX);
            }
            writeOutputFile(SyntaxTreeGenerator.generateSyntaxTree(stubFileObject, isRoot), stubFilePath);
        } catch (IOException e) {
            throw new CodeBuilderException("IO Error while reading proto file descriptor. " + e.getMessage(), e);
        }
    }

    private void validateDirectoryWithPackageName(String moduleName, String currentPackageName)
            throws CodeBuilderException {
        if (!moduleName.equals(currentPackageName) && !moduleName.startsWith(currentPackageName + PACKAGE_SEPARATOR)) {
            throw new CodeBuilderException("Ballerina package name does not match with the " +
                    "given package name in the proto file");
        }
    }

    private String getExistingPackageName(String packagePath) throws IOException {
        File ballerinaTomlFile = new File(packagePath, FILE_SEPARATOR + BALLERINA_TOML_FILE_NAME);
        if (ballerinaTomlFile.isFile()) {
            String content = new String(Files.readAllBytes(Paths.get(ballerinaTomlFile.getPath())));
            TomlDocument ballerinaToml = TomlDocument.from(BALLERINA_TOML_FILE_NAME, content);
            Optional<Toml> packageTable = ballerinaToml.toml().getTable("package");
            if (packageTable.isPresent()) {
                Optional<TomlValueNode> packageNameToml = packageTable.get().get("name");
                if (packageNameToml.isPresent()) {
                    return packageNameToml.get().toNativeValue().toString();
                }
            }
            return ballerinaTomlFile.getParentFile().getName();
        }
        return null;
    }

    private String createBallerinaPackage(String packageName) throws CodeGeneratorException, IOException {
        if (packageName.contains(PACKAGE_SEPARATOR)) {
            packageName = packageName.substring(0, packageName.indexOf(PACKAGE_SEPARATOR));
        }
        Files.createDirectories(Paths.get(balOutPath));
        File ballerinaDir = new File(balOutPath + FILE_SEPARATOR + packageName);
        if (!ballerinaDir.isDirectory()) {
            runBalNewProcess(packageName);
        }
        balOutPath = balOutPath + FILE_SEPARATOR + packageName;
        delete(new File(balOutPath + FILE_SEPARATOR + "main.bal"));
        return packageName;
    }

    private void runBalNewProcess(String packageName) throws IOException, CodeGeneratorException {
        Process balNewProcess = runProcess("cd " + balOutPath + " && bal new " + packageName);
        try {
            balNewProcess.waitFor();
        } catch (InterruptedException e) {
            throw new CodeGeneratorException("Failed to create a new Ballerina module. " + e.getMessage(), e);
        }
        handleProcessExecutionErrors(balNewProcess);
    }

    private String getModuleName(DescriptorProtos.FileDescriptorProto fileDescriptorSet) {
        if (!fileDescriptorSet.getOptions().getUnknownFields().hasField(EXTENSION)) {
            return "";
        }
        return fileDescriptorSet.getOptions().getUnknownFields().getField(EXTENSION)
                .getLengthDelimitedList().get(0).toStringUtf8();
    }

    private String generateOutputFile(String outputDir, String fileName) throws CodeBuilderException {
        try {
            Files.createDirectories(Paths.get(outputDir, fileName).getParent());
            File file = new File(outputDir, fileName);

            if (!file.isFile()) {
                Files.createFile(Paths.get(file.getAbsolutePath()));
            }
            return file.getAbsolutePath();
        } catch (IOException e) {
            throw new CodeBuilderException("IO Error while creating output Ballerina files. " + e.getMessage(), e);
        }
    }

    /**
     * Write ballerina definition of a <code>syntaxTree</code> to a file.
     *
     * @param syntaxTree Syntax tree object representing the stub file
     * @param outPath    Destination path for writing the resulting source file
     * @throws CodeBuilderException when file operations fail
     */
    private static void writeOutputFile(SyntaxTree syntaxTree, String outPath)
            throws CodeBuilderException {
        String content;
        try {
            content = Formatter.format(syntaxTree.toSourceCode());
        } catch (FormatterException e) {
            throw new CodeBuilderException("Formatter Error while formatting output source code. " + e.getMessage(), e);
        }
        try (PrintWriter writer = new PrintWriter(outPath, StandardCharsets.UTF_8.name())) {
            writer.println(content);
        } catch (IOException e) {
            throw new CodeBuilderException("IO Error while writing output to Ballerina file. " + e.getMessage(), e);
        }
    }

    private Set<byte[]> getDependentDescriptorSet(Set<DescriptorMeta> descriptorMetaSet) {
        Set<byte[]> dependentDescriptorSet = new HashSet<>();
        for (DescriptorMeta descriptorMeta : descriptorMetaSet) {
            dependentDescriptorSet.add(descriptorMeta.getDescriptor());
        }
        return dependentDescriptorSet;
    }

    private Map<String, List<String>> getUnusedImportsInDependentDescriptorSet(Set<DescriptorMeta> descriptorMetaSet) {
        Map<String, List<String>> unusedImports = new HashMap<>();
        for (DescriptorMeta descriptorMeta : descriptorMetaSet) {
            if (descriptorMeta.getUnusedImports().size() > 0) {
                unusedImports.put(descriptorMeta.getProtoName(), descriptorMeta.getUnusedImports());
            }
        }
        return unusedImports;
    }
}
