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

package org.ballerinalang.net.grpc.builder.syntaxtree.utils;

import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import org.ballerinalang.net.grpc.builder.stub.Method;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Class;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionBody;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionDefinition;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionSignature;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Map;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Returns;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.VariableDeclaration;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getExplicitNewExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getRemoteMethodCallActionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionParam.getRequiredParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Initializer.getCheckExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getListBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getObjectFieldNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getParameterizedTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getQualifiedNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTupleTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY;

public class Client {

    public static FunctionDefinition getStreamingClientFunction(Method method, boolean bidirectional) {
        String methodName = bidirectional? "executeBidirectionalStreaming" : "executeClientStreaming";
        String clientName = method.getMethodName().substring(0,1).toUpperCase() + method.getMethodName().substring(1)
                + "StreamingClient";
        FunctionSignature signature = new FunctionSignature();
        signature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        Returns.getParenthesisedTypeDescriptorNode(
                                getUnionTypeDescriptorNode(
                                        getSimpleNameReferenceNode(clientName),
                                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR))));
        FunctionBody body = new FunctionBody();
        VariableDeclaration sClient = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getQualifiedNameReferenceNode("grpc", "StreamingClient"),
                        getCaptureBindingPatternNode("sClient")),
                getCheckExpressionNode(
                        getRemoteMethodCallActionNode(
                                getFieldAccessExpressionNode("self", "grpcClient"),
                                methodName,
                                new String[]{"\"" + method.getMethodId() +  "\""}
                        )
                )
        );
        body.addVariableStatement(sClient.getVariableDeclarationNode());
        body.addReturnStatement(getExplicitNewExpressionNode(clientName, new String[]{"sClient"}));
        FunctionDefinition definition = new FunctionDefinition(
                method.getMethodName(),
                signature.getFunctionSignature(),
                body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    public static Class getStreamingClientClass(Method method) {
        String name = method.getMethodName().substring(0, 1).toUpperCase() + method.getMethodName().substring(1) +
                "StreamingClient";
        Class streamingClient = new Class(name, true);
        String inputType = method.getInputType().substring(0, 1).toUpperCase() + method.getInputType().substring(1);
        String outputType = method.getOutputType().substring(0, 1).toUpperCase() + method.getOutputType().substring(1);
        streamingClient.addQualifiers(new String[]{"client"});

        streamingClient.addMember(
                getObjectFieldNode(
                        "private",
                        new String[]{},
                        getQualifiedNameReferenceNode("grpc", "StreamingClient"),
                        "sClient"));

        FunctionSignature initSignature = new FunctionSignature();
        initSignature.addParameter(
                getRequiredParamNode(
                        TypeDescriptor.getQualifiedNameReferenceNode("grpc", "StreamingClient"),
                        "sClient"));
        FunctionBody initBody = new FunctionBody();
        initBody.addAssignmentStatement(
                getFieldAccessExpressionNode("self", "sClient"),
                getSimpleNameReferenceNode("sClient"));
        FunctionDefinition initDefinition = new FunctionDefinition(
                "init",
                initSignature.getFunctionSignature(),
                initBody.getFunctionBody());
        initDefinition.addQualifiers(new String[]{"isolated"});
        streamingClient.addMember(initDefinition.getFunctionDefinitionNode());

        FunctionSignature sendSignature = new FunctionSignature();
        sendSignature.addParameter(
                getRequiredParamNode(
                        getSimpleNameReferenceNode(method.getInputType()),
                        "message"));
        sendSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody sendBody = new FunctionBody();
        sendBody.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "sClient"),
                        "send",
                        new String[]{"message"}));
        FunctionDefinition sendDefinition = new FunctionDefinition(
                "send" + inputType,
                sendSignature.getFunctionSignature(),
                sendBody.getFunctionBody());
        sendDefinition.addQualifiers(new String[]{"isolated", "remote"});
        streamingClient.addMember(sendDefinition.getFunctionDefinitionNode());

        FunctionSignature sendContextSignature = new FunctionSignature();
        sendContextSignature.addParameter(
                getRequiredParamNode(
                        getSimpleNameReferenceNode("Context" + inputType),
                        "message"));
        sendContextSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody sendContextBody = new FunctionBody();
        sendContextBody.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "sClient"),
                        "send",
                        new String[]{"message"}));
        FunctionDefinition sendContextDefinition = new FunctionDefinition(
                "sendContext" + inputType,
                sendContextSignature.getFunctionSignature(),
                sendContextBody.getFunctionBody());
        sendContextDefinition.addQualifiers(new String[]{"isolated", "remote"});
        streamingClient.addMember(sendContextDefinition.getFunctionDefinitionNode());

        SeparatedNodeList<Node> receiveArgs = NodeFactory.createSeparatedNodeList(
                getBuiltinSimpleNameReferenceNode("anydata"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getParameterizedTypeDescriptorNode("map", getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_VAR_STRING_ARRAY))
        );
        VariableDeclaration receive = new VariableDeclaration(getTypedBindingPatternNode(getTupleTypeDescriptorNode(receiveArgs), getListBindingPatternNode(new String[]{"payload", "headers"})), getCheckExpressionNode(getRemoteMethodCallActionNode(getFieldAccessExpressionNode("self", "sClient"), "receive", new String[]{})));

        FunctionSignature receiveSignature = new FunctionSignature();
        receiveSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        TypeDescriptor.getUnionTypeDescriptorNode(
                                getSimpleNameReferenceNode(method.getOutputType()),
                                SYNTAX_TREE_GRPC_ERROR)));
        FunctionBody receiveBody = new FunctionBody();
        receiveBody.addVariableStatement(receive.getVariableDeclarationNode());
        receiveBody.addReturnStatement(
                getMethodCallExpressionNode(
                        getSimpleNameReferenceNode("payload"),
                        "toString",
                        new String[]{}));
        FunctionDefinition receiveDefinition = new FunctionDefinition(
                "receive" + outputType,
                receiveSignature.getFunctionSignature(),
                receiveBody.getFunctionBody());
        receiveDefinition.addQualifiers(new String[]{"isolated", "remote"});
        streamingClient.addMember(receiveDefinition.getFunctionDefinitionNode());

        FunctionSignature receiveContextSignature = new FunctionSignature();
        receiveContextSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        TypeDescriptor.getUnionTypeDescriptorNode(
                                getSimpleNameReferenceNode("Context" + outputType),
                                SYNTAX_TREE_GRPC_ERROR)));
        FunctionBody receiveContextBody = new FunctionBody();
        receiveContextBody.addVariableStatement(receive.getVariableDeclarationNode());
        Map returnMap = new Map();
        returnMap.addMethodCallField(
                "content",
                getSimpleNameReferenceNode("payload"),
                "toString",
                new String[]{});
        returnMap.addSimpleNameReferenceField("headers", "headers");
        receiveContextBody.addReturnStatement(returnMap.getMappingConstructorExpressionNode());
        FunctionDefinition receiveContextDefinition = new FunctionDefinition(
                "receiveContext" + outputType,
                receiveContextSignature.getFunctionSignature(),
                receiveContextBody.getFunctionBody());
        receiveContextDefinition.addQualifiers(new String[]{"isolated", "remote"});
        streamingClient.addMember(receiveContextDefinition.getFunctionDefinitionNode());

        FunctionSignature sendErrorSignature = new FunctionSignature();
        sendErrorSignature.addParameter(
                getRequiredParamNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR,
                        "response"));
        sendErrorSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody sendErrorBody = new FunctionBody();
        sendErrorBody.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "sClient"),
                        "sendError",
                        new String[]{"response"}));
        FunctionDefinition sendErrorDefinition = new FunctionDefinition(
                "sendError",
                sendErrorSignature.getFunctionSignature(),
                sendErrorBody.getFunctionBody());
        sendErrorDefinition.addQualifiers(new String[]{"isolated", "remote"});
        streamingClient.addMember(sendErrorDefinition.getFunctionDefinitionNode());

        FunctionSignature completeSignature = new FunctionSignature();
        completeSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody completeBody = new FunctionBody();
        completeBody.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "sClient"),
                        "complete",
                        new String[]{}));
        FunctionDefinition completeDefinition = new FunctionDefinition(
                "complete",
                completeSignature.getFunctionSignature(),
                completeBody.getFunctionBody());
        completeDefinition.addQualifiers(new String[]{"isolated", "remote"});
        streamingClient.addMember(completeDefinition.getFunctionDefinitionNode());

        return streamingClient;
    }
}
