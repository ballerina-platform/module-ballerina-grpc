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

import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.BinaryExpressionNode;
import io.ballerina.compiler.syntax.tree.ModuleMemberDeclarationNode;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import org.ballerinalang.net.grpc.builder.stub.Field;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionBody;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionDefinition;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionSignature;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Record;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Type;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.VariableDeclaration;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getOptionalFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionParam.getRequiredParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getBinaryExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getBracedExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getNilTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getTypeTestExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getUnaryExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Literal.getLiteralValueToken;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Returns.getReturnTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Statement.getCompoundAssignmentStatementNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Statement.getReturnStatementNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;

public class Message {

    public static NodeList<ModuleMemberDeclarationNode> getMessageNodes(org.ballerinalang.net.grpc.builder.stub.Message message) {
        NodeList<ModuleMemberDeclarationNode> messageMembers = AbstractNodeFactory.createEmptyNodeList();

        messageMembers = messageMembers.add(getMessageType(message).getTypeDefinitionNode());
        if (message.getOneofFieldMap() != null) {
            messageMembers = messageMembers.add(getValidationFunction(message).getFunctionDefinitionNode());
        }
        return messageMembers;
    }

    private static Type getMessageType(org.ballerinalang.net.grpc.builder.stub.Message message) {
        Record messageRecord = new Record();
        for (Field field : message.getFieldList()) {
            switch (field.getFieldType()) {
                case "string" :
                    messageRecord.addStringFieldWithDefaultValue(
                            field.getFieldName(),
                            field.getDefaultValue());
                    break;
                case "int" :
                    messageRecord.addIntegerFieldWithDefaultValue(
                            field.getFieldName(),
                            field.getDefaultValue());
                    break;
                case "boolean" :
                    messageRecord.addBooleanFieldWithDefaultValue(
                            field.getFieldName(),
                            field.getDefaultValue());
                    break;
                default:
                    messageRecord.addCustomFieldWithDefaultValue(
                            field.getFieldType(),
                            field.getFieldName(),
                            field.getDefaultValue());
            }
        }
        if (message.getOneofFieldMap() != null) {
            for (Map.Entry<String, List<Field>> oneOfFieldMap : message.getOneofFieldMap().entrySet()) {
                for (Field field : oneOfFieldMap.getValue()) {
                    switch (field.getFieldType()) {
                        case "string" :
                            messageRecord.addOptionalStringField(field.getFieldName());
                            break;
                        case "int" :
                            messageRecord.addOptionalIntegerField(field.getFieldName());
                            break;
                        case "boolean" :
                            messageRecord.addOptionalBooleanField(field.getFieldName());
                            break;
                        default:
                            messageRecord.addOptionalCustomField(field.getFieldName(), field.getFieldType());
                    }
                }
            }
        }
        return new Type(
                true,
                message.getMessageName(),
                messageRecord.getRecordTypeDescriptorNode());
    }

    private static FunctionDefinition getValidationFunction(org.ballerinalang.net.grpc.builder.stub.Message message) {
//        String name = message.getMessageName().substring(0, 1).toLowerCase() + message.getMessageName().substring(1);
        String name = "r";
        FunctionSignature signature = new FunctionSignature();
        signature.addReturns(
                getReturnTypeDescriptorNode(
                        getBuiltinSimpleNameReferenceNode("boolean")
                )
        );
        signature.addParameter(
                getRequiredParamNode(
                        getSimpleNameReferenceNode(message.getMessageName()),
                        name
                )
        );
        FunctionBody body = new FunctionBody();
        ArrayList<String> counts = new ArrayList();
        for (Map.Entry<String, List<Field>> oneOfFieldMap : message.getOneofFieldMap().entrySet()) {
            counts.add(oneOfFieldMap.getKey() + "Count");
            VariableDeclaration count = new VariableDeclaration(
                    getTypedBindingPatternNode(
                            SyntaxTreeConstants.SYNTAX_TREE_VAR_INT,
                            getCaptureBindingPatternNode(oneOfFieldMap.getKey() + "Count")
                    ),
                    NodeFactory.createBasicLiteralNode(SyntaxKind.NUMERIC_LITERAL, getLiteralValueToken(0))
            );
            body.addVariableStatement(count.getVariableDeclarationNode());
            for (Field field : oneOfFieldMap.getValue()) {
                IfElse oneOfFieldCheck = new IfElse(
                        getUnaryExpressionNode(
                                getBracedExpressionNode(
                                        getTypeTestExpressionNode(
                                                getOptionalFieldAccessExpressionNode(name, field.getFieldName()),
                                                getNilTypeDescriptorNode()
                                        )
                                )
                        )
                );
                oneOfFieldCheck.addIfStatement(
                        getCompoundAssignmentStatementNode(
                                oneOfFieldMap.getKey() + "Count",
                                SyntaxTreeConstants.SYNTAX_TREE_OPERATOR_PLUS,
                                1
                        )
                );
                body.addIfElseStatement(oneOfFieldCheck.getIfElseStatementNode());
            }
        }
        if (counts.size() > 0) {
            IfElse countCheck = new IfElse(
                    getBracedExpressionNode(
                            getCountCheckBinaryExpression(counts)
                    )
            );
            countCheck.addIfStatement(
                    getReturnStatementNode(
                            NodeFactory.createBasicLiteralNode(
                                    SyntaxKind.BOOLEAN_LITERAL,
                                    getLiteralValueToken(false)
                            )
                    )
            );
            body.addIfElseStatement(countCheck.getIfElseStatementNode());
        }
        body.addReturnStatement(
                NodeFactory.createBasicLiteralNode(
                        SyntaxKind.BOOLEAN_LITERAL,
                        getLiteralValueToken(true))
        );
        FunctionDefinition validationFunction = new FunctionDefinition(
                "isValid" + message.getMessageName(),
                signature.getFunctionSignature(),
                body.getFunctionBody()
        );
        validationFunction.addQualifiers(new String[]{"isolated"});
        return validationFunction;
    }

    private static BinaryExpressionNode getCountCheckBinaryExpression(ArrayList<String> counts) {
        BinaryExpressionNode binaryExpressionNode = getBinaryExpressionNode(
                getSimpleNameReferenceNode(counts.get(0)),
                NodeFactory.createBasicLiteralNode(
                        SyntaxKind.NUMERIC_LITERAL,
                        getLiteralValueToken(1)
                ),
                SyntaxTreeConstants.SYNTAX_TREE_OPERATOR_GREATER_THAN
        );
        for (int i = 1; i < counts.size(); i ++) {
            BinaryExpressionNode rhs = getBinaryExpressionNode(
                    getSimpleNameReferenceNode(counts.get(i)),
                    NodeFactory.createBasicLiteralNode(
                            SyntaxKind.NUMERIC_LITERAL,
                            getLiteralValueToken(1)
                    ),
                    SyntaxTreeConstants.SYNTAX_TREE_OPERATOR_GREATER_THAN
            );
            binaryExpressionNode = getBinaryExpressionNode(
                    binaryExpressionNode,
                    rhs,
                    SyntaxTreeConstants.SYNTAX_TREE_OPERATOR_OR
            );
        }
        return binaryExpressionNode;
    }
}
