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

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
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
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CommonUtils.capitalize;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.CommonUtils.capitalizeFirstLetter;
import static org.ballerinalang.net.grpc.builder.syntaxtree.utils.EnumUtils.getEnum;

public class MessageUtils {

    public static NodeList<ModuleMemberDeclarationNode> getMessageNodes(org.ballerinalang.net.grpc.builder.stub.Message message) {
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

    private static Type getMessageType(org.ballerinalang.net.grpc.builder.stub.Message message) {
        Record messageRecord = new Record();
        for (Field field : message.getFieldList()) {
            String fieldName = field.getFieldName();
            String defaultValue = field.getDefaultValue();
            switch (field.getFieldType()) {
                case "string" :
                    messageRecord.addStringFieldWithDefaultValue(fieldName, defaultValue);
                    break;
                case "int" :
                    messageRecord.addIntegerFieldWithDefaultValue(fieldName, defaultValue);
                    break;
                case "float" :
                    messageRecord.addFloatFieldWithDefaultValue(fieldName, defaultValue);
                    break;
                case "boolean" :
                    messageRecord.addBooleanFieldWithDefaultValue(fieldName, defaultValue);
                    break;
                case "byte[]" :
                    messageRecord.addArrayFieldWithDefaultValue(fieldName, "byte");
                    break;
                default:
                    messageRecord.addCustomFieldWithDefaultValue(field.getFieldType(), fieldName, defaultValue);
            }
        }
        if (message.getOneofFieldMap() != null) {
            for (Map.Entry<String, List<Field>> oneOfField : message.getOneofFieldMap().entrySet()) {
                for (Field field : oneOfField.getValue()) {
                    switch (field.getFieldType()) {
                        case "string" :
                            messageRecord.addOptionalStringField(field.getFieldName());
                            break;
                        case "int" :
                            messageRecord.addOptionalIntegerField(field.getFieldName());
                            break;
                        case "float" :
                            messageRecord.addOptionalFloatField(field.getFieldName());
                            break;
                        case "boolean" :
                            messageRecord.addOptionalBooleanField(field.getFieldName());
                            break;
                        case "byte[]" :
                            messageRecord.addOptionalArrayField(field.getFieldName(), "byte");
                            break;
                        default:
                            messageRecord.addOptionalCustomField(field.getFieldName(), field.getFieldType());
                    }
                }
            }
        }
        if (message.getMapList() != null) {
            for (Message map : message.getMapList()) {
                Record record = new Record();
                for (Field field : map.getFieldList()) {
                    // Todo: Add a test case with all the field types (int32, int64 ...)
                    record.addField(field.getFieldType(), field.getFieldName());
                }
                messageRecord.addArrayFieldWithDefaultValue(map.getMessageName(), record);
            }
        }
        return new Type(
                true,
                message.getMessageName(),
                messageRecord.getRecordTypeDescriptorNode());
    }

    private static Function getValidationFunction(Message message) {
        Function function = new Function("isValid" + capitalizeFirstLetter(message.getMessageName()));
        function.addReturns(
                getReturnTypeDescriptorNode(
                        getBuiltinSimpleNameReferenceNode("boolean")
                )
        );
        function.addParameter(
                getRequiredParamNode(
                        getSimpleNameReferenceNode(message.getMessageName()),
                        "r"
                )
        );
        ArrayList<String> counts = new ArrayList<>();
        for (Map.Entry<String, List<Field>> oneOfFieldMap : message.getOneofFieldMap().entrySet()) {
            counts.add(oneOfFieldMap.getKey() + "Count");
            VariableDeclaration count = new VariableDeclaration(
                    getTypedBindingPatternNode(
                            SyntaxTreeConstants.SYNTAX_TREE_VAR_INT,
                            getCaptureBindingPatternNode(oneOfFieldMap.getKey() + "Count")
                    ),
                    NodeFactory.createBasicLiteralNode(SyntaxKind.NUMERIC_LITERAL, getLiteralValueToken(0))
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
                            NodeFactory.createBasicLiteralNode(
                                    SyntaxKind.BOOLEAN_LITERAL,
                                    getLiteralValueToken(false)
                            )
                    )
            );
            function.addIfElseStatement(countCheck.getIfElseStatementNode());
        }
        function.addReturnStatement(
                NodeFactory.createBasicLiteralNode(
                        SyntaxKind.BOOLEAN_LITERAL,
                        getLiteralValueToken(true)
                )
        );
        function.addQualifiers(new String[]{"isolated"});
        return function;
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

    private static Function getOneOfFieldSetFunction(String messageName, Field field, List<Field> fields) {
        StringBuilder functionName = new StringBuilder("set" + messageName + "_");
        for (String s : field.getFieldName().split("_")) {
            functionName.append(capitalize(s));
        }
        Function function = new Function(functionName.toString());
        function.addParameter(
                getRequiredParamNode(
                        getSimpleNameReferenceNode(messageName),
                        "r"
                )
        );
        function.addParameter(
                getRequiredParamNode(
                        getBuiltinSimpleNameReferenceNode(field.getFieldType()),
                        field.getFieldName()
                )
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
                                new String[]{"\"" + oneOfField.getFieldName() + "\""}
                        )
                );
            }
        }
        function.addQualifiers(new String[]{"isolated"});
        return function;
    }
}
