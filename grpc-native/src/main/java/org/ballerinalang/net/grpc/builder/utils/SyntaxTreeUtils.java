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
import io.ballerina.compiler.syntax.tree.BindingPatternNode;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.ImportDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModuleMemberDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModulePartNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.ParameterizedTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.compiler.syntax.tree.StatementNode;
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
import org.ballerinalang.net.grpc.builder.syntaxtree.IfElse;
import org.ballerinalang.net.grpc.builder.syntaxtree.Imports;
import org.ballerinalang.net.grpc.builder.syntaxtree.Map;
import org.ballerinalang.net.grpc.builder.syntaxtree.Record;
import org.ballerinalang.net.grpc.builder.syntaxtree.Returns;
import org.ballerinalang.net.grpc.builder.syntaxtree.Type;
import org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor;
import org.ballerinalang.net.grpc.builder.syntaxtree.VariableDeclaration;

import java.util.ArrayList;
import java.util.List;

import static org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR;
import static org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL;
import static org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_ANYDATA;
import static org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY;
import static org.ballerinalang.net.grpc.builder.syntaxtree.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.Expression.getMethodCallExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.Expression.getRemoteMethodCallActionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.Expression.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.FunctionParam.getIncludedRecordParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.FunctionParam.getRequiredParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.IfElse.getBlockStatementNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.IfElse.getBracedExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.IfElse.getNilTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.IfElse.getTypeTestExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.Initializer.getCheckExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.Returns.getReturnStatementNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getListBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getObjectFieldNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getParameterizedTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getQualifiedNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getStreamTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getTupleTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getTypeReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getTypedBindingPatternNode;
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
                serverStreamingClasses.add(getServerStreamClass(method));
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
                moduleMembers = moduleMembers.add(getCallerClass(caller.getKey()).getClassDefinitionNode());
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
        signature.addParameter(getRequiredParamNode(SYNTAX_TREE_VAR_STRING, "url"));
        signature.addParameter(getIncludedRecordParamNode(getQualifiedNameReferenceNode(
                "grpc", "ClientConfiguration"), "config"));
        signature.addReturns(Returns.getReturnTypeDescriptorNode(
                SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
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
        String name = method.getMethodName().substring(0, 1).toUpperCase() +
                method.getMethodName().substring(1) + "StreamingClient";
        Class streamingClient = new Class(name, true);
        String inputType = method.getInputType().substring(0, 1).toUpperCase() + method.getInputType().substring(1);
        String outputType = method.getOutputType().substring(0, 1).toUpperCase() + method.getOutputType().substring(1);
        streamingClient.addQualifiers(new String[]{"client"});

        streamingClient.addMember(getObjectFieldNode("private", new String[]{}, getQualifiedNameReferenceNode("grpc", "StreamingClient"), "sClient"));
        streamingClient.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature initSignature = new FunctionSignature();
        initSignature.addParameter(getRequiredParamNode(TypeDescriptor.getQualifiedNameReferenceNode("grpc", "StreamingClient"), "sClient"));
        FunctionBody initBody = new FunctionBody();
        initBody.addAssignmentStatement(getFieldAccessExpressionNode("self", "sClient"), getSimpleNameReferenceNode("sClient"));
        FunctionDefinition initDefinition = new FunctionDefinition("init",
                initSignature.getFunctionSignature(), initBody.getFunctionBody());
        initDefinition.addQualifiers(new String[]{"isolated"});
        streamingClient.addMember(initDefinition.getFunctionDefinitionNode());
        streamingClient.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature sendSignature = new FunctionSignature();
        sendSignature.addParameter(getRequiredParamNode(getSimpleNameReferenceNode(method.getInputType()), "message"));
        sendSignature.addReturns(Returns.getReturnTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody sendBody = new FunctionBody();
        sendBody.addReturnStatement(getRemoteMethodCallActionNode(getFieldAccessExpressionNode("self", "sClient"), "send", new String[]{"message"}));
        FunctionDefinition sendDefinition = new FunctionDefinition("send" + inputType,
                sendSignature.getFunctionSignature(), sendBody.getFunctionBody());
        sendDefinition.addQualifiers(new String[]{"isolated", "remote"});
        streamingClient.addMember(sendDefinition.getFunctionDefinitionNode());
        streamingClient.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature sendContextSignature = new FunctionSignature();
        sendContextSignature.addParameter(getRequiredParamNode(getSimpleNameReferenceNode("Context" + inputType), "message"));
        sendContextSignature.addReturns(Returns.getReturnTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody sendContextBody = new FunctionBody();
        sendContextBody.addReturnStatement(getRemoteMethodCallActionNode(getFieldAccessExpressionNode("self", "sClient"), "send", new String[]{"message"}));
        FunctionDefinition sendContextDefinition = new FunctionDefinition("sendContext" + inputType,
                sendContextSignature.getFunctionSignature(), sendContextBody.getFunctionBody());
        sendContextDefinition.addQualifiers(new String[]{"isolated", "remote"});
        streamingClient.addMember(sendContextDefinition.getFunctionDefinitionNode());
        streamingClient.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        SeparatedNodeList<Node> receiveArgs = NodeFactory.createSeparatedNodeList(
                getBuiltinSimpleNameReferenceNode("anydata"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getParameterizedTypeDescriptorNode("map", getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_VAR_STRING_ARRAY))
        );
        SeparatedNodeList<BindingPatternNode> bindingPatterns = NodeFactory.createSeparatedNodeList(
                getCaptureBindingPatternNode("payload"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getCaptureBindingPatternNode("headers"));
        VariableDeclaration receive = new VariableDeclaration(getTypedBindingPatternNode(getTupleTypeDescriptorNode(receiveArgs), getListBindingPatternNode(bindingPatterns)), getCheckExpressionNode(getRemoteMethodCallActionNode(getFieldAccessExpressionNode("self", "sClient"), "receive", new String[]{})));

        FunctionSignature receiveSignature = new FunctionSignature();
        receiveSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeDescriptor.getUnionTypeDescriptorNode(getSimpleNameReferenceNode(method.getOutputType()), SYNTAX_TREE_GRPC_ERROR)));
        FunctionBody receiveBody = new FunctionBody();
        receiveBody.addVariableStatement(receive.getVariableDeclarationNode());
        receiveBody.addReturnStatement(getMethodCallExpressionNode(getSimpleNameReferenceNode("payload"), "toString", new String[]{}));
        FunctionDefinition receiveDefinition = new FunctionDefinition("receive" + outputType,
                receiveSignature.getFunctionSignature(), receiveBody.getFunctionBody());
        receiveDefinition.addQualifiers(new String[]{"isolated", "remote"});
        streamingClient.addMember(receiveDefinition.getFunctionDefinitionNode());
        streamingClient.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature receiveContextSignature = new FunctionSignature();
        receiveContextSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeDescriptor.getUnionTypeDescriptorNode(getSimpleNameReferenceNode("Context" + outputType), SYNTAX_TREE_GRPC_ERROR)));
        FunctionBody receiveContextBody = new FunctionBody();
        receiveContextBody.addVariableStatement(receive.getVariableDeclarationNode());
        Map returnMap = new Map();
        returnMap.addMethodCallField("content", getSimpleNameReferenceNode("payload"), "toString", new String[]{});
        returnMap.addSimpleNameReferenceField("headers", "headers");
        receiveContextBody.addReturnStatement(returnMap.getMappingConstructorExpressionNode());
        FunctionDefinition receiveContextDefinition = new FunctionDefinition("receiveContext" + outputType,
                receiveContextSignature.getFunctionSignature(), receiveContextBody.getFunctionBody());
        receiveContextDefinition.addQualifiers(new String[]{"isolated", "remote"});
        streamingClient.addMember(receiveContextDefinition.getFunctionDefinitionNode());
        streamingClient.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature sendErrorSignature = new FunctionSignature();
        sendErrorSignature.addParameter(getRequiredParamNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR, "response"));
        sendErrorSignature.addReturns(Returns.getReturnTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody sendErrorBody = new FunctionBody();
        sendErrorBody.addReturnStatement(getRemoteMethodCallActionNode(getFieldAccessExpressionNode("self", "sClient"), "sendError", new String[]{"response"}));
        FunctionDefinition sendErrorDefinition = new FunctionDefinition("sendError",
                sendErrorSignature.getFunctionSignature(), sendErrorBody.getFunctionBody());
        sendErrorDefinition.addQualifiers(new String[]{"isolated", "remote"});
        streamingClient.addMember(sendErrorDefinition.getFunctionDefinitionNode());
        streamingClient.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature completeSignature = new FunctionSignature();
        completeSignature.addReturns(Returns.getReturnTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody completeBody = new FunctionBody();
        completeBody.addReturnStatement(getRemoteMethodCallActionNode(getFieldAccessExpressionNode("self", "sClient"), "complete", new String[]{}));
        FunctionDefinition completeDefinition = new FunctionDefinition("complete",
                completeSignature.getFunctionSignature(), completeBody.getFunctionBody());
        completeDefinition.addQualifiers(new String[]{"isolated", "remote"});
        streamingClient.addMember(completeDefinition.getFunctionDefinitionNode());

        return streamingClient;
    }

    public static Class getServerStreamClass(Method method) {
        String inputType = method.getInputType().substring(0, 1).toUpperCase() + method.getInputType().substring(1);
        Class serverStream = new Class(inputType + "Stream", true);

        serverStream.addMember(getObjectFieldNode("private", new String[]{}, getStreamTypeDescriptorNode(SYNTAX_TREE_VAR_ANYDATA, SYNTAX_TREE_GRPC_ERROR), "anydataStream"));
        serverStream.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature initSignature = new FunctionSignature();
        initSignature.addParameter(getRequiredParamNode(getStreamTypeDescriptorNode(SYNTAX_TREE_VAR_ANYDATA, SYNTAX_TREE_GRPC_ERROR), "anydataStream"));
        FunctionBody initBody = new FunctionBody();
        initBody.addAssignmentStatement(getFieldAccessExpressionNode("self", "anydataStream"), getSimpleNameReferenceNode("anydataStream"));
        FunctionDefinition initDefinition = new FunctionDefinition("init",
                initSignature.getFunctionSignature(), initBody.getFunctionBody());
        initDefinition.addQualifiers(new String[]{"public", "isolated"});
        serverStream.addMember(initDefinition.getFunctionDefinitionNode());
        serverStream.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature nextSignature = new FunctionSignature();
        Record nextRecord = new Record();
        nextRecord.addCustomField("value", method.getInputType());
        nextSignature.addReturns(Returns.getReturnTypeDescriptorNode(getUnionTypeDescriptorNode(nextRecord.getRecordTypeDescriptorNode(), SYNTAX_TREE_GRPC_ERROR_OPTIONAL)));
        FunctionBody nextBody = new FunctionBody();

        VariableDeclaration streamValue = new VariableDeclaration(getTypedBindingPatternNode(getBuiltinSimpleNameReferenceNode("var"), getCaptureBindingPatternNode("streamValue")), getMethodCallExpressionNode(getFieldAccessExpressionNode("self", "anydataStream"), "next", new String[]{}));
        nextBody.addVariableStatement(streamValue.getVariableDeclarationNode());

        IfElse streamValueNilCheck = new IfElse(
                getBracedExpressionNode(getTypeTestExpressionNode(getSimpleNameReferenceNode("streamValue"), getNilTypeDescriptorNode()))
        );
        streamValueNilCheck.addReturnStatement(getSimpleNameReferenceNode("streamValue"));
        IfElse streamValueErrorCheck = new IfElse(
                getBracedExpressionNode(getTypeTestExpressionNode(getSimpleNameReferenceNode("streamValue"), SYNTAX_TREE_GRPC_ERROR))
        );
        streamValueErrorCheck.addReturnStatement(getSimpleNameReferenceNode("streamValue"));

        ArrayList<StatementNode> elseStatement = new ArrayList<>();

        Record nextRecordRec = new Record();
        nextRecordRec.addStringField("value");
        Map nextRecordMap = new Map();
        nextRecordMap.addTypeCastExpressionField("value", "string", getFieldAccessExpressionNode("streamValue", "value"));
        VariableDeclaration nextRecordVar = new VariableDeclaration(getTypedBindingPatternNode(nextRecordRec.getRecordTypeDescriptorNode(), getCaptureBindingPatternNode("nextRecord")), nextRecordMap.getMappingConstructorExpressionNode());
        elseStatement.add(nextRecordVar.getVariableDeclarationNode());
        elseStatement.add(getReturnStatementNode(getSimpleNameReferenceNode("nextRecord")));
        streamValueErrorCheck.addElseBody(getBlockStatementNode(elseStatement));
        streamValueNilCheck.addElseBody(streamValueErrorCheck);

        nextBody.addIfElseStatement(streamValueNilCheck.getIfElseStatementNode());

        FunctionDefinition next = new FunctionDefinition("next",
                nextSignature.getFunctionSignature(), nextBody.getFunctionBody());
        next.addQualifiers(new String[]{"public", "isolated"});
        serverStream.addMember(next.getFunctionDefinitionNode());
        serverStream.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature closeSignature = new FunctionSignature();
        closeSignature.addReturns(Returns.getReturnTypeDescriptorNode(SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody closeBody = new FunctionBody();
        closeBody.addReturnStatement(getMethodCallExpressionNode(getFieldAccessExpressionNode("self", "anydataStream"), "close", new String[]{}));
        FunctionDefinition close = new FunctionDefinition("close",
                closeSignature.getFunctionSignature(), closeBody.getFunctionBody());
        close.addQualifiers(new String[]{"public", "isolated"});
        serverStream.addMember(close.getFunctionDefinitionNode());

        return serverStream;
    }

    private static Class getCallerClass(String key) {
        Class caller = new Class(key, true);
        caller.addQualifiers(new String[]{"client"});

        caller.addMember(getObjectFieldNode("private", new String[]{}, getQualifiedNameReferenceNode("grpc", "Caller"), "caller"));
        caller.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature initSignature = new FunctionSignature();
        initSignature.addParameter(getRequiredParamNode(TypeDescriptor.getQualifiedNameReferenceNode("grpc", "Caller"), "caller"));
        FunctionBody initBody = new FunctionBody();
        initBody.addAssignmentStatement(getFieldAccessExpressionNode("self", "caller"), getSimpleNameReferenceNode("caller"));
        FunctionDefinition initDefinition = new FunctionDefinition("init",
                initSignature.getFunctionSignature(), initBody.getFunctionBody());
        initDefinition.addQualifiers(new String[]{"public", "isolated"});
        caller.addMember(initDefinition.getFunctionDefinitionNode());
        caller.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature getIdSignature = new FunctionSignature();
        getIdSignature.addReturns(Returns.getReturnTypeDescriptorNode(NodeFactory.createBuiltinSimpleNameReferenceNode(SyntaxKind.INT_TYPE_DESC, AbstractNodeFactory.createIdentifierToken("int"))));
        FunctionBody getIdBody = new FunctionBody();
        getIdBody.addReturnStatement(getMethodCallExpressionNode(getFieldAccessExpressionNode("self", "caller"), "getId", new String[]{}));
        FunctionDefinition getIdDefinition = new FunctionDefinition("getId",
                getIdSignature.getFunctionSignature(), getIdBody.getFunctionBody());
        getIdDefinition.addQualifiers(new String[]{"public", "isolated"});
        caller.addMember(getIdDefinition.getFunctionDefinitionNode());
        caller.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature sendStringSignature = new FunctionSignature();
        sendStringSignature.addParameter(getRequiredParamNode(SYNTAX_TREE_VAR_STRING, "response"));
        sendStringSignature.addReturns(Returns.getReturnTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody sendStringBody = new FunctionBody();
        sendStringBody.addReturnStatement(getRemoteMethodCallActionNode(getFieldAccessExpressionNode("self", "caller"), "send", new String[]{"response"}));
        FunctionDefinition sendStringDefinition = new FunctionDefinition("sendString",
                sendStringSignature.getFunctionSignature(), sendStringBody.getFunctionBody());
        sendStringDefinition.addQualifiers(new String[]{"isolated", "remote"});
        caller.addMember(sendStringDefinition.getFunctionDefinitionNode());
        caller.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature sendContextStringSignature = new FunctionSignature();
        sendContextStringSignature.addParameter(getRequiredParamNode(SyntaxTreeConstants.SYNTAX_TREE_CONTEXT_STRING, "response"));
        sendContextStringSignature.addReturns(Returns.getReturnTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody sendContextStringBody = new FunctionBody();
        sendContextStringBody.addReturnStatement(getRemoteMethodCallActionNode(getFieldAccessExpressionNode("self", "caller"), "send", new String[]{"response"}));
        FunctionDefinition sendContextStringDefinition = new FunctionDefinition("sendContextString",
                sendContextStringSignature.getFunctionSignature(), sendContextStringBody.getFunctionBody());
        sendContextStringDefinition.addQualifiers(new String[]{"isolated", "remote"});
        caller.addMember(sendContextStringDefinition.getFunctionDefinitionNode());
        caller.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature sendErrorSignature = new FunctionSignature();
        sendErrorSignature.addParameter(getRequiredParamNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR, "response"));
        sendErrorSignature.addReturns(Returns.getReturnTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody sendErrorBody = new FunctionBody();
        sendErrorBody.addReturnStatement(getRemoteMethodCallActionNode(getFieldAccessExpressionNode("self", "caller"), "sendError", new String[]{"response"}));
        FunctionDefinition sendErrorDefinition = new FunctionDefinition("sendError",
                sendErrorSignature.getFunctionSignature(), sendErrorBody.getFunctionBody());
        sendErrorDefinition.addQualifiers(new String[]{"isolated", "remote"});
        caller.addMember(sendErrorDefinition.getFunctionDefinitionNode());
        caller.addMember(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);

        FunctionSignature completeSignature = new FunctionSignature();
        completeSignature.addReturns(Returns.getReturnTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody completeBody = new FunctionBody();
        completeBody.addReturnStatement(getRemoteMethodCallActionNode(getFieldAccessExpressionNode("self", "caller"), "complete", new String[]{}));
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
