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
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Class;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Function;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.IfElse;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Map;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Record;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.VariableDeclaration;
import io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getBracedExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getExplicitNewExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getTypeTestExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Statement.getReturnStatementNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getListBindingPatternNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getMapTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getNilTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getObjectFieldNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getSimpleNameReferenceNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getStreamTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getTupleTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.addClientCallBody;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.capitalize;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.getProtobufType;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.isBallerinaProtobufType;

/**
 * Utility functions related to Server.
 *
 * @since 0.8.0
 */
public class ServerUtils {

    private ServerUtils() {

    }

    public static Function getServerStreamingFunction(Method method) {
        Function function = new Function(method.getMethodName());
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
                            getSimpleNameReferenceNode(method.getInputType()),
                            getSimpleNameReferenceNode(contextParam)
                    ),
                    "req"
            );
        }
        String outCap;
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
        function.addReturns(
                getUnionTypeDescriptorNode(
                        getStreamTypeDescriptorNode(
                                getSimpleNameReferenceNode(method.getOutputType()),
                                SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL
                        ),
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR
                )
        );
        addServerBody(function, method, inputCap, outCap, "_");
        function.addReturnStatement(
                getExplicitNewExpressionNode(
                        getStreamTypeDescriptorNode(
                                getSimpleNameReferenceNode(method.getOutputType()),
                                SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL
                        ),
                        new String[]{"outputStream"}
                )
        );
        function.addQualifiers(new String[]{"isolated", "remote"});
        return function;
    }

    public static Function getServerStreamingContextFunction(Method method) {
        Function function = new Function(method.getMethodName() + "Context");
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
                            getSimpleNameReferenceNode(method.getInputType()),
                            getSimpleNameReferenceNode(contextParam)
                    ),
                    "req"
            );
        }
        String outputCap;
        switch (method.getOutputType()) {
            case "byte[]":
                outputCap = "Bytes";
                break;
            case "time:Utc":
                outputCap = "Timestamp";
                break;
            case "time:Seconds":
                outputCap = "Duration";
                break;
            case "map<anydata>":
                outputCap = "Struct";
                break;
            case "'any:Any":
                outputCap = "Any";
                break;
            default:
                outputCap = capitalize(method.getOutputType());
                break;
        }
        String contextStreamParam = "Context" + outputCap + "Stream";
        if (isBallerinaProtobufType(method.getOutputType())) {
            contextStreamParam = getProtobufType(method.getOutputType()) + ":" + contextStreamParam;
        }
        function.addReturns(
                getUnionTypeDescriptorNode(
                        getSimpleNameReferenceNode(contextStreamParam),
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR
                )
        );
        addServerBody(function, method, inputCap, outputCap, "respHeaders");
        Map returnMap = new Map();
        returnMap.addField(
                "content",
                getExplicitNewExpressionNode(
                        getStreamTypeDescriptorNode(
                                getSimpleNameReferenceNode(method.getOutputType()),
                                SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL
                        ),
                        new String[]{"outputStream"}
                )
        );
        returnMap.addSimpleNameReferenceField("headers", "respHeaders");
        function.addReturnStatement(returnMap.getMappingConstructorExpressionNode());
        function.addQualifiers(new String[]{"isolated", "remote"});
        return function;
    }

    public static Class getServerStreamClass(Method method) {
        String outputCap;
        switch (method.getOutputType()) {
            case "byte[]":
                outputCap = "Bytes";
                break;
            case "time:Utc":
                outputCap = "Timestamp";
                break;
            case "time:Seconds":
                outputCap = "Duration";
                break;
            case "map<anydata>":
                outputCap = "Struct";
                break;
            case "'any:Any":
                outputCap = "Any";
                break;
            default:
                outputCap = capitalize(method.getOutputType());
                break;
        }
        Class serverStream = new Class(outputCap + "Stream", true);

        serverStream.addMember(
                getObjectFieldNode(
                        "private",
                        new String[]{},
                        getStreamTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_ANYDATA,
                                SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL), "anydataStream"));

        serverStream.addMember(getInitFunction().getFunctionDefinitionNode());

        serverStream.addMember(getNextFunction(method).getFunctionDefinitionNode());

        serverStream.addMember(getCloseFunction().getFunctionDefinitionNode());

        return serverStream;
    }

    private static Function getInitFunction() {
        Function function = new Function("init");
        function.addRequiredParameter(
                getStreamTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_ANYDATA,
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL), "anydataStream"
        );
        function.addAssignmentStatement(
                getFieldAccessExpressionNode("self", "anydataStream"),
                getSimpleNameReferenceNode("anydataStream")
        );
        function.addQualifiers(new String[]{"public", "isolated"});
        return function;
    }

    private static Function getNextFunction(Method method) {
        Function function = new Function("next");
        Record nextRecord = new Record();
        nextRecord.addCustomField(method.getOutputType(), "value");
        function.addReturns(
                getUnionTypeDescriptorNode(
                        nextRecord.getRecordTypeDescriptorNode(),
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL
                )
        );
        VariableDeclaration streamValue = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getBuiltinSimpleNameReferenceNode("var"),
                        getCaptureBindingPatternNode("streamValue")
                ),
                getMethodCallExpressionNode(
                        getFieldAccessExpressionNode("self", "anydataStream"),
                        "next",
                        new String[]{}
                )
        );
        function.addVariableStatement(streamValue.getVariableDeclarationNode());

        IfElse streamValueNilCheck = new IfElse(
                getBracedExpressionNode(
                        getTypeTestExpressionNode(
                                getSimpleNameReferenceNode("streamValue"),
                                getNilTypeDescriptorNode()
                        )
                )
        );
        streamValueNilCheck.addIfStatement(
                getReturnStatementNode(
                        getSimpleNameReferenceNode("streamValue")
                )
        );
        IfElse streamValueErrorCheck = new IfElse(
                getBracedExpressionNode(
                        getTypeTestExpressionNode(
                                getSimpleNameReferenceNode("streamValue"),
                                SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR
                        )
                )
        );
        streamValueErrorCheck.addIfStatement(
                getReturnStatementNode(
                        getSimpleNameReferenceNode("streamValue")
                )
        );

        Record nextRecordRec = new Record();
        nextRecordRec.addCustomField(method.getOutputType(), "value");
        Map nextRecordMap = new Map();
        if (method.getOutputType().equals("time:Utc")) {
            nextRecordMap.addTypeCastExpressionField(
                    "value",
                    method.getOutputType(),
                    getMethodCallExpressionNode(
                            getFieldAccessExpressionNode("streamValue", "value"),
                            "cloneReadOnly", new String[]{}
                    )
            );
        } else {
            nextRecordMap.addTypeCastExpressionField(
                    "value",
                    method.getOutputType(),
                    getFieldAccessExpressionNode("streamValue", "value")
            );
        }
        VariableDeclaration nextRecordVar = new VariableDeclaration(
                getTypedBindingPatternNode(
                        nextRecordRec.getRecordTypeDescriptorNode(),
                        getCaptureBindingPatternNode("nextRecord")
                ),
                nextRecordMap.getMappingConstructorExpressionNode()
        );
        streamValueErrorCheck.addElseStatement(
                nextRecordVar.getVariableDeclarationNode()
        );
        streamValueErrorCheck.addElseStatement(
                getReturnStatementNode(
                        getSimpleNameReferenceNode("nextRecord")
                )
        );
        streamValueNilCheck.addElseBody(streamValueErrorCheck);

        function.addIfElseStatement(streamValueNilCheck.getIfElseStatementNode());
        function.addQualifiers(new String[]{"public", "isolated"});
        return function;
    }

    private static Function getCloseFunction() {
        Function function = new Function("close");
        function.addReturns(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL);
        function.addReturnStatement(
                getMethodCallExpressionNode(
                        getFieldAccessExpressionNode("self", "anydataStream"),
                        "close",
                        new String[]{}
                )
        );
        function.addQualifiers(new String[]{"public", "isolated"});
        return function;
    }

    private static void addServerBody(Function function, Method method, String inputCap, String outCap,
                                      String headers) {

        addClientCallBody(function, inputCap, method);
        SeparatedNodeList<Node> payloadArgs = NodeFactory.createSeparatedNodeList(
                getStreamTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_ANYDATA,
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL), SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getMapTypeDescriptorNode(
                        getUnionTypeDescriptorNode(
                                SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING,
                                SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY
                        )
                )
        );
        VariableDeclaration payloadTuple = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getTupleTypeDescriptorNode(payloadArgs),
                        getListBindingPatternNode(new String[]{"result", headers})),
                getSimpleNameReferenceNode("payload")
        );
        function.addVariableStatement(payloadTuple.getVariableDeclarationNode());

        String streamParam = outCap + "Stream";
        if (isBallerinaProtobufType(method.getOutputType())) {
            String streamParamPrefix = "s" + getProtobufType(method.getOutputType());
            if (inputCap.equals("Any")) {
                streamParamPrefix = "sany";
            }
            streamParam = streamParamPrefix + ":" + streamParam;
        }
        VariableDeclaration stream = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getSimpleNameReferenceNode(streamParam),
                        getCaptureBindingPatternNode("outputStream")
                ),
                getExplicitNewExpressionNode(streamParam, new String[]{"result"})
        );
        function.addVariableStatement(stream.getVariableDeclarationNode());
    }
}
