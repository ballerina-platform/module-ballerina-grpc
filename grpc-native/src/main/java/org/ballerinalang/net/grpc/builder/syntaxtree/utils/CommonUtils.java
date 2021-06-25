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

import io.ballerina.compiler.syntax.tree.TypeDescriptorNode;
import org.ballerinalang.net.grpc.builder.stub.Method;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Function;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Map;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.VariableDeclaration;

import static org.ballerinalang.net.grpc.MethodDescriptor.MethodType.UNARY;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getBracedExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getCheckExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getRemoteMethodCallActionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getTypeTestExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Statement.getAssignmentStatementNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getMapTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY;

/**
 * Utility functions common to Syntax tree generation.
 *
 * @since 0.8.0
 */
public class CommonUtils {

    private CommonUtils() {

    }

    public static String capitalize(String name) {
        return name.substring(0, 1).toUpperCase() + name.substring(1);
    }

    public static String capitalizeFirstLetter(String name) {
        return name.substring(0, 1).toUpperCase() + name.substring(1).toLowerCase();
    }

    public static String toPascalCase(String str) {
        StringBuilder pascalCaseOutput = new StringBuilder();
        for (String s : str.split("_")) {
            s = s.replaceAll("[^a-zA-Z0-9]", "");
            pascalCaseOutput.append(capitalize(s));
        }
        return pascalCaseOutput.toString();
    }

    public static boolean isBallerinaBasicType(String type) {
        switch (type) {
            case "string" :
            case "int" :
            case "float" :
            case "boolean" :
            case "bytes" :
                return true;
            default:
                return false;
        }
    }

    public static void addClientCallBody(Function function, String inputCap, Method method) {
        String methodName = method.getMethodType().equals(UNARY) ? "executeSimpleRPC" : "executeServerStreaming";
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
                                methodName,
                                new String[]{"\"" + method.getMethodId() + "\"", "message", "headers"}
                        )
                )
        );
        function.addVariableStatement(payload.getVariableDeclarationNode());
    }
}
