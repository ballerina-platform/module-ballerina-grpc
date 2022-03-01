/*
 *  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package io.ballerina.stdlib.grpc.builder.syntaxtree;

import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.ImportDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModuleMemberDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModulePartNode;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.compiler.syntax.tree.TypeDescriptorNode;
import io.ballerina.stdlib.grpc.builder.stub.Descriptor;
import io.ballerina.stdlib.grpc.builder.stub.EnumMessage;
import io.ballerina.stdlib.grpc.builder.stub.Message;
import io.ballerina.stdlib.grpc.builder.stub.Method;
import io.ballerina.stdlib.grpc.builder.stub.ServiceStub;
import io.ballerina.stdlib.grpc.builder.stub.StubFile;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Annotation;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Class;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Constant;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Function;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Imports;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Listener;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Map;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.ModuleVariable;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Service;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Type;
import io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;
import io.ballerina.stdlib.grpc.builder.syntaxtree.utils.ClientUtils;
import io.ballerina.stdlib.grpc.builder.syntaxtree.utils.UnaryUtils;
import io.ballerina.tools.text.TextDocument;
import io.ballerina.tools.text.TextDocuments;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeMap;

import static io.ballerina.stdlib.grpc.MethodDescriptor.MethodType.BIDI_STREAMING;
import static io.ballerina.stdlib.grpc.MethodDescriptor.MethodType.CLIENT_STREAMING;
import static io.ballerina.stdlib.grpc.MethodDescriptor.MethodType.SERVER_STREAMING;
import static io.ballerina.stdlib.grpc.builder.BallerinaFileBuilder.dependentValueTypeMap;
import static io.ballerina.stdlib.grpc.builder.BallerinaFileBuilder.streamClassMap;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getCheckExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getFunctionCallExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getImplicitNewExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Statement.getCallStatementNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getErrorTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getMapTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getObjectFieldNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getOptionalTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getQualifiedNameReferenceNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getSimpleNameReferenceNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getStreamTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getTypeReferenceNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.GET_DESCRIPTOR_MAP;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.ROOT_DESCRIPTOR;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CallerUtils.getCallerClass;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.checkForImportsInMessageMap;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.checkForImportsInServices;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.getProtobufType;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.isBallerinaProtobufType;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.toPascalCase;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.EnumUtils.getEnum;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.MessageUtils.getMessageNodes;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.ServerUtils.getServerStreamClass;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.ServerUtils.getServerStreamingContextFunction;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.ServerUtils.getServerStreamingFunction;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.ValueTypeUtils.getValueType;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.ValueTypeUtils.getValueTypeStream;

/**
 * Syntax tree generation class.
 *
 * @since 0.8.0
 */
public class SyntaxTreeGenerator {

    private SyntaxTreeGenerator() {

    }

    public static SyntaxTree generateSyntaxTree(StubFile stubFile, boolean isRoot) {
        Set<String> protobufImports = new LinkedHashSet<>();
        Set<String> grpcStreamImports = new LinkedHashSet<>();
        NodeList<ModuleMemberDeclarationNode> moduleMembers = AbstractNodeFactory.createEmptyNodeList();

        NodeList<ImportDeclarationNode> imports = NodeFactory.createEmptyNodeList();
        if (stubFile.getStubList().size() > 0) {
            ImportDeclarationNode importForGrpc = Imports.getImportDeclarationNode(
                    "ballerina", "grpc"
            );
            imports = imports.add(importForGrpc);
        }
        boolean importTime = false;
        boolean importAny = false;
        for (ServiceStub serviceStub : stubFile.getStubList()) {
            List<Method> methodList = new ArrayList<>();
            methodList.addAll(serviceStub.getUnaryFunctions());
            methodList.addAll(serviceStub.getClientStreamingFunctions());
            methodList.addAll(serviceStub.getServerStreamingFunctions());
            methodList.addAll(serviceStub.getBidiStreamingFunctions());

            if (checkForImportsInServices(methodList, "time:Utc")
                    || checkForImportsInServices(methodList, "time:Seconds")) {
                importTime = true;
            }
            if (checkForImportsInServices(methodList, "'any:Any")) {
                importAny = true;
            }
        }
        if (!importTime) {
            if (checkForImportsInMessageMap(stubFile, "Timestamp") ||
                    checkForImportsInMessageMap(stubFile, "Duration")) {
                importTime = true;
            }
        }
        if (!importAny) {
            if (checkForImportsInMessageMap(stubFile, "'any:Any")) {
                importAny = true;
            }
        }
        if (importTime) {
            ImportDeclarationNode importForTime = Imports.getImportDeclarationNode(
                    "ballerina", "time"
            );
            imports = imports.add(importForTime);
        }
        if (importAny) {
            ImportDeclarationNode importForAny = Imports.getImportDeclarationNode(
                    "ballerina", "protobuf.types.'any"
            );
            imports = imports.add(importForAny);
        }

        java.util.Map<String, Class> clientStreamingClasses = new LinkedHashMap<>();
        java.util.Map<String, Class> serverStreamingClasses = new LinkedHashMap<>();
        java.util.Map<String, Class> bidirectionalStreamingClasses = new LinkedHashMap<>();
        java.util.Map<String, Class> callerClasses = new LinkedHashMap<>();
        java.util.Map<String, Type> valueTypes = new LinkedHashMap<>();
        java.util.Map<String, Type> valueTypeStreams = new LinkedHashMap<>();

        for (ServiceStub service : stubFile.getStubList()) {
            Class client = new Class(service.getServiceName() + "Client", true);
            client.addQualifiers(new String[]{"isolated", "client"});

            client.addMember(getTypeReferenceNode(
                    getQualifiedNameReferenceNode("grpc", "AbstractClientEndpoint")));
            client.addMember(getObjectFieldNode("private", new String[]{"final"},
                    getQualifiedNameReferenceNode("grpc", "Client"), "grpcClient"));
            client.addMember(getInitFunction(stubFile.getFileName()).getFunctionDefinitionNode());

            for (Method method : service.getUnaryFunctions()) {
                client.addMember(UnaryUtils.getUnaryFunction(method).getFunctionDefinitionNode());
                client.addMember(UnaryUtils.getUnaryContextFunction(method).getFunctionDefinitionNode());
            }
            for (Method method : service.getClientStreamingFunctions()) {
                client.addMember(ClientUtils.getStreamingClientFunction(method).getFunctionDefinitionNode());
                clientStreamingClasses.put(method.getMethodName(), ClientUtils.getStreamingClientClass(method));
            }
            for (Method method : service.getServerStreamingFunctions()) {
                client.addMember(getServerStreamingFunction(method).getFunctionDefinitionNode());
                client.addMember(getServerStreamingContextFunction(method).getFunctionDefinitionNode());
                if (!isBallerinaProtobufType(method.getOutputType())) {
                    if (!streamClassMap.containsKey(method.getOutputType())) {
                        Class serverStreamClass = getServerStreamClass(method);
                        serverStreamingClasses.put(method.getOutputType(), serverStreamClass);
                        streamClassMap.put(method.getOutputType(), serverStreamClass);
                    }
                } else {
                    grpcStreamImports.add(getProtobufType(method.getOutputType()));
                }
            }
            for (Method method : service.getBidiStreamingFunctions()) {
                client.addMember(ClientUtils.getStreamingClientFunction(method).getFunctionDefinitionNode());
                bidirectionalStreamingClasses.put(method.getMethodName(), ClientUtils.getStreamingClientClass(method));
            }
            moduleMembers = moduleMembers.add(client.getClassDefinitionNode());

            for (java.util.Map.Entry<String, String> caller : service.getCallerMap().entrySet()) {
                callerClasses.put(caller.getKey(), getCallerClass(caller.getKey(), caller.getValue()));
            }
            for (java.util.Map.Entry<String, Boolean> valueType : service.getValueTypeMap().entrySet()) {
                if (!(isRoot && dependentValueTypeMap.containsKey(valueType.getKey()))) {
                    if (!isBallerinaProtobufType(valueType.getKey())) {
                        if (valueType.getValue()) {
                            valueTypeStreams.put(valueType.getKey(), getValueTypeStream(valueType.getKey()));
                        }
                        valueTypes.put(valueType.getKey(), getValueType(valueType.getKey()));
                    } else {
                        protobufImports.add(getProtobufType(valueType.getKey()));
                    }
                }
            }
        }

        // Add protobuf imports
        for (String protobufImport : protobufImports) {
            imports = imports.add(
                    Imports.getImportDeclarationNode(
                            "ballerina",
                            "protobuf",
                            new String[]{"types", protobufImport},
                            ""
                    )
            );
        }
        // Add grpc server streaming imports
        for (String sImport : grpcStreamImports) {
            String prefix = sImport;
            if (sImport.equals("'any")) {
                prefix = "any";
            }
            imports = imports.add(
                    Imports.getImportDeclarationNode(
                            "ballerina",
                            "grpc",
                            new String[]{"types", sImport},
                            "s" + prefix
                    )
            );
        }

        for (java.util.Map.Entry<String, Class> streamingClient : clientStreamingClasses.entrySet()) {
            moduleMembers = moduleMembers.add(streamingClient.getValue().getClassDefinitionNode());
        }
        for (java.util.Map.Entry<String, Class> streamingServer : serverStreamingClasses.entrySet()) {
            moduleMembers = moduleMembers.add(streamingServer.getValue().getClassDefinitionNode());
        }
        for (java.util.Map.Entry<String, Class> streamingBidirectional : bidirectionalStreamingClasses.entrySet()) {
            moduleMembers = moduleMembers.add(streamingBidirectional.getValue().getClassDefinitionNode());
        }
        for (java.util.Map.Entry<String, Class> callerClass : callerClasses.entrySet()) {
            moduleMembers = moduleMembers.add(callerClass.getValue().getClassDefinitionNode());
        }
        for (java.util.Map.Entry<String, Type> valueTypeStream : valueTypeStreams.entrySet()) {
            moduleMembers = moduleMembers.add(valueTypeStream.getValue().getTypeDefinitionNode());
        }
        for (java.util.Map.Entry<String, Type> valueType : valueTypes.entrySet()) {
            moduleMembers = moduleMembers.add(valueType.getValue().getTypeDefinitionNode());
        }
        for (java.util.Map.Entry<String, Message> message : stubFile.getMessageMap().entrySet()) {
            for (ModuleMemberDeclarationNode messageNode : getMessageNodes(message.getValue())) {
                moduleMembers = moduleMembers.add(messageNode);
            }
        }

        for (EnumMessage enumMessage : stubFile.getEnumList()) {
            moduleMembers = moduleMembers.add(getEnum(enumMessage).getEnumDeclarationNode());
        }

        // ROOT_DESCRIPTOR
        if (stubFile.getRootDescriptor() != null) {
            Constant rootDescriptor = new Constant(
                    "string",
                    ROOT_DESCRIPTOR + stubFile.getFileName().toUpperCase(),
                    stubFile.getRootDescriptor()
            );
            moduleMembers = moduleMembers.add(rootDescriptor.getConstantDeclarationNode());
        }

        // getDescriptorMap function
        if (stubFile.getDescriptors().size() > 0) {
            Function getDescriptorMap = new Function(GET_DESCRIPTOR_MAP + toPascalCase(stubFile.getFileName()));
            getDescriptorMap.addReturns(
                    getMapTypeDescriptorNode(SYNTAX_TREE_VAR_STRING)
            );
            Map descriptorMap = new Map();
            for (java.util.Map.Entry<String, String> descriptor : getSortedDescriptorMap(stubFile).entrySet()) {
                descriptorMap.addStringField(descriptor.getKey(), descriptor.getValue());
            }
            getDescriptorMap.addReturnStatement(descriptorMap.getMappingConstructorExpressionNode());
            getDescriptorMap.addQualifiers(new String[]{"public", "isolated"});
            moduleMembers = moduleMembers.add(getDescriptorMap.getFunctionDefinitionNode());
        }

        Token eofToken = AbstractNodeFactory.createIdentifierToken("");
        ModulePartNode modulePartNode = NodeFactory.createModulePartNode(imports, moduleMembers, eofToken);
        TextDocument textDocument = TextDocuments.from("");
        SyntaxTree syntaxTree = SyntaxTree.from(textDocument);
        return syntaxTree.modifyWith(modulePartNode);
    }

    public static SyntaxTree generateSyntaxTreeForServiceSample(ServiceStub serviceStub, boolean addListener,
                                                                String fileName) {
        NodeList<ModuleMemberDeclarationNode> moduleMembers = AbstractNodeFactory.createEmptyNodeList();
        NodeList<ImportDeclarationNode> imports = NodeFactory.createEmptyNodeList();
        ImportDeclarationNode importForGrpc = Imports.getImportDeclarationNode("ballerina", "grpc");
        imports = imports.add(importForGrpc);

        List<Method> methodList = new ArrayList<>();
        methodList.addAll(serviceStub.getUnaryFunctions());
        methodList.addAll(serviceStub.getClientStreamingFunctions());
        methodList.addAll(serviceStub.getServerStreamingFunctions());
        methodList.addAll(serviceStub.getBidiStreamingFunctions());

        if (checkForImportsInServices(methodList, "time:Utc")
                || checkForImportsInServices(methodList, "time:Seconds")) {
            ImportDeclarationNode importForTime = Imports.getImportDeclarationNode(
                    "ballerina", "time"
            );
            imports = imports.add(importForTime);
        }

        if (checkForImportsInServices(methodList, "'any:Any")) {
            ImportDeclarationNode importForAny = Imports.getImportDeclarationNode(
                    "ballerina", "protobuf.types.'any"
            );
            imports = imports.add(importForAny);
        }

        if (addListener) {
            Listener listener = new Listener(
                    "ep",
                    getQualifiedNameReferenceNode("grpc", "Listener"),
                    getImplicitNewExpressionNode(new String[]{"9090"}),
                    false
            );
            moduleMembers = moduleMembers.add(listener.getListenerDeclarationNode());
        }

        Service service = new Service(
                new String[]{"\"" + serviceStub.getServiceName() + "\""},
                new String[]{"ep"}
        );
        Annotation grpcServiceDescriptor = new Annotation("grpc", "ServiceDescriptor");
        grpcServiceDescriptor.addField(
                "descriptor",
                ROOT_DESCRIPTOR + fileName.toUpperCase()
        );
        grpcServiceDescriptor.addField(
                "descMap",
                getFunctionCallExpressionNode(GET_DESCRIPTOR_MAP + toPascalCase(fileName), new String[]{})
        );
        service.addAnnotation(grpcServiceDescriptor.getAnnotationNode());

        for (Method method : methodList) {
            Function function = new Function(method.getMethodName());
            function.addQualifiers(new String[]{"remote"});
            String input = method.getInputType();
            String output = method.getOutputType();

            if (method.getInputType() != null) {
                TypeDescriptorNode inputParam;
                String inputName;
                if (method.getMethodType().equals(CLIENT_STREAMING) ||
                        method.getMethodType().equals(BIDI_STREAMING)) {
                    inputParam = getStreamTypeDescriptorNode(
                            getSimpleNameReferenceNode(input),
                            SYNTAX_TREE_GRPC_ERROR_OPTIONAL
                    );
                    inputName = "clientStream";
                } else {
                    inputParam = getSimpleNameReferenceNode(input);
                    inputName = "value";
                }
                function.addRequiredParameter(inputParam, inputName);
            }

            if (method.getOutputType() != null) {
                TypeDescriptorNode outputParam;
                if (method.getMethodType().equals(SERVER_STREAMING) ||
                        method.getMethodType().equals(BIDI_STREAMING)) {
                    outputParam = getStreamTypeDescriptorNode(
                            getSimpleNameReferenceNode(output),
                            getOptionalTypeDescriptorNode("", "error")
                    );
                } else {
                    outputParam = getSimpleNameReferenceNode(output);
                }
                function.addReturns(
                        getUnionTypeDescriptorNode(
                                outputParam,
                                getErrorTypeDescriptorNode()
                        )
                );
            } else {
                function.addReturns(
                        getOptionalTypeDescriptorNode("", "error")
                );
            }
            service.addMember(function.getFunctionDefinitionNode());
        }
        moduleMembers = moduleMembers.add(service.getServiceDeclarationNode());

        Token eofToken = AbstractNodeFactory.createIdentifierToken("");
        ModulePartNode modulePartNode = NodeFactory.createModulePartNode(imports, moduleMembers, eofToken);
        TextDocument textDocument = TextDocuments.from("");
        SyntaxTree syntaxTree = SyntaxTree.from(textDocument);
        return syntaxTree.modifyWith(modulePartNode);
    }

    public static SyntaxTree generateSyntaxTreeForClientSample(ServiceStub serviceStub) {
        NodeList<ModuleMemberDeclarationNode> moduleMembers = AbstractNodeFactory.createEmptyNodeList();
        NodeList<ImportDeclarationNode> imports = AbstractNodeFactory.createEmptyNodeList();

        Function main = new Function("main");
        main.addQualifiers(new String[]{"public"});
        ModuleVariable clientEp = new ModuleVariable(
                getTypedBindingPatternNode(
                        getSimpleNameReferenceNode(serviceStub.getServiceName() + "Client"),
                        getCaptureBindingPatternNode("ep")
                ),
                getCheckExpressionNode(
                        getImplicitNewExpressionNode(new String[]{"\"http://localhost:9090\""})
                )
        );
        moduleMembers = moduleMembers.add(clientEp.getModuleVariableDeclarationNode());
        moduleMembers = moduleMembers.add(main.getFunctionDefinitionNode());

        Token eofToken = AbstractNodeFactory.createIdentifierToken("");
        ModulePartNode modulePartNode = NodeFactory.createModulePartNode(imports, moduleMembers, eofToken);
        TextDocument textDocument = TextDocuments.from("");
        SyntaxTree syntaxTree = SyntaxTree.from(textDocument);
        return syntaxTree.modifyWith(modulePartNode);
    }

    public static Function getInitFunction(String fileName) {
        Function function = new Function("init");
        function.addRequiredParameter(SYNTAX_TREE_VAR_STRING, "url");
        function.addIncludedRecordParameter(
                getQualifiedNameReferenceNode("grpc", "ClientConfiguration"),
                "config"
        );
        function.addReturns(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL);
        function.addAssignmentStatement(
                getFieldAccessExpressionNode("self", "grpcClient"),
                getCheckExpressionNode(
                        getImplicitNewExpressionNode(new String[]{"url", "config"})
                )
        );
        function.addExpressionStatement(
                getCallStatementNode(
                        getCheckExpressionNode(
                                getMethodCallExpressionNode(
                                        getFieldAccessExpressionNode("self", "grpcClient"),
                                        "initStub",
                                        new String[]{
                                                "self",
                                                ROOT_DESCRIPTOR + fileName.toUpperCase(),
                                                GET_DESCRIPTOR_MAP + toPascalCase(fileName) + "()"}
                                )
                        )
                )
        );
        function.addQualifiers(new String[]{"public", "isolated"});
        return function;
    }

    private static java.util.Map<String, String> getSortedDescriptorMap(StubFile stubFile) {
        java.util.Map<String, String> map = new HashMap<>();

        for (Descriptor descriptor : stubFile.getDescriptors()) {
            map.put(descriptor.getKey(), descriptor.getData());
        }
        return new TreeMap<>(map);
    }
}
