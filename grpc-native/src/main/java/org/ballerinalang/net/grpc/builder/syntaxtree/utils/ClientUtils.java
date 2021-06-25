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
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Function;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Map;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.VariableDeclaration;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.MethodDescriptor.MethodType.BIDI_STREAMING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getCheckExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getExplicitNewExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getRemoteMethodCallActionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getTypeTestExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Statement.getReturnStatementNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getListBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getMapTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getNilTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getObjectFieldNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getParenthesisedTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getQualifiedNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTupleTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypeCastExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CommonUtils.capitalize;

/**
 * Utility functions related to Client.
 *
 * @since 0.8.0
 */
public class ClientUtils {

    private ClientUtils() {

    }

    public static Function getStreamingClientFunction(Method method) {
        String methodName = method.getMethodType().equals(BIDI_STREAMING) ? "executeBidirectionalStreaming" :
                "executeClientStreaming";
        String clientName = capitalize(method.getMethodName()) + "StreamingClient";
        Function function = new Function(method.getMethodName());
        function.addReturns(
                getParenthesisedTypeDescriptorNode(
                        getUnionTypeDescriptorNode(
                                getSimpleNameReferenceNode(clientName),
                                SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR
                        )
                )
        );
        VariableDeclaration sClient = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getQualifiedNameReferenceNode("grpc", "StreamingClient"),
                        getCaptureBindingPatternNode("sClient")
                ),
                getCheckExpressionNode(
                        getRemoteMethodCallActionNode(
                                getFieldAccessExpressionNode("self", "grpcClient"),
                                methodName,
                                new String[]{"\"" + method.getMethodId() + "\""}
                        )
                )
        );
        function.addVariableStatement(sClient.getVariableDeclarationNode());
        function.addReturnStatement(getExplicitNewExpressionNode(clientName, new String[]{"sClient"}));
        function.addQualifiers(new String[]{"isolated", "remote"});
        return function;
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

    private static Function getInitFunction() {
        Function function = new Function("init");
        function.addRequiredParameter(
                TypeDescriptor.getQualifiedNameReferenceNode("grpc", "StreamingClient"),
                "sClient"
        );
        function.addAssignmentStatement(
                getFieldAccessExpressionNode("self", "sClient"),
                getSimpleNameReferenceNode("sClient")
        );
        function.addQualifiers(new String[]{"isolated"});
        return function;
    }

    private static Function getSendFunction(Method method) {
        String inputCap;
        if (method.getInputType().equals("byte[]")) {
            inputCap = "Bytes";
        } else {
            inputCap = capitalize(method.getInputType());
        }
        Function function = new Function("send" + inputCap);
        function.addRequiredParameter(
                getSimpleNameReferenceNode(method.getInputType()),
                "message"
        );
        function.addReturns(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL);
        function.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "sClient"),
                        "send",
                        new String[]{"message"}
                )
        );
        function.addQualifiers(new String[]{"isolated", "remote"});
        return function;
    }

    private static Function getSendContextFunction(Method method) {
        String inputCap;
        if (method.getInputType().equals("byte[]")) {
            inputCap = "Bytes";
        } else {
            inputCap = capitalize(method.getInputType());
        }
        Function function = new Function("sendContext" + inputCap);
        function.addRequiredParameter(
                getSimpleNameReferenceNode("Context" + inputCap),
                "message"
        );
        function.addReturns(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL);
        function.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "sClient"),
                        "send",
                        new String[]{"message"}
                )
        );
        function.addQualifiers(new String[]{"isolated", "remote"});
        return function;
    }

    private static Function getReceiveFunction(Method method) {
        String functionName = "receive";
        if (method.getOutputType() != null) {
            String outCap;
            if (method.getOutputType().equals("byte[]")) {
                outCap = "Bytes";
            } else {
                outCap = capitalize(method.getOutputType());
            }
            functionName = "receive" + outCap;
        }
        Function function = new Function(functionName);
        SeparatedNodeList<Node> receiveArgs = NodeFactory.createSeparatedNodeList(
                getBuiltinSimpleNameReferenceNode("anydata"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getMapTypeDescriptorNode(
                        getUnionTypeDescriptorNode(
                                SYNTAX_TREE_VAR_STRING,
                                SYNTAX_TREE_VAR_STRING_ARRAY
                        )
                )
        );
        TypedBindingPatternNode receiveArgsPattern = getTypedBindingPatternNode(
                getTupleTypeDescriptorNode(receiveArgs),
                getListBindingPatternNode(new String[]{"payload", "headers"}));
        if (method.getOutputType() != null) {
            function.addReturns(
                    TypeDescriptor.getUnionTypeDescriptorNode(
                            getSimpleNameReferenceNode(method.getOutputType()),
                            SYNTAX_TREE_GRPC_ERROR_OPTIONAL
                    )
            );
        } else {
            function.addReturns(SYNTAX_TREE_GRPC_ERROR_OPTIONAL);
        }
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
        function.addVariableStatement(response.getVariableDeclarationNode());
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
        responseCheck.addElseStatement(
                new VariableDeclaration(
                        receiveArgsPattern,
                        getSimpleNameReferenceNode("response")
                ).getVariableDeclarationNode()
        );
        if (method.getOutputType() != null) {
            if (method.getOutputType().equals("string")) {
                responseCheck.addElseStatement(
                        getReturnStatementNode(
                                getMethodCallExpressionNode(
                                        getSimpleNameReferenceNode("payload"),
                                        "toString",
                                        new String[]{}
                                )
                        )
                );
            } else {
                responseCheck.addElseStatement(
                        getReturnStatementNode(
                                getTypeCastExpressionNode(
                                        method.getOutputType(),
                                        getSimpleNameReferenceNode("payload")
                                )
                        )
                );
            }
        }
        function.addIfElseStatement(responseCheck.getIfElseStatementNode());
        function.addQualifiers(new String[]{"isolated", "remote"});
        return function;
    }

    private static Function getReceiveContextFunction(Method method) {
        String outCap = "Nil";
        if (method.getOutputType() != null) {
            if (method.getOutputType().equals("byte[]")) {
                outCap = "Bytes";
            } else {
                outCap = capitalize(method.getOutputType());
            }
        }
        Function function = new Function("receiveContext" + outCap);
        SeparatedNodeList<Node> receiveArgs = NodeFactory.createSeparatedNodeList(
                getBuiltinSimpleNameReferenceNode("anydata"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getMapTypeDescriptorNode(
                        getUnionTypeDescriptorNode(
                                SYNTAX_TREE_VAR_STRING,
                                SYNTAX_TREE_VAR_STRING_ARRAY
                        )
                )
        );
        TypedBindingPatternNode receiveArgsPattern = getTypedBindingPatternNode(
                getTupleTypeDescriptorNode(receiveArgs),
                getListBindingPatternNode(new String[]{"payload", "headers"})
        );
        function.addReturns(
                TypeDescriptor.getUnionTypeDescriptorNode(
                        getSimpleNameReferenceNode("Context" + outCap),
                        SYNTAX_TREE_GRPC_ERROR_OPTIONAL
                )
        );
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
        function.addVariableStatement(response.getVariableDeclarationNode());
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
        responseCheck.addElseStatement(
                new VariableDeclaration(
                        receiveArgsPattern,
                        getSimpleNameReferenceNode("response")
                ).getVariableDeclarationNode()
        );
        Map returnMap = new Map();
        if (method.getOutputType() != null) {
            if (method.getOutputType().equals("string")) {
                returnMap.addMethodCallField(
                        "content",
                        getSimpleNameReferenceNode("payload"),
                        "toString",
                        new String[]{}
                );
            } else {
                returnMap.addTypeCastExpressionField(
                        "content",
                        method.getOutputType(),
                        getSimpleNameReferenceNode("payload")
                );
            }
        }
        returnMap.addSimpleNameReferenceField("headers", "headers");
        responseCheck.addElseStatement(
                getReturnStatementNode(
                        returnMap.getMappingConstructorExpressionNode()
                )
        );
        function.addIfElseStatement(responseCheck.getIfElseStatementNode());
        function.addQualifiers(new String[]{"isolated", "remote"});
        return function;
    }

    private static Function getSendErrorFunction() {
        Function function = new Function("sendError");
        function.addRequiredParameter(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR, "response");
        function.addReturns(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL);
        function.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "sClient"),
                        "sendError",
                        new String[]{"response"}
                )
        );
        function.addQualifiers(new String[]{"isolated", "remote"});
        return function;
    }

    private static Function getCompleteFunction() {
        Function function = new Function("complete");
        function.addReturns(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL);
        function.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "sClient"),
                        "complete",
                        new String[]{}
                )
        );
        function.addQualifiers(new String[]{"isolated", "remote"});
        return function;
    }
}
