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
package org.ballerinalang.net.grpc.builder;

import com.google.api.AnnotationsProto;
import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.ExtensionRegistry;
import io.ballerina.compiler.syntax.tree.SyntaxTree;
import org.apache.commons.lang3.StringUtils;
import org.ballerinalang.formatter.core.Formatter;
import org.ballerinalang.formatter.core.FormatterException;
import org.ballerinalang.net.grpc.builder.balgen.BalGenConstants;
import org.ballerinalang.net.grpc.builder.stub.Descriptor;
import org.ballerinalang.net.grpc.builder.stub.EnumMessage;
import org.ballerinalang.net.grpc.builder.stub.Message;
import org.ballerinalang.net.grpc.builder.stub.Method;
import org.ballerinalang.net.grpc.builder.stub.ServiceFile;
import org.ballerinalang.net.grpc.builder.stub.ServiceStub;
import org.ballerinalang.net.grpc.builder.stub.StubFile;
import org.ballerinalang.net.grpc.builder.syntaxtree.SyntaxTreeGenerator;
import org.ballerinalang.net.grpc.exception.CodeBuilderException;

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

import static org.ballerinalang.net.grpc.StandardDescriptorBuilder.EMPTY_PROTO_PACKAGE_KEY;
import static org.ballerinalang.net.grpc.StandardDescriptorBuilder.getFileDescriptor;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.EMPTY_DATA_TYPE;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.FILE_SEPARATOR;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.GOOGLE_API_LIB;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.GOOGLE_STANDARD_LIB;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.GRPC_CLIENT;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.GRPC_SERVICE;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.PACKAGE_SEPARATOR;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.SAMPLE_FILE_PREFIX;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.SAMPLE_SERVICE_FILE_PREFIX;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.STUB_FILE_PREFIX;

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

    public BallerinaFileBuilder(byte[] rootDescriptor, Set<byte[]> dependentDescriptors) {
        setRootDescriptor(rootDescriptor);
        this.dependentDescriptors = dependentDescriptors;
    }

    public BallerinaFileBuilder(byte[] rootDescriptor, Set<byte[]> dependentDescriptors, String balOutPath) {
        setRootDescriptor(rootDescriptor);
        this.dependentDescriptors = dependentDescriptors;
        this.balOutPath = balOutPath;
    }

    public void build(String mode) throws CodeBuilderException {
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

            if (fileDescriptorSet.getPackage().contains(GOOGLE_STANDARD_LIB) ||
                    fileDescriptorSet.getPackage().contains(GOOGLE_API_LIB)) {
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
            String filename = fileDescriptorSet.getName().replace(PROTO_FILE_EXTENSION, "");
            String filePackage = fileDescriptorSet.getPackage();
            StubFile stubFileObject = new StubFile(filename);

            if (descriptor == rootDescriptor) {
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
                Message message = Message.newBuilder(descriptorProto).build();
                messageList.add(message);
            }

            // write definition objects to ballerina files.
            if (this.balOutPath == null) {
                this.balOutPath = StringUtils.isNotBlank(fileDescriptorSet.getPackage()) ?
                        fileDescriptorSet.getPackage().replace(PACKAGE_SEPARATOR, FILE_SEPARATOR) : BalGenConstants
                        .DEFAULT_PACKAGE;
            }

            boolean hasEmptyMessage = false;
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

                    if (method.containsEmptyType() && !(stubFileObject.isMessageExists(EMPTY_DATA_TYPE))
                            && !hasEmptyMessage) {
                        Message message =
                                Message.newBuilder(getFileDescriptor(EMPTY_PROTO_PACKAGE_KEY).getMessageTypes().get(0)
                                        .toProto()).build();
                        messageList.add(message);
                        stubFileObject.addMessage(message);
                        hasEmptyMessage = true;
                    }
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
                if (GRPC_SERVICE.equals(mode)) {
                    String serviceFilePath = generateOutputFile(this.balOutPath, serviceStub.getServiceName() +
                            SAMPLE_SERVICE_FILE_PREFIX);
                    writeOutputFile(SyntaxTreeGenerator.generateSyntaxTreeForServiceSample(serviceStub,
                            serviceIndex == 0), serviceFilePath);
                } else if (GRPC_CLIENT.equals(mode)) {
                    String clientFilePath = generateOutputFile(this.balOutPath,
                            serviceStub.getServiceName() + SAMPLE_FILE_PREFIX
                    );
                    writeOutputFile(SyntaxTreeGenerator.generateSyntaxTreeForClientSample(serviceStub), clientFilePath);
                }
                serviceIndex++;
            }
            String stubFilePath = generateOutputFile(this.balOutPath, filename + STUB_FILE_PREFIX);
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
        this.rootDescriptor = new byte[rootDescriptor.length];
        this.rootDescriptor = Arrays.copyOf(rootDescriptor, rootDescriptor.length);
    }
}
