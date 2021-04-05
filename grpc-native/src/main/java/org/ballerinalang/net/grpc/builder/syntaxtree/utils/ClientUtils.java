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
import io.ballerina.compiler.syntax.tree.TypedBindingPatternNode;
import org.ballerinalang.net.grpc.builder.stub.Method;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Class;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionBody;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionDefinition;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionSignature;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse;
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
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getNilTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getTypeTestExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Initializer.getCheckExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Statement.getReturnStatementNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getListBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getObjectFieldNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getParameterizedTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getQualifiedNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTupleTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypeCastExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CommonUtils.getCapitalized;

public class ClientUtils {

    public static FunctionDefinition getStreamingClientFunction(Method method, boolean bidirectional) {
        String methodName = bidirectional? "executeBidirectionalStreaming" : "executeClientStreaming";
        String clientName = getCapitalized(method.getMethodName()) + "StreamingClient";
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
        streamingClient.addQualifiers(new String[]{"client"});

        streamingClient.addMember(
                getObjectFieldNode(
                        "private",
                        new String[]{},
                        getQualifiedNameReferenceNode("grpc", "StreamingClient"),
                        "sClient"));

        streamingClient.addMember(getInitFunction().getFunctionDefinitionNode());

        streamingClient.addMember(getSendFunction(method).getFunctionDefinitionNode());

        streamingClient.addMember(getSendContextFunction(method).getFunctionDefinitionNode());

        streamingClient.addMember(getReceiveFunction(method).getFunctionDefinitionNode());

        streamingClient.addMember(getReceiveContextFunction(method).getFunctionDefinitionNode());

        streamingClient.addMember(getSendErrorFunction().getFunctionDefinitionNode());

        streamingClient.addMember(getCompleteFunction().getFunctionDefinitionNode());

        return streamingClient;
    }

    private static FunctionDefinition getInitFunction() {
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(
                getRequiredParamNode(
                        TypeDescriptor.getQualifiedNameReferenceNode("grpc", "StreamingClient"),
                        "sClient"));
        FunctionBody body = new FunctionBody();
        body.addAssignmentStatement(
                getFieldAccessExpressionNode("self", "sClient"),
                getSimpleNameReferenceNode("sClient"));
        FunctionDefinition definition = new FunctionDefinition(
                "init",
                signature.getFunctionSignature(),
                body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated"});
        return definition;
    }

    private static FunctionDefinition getSendFunction(Method method) {
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(
                getRequiredParamNode(
                        getSimpleNameReferenceNode(method.getInputType()),
                        "message"));
        signature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody body = new FunctionBody();
        body.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "sClient"),
                        "send",
                        new String[]{"message"}));
        FunctionDefinition definition = new FunctionDefinition(
                "send" + getCapitalized(method.getInputType()),
                signature.getFunctionSignature(),
                body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    private static FunctionDefinition getSendContextFunction(Method method) {
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(
                getRequiredParamNode(
                        getSimpleNameReferenceNode("Context" + getCapitalized(method.getInputType())),
                        "message"));
        signature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody body = new FunctionBody();
        body.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "sClient"),
                        "send",
                        new String[]{"message"}));
        FunctionDefinition definition = new FunctionDefinition(
                "sendContext" + getCapitalized(method.getInputType()),
                signature.getFunctionSignature(),
                body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    private static FunctionDefinition getReceiveFunction(Method method) {
        SeparatedNodeList<Node> receiveArgs = NodeFactory.createSeparatedNodeList(
                getBuiltinSimpleNameReferenceNode("anydata"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getParameterizedTypeDescriptorNode("map", getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_VAR_STRING_ARRAY))
        );
        TypedBindingPatternNode receiveArgsPattern = getTypedBindingPatternNode(
                getTupleTypeDescriptorNode(receiveArgs),
                getListBindingPatternNode(new String[]{"payload", "headers"}));
        FunctionSignature signature = new FunctionSignature();
        signature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        TypeDescriptor.getUnionTypeDescriptorNode(
                                getSimpleNameReferenceNode(method.getOutputType()),
                                SYNTAX_TREE_GRPC_ERROR_OPTIONAL)));

        FunctionBody body = new FunctionBody();
        if (method.getOutputType().equals("string")) {
            VariableDeclaration receive = new VariableDeclaration(
                    receiveArgsPattern,
                    getCheckExpressionNode(
                            getRemoteMethodCallActionNode(
                                    getFieldAccessExpressionNode("self", "sClient"),
                                    "receive", new String[]{}))
            );
            body.addVariableStatement(receive.getVariableDeclarationNode());
            body.addReturnStatement(
                    getMethodCallExpressionNode(
                            getSimpleNameReferenceNode("payload"),
                            "toString",
                            new String[]{}));
        } else {
            VariableDeclaration response = new VariableDeclaration(
                    getTypedBindingPatternNode(
                            getBuiltinSimpleNameReferenceNode("var"),
                            getCaptureBindingPatternNode("response")
                    ),
                    getCheckExpressionNode(
                            getRemoteMethodCallActionNode(
                                  getFieldAccessExpressionNode("self", "sClient"),
                                  "receive",
                                  new String[]{}
                            )
                    )
            );
            body.addVariableStatement(response.getVariableDeclarationNode());
            IfElse responseCheck = new IfElse(
                    getTypeTestExpressionNode(
                            getSimpleNameReferenceNode("response"),
                            getNilTypeDescriptorNode()
                    )
            );
            responseCheck.addIfStatement(
                    getReturnStatementNode(
                            getSimpleNameReferenceNode("response")
                    )
            );
            responseCheck.addElseVariableDeclarationStatement(
                    new VariableDeclaration(
                            receiveArgsPattern,
                            getSimpleNameReferenceNode("response")
                    ).getVariableDeclarationNode());
            responseCheck.addElseReturnStatement(
                    getTypeCastExpressionNode(
                            method.getOutputType(),
                            getSimpleNameReferenceNode("payload")
                    )
            );
            body.addIfElseStatement(responseCheck.getIfElseStatementNode());
        }
        FunctionDefinition definition = new FunctionDefinition(
                "receive" + getCapitalized(method.getOutputType()),
                signature.getFunctionSignature(),
                body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    private static FunctionDefinition getReceiveContextFunction(Method method) {
        SeparatedNodeList<Node> receiveArgs = NodeFactory.createSeparatedNodeList(
                getBuiltinSimpleNameReferenceNode("anydata"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getParameterizedTypeDescriptorNode("map", getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_VAR_STRING_ARRAY))
        );
        TypedBindingPatternNode receiveArgsPattern = getTypedBindingPatternNode(
                getTupleTypeDescriptorNode(receiveArgs),
                getListBindingPatternNode(new String[]{"payload", "headers"}));
        FunctionSignature signature = new FunctionSignature();
        signature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        TypeDescriptor.getUnionTypeDescriptorNode(
                                getSimpleNameReferenceNode("Context" + getCapitalized(method.getOutputType())),
                                SYNTAX_TREE_GRPC_ERROR_OPTIONAL)));
        FunctionBody body = new FunctionBody();
        if (method.getOutputType().equals("string")) {
            VariableDeclaration receive = new VariableDeclaration(
                    receiveArgsPattern,
                    getCheckExpressionNode(
                            getRemoteMethodCallActionNode(
                                    getFieldAccessExpressionNode("self", "sClient"),
                                    "receive", new String[]{}))
            );
            body.addVariableStatement(receive.getVariableDeclarationNode());
            Map returnMap = new Map();
            returnMap.addMethodCallField(
                    "content",
                    getSimpleNameReferenceNode("payload"),
                    "toString",
                    new String[]{});
            returnMap.addSimpleNameReferenceField("headers", "headers");
            body.addReturnStatement(returnMap.getMappingConstructorExpressionNode());
        } else {
            VariableDeclaration response = new VariableDeclaration(
                    getTypedBindingPatternNode(
                            getBuiltinSimpleNameReferenceNode("var"),
                            getCaptureBindingPatternNode("response")
                    ),
                    getCheckExpressionNode(
                            getRemoteMethodCallActionNode(
                                    getFieldAccessExpressionNode("self", "sClient"),
                                    "receive",
                                    new String[]{}
                            )
                    )
            );
            body.addVariableStatement(response.getVariableDeclarationNode());
            IfElse responseCheck = new IfElse(
                    getTypeTestExpressionNode(
                            getSimpleNameReferenceNode("response"),
                            getNilTypeDescriptorNode()
                    )
            );
            responseCheck.addIfStatement(
                    getReturnStatementNode(
                            getSimpleNameReferenceNode("response")
                    )
            );
            responseCheck.addElseVariableDeclarationStatement(
                    new VariableDeclaration(
                            receiveArgsPattern,
                            getSimpleNameReferenceNode("response")
                    ).getVariableDeclarationNode());
            Map returnMap = new Map();
            returnMap.addTypeCastExpressionField(
                    "content",
                    method.getOutputType(),
                    getSimpleNameReferenceNode("payload")
                    );
            returnMap.addSimpleNameReferenceField("headers", "headers");
            responseCheck.addElseReturnStatement(returnMap.getMappingConstructorExpressionNode());
            body.addIfElseStatement(responseCheck.getIfElseStatementNode());
        }
        FunctionDefinition definition = new FunctionDefinition(
                "receiveContext" + getCapitalized(method.getOutputType()),
                signature.getFunctionSignature(),
                body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    private static FunctionDefinition getSendErrorFunction() {
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(
                getRequiredParamNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR,
                        "response"));
        signature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody body = new FunctionBody();
        body.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "sClient"),
                        "sendError",
                        new String[]{"response"}));
        FunctionDefinition definition = new FunctionDefinition(
                "sendError",
                signature.getFunctionSignature(),
                body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    private static FunctionDefinition getCompleteFunction() {
        FunctionSignature signature = new FunctionSignature();
        signature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody body = new FunctionBody();
        body.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "sClient"),
                        "complete",
                        new String[]{}));
        FunctionDefinition definition = new FunctionDefinition(
                "complete",
                signature.getFunctionSignature(),
                body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }
}
