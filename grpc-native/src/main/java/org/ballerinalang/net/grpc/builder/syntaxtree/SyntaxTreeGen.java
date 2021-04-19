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

package org.ballerinalang.net.grpc.builder.syntaxtree;

import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.ImportDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModuleMemberDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModulePartNode;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.ParameterizedTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.tools.text.TextDocument;
import io.ballerina.tools.text.TextDocuments;
import org.ballerinalang.net.grpc.builder.stub.Descriptor;
import org.ballerinalang.net.grpc.builder.stub.EnumMessage;
import org.ballerinalang.net.grpc.builder.stub.Message;
import org.ballerinalang.net.grpc.builder.stub.Method;
import org.ballerinalang.net.grpc.builder.stub.ServiceStub;
import org.ballerinalang.net.grpc.builder.stub.StubFile;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Annotation;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Class;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Constant;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionBody;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionDefinition;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionSignature;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Imports;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Listener;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Map;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.ModuleVariable;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Returns;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Service;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import java.util.ArrayList;
import java.util.List;

import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.GRPC_CLIENT;
import static org.ballerinalang.net.grpc.builder.balgen.BalGenConstants.GRPC_SERVICE;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFunctionCallExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getImplicitNewExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionParam.getIncludedRecordParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionParam.getRequiredParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Initializer.getCallStatementNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Initializer.getCheckExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getErrorTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getObjectFieldNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getOptionalTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getQualifiedNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getStreamTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypeReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CallerUtils.getCallerClass;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.ClientUtils.getStreamingClientClass;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.ClientUtils.getStreamingClientFunction;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.EnumUtils.getEnum;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.MessageUtils.getMessageNodes;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.ServerUtils.getServerStreamClass;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.ServerUtils.getServerStreamingContextFunction;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.ServerUtils.getServerStreamingFunction;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.UnaryUtils.getUnaryContextFunction;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.UnaryUtils.getUnaryFunction;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.ValueTypeUtils.getValueType;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.ValueTypeUtils.getValueTypeStream;

public class SyntaxTreeGen {

    public static SyntaxTree generateSyntaxTree(StubFile stubFile) {
        NodeList<ModuleMemberDeclarationNode> moduleMembers = AbstractNodeFactory.createEmptyNodeList();

        ImportDeclarationNode importForGrpc = Imports.getImportDeclarationNode("ballerina", "grpc");
        NodeList<ImportDeclarationNode> imports = AbstractNodeFactory.createNodeList(importForGrpc);

        for (ServiceStub service : stubFile.getStubList()) {
            List<Class> clientStreamingClasses = new ArrayList<>();
            List<Class> serverStreamingClasses = new ArrayList<>();
            List<Class> bidirectionalStreamingClasses = new ArrayList<>();
            Class client = new Class(service.getServiceName() + "Client", true);
            client.addQualifiers(new String[]{"client"});

            client.addMember(getTypeReferenceNode(getQualifiedNameReferenceNode("grpc", "AbstractClientEndpoint")));
            client.addMember(getObjectFieldNode("private", new String[]{}, getQualifiedNameReferenceNode("grpc", "Client"), "grpcClient"));
            client.addMember(getInitFunction().getFunctionDefinitionNode());

            for (Method method : service.getUnaryFunctions()) {
                client.addMember(getUnaryFunction(method).getFunctionDefinitionNode());
                client.addMember(getUnaryContextFunction(method).getFunctionDefinitionNode());
            }
            for (Method method : service.getClientStreamingFunctions()) {
                client.addMember(getStreamingClientFunction(method, false).getFunctionDefinitionNode());
                clientStreamingClasses.add(getStreamingClientClass(method));
            }
            for (Method method : service.getServerStreamingFunctions()) {
                client.addMember(getServerStreamingFunction(method).getFunctionDefinitionNode());
                client.addMember(getServerStreamingContextFunction(method).getFunctionDefinitionNode());
                serverStreamingClasses.add(getServerStreamClass(method));
            }
            for (Method method : service.getBidiStreamingFunctions()) {
                client.addMember(getStreamingClientFunction(method, true).getFunctionDefinitionNode());
                bidirectionalStreamingClasses.add(getStreamingClientClass(method));
            }
            moduleMembers = moduleMembers.add(client.getClassDefinitionNode());

            for (Class streamingClient : clientStreamingClasses) {
                moduleMembers = moduleMembers.add(streamingClient.getClassDefinitionNode());
            }
            for (Class streamingServer : serverStreamingClasses) {
                moduleMembers = moduleMembers.add(streamingServer.getClassDefinitionNode());
            }
            for (Class streamingBidirectional : bidirectionalStreamingClasses) {
                moduleMembers = moduleMembers.add(streamingBidirectional.getClassDefinitionNode());
            }

            for (java.util.Map.Entry<String, String> caller : service.getCallerMap().entrySet()) {
                moduleMembers = moduleMembers.add(getCallerClass(caller.getKey(), caller.getValue()).getClassDefinitionNode());
            }
            for (java.util.Map.Entry<String, Boolean> valueType : service.getValueTypeMap().entrySet()) {
                if (valueType.getValue()) {
                    moduleMembers = moduleMembers.add(getValueTypeStream(valueType.getKey()).getTypeDefinitionNode());
                }
                moduleMembers = moduleMembers.add(getValueType(valueType.getKey()).getTypeDefinitionNode());
            }
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
        Constant rootDescriptor = new Constant("string", "ROOT_DESCRIPTOR", stubFile.getRootDescriptor(), false);
        moduleMembers = moduleMembers.add(rootDescriptor.getConstantDeclarationNode());

        // getDescriptorMap function
        FunctionSignature getDescriptorMapSignature = new FunctionSignature();
        ParameterizedTypeDescriptorNode mapString = NodeFactory.createParameterizedTypeDescriptorNode(AbstractNodeFactory.createIdentifierToken("map"), TypeDescriptor.getTypeParameterNode(SYNTAX_TREE_VAR_STRING));
        getDescriptorMapSignature.addReturns(Returns.getReturnTypeDescriptorNode(mapString));
        FunctionBody getDescriptorMapBody = new FunctionBody();

        Map descriptorMap = new Map();
        for (Descriptor descriptor : stubFile.getDescriptors()) {
            descriptorMap.addStringField(descriptor.getKey(), descriptor.getData());
        }
        getDescriptorMapBody.addReturnStatement(descriptorMap.getMappingConstructorExpressionNode());

        FunctionDefinition getDescriptorMapDefinition = new FunctionDefinition("getDescriptorMap",
                getDescriptorMapSignature.getFunctionSignature(), getDescriptorMapBody.getFunctionBody());
        getDescriptorMapDefinition.addQualifiers(new String[]{"isolated"});
        FunctionDefinitionNode getDescriptorMapFunction = getDescriptorMapDefinition.getFunctionDefinitionNode();
        moduleMembers = moduleMembers.add(getDescriptorMapFunction);

        Token eofToken = AbstractNodeFactory.createIdentifierToken("");
        ModulePartNode modulePartNode = NodeFactory.createModulePartNode(imports, moduleMembers, eofToken);
        TextDocument textDocument = TextDocuments.from("");
        SyntaxTree syntaxTree = SyntaxTree.from(textDocument);
        return syntaxTree.modifyWith(modulePartNode);
    }

    public static FunctionDefinition getInitFunction() {
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(
                getRequiredParamNode(SYNTAX_TREE_VAR_STRING, "url"));
        signature.addParameter(
                getIncludedRecordParamNode(
                        getQualifiedNameReferenceNode("grpc", "ClientConfiguration"),
                        "config"));
        signature.addReturns(
                Returns.getReturnTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody body = new FunctionBody();
        body.addAssignmentStatement(
                getFieldAccessExpressionNode("self", "grpcClient"),
                getCheckExpressionNode(getImplicitNewExpressionNode(new String[]{"url", "config"})));
        body.addExpressionStatement(
                getCallStatementNode(
                        getCheckExpressionNode(
                                getMethodCallExpressionNode(
                                        getFieldAccessExpressionNode("self", "grpcClient"),
                                        "initStub",
                                        new String[]{"self", "ROOT_DESCRIPTOR","getDescriptorMap()"}))));
        FunctionDefinition definition = new FunctionDefinition(
                "init",
                signature.getFunctionSignature(),
                body.getFunctionBody());
        definition.addQualifiers(new String[]{"public", "isolated"});
        return definition;
    }

    public static SyntaxTree generateSyntaxTree(StubFile stubFile, String mode) {
        NodeList<ModuleMemberDeclarationNode> moduleMembers = AbstractNodeFactory.createEmptyNodeList();
        NodeList<ImportDeclarationNode> imports = AbstractNodeFactory.createEmptyNodeList();

        if (GRPC_SERVICE.equals(mode)) {
            String input = stubFile.getStubList().get(0).getServerStreamingFunctions().get(0).getInputType();
            String output = stubFile.getStubList().get(0).getServerStreamingFunctions().get(0).getOutputType();
            ImportDeclarationNode importForGrpc = Imports.getImportDeclarationNode("ballerina", "grpc");
            imports = AbstractNodeFactory.createNodeList(importForGrpc);

            Listener listener = new Listener(
                    "ep",
                    getQualifiedNameReferenceNode("grpc", "Listener"),
                    getImplicitNewExpressionNode(new String[]{"9090"}),
                    false
            );
            moduleMembers = moduleMembers.add(listener.getListenerDeclarationNode());

            Service service = new Service(
                    new String[]{"\"" + stubFile.getStubList().get(0).getServiceName() + "\""},
                    new String[]{"ep"}
            );
            Annotation grpcServiceDescriptor = new Annotation("grpc", "ServiceDescriptor");
            grpcServiceDescriptor.addField("descriptor", "ROOT_DESCRIPTOR");
            grpcServiceDescriptor.addField(
                    "descMap",
                    getFunctionCallExpressionNode("getDescriptorMap", new String[]{})
                    );
            service.addAnnotation(grpcServiceDescriptor.getAnnotationNode());
            FunctionSignature signature = new FunctionSignature();
            signature.addParameter(
                    getRequiredParamNode(
                            getSimpleNameReferenceNode(input),
                            "value"
                    )
            );
            signature.addReturns(
                    Returns.getReturnTypeDescriptorNode(
                            getUnionTypeDescriptorNode(
                                    getStreamTypeDescriptorNode(
                                            getSimpleNameReferenceNode(output),
                                            // Todo: parametarize identirifer (optionalTypeDescriptor)
                                            getOptionalTypeDescriptorNode("", "error")
                                    ),
                                    getErrorTypeDescriptorNode()
                            )
                    )
            );
            FunctionBody body = new FunctionBody();
            FunctionDefinition function = new FunctionDefinition(
                    // Todo: parameterize
                    stubFile.getStubList().get(0).getServerStreamingFunctions().get(0).getMethodName(),
                    signature.getFunctionSignature(),
                    body.getFunctionBody()
            );
            function.addQualifiers(new String[]{"remote"});
            service.addMember(function.getFunctionDefinitionNode());
            moduleMembers = moduleMembers.add(service.getServiceDeclarationNode());
        }
        if (GRPC_CLIENT.equals(mode)) {
            ModuleVariable clientEp = new ModuleVariable(
                    getTypedBindingPatternNode(
                            getSimpleNameReferenceNode("Client"),
                            getCaptureBindingPatternNode("ep")
                    ),
                    getCheckExpressionNode(
                            getImplicitNewExpressionNode(new String[]{"\"http://localhost:9090\""})
                    ),
                    false
            );
            moduleMembers = moduleMembers.add(clientEp.getModuleVariableDeclarationNode());

            FunctionSignature signature = new FunctionSignature();
            FunctionBody body = new FunctionBody();
            FunctionDefinition main = new FunctionDefinition(
                    "main",
                    signature.getFunctionSignature(),
                    body.getFunctionBody()
            );
            moduleMembers = moduleMembers.add(main.getFunctionDefinitionNode());
        }

        Token eofToken = AbstractNodeFactory.createIdentifierToken("");
        ModulePartNode modulePartNode = NodeFactory.createModulePartNode(imports, moduleMembers, eofToken);
        TextDocument textDocument = TextDocuments.from("");
        SyntaxTree syntaxTree = SyntaxTree.from(textDocument);
        return syntaxTree.modifyWith(modulePartNode);
    }
}
