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
import io.ballerina.compiler.syntax.tree.TypeDescriptorNode;
import org.ballerinalang.net.grpc.builder.stub.Method;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Function;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Map;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.VariableDeclaration;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getBracedExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getCheckExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getRemoteMethodCallActionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getTypeTestExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Statement.getAssignmentStatementNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getListBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getMapTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getParenthesisedTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTupleTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypeCastExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CommonUtils.capitalize;

/**
 * Utility functions related to Unary.
 *
 * @since 0.8.0
 */
public class UnaryUtils {

    private UnaryUtils() {

    }

    public static Function getUnaryFunction(Method method) {
        Function function = new Function(method.getMethodName());
        function.addQualifiers(new String[]{"isolated", "remote"});
        String inputCap = "Nil";
        if (method.getInputType() != null) {
            if (method.getInputType().equals("byte[]")) {
                inputCap = "Bytes";
            } else {
                inputCap = capitalize(method.getInputType());
            }
            function.addRequiredParameter(
                    getUnionTypeDescriptorNode(
                            getSimpleNameReferenceNode(method.getInputType()),
                            getSimpleNameReferenceNode("Context" + inputCap)
                    ),
                    "req"
            );
        }
        if (method.getOutputType() != null) {
            function.addReturns(
                    getParenthesisedTypeDescriptorNode(
                            getUnionTypeDescriptorNode(
                                    getSimpleNameReferenceNode(method.getOutputType()),
                                    SYNTAX_TREE_GRPC_ERROR
                            )
                    )
            );
        } else {
            function.addReturns(
                    getParenthesisedTypeDescriptorNode(
                            SYNTAX_TREE_GRPC_ERROR_OPTIONAL
                    )
            );
        }
        addUnaryBody(function, inputCap, method);
        if (method.getOutputType() != null) {
            SeparatedNodeList<Node> payloadArgs = NodeFactory.createSeparatedNodeList(
                    getBuiltinSimpleNameReferenceNode("anydata"),
                    SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                    getMapTypeDescriptorNode(
                            getUnionTypeDescriptorNode(
                                    SYNTAX_TREE_VAR_STRING,
                                    SYNTAX_TREE_VAR_STRING_ARRAY
                            )
                    )
            );
            VariableDeclaration payload = new VariableDeclaration(
                    getTypedBindingPatternNode(
                            getTupleTypeDescriptorNode(payloadArgs),
                            getListBindingPatternNode(new String[]{"result", "_"})),
                    getSimpleNameReferenceNode("payload")
            );
            function.addVariableStatement(payload.getVariableDeclarationNode());
            addUnaryFunctionReturnStatement(function, method);
        }
        return function;
    }

    public static Function getUnaryContextFunction(Method method) {
        Function function = new Function(method.getMethodName() + "Context");
        function.addQualifiers(new String[]{"isolated", "remote"});
        String inputCap = "Nil";
        String outCap = "Nil";
        if (method.getInputType() != null) {
            if (method.getInputType().equals("byte[]")) {
                inputCap = "Bytes";
            } else {
                inputCap = capitalize(method.getInputType());
            }
            function.addRequiredParameter(
                    getUnionTypeDescriptorNode(
                            getSimpleNameReferenceNode(method.getInputType()),
                            getSimpleNameReferenceNode("Context" + inputCap)
                    ),
                    "req"
            );
        }
        if (method.getOutputType() != null) {
            if (method.getOutputType().equals("byte[]")) {
                outCap = "Bytes";
            } else {
                outCap = capitalize(method.getOutputType());
            }
        }
        function.addReturns(
                getParenthesisedTypeDescriptorNode(
                        getUnionTypeDescriptorNode(
                                getSimpleNameReferenceNode("Context" + outCap),
                                SYNTAX_TREE_GRPC_ERROR
                        )
                )
        );
        addUnaryBody(function, inputCap, method);
        SeparatedNodeList<Node> payloadArgs = NodeFactory.createSeparatedNodeList(
                getBuiltinSimpleNameReferenceNode("anydata"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getMapTypeDescriptorNode(
                        getUnionTypeDescriptorNode(
                                SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_VAR_STRING_ARRAY
                        )
                )
        );
        VariableDeclaration payload = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getTupleTypeDescriptorNode(payloadArgs),
                        getListBindingPatternNode(new String[]{"result", "respHeaders"})),
                getSimpleNameReferenceNode("payload")
        );
        function.addVariableStatement(payload.getVariableDeclarationNode());
        addUnaryContextFunctionReturnStatement(function, method);
        return function;
    }

    private static void addUnaryBody(Function function, String inputCap, Method method) {
        if (method.getInputType() == null) {
            Map empty = new Map();
            VariableDeclaration message = new VariableDeclaration(
                    getTypedBindingPatternNode(
                            getSimpleNameReferenceNode("Empty"),
                            getCaptureBindingPatternNode("message")
                    ),
                    empty.getMappingConstructorExpressionNode()
            );
            function.addVariableStatement(message.getVariableDeclarationNode());
        }
        VariableDeclaration headers = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getMapTypeDescriptorNode(
                                getUnionTypeDescriptorNode(
                                        SYNTAX_TREE_VAR_STRING,
                                        SYNTAX_TREE_VAR_STRING_ARRAY
                                )
                        ),
                        getCaptureBindingPatternNode("headers")),
                new Map().getMappingConstructorExpressionNode()
        );
        function.addVariableStatement(headers.getVariableDeclarationNode());
        if (method.getInputType() != null) {
            TypeDescriptorNode messageType;
            if (method.getInputType().equals("string")) {
                messageType = getBuiltinSimpleNameReferenceNode("string");
            } else {
                messageType = getSimpleNameReferenceNode(method.getInputType());
            }
            VariableDeclaration message = new VariableDeclaration(
                    getTypedBindingPatternNode(
                            messageType,
                            getCaptureBindingPatternNode("message")),
                    null
            );
            function.addVariableStatement(message.getVariableDeclarationNode());
            IfElse reqIsContext = new IfElse(
                    getBracedExpressionNode(
                            getTypeTestExpressionNode(
                                    getSimpleNameReferenceNode("req"),
                                    getSimpleNameReferenceNode("Context" + inputCap)
                            )));
            reqIsContext.addIfStatement(
                    getAssignmentStatementNode(
                            "message",
                            getFieldAccessExpressionNode("req", "content")
                    )
            );
            reqIsContext.addIfStatement(
                    getAssignmentStatementNode(
                            "headers",
                            getFieldAccessExpressionNode("req", "headers")
                    )
            );
            reqIsContext.addElseStatement(
                    getAssignmentStatementNode(
                            "message",
                            getSimpleNameReferenceNode("req")
                    )
            );
            function.addIfElseStatement(reqIsContext.getIfElseStatementNode());
        }
        VariableDeclaration payload = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getBuiltinSimpleNameReferenceNode("var"),
                        getCaptureBindingPatternNode("payload")),
                getCheckExpressionNode(
                        getRemoteMethodCallActionNode(
                                getFieldAccessExpressionNode("self", "grpcClient"),
                                "executeSimpleRPC",
                                new String[]{"\"" + method.getMethodId() + "\"", "message", "headers"}
                        )
                )
        );
        function.addVariableStatement(payload.getVariableDeclarationNode());
    }

    private static void addUnaryFunctionReturnStatement(Function function, Method method) {
        if (method.getOutputType().equals("string")) {
            function.addReturnStatement(
                    getMethodCallExpressionNode(
                            getSimpleNameReferenceNode("result"),
                            "toString",
                            new String[]{}
                    )
            );
        } else {
            function.addReturnStatement(
                    getTypeCastExpressionNode(
                            method.getOutputType(),
                            getSimpleNameReferenceNode("result")
                    )
            );
        }
    }

    private static void addUnaryContextFunctionReturnStatement(Function function, Method method) {
        Map returnMap = new Map();
        if (method.getOutputType() != null) {
            if (method.getOutputType().equals("string")) {
                returnMap.addMethodCallField(
                        "content",
                        getSimpleNameReferenceNode("result"),
                        "toString",
                        new String[]{}
                );
            } else {
                returnMap.addTypeCastExpressionField(
                        "content",
                        method.getOutputType(),
                        getSimpleNameReferenceNode("result"));
            }
        }
        returnMap.addSimpleNameReferenceField("headers", "respHeaders");
        function.addReturnStatement(returnMap.getMappingConstructorExpressionNode());
    }
}
