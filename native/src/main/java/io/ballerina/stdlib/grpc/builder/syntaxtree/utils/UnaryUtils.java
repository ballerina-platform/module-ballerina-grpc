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

package io.ballerina.stdlib.grpc.builder.syntaxtree.utils;

import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.stdlib.grpc.builder.stub.Method;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Function;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Map;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.VariableDeclaration;
import io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getListBindingPatternNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getMapTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getSimpleNameReferenceNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getTupleTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getTypeCastExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.addClientCallBody;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.capitalize;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.getProtobufType;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.isBallerinaProtobufType;

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
            switch (method.getInputType()) {
                case "byte[]":
                    inputCap = "Bytes";
                    break;
                case "time:Utc":
                    inputCap = "Timestamp";
                    break;
                case "time:Seconds":
                    inputCap = "Duration";
                    break;
                case "map<anydata>":
                    inputCap = "Struct";
                    break;
                case "'any:Any":
                    inputCap = "Any";
                    break;
                default:
                    inputCap = capitalize(method.getInputType());
                    break;
            }
            String contextParam = "Context" + inputCap;
            if (isBallerinaProtobufType(method.getInputType())) {
                contextParam = getProtobufType(method.getInputType()) + ":" + contextParam;
            }
            function.addRequiredParameter(
                    getUnionTypeDescriptorNode(
                            getSimpleNameReferenceNode(
                                    method.getInputType()
                            ),
                            getSimpleNameReferenceNode(contextParam)
                    ),
                    "req"
            );
        }
        if (method.getOutputType() != null) {
            function.addReturns(
                    getUnionTypeDescriptorNode(
                            getSimpleNameReferenceNode(
                                    method.getOutputType()
                            ),
                            SYNTAX_TREE_GRPC_ERROR
                    )
            );
        } else {
            function.addReturns(
                    SYNTAX_TREE_GRPC_ERROR_OPTIONAL
            );
        }
        addClientCallBody(function, inputCap, method);
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
        String outCap;
        if (method.getInputType() != null) {
            switch (method.getInputType()) {
                case "byte[]":
                    inputCap = "Bytes";
                    break;
                case "time:Utc":
                    inputCap = "Timestamp";
                    break;
                case "time:Seconds":
                    inputCap = "Duration";
                    break;
                case "map<anydata>":
                    inputCap = "Struct";
                    break;
                case "'any:Any":
                    inputCap = "Any";
                    break;
                default:
                    inputCap = capitalize(method.getInputType());
                    break;
            }
            String contextParam = "Context" + inputCap;
            if (isBallerinaProtobufType(method.getInputType())) {
                contextParam = getProtobufType(method.getInputType()) + ":" + contextParam;
            }
            function.addRequiredParameter(
                    getUnionTypeDescriptorNode(
                            getSimpleNameReferenceNode(method.getInputType()),
                            getSimpleNameReferenceNode(contextParam)
                    ),
                    "req"
            );
        }
        String contextParam;
        if (method.getOutputType() != null) {
            switch (method.getOutputType()) {
                case "byte[]":
                    outCap = "Bytes";
                    break;
                case "time:Utc":
                    outCap = "Timestamp";
                    break;
                case "time:Seconds":
                    outCap = "Duration";
                    break;
                case "map<anydata>":
                    outCap = "Struct";
                    break;
                case "'any:Any":
                    outCap = "Any";
                    break;
                default:
                    outCap = capitalize(method.getOutputType());
                    break;
            }
            contextParam = "Context" + outCap;
            if (isBallerinaProtobufType(method.getOutputType())) {
                contextParam = getProtobufType(method.getOutputType()) + ":" + contextParam;
            }
        } else {
            contextParam = "empty:ContextNil";
        }
        function.addReturns(
                getUnionTypeDescriptorNode(
                        getSimpleNameReferenceNode(contextParam),
                        SYNTAX_TREE_GRPC_ERROR
                )
        );
        addClientCallBody(function, inputCap, method);
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

    private static void addUnaryFunctionReturnStatement(Function function, Method method) {
        if (method.getOutputType().equals("string")) {
            function.addReturnStatement(
                    getMethodCallExpressionNode(
                            getSimpleNameReferenceNode("result"),
                            "toString",
                            new String[]{}
                    )
            );
        } else if (method.getOutputType().equals("time:Utc")) {
            function.addReturnStatement(
                    getTypeCastExpressionNode(
                            method.getOutputType(),
                            getMethodCallExpressionNode(
                                    getSimpleNameReferenceNode("result"),
                                    "cloneReadOnly",
                                    new String[]{}
                            )
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
            } else if (method.getOutputType().equals("time:Utc")) {
                returnMap.addTypeCastExpressionField(
                        "content",
                        method.getOutputType(),
                        getMethodCallExpressionNode(
                                getSimpleNameReferenceNode("result"),
                                "cloneReadOnly",
                                new String[]{}
                        )
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
