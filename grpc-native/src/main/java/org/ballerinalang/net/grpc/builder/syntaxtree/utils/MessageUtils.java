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
import io.ballerina.compiler.syntax.tree.NodeList;
import org.ballerinalang.net.grpc.builder.stub.EnumMessage;
import org.ballerinalang.net.grpc.builder.stub.Field;
import org.ballerinalang.net.grpc.builder.stub.Message;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Function;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Record;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Type;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.VariableDeclaration;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getBinaryExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getBracedExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getOptionalFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getTypeTestExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getUnaryExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Literal.getBooleanLiteralNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Literal.getNumericLiteralNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Statement.getCompoundAssignmentStatementNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Statement.getReturnStatementNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getNilTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CommonUtils.capitalizeFirstLetter;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CommonUtils.toPascalCase;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.EnumUtils.getEnum;

/**
 * Utility functions related to Message.
 *
 * @since 0.8.0
 */
public class MessageUtils {

    private MessageUtils() {

    }

    public static NodeList<ModuleMemberDeclarationNode> getMessageNodes(Message message) {
        NodeList<ModuleMemberDeclarationNode> messageMembers = AbstractNodeFactory.createEmptyNodeList();

        messageMembers = messageMembers.add(getMessageType(message).getTypeDefinitionNode());

        if (message.getNestedMessageList() != null) {
            for (Message nestedMessage : message.getNestedMessageList()) {
                for (ModuleMemberDeclarationNode messageNode : getMessageNodes(nestedMessage)) {
                    messageMembers = messageMembers.add(messageNode);
                }
            }
        }
        if (message.getOneofFieldMap() != null) {
            messageMembers = messageMembers.add(getValidationFunction(message).getFunctionDefinitionNode());
            for (Map.Entry<String, List<Field>> oneOfFieldMap : message.getOneofFieldMap().entrySet()) {
                for (Field field : oneOfFieldMap.getValue()) {
                    messageMembers = messageMembers.add(
                            getOneOfFieldSetFunction(
                                    message.getMessageName(),
                                    field,
                                    oneOfFieldMap.getValue()
                            ).getFunctionDefinitionNode()
                    );
                }
            }
        }
        if (message.getEnumList() != null) {
            for (EnumMessage enumMessage : message.getEnumList()) {
                messageMembers = messageMembers.add(getEnum(enumMessage).getEnumDeclarationNode());
            }
        }
        return messageMembers;
    }

    private static Type getMessageType(Message message) {
        Record messageRecord = new Record();
        for (Field field : message.getFieldList()) {
            switch (field.getFieldType()) {
                case "string":
                case "int":
                case "float":
                case "boolean":
                    if (field.getFieldLabel() == null) {
                        messageRecord.addBasicFieldWithDefaultValue(field.getFieldType(), field.getFieldName(),
                                field.getDefaultValue());
                    } else {
                        messageRecord.addArrayFieldWithDefaultValue(field.getFieldType(), field.getFieldName());
                    }
                    break;
                case "byte[]":
                    messageRecord.addArrayFieldWithDefaultValue("byte", field.getFieldName());
                    break;
                case "Timestamp":
                    messageRecord.addCustomFieldWithDefaultValue("time:Utc", field.getFieldName(), "[0, 0.0d]");
                    break;
                case "Duration":
                    messageRecord.addCustomFieldWithDefaultValue("time:Seconds", field.getFieldName(), "0.0d");
                    break;
                default:
                    if (field.getFieldLabel() == null) {
                        messageRecord.addCustomFieldWithDefaultValue(field.getFieldType(), field.getFieldName(),
                                field.getDefaultValue());
                    } else {
                        messageRecord.addArrayFieldWithDefaultValue(field.getFieldType(), field.getFieldName());
                    }
            }
        }
        if (message.getOneofFieldMap() != null) {
            for (Map.Entry<String, List<Field>> oneOfField : message.getOneofFieldMap().entrySet()) {
                for (Field field : oneOfField.getValue()) {
                    switch (field.getFieldType()) {
                        case "string":
                        case "int":
                        case "float":
                        case "boolean":
                            if (field.getFieldLabel() == null) {
                                messageRecord.addOptionalBasicField(field.getFieldType(), field.getFieldName());
                            } else {
                                messageRecord.addOptionalArrayField(field.getFieldType(), field.getFieldName());
                            }
                            break;
                        case "byte[]":
                            messageRecord.addOptionalArrayField("byte", field.getFieldName());
                            break;
                        case "Timestamp":
                            messageRecord.addOptionalCustomField("time:Utc", field.getFieldName());
                            break;
                        case "Duration":
                            messageRecord.addOptionalCustomField("time:Seconds", field.getFieldName());
                            break;
                        default:
                            if (field.getFieldLabel() == null) {
                                messageRecord.addOptionalCustomField(field.getFieldType(), field.getFieldName());
                            } else {
                                messageRecord.addOptionalArrayField(field.getFieldType(), field.getFieldName());
                            }
                    }
                }
            }
        }
        if (message.getMapList() != null) {
            for (Message map : message.getMapList()) {
                Record record = new Record();
                for (Field field : map.getFieldList()) {
                    // Todo: Add a test case with all the field types (int32, int64 ...)
                    record.addBasicField(field.getFieldType(), field.getFieldName());
                }
                messageRecord.addArrayFieldWithDefaultValue(record, map.getMessageName());
            }
        }
        return new Type(
                true,
                message.getMessageName(),
                messageRecord.getRecordTypeDescriptorNode());
    }

    private static Function getValidationFunction(Message message) {
        Function function = new Function("isValid" + capitalizeFirstLetter(message.getMessageName()));
        function.addReturns(getBuiltinSimpleNameReferenceNode("boolean"));
        function.addRequiredParameter(getSimpleNameReferenceNode(message.getMessageName()), "r");
        ArrayList<String> counts = new ArrayList<>();
        for (Map.Entry<String, List<Field>> oneOfFieldMap : message.getOneofFieldMap().entrySet()) {
            counts.add(oneOfFieldMap.getKey() + "Count");
            VariableDeclaration count = new VariableDeclaration(
                    getTypedBindingPatternNode(
                            SyntaxTreeConstants.SYNTAX_TREE_VAR_INT,
                            getCaptureBindingPatternNode(oneOfFieldMap.getKey() + "Count")
                    ),
                    getNumericLiteralNode(0)
            );
            function.addVariableStatement(count.getVariableDeclarationNode());
            for (Field field : oneOfFieldMap.getValue()) {
                IfElse oneOfFieldCheck = new IfElse(
                        getUnaryExpressionNode(
                                getBracedExpressionNode(
                                        getTypeTestExpressionNode(
                                                getOptionalFieldAccessExpressionNode("r", field.getFieldName()),
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
                function.addIfElseStatement(oneOfFieldCheck.getIfElseStatementNode());
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
                            getBooleanLiteralNode(false)
                    )
            );
            function.addIfElseStatement(countCheck.getIfElseStatementNode());
        }
        function.addReturnStatement(
                getBooleanLiteralNode(true)
        );
        function.addQualifiers(new String[]{"isolated"});
        return function;
    }

    private static BinaryExpressionNode getCountCheckBinaryExpression(ArrayList<String> counts) {
        BinaryExpressionNode binaryExpressionNode = getBinaryExpressionNode(
                getSimpleNameReferenceNode(counts.get(0)),
                getNumericLiteralNode(1),
                SyntaxTreeConstants.SYNTAX_TREE_OPERATOR_GREATER_THAN
        );
        for (int i = 1; i < counts.size(); i++) {
            BinaryExpressionNode rhs = getBinaryExpressionNode(
                    getSimpleNameReferenceNode(counts.get(i)),
                    getNumericLiteralNode(1),
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

    private static Function getOneOfFieldSetFunction(String messageName, Field field, List<Field> fields) {
        Function function = new Function("set" + messageName + "_" + toPascalCase(field.getFieldName()));
        function.addRequiredParameter(getSimpleNameReferenceNode(messageName), "r");
        function.addRequiredParameter(
                getBuiltinSimpleNameReferenceNode(field.getFieldType()),
                field.getFieldName()
        );
        function.addAssignmentStatement(
                getFieldAccessExpressionNode(
                        "r",
                        field.getFieldName()
                ),
                getSimpleNameReferenceNode(field.getFieldName())
        );
        for (Field oneOfField : fields) {
            if (!oneOfField.getFieldName().equals(field.getFieldName())) {
                function.addAssignmentStatement(
                        getSimpleNameReferenceNode("_"),
                        getMethodCallExpressionNode(
                                getSimpleNameReferenceNode("r"),
                                "removeIfHasKey",
                                new String[]{"\"" + oneOfField.getFieldName().replaceAll("'", "") + "\""}
                        )
                );
            }
        }
        function.addQualifiers(new String[]{"isolated"});
        return function;
    }
}
