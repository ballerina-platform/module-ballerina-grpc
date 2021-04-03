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

import com.github.jknack.handlebars.Handlebars;
import com.github.jknack.handlebars.Template;
import com.github.jknack.handlebars.helper.StringHelpers;
import com.github.jknack.handlebars.io.ClassPathTemplateLoader;
import com.github.jknack.handlebars.io.FileTemplateLoader;
import com.google.api.AnnotationsProto;
import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.ExtensionRegistry;
import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.tools.text.TextDocument;
import io.ballerina.tools.text.TextDocuments;
import org.apache.commons.lang3.StringUtils;
import org.ballerinalang.formatter.core.Formatter;
import org.ballerinalang.formatter.core.FormatterException;
import org.ballerinalang.net.grpc.builder.stub.Descriptor;
import org.ballerinalang.net.grpc.builder.stub.EnumMessage;
import org.ballerinalang.net.grpc.builder.stub.Message;
import org.ballerinalang.net.grpc.builder.stub.Method;
import org.ballerinalang.net.grpc.builder.stub.ServiceFile;
import org.ballerinalang.net.grpc.builder.stub.ServiceStub;
import org.ballerinalang.net.grpc.builder.stub.StubFile;
import org.ballerinalang.net.grpc.builder.balgen.BalGenConstants;
import org.ballerinalang.net.grpc.builder.balgen.BalGenerationUtils;
import org.ballerinalang.net.grpc.builder.syntaxtree.SyntaxTreeGen;
import org.ballerinalang.net.grpc.exception.CodeBuilderException;
import org.ballerinalang.net.grpc.exception.GrpcServerException;
import org.ballerinalang.net.grpc.proto.definition.EmptyMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;

import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.EMPTY_DATA_TYPE;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.FILE_SEPARATOR;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.GOOGLE_API_LIB;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.GOOGLE_STANDARD_LIB;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.GRPC_CLIENT;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.GRPC_SERVICE;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.PACKAGE_SEPARATOR;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.STUB_FILE_PREFIX;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.TEMPLATES_DIR_PATH_KEY;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.TEMPLATES_SUFFIX;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.TEMPLATE_DIR;
import static org.ballerinalang.net.grpc.proto.ServiceProtoConstants.PROTO_FILE_EXTENSION;

/**
 * Class is responsible of generating the ballerina stub which is mapping proto definition.
 */
public class BallerinaFileBuilder {
    public static final Logger LOG = LoggerFactory.getLogger(BallerinaFileBuilder.class);
    private byte[] rootDescriptor;
    private Set<byte[]> dependentDescriptors;
    private String balOutPath;
    private static final Path resourceDirectory = Paths.get("src").resolve("main").resolve("resources").toAbsolutePath();

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
        SyntaxTree treeDemo = syntaxTreeDemo();
        // compute root descriptor source code.
        computeSourceContent(rootDescriptor, mode);
        // compute dependent descriptor source code.
        for (byte[] descriptorData : dependentDescriptors) {
            computeSourceContent(descriptorData, null);
        }
    }

    public static SyntaxTree syntaxTreeDemo() {
        Path sourceFilePath = Paths.get(resourceDirectory.toString(), "helloWorldWithEnum_pb.bal");
        String content = null;
        try {
            content = getSourceText(sourceFilePath);
        } catch (IOException e) {
            // do something
        }
        TextDocument textDocument = TextDocuments.from(content);
        return SyntaxTree.from(textDocument);
    }

    private static String getSourceText(Path sourceFilePath) throws IOException {
        return Files.readString(resourceDirectory.resolve(sourceFilePath));
    }

    private void computeSourceContent(byte[] descriptor, String mode) throws CodeBuilderException {
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
            ServiceFile serviceFile;

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

            // read message types.
            for (DescriptorProtos.DescriptorProto descriptorProto : messageTypeList) {
                Message message = Message.newBuilder(descriptorProto).build();
                messageList.add(message);
            }

            // read enum types.
            for (DescriptorProtos.EnumDescriptorProto descriptorProto : enumDescriptorProtos) {
                EnumMessage enumMessage = EnumMessage.newBuilder(descriptorProto).build();
                enumList.add(enumMessage);
            }

            // write definition objects to ballerina files.
            if (this.balOutPath == null) {
                this.balOutPath = StringUtils.isNotBlank(fileDescriptorSet.getPackage()) ?
                        fileDescriptorSet.getPackage().replace(PACKAGE_SEPARATOR, FILE_SEPARATOR) : BalGenConstants
                        .DEFAULT_PACKAGE;
            }

            boolean hasEmptyMessage = false;
            boolean enableEp = true;
            for (DescriptorProtos.ServiceDescriptorProto serviceDescriptor : serviceDescriptorList) {
                ServiceStub.Builder serviceStubBuilder = ServiceStub.newBuilder(serviceDescriptor.getName());
                ServiceFile.Builder sampleServiceBuilder = ServiceFile.newBuilder(serviceDescriptor.getName());
                List<DescriptorProtos.MethodDescriptorProto> methodList = serviceDescriptor.getMethodList();
//                boolean isUnaryContains = false;
                stubFileObject.setMessageMap(messageList.stream().collect(Collectors.toMap(Message::getMessageName,
                        message -> message)));
                for (DescriptorProtos.MethodDescriptorProto methodDescriptorProto : methodList) {
                    String methodID;
                    if (filePackage != null && !filePackage.isEmpty()) {
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
                        Message message = Message.newBuilder(EmptyMessage.newBuilder().getDescriptor().toProto())
                                .build();
                        messageList.add(message);
                        stubFileObject.addMessage(message);
                        hasEmptyMessage = true;
                    }
                }
                stubFileObject.addServiceStub(serviceStubBuilder.build());
                stubFileObject.setEnumList(enumList);
                stubFileObject.setDescriptors(descriptors);
                if (!stubRootDescriptor.isEmpty()) {
                    stubFileObject.setRootDescriptor(stubRootDescriptor);
                }

                if (GRPC_SERVICE.equals(mode)) {
                    serviceFile = sampleServiceBuilder.build();
                    // Todo: remove
                    serviceFile.setEnableEp(enableEp);
                    if (enableEp) {
                        enableEp = false;
                    }

//                    String servicePath = generateOutputFile(this.balOutPath, serviceDescriptor.getName() +
//                            SAMPLE_SERVICE_FILE_PREFIX);
//                    writeOutputFile(serviceFile, servicePath);

                    String stubFilePath = generateOutputFile(this.balOutPath, filename + STUB_FILE_PREFIX);
                    writeOutputFile(SyntaxTreeGen.generateSyntaxTree(stubFileObject), stubFilePath);
                } else if (GRPC_CLIENT.equals(mode)) {
//                    String clientFilePath = generateOutputFile(
//                            this.balOutPath,
//                            serviceDescriptor.getName() + SAMPLE_FILE_PREFIX
//                    );
//                    writeOutputFile(new ClientFile(serviceDescriptor.getName()),
//                            SAMPLE_CLIENT_TEMPLATE_NAME, clientFilePath);
                    String stubFilePath = generateOutputFile(this.balOutPath, filename + STUB_FILE_PREFIX);
                    writeOutputFile(SyntaxTreeGen.generateSyntaxTree(stubFileObject), stubFilePath);
                } else {
                    // For both client and server sides
                    String stubFilePath = generateOutputFile(this.balOutPath, filename + STUB_FILE_PREFIX);
                    writeOutputFile(SyntaxTreeGen.generateSyntaxTree(stubFileObject), stubFilePath);
                }
            }
        } catch (GrpcServerException e) {
            throw new CodeBuilderException("Message descriptor error. " + e.getMessage());
        } catch (IOException e) {
            throw new CodeBuilderException("IO Error which reading proto file descriptor. " + e.getMessage(), e);
        }
    }

    private String generateOutputFile(String outputDir, String fileName) throws CodeBuilderException {
        try {
            if (outputDir != null) {
                Files.createDirectories(Paths.get(outputDir));
            }
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
        String content = "";
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

    private static Template compileTemplate(String templateName)
            throws CodeBuilderException {
        String templatesDirPath = System.getProperty(TEMPLATES_DIR_PATH_KEY, TEMPLATE_DIR);
        ClassPathTemplateLoader cpTemplateLoader = new ClassPathTemplateLoader((templatesDirPath));
        FileTemplateLoader fileTemplateLoader = new FileTemplateLoader(templatesDirPath);
        cpTemplateLoader.setSuffix(TEMPLATES_SUFFIX);
        fileTemplateLoader.setSuffix(TEMPLATES_SUFFIX);
        // add handlebars with helpers.
        Handlebars handlebars = new Handlebars().with(cpTemplateLoader, fileTemplateLoader);
        handlebars.registerHelpers(StringHelpers.class);
        handlebars.registerHelper("equals", (object, options) -> {
            CharSequence result;
            Object param0 = options.param(0);

            if (param0 == null) {
                throw new IllegalArgumentException("found n'null', expected 'string'");
            }
            if (object != null && object.toString().equals(param0.toString())) {
                result = options.fn(options.context);
            } else {
                result = null;
            }

            return result;
        });
        handlebars.registerHelper("camelcase", (object, options) -> {
            if (object instanceof String) {
                return BalGenerationUtils.toCamelCase((String) object);
            }
            return "";
        });
        handlebars.registerHelper("pascalcase", (object, options) -> {
            if (object instanceof String) {
                return BalGenerationUtils.toPascalCase((String) object);
            }
            return "";
        });
        handlebars.registerHelper("removeSpecialCharacters", (object, options) -> {
            if (object instanceof String) {
                String outputType = ((String) object).replaceAll("[^a-zA-Z0-9]", "");
                if ("byte".equalsIgnoreCase(outputType)) {
                    outputType = "Bytes";
                }
                return BalGenerationUtils.toPascalCase(outputType);
            }
            return "";
        });
        handlebars.registerHelper("ignoreQuote", (object, options) -> {
            if (object instanceof String) {
                String word = (String) object;
                if (word.startsWith("'")) {
                    return word.substring(1);
                }
            }
            return object;
        });
        handlebars.registerHelper("uppercase", (object, options) -> {
            if (object instanceof String) {
                return ((String) object).toUpperCase(Locale.ENGLISH);
            }
            return "";
        });
        handlebars.registerHelper("not_equal", (object, options) -> {
            CharSequence result;
            Object param0 = options.param(0);

            if (param0 == null) {
                throw new IllegalArgumentException("found n'null', expected 'string'");
            }
            if (object == null || !object.toString().equals(param0.toString())) {
                result = options.fn(options.context);
            } else {
                result = null;
            }

            return result;
        });
        handlebars.registerHelper("isNotNull", (object, options) -> {
            CharSequence result;
            if (object != null) {
                result = options.fn(options.context);
            } else {
                result = null;
            }
            return result;
        });
        handlebars.registerHelper("isNull", (object, options) -> {
            CharSequence result;
            if (object == null) {
                result = options.fn(options.context);
            } else {
                result = null;
            }
            return result;
        });
        handlebars.registerHelper("literal", (object, options) -> {
            if (object instanceof String) {
                return object;
            }
            return "";
        });
        // This is enable nested messages. There won't be any infinite scenarios in nested messages.
        handlebars.infiniteLoops(true);
        try {
            return handlebars.compile(templateName);
        } catch (FileNotFoundException e) {
            throw new CodeBuilderException("Code generation template file does not exist. " + e.getMessage(), e);
        } catch (IOException e) {
            throw new CodeBuilderException("IO error while compiling the template file. " + e.getMessage(), e);
        }
    }

    private void setRootDescriptor(byte[] rootDescriptor) {
        this.rootDescriptor = new byte[rootDescriptor.length];
        this.rootDescriptor = Arrays.copyOf(rootDescriptor, rootDescriptor.length);
    }
}
