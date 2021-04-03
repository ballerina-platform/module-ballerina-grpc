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
import org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Map;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Record;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Returns;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.VariableDeclaration;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getExplicitNewExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getRemoteMethodCallActionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionParam.getRequiredParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getBracedExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getNilTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getTypeTestExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Initializer.getCheckExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getListBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getObjectFieldNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getParameterizedTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getStreamTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTupleTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_ANYDATA;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY;

public class Server {

    public static FunctionDefinition getServerStreamingFunction(Method method) {
        String outCap = method.getOutputType().substring(0,1).toUpperCase() + method.getOutputType().substring(1);
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(
                getRequiredParamNode(
                        getSimpleNameReferenceNode(method.getInputType()),
                        "req"));
        signature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        getUnionTypeDescriptorNode(
                                getStreamTypeDescriptorNode(
                                        getSimpleNameReferenceNode(method.getOutputType()),
                                        SYNTAX_TREE_GRPC_ERROR),
                                SYNTAX_TREE_GRPC_ERROR)));
        FunctionBody body = getServerBody(method, "_", outCap);
        body.addReturnStatement(
                getExplicitNewExpressionNode(
                        getStreamTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_GRPC_ERROR),
                        new String[]{"outputStream"}
                )
        );
        FunctionDefinition definition = new FunctionDefinition(
                method.getMethodName(),
                signature.getFunctionSignature(),
                body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    public static FunctionDefinition getServerStreamingContextFunction(Method method) {
        String outCap = method.getOutputType().substring(0,1).toUpperCase() + method.getOutputType().substring(1);
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(
                getRequiredParamNode(
                        getSimpleNameReferenceNode(method.getInputType()),
                        "req"));
        signature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        getUnionTypeDescriptorNode(
                                getSimpleNameReferenceNode(
                                        "Context" + outCap + "Stream"),
                                SYNTAX_TREE_GRPC_ERROR)));
        FunctionBody body = getServerBody(method, "headers", outCap);
        Map returnMap = new Map();
        returnMap.addField(
                "content",
                getExplicitNewExpressionNode(
                        getStreamTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_GRPC_ERROR),
                        new String[]{"outputStream"}
                )
        );
        returnMap.addSimpleNameReferenceField("headers", "headers");
        body.addReturnStatement(returnMap.getMappingConstructorExpressionNode());
        FunctionDefinition definition = new FunctionDefinition(
                method.getMethodName() + "Context",
                signature.getFunctionSignature(),
                body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    public static Class getServerStreamClass(Method method) {
        String outputType = method.getOutputType().substring(0, 1).toUpperCase() + method.getInputType().substring(1);
        Class serverStream = new Class(outputType + "Stream", true);

        serverStream.addMember(
                getObjectFieldNode(
                        "private",
                        new String[]{},
                        getStreamTypeDescriptorNode(SYNTAX_TREE_VAR_ANYDATA, SYNTAX_TREE_GRPC_ERROR),
                        "anydataStream"));

        FunctionSignature initSignature = new FunctionSignature();
        initSignature.addParameter(
                getRequiredParamNode(
                        getStreamTypeDescriptorNode(SYNTAX_TREE_VAR_ANYDATA, SYNTAX_TREE_GRPC_ERROR),
                        "anydataStream"));
        FunctionBody initBody = new FunctionBody();
        initBody.addAssignmentStatement(
                getFieldAccessExpressionNode("self", "anydataStream"),
                getSimpleNameReferenceNode("anydataStream"));
        FunctionDefinition initDefinition = new FunctionDefinition(
                "init",
                initSignature.getFunctionSignature(),
                initBody.getFunctionBody());
        initDefinition.addQualifiers(new String[]{"public", "isolated"});
        serverStream.addMember(initDefinition.getFunctionDefinitionNode());

        FunctionSignature nextSignature = new FunctionSignature();
        Record nextRecord = new Record();
        nextRecord.addCustomField("value", method.getInputType());
        nextSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        getUnionTypeDescriptorNode(
                                nextRecord.getRecordTypeDescriptorNode(),
                                SYNTAX_TREE_GRPC_ERROR_OPTIONAL)));
        FunctionBody nextBody = new FunctionBody();
        VariableDeclaration streamValue = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getBuiltinSimpleNameReferenceNode("var"),
                        getCaptureBindingPatternNode("streamValue")),
                getMethodCallExpressionNode(
                        getFieldAccessExpressionNode("self", "anydataStream"),
                        "next",
                        new String[]{}));
        nextBody.addVariableStatement(streamValue.getVariableDeclarationNode());

        IfElse streamValueNilCheck = new IfElse(
                getBracedExpressionNode(
                        getTypeTestExpressionNode(
                                getSimpleNameReferenceNode("streamValue"),
                                getNilTypeDescriptorNode()))
        );
        streamValueNilCheck.addIfReturnStatement(getSimpleNameReferenceNode("streamValue"));
        IfElse streamValueErrorCheck = new IfElse(
                getBracedExpressionNode(
                        getTypeTestExpressionNode(
                                getSimpleNameReferenceNode("streamValue"),
                                SYNTAX_TREE_GRPC_ERROR))
        );
        streamValueErrorCheck.addIfReturnStatement(getSimpleNameReferenceNode("streamValue"));

        Record nextRecordRec = new Record();
        nextRecordRec.addStringField("value");
        Map nextRecordMap = new Map();
        nextRecordMap.addTypeCastExpressionField(
                "value",
                "string",
                getFieldAccessExpressionNode("streamValue", "value"));
        VariableDeclaration nextRecordVar = new VariableDeclaration(
                getTypedBindingPatternNode(
                        nextRecordRec.getRecordTypeDescriptorNode(),
                        getCaptureBindingPatternNode("nextRecord")),
                nextRecordMap.getMappingConstructorExpressionNode());
        streamValueErrorCheck.addElseBody();
        streamValueErrorCheck.addElseVariableDeclarationStatement(nextRecordVar.getVariableDeclarationNode());
        streamValueErrorCheck.addElseReturnStatement(getSimpleNameReferenceNode("nextRecord"));
        streamValueNilCheck.addElseBody(streamValueErrorCheck);

        nextBody.addIfElseStatement(streamValueNilCheck.getIfElseStatementNode());

        FunctionDefinition next = new FunctionDefinition(
                "next",
                nextSignature.getFunctionSignature(),
                nextBody.getFunctionBody());
        next.addQualifiers(new String[]{"public", "isolated"});
        serverStream.addMember(next.getFunctionDefinitionNode());

        FunctionSignature closeSignature = new FunctionSignature();
        closeSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody closeBody = new FunctionBody();
        closeBody.addReturnStatement(
                getMethodCallExpressionNode(
                        getFieldAccessExpressionNode("self", "anydataStream"),
                        "close",
                        new String[]{}));
        FunctionDefinition close = new FunctionDefinition(
                "close",
                closeSignature.getFunctionSignature(),
                closeBody.getFunctionBody());
        close.addQualifiers(new String[]{"public", "isolated"});
        serverStream.addMember(close.getFunctionDefinitionNode());

        return serverStream;
    }

    private static FunctionBody getServerBody(Method method, String headers, String outCap) {
        FunctionBody body = new FunctionBody();
        VariableDeclaration payload = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getBuiltinSimpleNameReferenceNode("var"),
                        getCaptureBindingPatternNode("payload")),
                getCheckExpressionNode(
                        getRemoteMethodCallActionNode(
                                getFieldAccessExpressionNode("self", "grpcClient"),
                                "executeServerStreaming",
                                new String[]{"\"" + method.getMethodId() +  "\"", "req"}
                        )
                )
        );
        body.addVariableStatement(payload.getVariableDeclarationNode());

        SeparatedNodeList<Node> payloadArgs = NodeFactory.createSeparatedNodeList(
                getStreamTypeDescriptorNode(SYNTAX_TREE_VAR_ANYDATA, SYNTAX_TREE_GRPC_ERROR),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getParameterizedTypeDescriptorNode(
                        "map",
                        getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_VAR_STRING_ARRAY))
        );
        VariableDeclaration payloadTuple = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getTupleTypeDescriptorNode(payloadArgs),
                        getListBindingPatternNode(new String[]{"result", headers})),
                getSimpleNameReferenceNode("payload")
        );
        body.addVariableStatement(payloadTuple.getVariableDeclarationNode());

        VariableDeclaration stream = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getSimpleNameReferenceNode(outCap + "Stream"),
                        getCaptureBindingPatternNode("outputStream")
                ),
                getExplicitNewExpressionNode(outCap + "Stream", new String[]{"result"})
        );
        body.addVariableStatement(stream.getVariableDeclarationNode());
        return body;
    }
}
