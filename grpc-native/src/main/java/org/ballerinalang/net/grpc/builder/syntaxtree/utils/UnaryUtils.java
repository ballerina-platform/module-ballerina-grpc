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
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Returns;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.VariableDeclaration;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getRemoteMethodCallActionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionParam.getRequiredParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getBracedExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getTypeTestExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Initializer.getCheckExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getListBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getParameterizedTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTupleTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypeCastExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CommonUtils.capitalize;

public class UnaryUtils {

    public static Function getUnaryFunction(Method method) {
        Function function = new Function(method.getMethodName());
        String inputCap = capitalize(method.getInputType());
        function.addParameter(
                getRequiredParamNode(
                        getUnionTypeDescriptorNode(
                                getSimpleNameReferenceNode(method.getInputType()),
                                getSimpleNameReferenceNode("Context" + inputCap)),
                        "req"));
        function.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        Returns.getParenthesisedTypeDescriptorNode(
                                getUnionTypeDescriptorNode(
                                        getSimpleNameReferenceNode(method.getOutputType()),
                                        SYNTAX_TREE_GRPC_ERROR))));
        addUnaryBody(function, inputCap, method);
        SeparatedNodeList<Node> payloadArgs = NodeFactory.createSeparatedNodeList(
                getBuiltinSimpleNameReferenceNode("anydata"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getParameterizedTypeDescriptorNode(
                        "map",
                        getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_VAR_STRING_ARRAY))
        );
        VariableDeclaration payload = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getTupleTypeDescriptorNode(payloadArgs),
                        getListBindingPatternNode(new String[]{"result", "_"})),
                getSimpleNameReferenceNode("payload")
        );
        function.addVariableStatement(payload.getVariableDeclarationNode());
        addUnaryFunctionReturnStatement(function, method);
        function.addQualifiers(new String[]{"isolated", "remote"});
        return function;
    }

    public static Function getUnaryContextFunction(Method method) {
        String inputCap = method.getInputType().substring(0, 1).toUpperCase() + method.getInputType().substring(1);
        String outCap = method.getOutputType().substring(0, 1).toUpperCase() + method.getOutputType().substring(1);
        Function function = new Function(method.getMethodName() + "Context");
        function.addParameter(
                getRequiredParamNode(
                        getUnionTypeDescriptorNode(
                                getSimpleNameReferenceNode(method.getInputType()),
                                getSimpleNameReferenceNode("Context" + inputCap)),
                        "req"));
        function.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        Returns.getParenthesisedTypeDescriptorNode(
                                getUnionTypeDescriptorNode(
                                        getSimpleNameReferenceNode("Context" + outCap),
                                        SYNTAX_TREE_GRPC_ERROR))));
        addUnaryBody(function, inputCap, method);
        SeparatedNodeList<Node> payloadArgs = NodeFactory.createSeparatedNodeList(
                getBuiltinSimpleNameReferenceNode("anydata"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getParameterizedTypeDescriptorNode(
                        "map",
                        getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_VAR_STRING_ARRAY))
        );
        VariableDeclaration payload = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getTupleTypeDescriptorNode(payloadArgs),
                        getListBindingPatternNode(new String[]{"result", "respHeaders"})),
                getSimpleNameReferenceNode("payload")
        );
        function.addVariableStatement(payload.getVariableDeclarationNode());
        addUnaryContextFunctionReturnStatement(function, method);
        function.addQualifiers(new String[]{"isolated", "remote"});
        return function;
    }

    private static void addUnaryBody(Function function, String inputCap, Method method) {
        VariableDeclaration headers = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getParameterizedTypeDescriptorNode(
                                "map",
                                getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_VAR_STRING_ARRAY)),
                        getCaptureBindingPatternNode("headers")),
                new Map().getMappingConstructorExpressionNode()
        );
        function.addVariableStatement(headers.getVariableDeclarationNode());
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
        reqIsContext.addIfAssignmentStatement(
                "message",
                getFieldAccessExpressionNode("req", "content"));
        reqIsContext.addIfAssignmentStatement(
                "headers",
                getFieldAccessExpressionNode("req", "headers"));
        reqIsContext.addElseBody();
        reqIsContext.addElseAssignmentStatement(
                "message",
                getSimpleNameReferenceNode("req")
        );
        function.addIfElseStatement(reqIsContext.getIfElseStatementNode());

        VariableDeclaration payload = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getBuiltinSimpleNameReferenceNode("var"),
                        getCaptureBindingPatternNode("payload")),
                getCheckExpressionNode(
                        getRemoteMethodCallActionNode(
                                getFieldAccessExpressionNode("self", "grpcClient"),
                                "executeSimpleRPC",
                                new String[]{"\"" + method.getMethodId() +  "\"", "message", "headers"}
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
        returnMap.addSimpleNameReferenceField("headers", "respHeaders");
        function.addReturnStatement(returnMap.getMappingConstructorExpressionNode());
    }
}
