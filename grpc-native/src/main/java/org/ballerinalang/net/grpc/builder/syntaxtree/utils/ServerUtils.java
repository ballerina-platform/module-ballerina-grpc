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
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Function;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Map;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Record;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.VariableDeclaration;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getBracedExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getExplicitNewExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getTypeTestExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Statement.getReturnStatementNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getListBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getMapTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getNilTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getObjectFieldNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getStreamTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTupleTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_ANYDATA;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CommonUtils.addClientCallBody;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CommonUtils.capitalize;

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
        String outCap;
        if (method.getOutputType().equals("byte[]")) {
            outCap = "Bytes";
        } else {
            outCap = capitalize(method.getOutputType());
        }
        function.addReturns(
                getUnionTypeDescriptorNode(
                        getStreamTypeDescriptorNode(
                                getSimpleNameReferenceNode(method.getOutputType()),
                                SYNTAX_TREE_GRPC_ERROR_OPTIONAL
                        ),
                        SYNTAX_TREE_GRPC_ERROR
                )
        );
        addServerBody(function, method, inputCap, outCap, "_");
        function.addReturnStatement(
                getExplicitNewExpressionNode(
                        getStreamTypeDescriptorNode(
                                getSimpleNameReferenceNode(method.getOutputType()),
                                SYNTAX_TREE_GRPC_ERROR_OPTIONAL
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
        String outputCap;
        if (method.getOutputType().equals("byte[]")) {
            outputCap = "Bytes";
        } else {
            outputCap = capitalize(method.getOutputType());
        }
        function.addReturns(
                getUnionTypeDescriptorNode(
                        getSimpleNameReferenceNode("Context" + outputCap + "Stream"),
                        SYNTAX_TREE_GRPC_ERROR
                )
        );
        addServerBody(function, method, inputCap, outputCap, "respHeaders");
        Map returnMap = new Map();
        returnMap.addField(
                "content",
                getExplicitNewExpressionNode(
                        getStreamTypeDescriptorNode(
                                getSimpleNameReferenceNode(method.getOutputType()),
                                SYNTAX_TREE_GRPC_ERROR_OPTIONAL
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
        if (method.getOutputType().equals("byte[]")) {
            outputCap = "Bytes";
        } else {
            outputCap = capitalize(method.getOutputType());
        }
        Class serverStream = new Class(outputCap + "Stream", true);

        serverStream.addMember(
                getObjectFieldNode(
                        "private",
                        new String[]{},
                        getStreamTypeDescriptorNode(SYNTAX_TREE_VAR_ANYDATA, SYNTAX_TREE_GRPC_ERROR_OPTIONAL),
                        "anydataStream"));

        serverStream.addMember(getInitFunction().getFunctionDefinitionNode());

        serverStream.addMember(getNextFunction(method).getFunctionDefinitionNode());

        serverStream.addMember(getCloseFunction().getFunctionDefinitionNode());

        return serverStream;
    }

    private static Function getInitFunction() {
        Function function = new Function("init");
        function.addRequiredParameter(
                getStreamTypeDescriptorNode(SYNTAX_TREE_VAR_ANYDATA, SYNTAX_TREE_GRPC_ERROR_OPTIONAL),
                "anydataStream"
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
                        SYNTAX_TREE_GRPC_ERROR_OPTIONAL
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
                                SYNTAX_TREE_GRPC_ERROR
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
        nextRecordMap.addTypeCastExpressionField(
                "value",
                method.getOutputType(),
                getFieldAccessExpressionNode("streamValue", "value")
        );
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
        function.addReturns(SYNTAX_TREE_GRPC_ERROR_OPTIONAL);
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
                getStreamTypeDescriptorNode(SYNTAX_TREE_VAR_ANYDATA, SYNTAX_TREE_GRPC_ERROR_OPTIONAL),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getMapTypeDescriptorNode(
                        getUnionTypeDescriptorNode(
                                SYNTAX_TREE_VAR_STRING,
                                SYNTAX_TREE_VAR_STRING_ARRAY
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

        VariableDeclaration stream = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getSimpleNameReferenceNode(outCap + "Stream"),
                        getCaptureBindingPatternNode("outputStream")
                ),
                getExplicitNewExpressionNode(outCap + "Stream", new String[]{"result"})
        );
        function.addVariableStatement(stream.getVariableDeclarationNode());
    }
}
