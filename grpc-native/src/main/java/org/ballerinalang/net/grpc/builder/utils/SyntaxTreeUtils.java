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

package org.ballerinalang.net.grpc.builder.utils;

import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.ImportDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModuleMemberDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModulePartNode;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.ParameterizedTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.tools.text.TextDocument;
import io.ballerina.tools.text.TextDocuments;
import org.ballerinalang.net.grpc.builder.components.Descriptor;
import org.ballerinalang.net.grpc.builder.components.Message;
import org.ballerinalang.net.grpc.builder.components.Method;
import org.ballerinalang.net.grpc.builder.components.ServiceStub;
import org.ballerinalang.net.grpc.builder.components.StubFile;
import org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants;
import org.ballerinalang.net.grpc.builder.syntaxtree.Class;
import org.ballerinalang.net.grpc.builder.syntaxtree.Constant;
import org.ballerinalang.net.grpc.builder.syntaxtree.FunctionBody;
import org.ballerinalang.net.grpc.builder.syntaxtree.FunctionDefinition;
import org.ballerinalang.net.grpc.builder.syntaxtree.FunctionSignature;
import org.ballerinalang.net.grpc.builder.syntaxtree.Imports;
import org.ballerinalang.net.grpc.builder.syntaxtree.Map;
import org.ballerinalang.net.grpc.builder.syntaxtree.Record;
import org.ballerinalang.net.grpc.builder.syntaxtree.Returns;
import org.ballerinalang.net.grpc.builder.syntaxtree.Type;
import org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor;

import java.util.ArrayList;
import java.util.List;

import static org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR;
import static org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.FunctionParam.getIncludedRecordParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.FunctionParam.getRequiredParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getObjectFieldNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getQualifiedNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getStreamTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getTypeReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getUnionTypeDescriptorNode;

public class SyntaxTreeUtils {

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
                client.addMember(getClientStreamingFunction(method).getFunctionDefinitionNode());
                clientStreamingClasses.add(getStreamingClientClass(method));
            }
            for (Method method : service.getServerStreamingFunctions()) {
                client.addMember(getServerStreamingFunction(method).getFunctionDefinitionNode());
                client.addMember(getServerStreamingContextFunction(method).getFunctionDefinitionNode());
                serverStreamingClasses.add(getStreamClass(method));
            }
            for (Method method : service.getBidiStreamingFunctions()) {
                client.addMember(getBidirectionalStreamingFunction(method).getFunctionDefinitionNode());
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
                moduleMembers = moduleMembers.add(getCallerClass(caller.getKey(), caller.getKey()).getClassDefinitionNode());
            }
            for (java.util.Map.Entry<String, Boolean> valueType : service.getValueTypeMap().entrySet()) {
                if (valueType.getValue()) {
                    moduleMembers = moduleMembers.add(getValueTypeStream(valueType.getKey()).getTypeDefinitionNode());
                }
                moduleMembers = moduleMembers.add(getValueType(valueType.getKey()).getTypeDefinitionNode());
            }
        }

        for (java.util.Map.Entry<String, Message> message : stubFile.getMessageMap().entrySet()) {
            moduleMembers = moduleMembers.add(getMessageType(message.getKey()).getTypeDefinitionNode());
        }

        // ROOT_DESCRIPTOR
        Constant rootDescriptor = new Constant("ROOT_DESCRIPTOR", stubFile.getRootDescriptor());
        moduleMembers = moduleMembers.add(rootDescriptor.getConstantDeclarationNode());

        // getDescriptorMap function
        FunctionSignature getDescriptorMapSignature = new FunctionSignature();
        ParameterizedTypeDescriptorNode mapString = NodeFactory.createParameterizedTypeDescriptorNode(AbstractNodeFactory.createIdentifierToken("map"), TypeDescriptor.getTypeParameterNode(SYNTAX_TREE_VAR_STRING));
        getDescriptorMapSignature.addReturns(Returns.getReturnTypeDescriptorNode(mapString));
        FunctionBody getDescriptorMapBody = new FunctionBody();

        Map descriptorMap = new Map();
        for (Descriptor descriptor : stubFile.getDescriptors()) {
            descriptorMap.addField(descriptor.getKey(), descriptor.getData());
        }
        getDescriptorMapBody.addReturnsStatement(descriptorMap.getMappingConstructorExpressionNode());

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
        signature.addParameter(getRequiredParamNode(SYNTAX_TREE_VAR_STRING, "url"));
        signature.addParameter(getIncludedRecordParamNode(getQualifiedNameReferenceNode(
                "grpc", "ClientConfiguration"), "config"));
        signature.addReturns(Returns.getReturnTypeDescriptorNode(
                TypeDescriptor.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody body = new FunctionBody();
        FunctionDefinition definition = new FunctionDefinition("init",
                signature.getFunctionSignature(), body.getFunctionBody());
        definition.addQualifiers(new String[]{"public", "isolated"});
        return definition;
    }

    public static FunctionDefinition getUnaryFunction(Method method) {
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(getRequiredParamNode(getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, getSimpleNameReferenceNode("ContextString")), "req"));
        signature.addReturns(Returns.getReturnTypeDescriptorNode(Returns.getParenthesisedTypeDescriptorNode(getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_GRPC_ERROR))));
        FunctionBody body = new FunctionBody();
        FunctionDefinition definition = new FunctionDefinition(method.getMethodName(),
                signature.getFunctionSignature(), body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    public static FunctionDefinition getUnaryContextFunction(Method method) {
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(getRequiredParamNode(getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, getSimpleNameReferenceNode("ContextString")), "req"));
        signature.addReturns(Returns.getReturnTypeDescriptorNode(Returns.getParenthesisedTypeDescriptorNode(getUnionTypeDescriptorNode(getSimpleNameReferenceNode("ContextString"), SYNTAX_TREE_GRPC_ERROR))));
        FunctionBody body = new FunctionBody();
        FunctionDefinition definition = new FunctionDefinition(method.getMethodName() + "Context",
                signature.getFunctionSignature(), body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    public static FunctionDefinition getServerStreamingFunction(Method method) {
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(getRequiredParamNode(SYNTAX_TREE_VAR_STRING, "req"));
        signature.addReturns(Returns.getReturnTypeDescriptorNode(getUnionTypeDescriptorNode(
                getStreamTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_GRPC_ERROR), SYNTAX_TREE_GRPC_ERROR)));
        FunctionBody body = new FunctionBody();
        FunctionDefinition definition = new FunctionDefinition(method.getMethodName(),
                signature.getFunctionSignature(), body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    public static FunctionDefinition getServerStreamingContextFunction(Method method) {
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(getRequiredParamNode(SYNTAX_TREE_VAR_STRING, "req"));
        signature.addReturns(Returns.getReturnTypeDescriptorNode(getUnionTypeDescriptorNode(
                getSimpleNameReferenceNode("ContextStringStream"), SYNTAX_TREE_GRPC_ERROR
        )));
        FunctionBody body = new FunctionBody();
        FunctionDefinition definition = new FunctionDefinition(method.getMethodName() + "Context",
                signature.getFunctionSignature(), body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    public static FunctionDefinition getClientStreamingFunction(Method method) {
        String clientName = method.getMethodName().substring(0,1).toUpperCase() +
                method.getMethodName().substring(1) + "StreamingClient";
        FunctionSignature signature = new FunctionSignature();
        signature.addReturns(Returns.getReturnTypeDescriptorNode(
                Returns.getParenthesisedTypeDescriptorNode(getUnionTypeDescriptorNode(
                        getSimpleNameReferenceNode(clientName),
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR))));
        FunctionBody body = new FunctionBody();
        FunctionDefinition definition = new FunctionDefinition(method.getMethodName(),
                signature.getFunctionSignature(), body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    public static FunctionDefinition getBidirectionalStreamingFunction(Method method) {
        String clientName = method.getMethodName().substring(0,1).toUpperCase() +
                method.getMethodName().substring(1) + "StreamingClient";
        FunctionSignature signature = new FunctionSignature();
        signature.addReturns(Returns.getReturnTypeDescriptorNode(
                Returns.getParenthesisedTypeDescriptorNode(getUnionTypeDescriptorNode(
                        getSimpleNameReferenceNode(clientName),
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR))));
        FunctionBody body = new FunctionBody();
        FunctionDefinition definition = new FunctionDefinition(method.getMethodName(),
                signature.getFunctionSignature(), body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    public static Class getStreamingClientClass(Method method) {
        String name = method.getMethodName().substring(0,1).toUpperCase() +
                method.getMethodName().substring(1) + "StreamingClient";
        Class streamingClient = new Class(name, true);
        streamingClient.addQualifiers(new String[]{"client"});
        return streamingClient;
    }

    public static Class getStreamClass(Method method) {
        Class streamingClient = new Class("StringStream", true);
        return streamingClient;
    }

    private static Class getCallerClass(String key, String value) {
        Class caller = new Class(key, true);
        caller.addQualifiers(new String[]{"client"});

        FunctionSignature initSignature = new FunctionSignature();
        initSignature.addParameter(getRequiredParamNode(TypeDescriptor.getQualifiedNameReferenceNode("grpc", "Caller"), "caller"));
        FunctionBody initBody = new FunctionBody();
        FunctionDefinition initDefinition = new FunctionDefinition("init",
                initSignature.getFunctionSignature(), initBody.getFunctionBody());
        initDefinition.addQualifiers(new String[]{"public", "isolated"});
        caller.addMember(initDefinition.getFunctionDefinitionNode());

        FunctionSignature getIdSignature = new FunctionSignature();
        getIdSignature.addReturns(Returns.getReturnTypeDescriptorNode(NodeFactory.createBuiltinSimpleNameReferenceNode(SyntaxKind.INT_TYPE_DESC, AbstractNodeFactory.createIdentifierToken("int"))));
        FunctionBody getIdBody = new FunctionBody();
        FunctionDefinition getIdDefinition = new FunctionDefinition("getId",
                getIdSignature.getFunctionSignature(), getIdBody.getFunctionBody());
        getIdDefinition.addQualifiers(new String[]{"public", "isolated"});
        caller.addMember(getIdDefinition.getFunctionDefinitionNode());

        FunctionSignature sendStringSignature = new FunctionSignature();
        sendStringSignature.addParameter(getRequiredParamNode(SYNTAX_TREE_VAR_STRING, "response"));
        sendStringSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeDescriptor.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody sendStringBody = new FunctionBody();
        FunctionDefinition sendStringDefinition = new FunctionDefinition("sendString",
                sendStringSignature.getFunctionSignature(), sendStringBody.getFunctionBody());
        sendStringDefinition.addQualifiers(new String[]{"isolated", "remote"});
        caller.addMember(sendStringDefinition.getFunctionDefinitionNode());

        FunctionSignature sendContextStringSignature = new FunctionSignature();
        sendContextStringSignature.addParameter(getRequiredParamNode(SyntaxTreeConstants.SYNTAX_TREE_CONTEXT_STRING, "response"));
        sendContextStringSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeDescriptor.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody sendContextStringBody = new FunctionBody();
        FunctionDefinition sendContextStringDefinition = new FunctionDefinition("sendContextString",
                sendContextStringSignature.getFunctionSignature(), sendContextStringBody.getFunctionBody());
        sendContextStringDefinition.addQualifiers(new String[]{"isolated", "remote"});
        caller.addMember(sendContextStringDefinition.getFunctionDefinitionNode());

        FunctionSignature sendErrorSignature = new FunctionSignature();
        sendErrorSignature.addParameter(getRequiredParamNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR, "response"));
        sendErrorSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeDescriptor.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody sendErrorBody = new FunctionBody();
        FunctionDefinition sendErrorDefinition = new FunctionDefinition("sendError",
                sendErrorSignature.getFunctionSignature(), sendErrorBody.getFunctionBody());
        sendErrorDefinition.addQualifiers(new String[]{"isolated", "remote"});
        caller.addMember(sendErrorDefinition.getFunctionDefinitionNode());

        FunctionSignature completeSignature = new FunctionSignature();
        completeSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeDescriptor.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody completeBody = new FunctionBody();
        FunctionDefinition completeDefinition = new FunctionDefinition("complete",
                completeSignature.getFunctionSignature(), completeBody.getFunctionBody());
        completeDefinition.addQualifiers(new String[]{"isolated", "remote"});
        caller.addMember(completeDefinition.getFunctionDefinitionNode());

        return caller;
    }

    public static Type getValueTypeStream(String name) {
        String typeName = "Context" + name.substring(0,1).toUpperCase() + name.substring(1) + "Stream";
        Record contextStringStream = new Record();
        contextStringStream.addStreamField("content", name);
        contextStringStream.addMapField("headers", getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING,
                SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY));
        return new Type(true, typeName, contextStringStream.getRecordTypeDescriptorNode());
    }

    public static Type getValueType(String name) {
        String typeName = "Context" + name.substring(0,1).toUpperCase() + name.substring(1);
        Record contextString = new Record();
        if (name.equals("string")) {
            contextString.addStringField("content");
        } else {
            contextString.addCustomField("content", name);
        }
        contextString.addMapField("headers", getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING,
                SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY));
        return new Type(true, typeName, contextString.getRecordTypeDescriptorNode());
    }

    public static Type getMessageType(String name) {
        Record message = new Record();
        message.addFieldWithDefaultValue("string", "name");
        message.addFieldWithDefaultValue("string", "message");
        return new Type(true, name, message.getRecordTypeDescriptorNode());
    }
}
