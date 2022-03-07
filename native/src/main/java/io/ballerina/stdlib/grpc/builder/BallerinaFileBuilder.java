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
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;

/**
 * Class is responsible of generating the ballerina stub which is mapping proto definition.
 */
public class BallerinaFileBuilder {
    private byte[] rootDescriptor;
    private final Set<byte[]> dependentDescriptors;
    private String balOutPath;

    // Proto file extension
    private static final String PROTO_FILE_EXTENSION = ".proto";
    public static Map<String, String> enumDefaultValueMap = new HashMap<>();
    public static Map<String, Boolean> dependentValueTypeMap = new HashMap<>();
    public static Map<String, Class> streamClassMap;
    public static Map<String, List<String>> unusedImports;

    public BallerinaFileBuilder(byte[] rootDescriptor, Set<byte[]> dependentDescriptors) {
        setRootDescriptor(rootDescriptor);
        this.dependentDescriptors = dependentDescriptors;
        streamClassMap = new HashMap<>();
    }

    public BallerinaFileBuilder(byte[] rootDescriptor, Set<byte[]> dependentDescriptors, String balOutPath) {
        setRootDescriptor(rootDescriptor);
        this.dependentDescriptors = dependentDescriptors;
        this.balOutPath = balOutPath;
        streamClassMap = new HashMap<>();
    }

    public void build(String mode, Map<String, List<String>> unusedImports) throws CodeBuilderException {
        BallerinaFileBuilder.unusedImports = unusedImports;
        // compute dependent descriptor source code.
        for (byte[] descriptorData : dependentDescriptors) {
            computeSourceContent(descriptorData, null, false);
        }
        // compute root descriptor source code.
        computeSourceContent(rootDescriptor, mode, true);
    }

    private void computeSourceContent(byte[] descriptor, String mode, boolean isRoot) throws CodeBuilderException {
        try (InputStream targetStream = new ByteArrayInputStream(descriptor)) {
            // define extension register and register custom option
            ExtensionRegistry extensionRegistry = ExtensionRegistry.newInstance();
            AnnotationsProto.registerAllExtensions(extensionRegistry);
            DescriptorProtos.FileDescriptorProto fileDescriptorSet = DescriptorProtos.FileDescriptorProto
                    .parseFrom(targetStream, extensionRegistry);

            if (fileDescriptorSet.getPackage().contains(BalGenConstants.GOOGLE_STANDARD_LIB) ||
                    fileDescriptorSet.getPackage().contains(BalGenConstants.GOOGLE_API_LIB)) {
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

            if (descriptor == rootDescriptor || serviceDescriptorList.size() > 0) {
                // Add root descriptor.
                Descriptor rootDesc = Descriptor.newBuilder(descriptor).build();
                stubRootDescriptor = rootDesc.getData();
                descriptors.add(rootDesc);

                // Add dependent descriptors.
                for (byte[] descriptorData : dependentDescriptors) {
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
            if (this.balOutPath == null) {
                this.balOutPath = StringUtils.isNotBlank(fileDescriptorSet.getPackage()) ?
                        fileDescriptorSet.getPackage().replace(BalGenConstants.PACKAGE_SEPARATOR,
                                BalGenConstants.FILE_SEPARATOR) : BalGenConstants.DEFAULT_PACKAGE;
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
                        methodID = filePackage + BalGenConstants.PACKAGE_SEPARATOR + serviceDescriptor.getName() + "/" +
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
            String stubFilePath = generateOutputFile(this.balOutPath,
                    filename + BalGenConstants.STUB_FILE_PREFIX);
            writeOutputFile(SyntaxTreeGenerator.generateSyntaxTree(stubFileObject, isRoot), stubFilePath);
        } catch (IOException e) {
            throw new CodeBuilderException("IO Error which reading proto file descriptor. " + e.getMessage(), e);
        }
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
     * @param syntaxTree   Syntax tree object representing the stub file
     * @param outPath      Destination path for writing the resulting source file
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

    private void setRootDescriptor(byte[] rootDescriptor) {
        this.rootDescriptor = Arrays.copyOf(rootDescriptor, rootDescriptor.length);
    }
}
