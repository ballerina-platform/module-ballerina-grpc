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

import io.ballerina.compiler.syntax.tree.CheckExpressionNode;
import io.ballerina.compiler.syntax.tree.TypeDescriptorNode;
import io.ballerina.stdlib.grpc.builder.stub.Method;
import io.ballerina.stdlib.grpc.builder.stub.StubFile;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Function;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.IfElse;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Map;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.VariableDeclaration;

import java.util.List;
import java.util.Set;

import static io.ballerina.stdlib.grpc.MethodDescriptor.MethodType.UNARY;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getCheckExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getRemoteMethodCallActionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getTypeTestExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Statement.getAssignmentStatementNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getMapTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getSimpleNameReferenceNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getWildcardBindingPatternNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY;

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

    public static boolean isBallerinaProtobufType(String type) {
        if (type == null) {
            return true;
        }
        switch (type) {
            case "string" :
            case "int" :
            case "float" :
            case "boolean" :
            case "byte[]" :
            case "time:Utc" :
            case "time:Seconds" :
            case "map<anydata>" :
            case "'any:Any" :
                return true;
            default:
                return false;
        }
    }

    public static String getProtobufType(String type) {
        if (type == null) {
            return "empty";
        }
        switch (type) {
            case "string" :
            case "int" :
            case "float" :
            case "boolean" :
            case "byte[]" :
                return "wrappers";
            case "time:Utc" :
                return "timestamp";
            case "time:Seconds" :
                return "duration";
            case "map<anydata>" :
                return "struct";
            case "'any:Any" :
                return "'any";
            default:
                return "";
        }
    }

    public static void addClientCallBody(Function function, String inputCap, Method method) {
        String methodName = method.getMethodType().equals(UNARY) ? "executeSimpleRPC" : "executeServerStreaming";
        if (method.getInputType() == null) {
            Map empty = new Map();
            VariableDeclaration message = new VariableDeclaration(
                    getTypedBindingPatternNode(
                            getSimpleNameReferenceNode("empty:Empty"),
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
            String contextParam = "Context" + inputCap;
            if (isBallerinaProtobufType(method.getInputType())) {
                contextParam = getProtobufType(method.getInputType()) + ":" + contextParam;
            }
            IfElse reqIsContext = new IfElse(
                    getTypeTestExpressionNode(
                            getSimpleNameReferenceNode("req"),
                            getSimpleNameReferenceNode(contextParam)
                    ));
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
        CheckExpressionNode checkExpressionNode = getCheckExpressionNode(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "grpcClient"),
                        methodName,
                        new String[]{"\"" + method.getMethodId() + "\"", "message", "headers"}
                )
        );
        if (method.getOutputType() == null && !function.getFunctionDefinitionNode()
                .functionName().toString().endsWith("Context")) {
            function.addAssignmentStatement(
                getWildcardBindingPatternNode(),
                checkExpressionNode
            );
        } else {
            VariableDeclaration payload = new VariableDeclaration(
                getTypedBindingPatternNode(
                    getBuiltinSimpleNameReferenceNode("var"),
                    getCaptureBindingPatternNode("payload")
                ),
                checkExpressionNode
            );
            function.addVariableStatement(payload.getVariableDeclarationNode());
        }
    }

    public static boolean checkForImportsInServices(List<Method> methodList, String type) {
        for (Method method : methodList) {
            if (isType(method.getInputType(), type) || isType(method.getOutputType(), type)) {
                return true;
            }
        }
        return false;
    }

    public static boolean isType(String methodType, String type) {
        return methodType != null && methodType.equals(type);
    }

    public static void addImports(StubFile stubFile, Set<String> ballerinaImports, Set<String> protobufImports) {
        for (String protobufImport : stubFile.getImportList()) {
            switch (protobufImport) {
                case "google/protobuf/wrappers.proto" :
                    protobufImports.add("wrappers");
                    break;
                case "google/protobuf/timestamp.proto" :
                case "google/protobuf/duration.proto" :
                    ballerinaImports.add("time");
                    break;
                case "google/protobuf/any.proto" :
                    protobufImports.add("'any");
                    break;
                case "google/protobuf/empty.proto" :
                    protobufImports.add("empty");
                    break;
                default:
                    break;
            }
        }
    }
}
