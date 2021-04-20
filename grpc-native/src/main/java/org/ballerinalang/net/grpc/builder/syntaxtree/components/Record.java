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

package org.ballerinalang.net.grpc.builder.syntaxtree.components;

import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.RecordTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.TypeDescriptorNode;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getListConstructorExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getNilTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Literal.getBooleanLiteralNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Literal.getNumericLiteralNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Literal.getStringLiteralNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getArrayTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getOptionalTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getParameterizedTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getStreamTypeDescriptorNode;

public class Record {

    private NodeList<Node> fields;

    public Record() {
        fields = NodeFactory.createEmptyNodeList();
    }

    public RecordTypeDescriptorNode getRecordTypeDescriptorNode() {
        return NodeFactory.createRecordTypeDescriptorNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_RECORD,
                SyntaxTreeConstants.SYNTAX_TREE_BODY_START_DELIMITER,
                fields,
                null,
                SyntaxTreeConstants.SYNTAX_TREE_BODY_END_DELIMITER
        );
    }

    public void addField(String fieldType, String fieldName) {
        fields = fields.add(NodeFactory.createRecordFieldNode(
                null,
                null,
                getBuiltinSimpleNameReferenceNode(fieldType),
                AbstractNodeFactory.createIdentifierToken(fieldName),
                null,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addStringField(String fieldName) {
        fields = fields.add(NodeFactory.createRecordFieldNode(
                null,
                null,
                getBuiltinSimpleNameReferenceNode("string"),
                AbstractNodeFactory.createIdentifierToken(fieldName),
                null,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addOptionalStringField(String fieldName) {
        fields = fields.add(NodeFactory.createRecordFieldNode(
                null,
                null,
                getBuiltinSimpleNameReferenceNode("string"),
                AbstractNodeFactory.createIdentifierToken(fieldName),
                SyntaxTreeConstants.SYNTAX_TREE_QUESTION_MARK,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addStringFieldWithDefaultValue(String fieldName, String defaultValue) {
        fields = fields.add(
                NodeFactory.createRecordFieldWithDefaultValueNode(
                        null,
                        null,
                        SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING,
                        AbstractNodeFactory.createIdentifierToken(fieldName),
                        SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                        getStringLiteralNode(defaultValue),
                        SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addOptionalBooleanField(String fieldName) {
        fields = fields.add(NodeFactory.createRecordFieldNode(
                null,
                null,
                getBuiltinSimpleNameReferenceNode("boolean"),
                AbstractNodeFactory.createIdentifierToken(fieldName),
                SyntaxTreeConstants.SYNTAX_TREE_QUESTION_MARK,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addOptionalArrayField(String fieldName, String fieldType) {
        fields = fields.add(NodeFactory.createRecordFieldNode(
                null,
                null,
                getArrayTypeDescriptorNode(fieldType),
                AbstractNodeFactory.createIdentifierToken(fieldName),
                SyntaxTreeConstants.SYNTAX_TREE_QUESTION_MARK,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addBooleanFieldWithDefaultValue(String fieldName, String defaultValue) {
        fields = fields.add(
                NodeFactory.createRecordFieldWithDefaultValueNode(
                        null,
                        null,
                        SyntaxTreeConstants.SYNTAX_TREE_VAR_BOOLEAN,
                        AbstractNodeFactory.createIdentifierToken(fieldName),
                        SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                        getBooleanLiteralNode(Boolean.parseBoolean(defaultValue)),
                        SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
                ));
    }

    public void addArrayFieldWithDefaultValue(String fieldName, String type) {
        fields = fields.add(
                NodeFactory.createRecordFieldWithDefaultValueNode(
                        null,
                        null,
                        getArrayTypeDescriptorNode(type),
                        AbstractNodeFactory.createIdentifierToken(fieldName),
                        SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                        getListConstructorExpressionNode(null),
                        SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
                ));
    }

    public void addArrayFieldWithDefaultValue(String fieldName, Record type) {
        fields = fields.add(
                NodeFactory.createRecordFieldWithDefaultValueNode(
                        null,
                        null,
                        getArrayTypeDescriptorNode(type),
                        AbstractNodeFactory.createIdentifierToken(fieldName),
                        SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                        getListConstructorExpressionNode(null),
                        SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
                ));
    }

    public void addOptionalIntegerField(String fieldName) {
        fields = fields.add(NodeFactory.createRecordFieldNode(
                null,
                null,
                getBuiltinSimpleNameReferenceNode("int"),
                AbstractNodeFactory.createIdentifierToken(fieldName),
                SyntaxTreeConstants.SYNTAX_TREE_QUESTION_MARK,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addOptionalFloatField(String fieldName) {
        fields = fields.add(NodeFactory.createRecordFieldNode(
                null,
                null,
                getBuiltinSimpleNameReferenceNode("float"),
                AbstractNodeFactory.createIdentifierToken(fieldName),
                SyntaxTreeConstants.SYNTAX_TREE_QUESTION_MARK,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addIntegerFieldWithDefaultValue(String fieldName, String defaultValue) {
        fields = fields.add(
                NodeFactory.createRecordFieldWithDefaultValueNode(
                        null,
                        null,
                        SyntaxTreeConstants.SYNTAX_TREE_VAR_INT,
                        AbstractNodeFactory.createIdentifierToken(fieldName),
                        SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                        getNumericLiteralNode(Integer.parseInt(defaultValue)),
                        SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
                ));
    }

    public void addFloatFieldWithDefaultValue(String fieldName, String defaultValue) {
        fields = fields.add(
                NodeFactory.createRecordFieldWithDefaultValueNode(
                        null,
                        null,
                        SyntaxTreeConstants.SYNTAX_TREE_VAR_FLOAT,
                        AbstractNodeFactory.createIdentifierToken(fieldName),
                        SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                        getNumericLiteralNode(Integer.parseInt(defaultValue)),
                        SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
                ));
    }

    public void addCustomField(String fieldName, String typeName) {
        fields = fields.add(
                NodeFactory.createRecordFieldNode(
                        null,
                        null,
                        getSimpleNameReferenceNode(typeName),
                        AbstractNodeFactory.createIdentifierToken(fieldName),
                        null,
                        SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addOptionalCustomField(String fieldName, String typeName) {
        fields = fields.add(NodeFactory.createRecordFieldNode(
                null,
                null,
                getSimpleNameReferenceNode(typeName),
                AbstractNodeFactory.createIdentifierToken(fieldName),
                SyntaxTreeConstants.SYNTAX_TREE_QUESTION_MARK,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addCustomFieldWithDefaultValue(String fieldType, String fieldName, String defaultValue) {
        if (defaultValue == null) {
            fields = fields.add(
                    NodeFactory.createRecordFieldWithDefaultValueNode(
                            null,
                            null,
                            getOptionalTypeDescriptorNode("", fieldType),
                            AbstractNodeFactory.createIdentifierToken(fieldName),
                            SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                            getNilTypeDescriptorNode(),
                            SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
                    )
            );
        } else {
            if ("[]".equals(defaultValue)) {
                fields = fields.add(
                        NodeFactory.createRecordFieldWithDefaultValueNode(
                                null,
                                null,
                                getArrayTypeDescriptorNode(fieldType),
                                AbstractNodeFactory.createIdentifierToken(fieldName),
                                SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                                getListConstructorExpressionNode(null),
                                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
                        )
                );
            }
        }
    }

    public void addMapField(String fieldName, TypeDescriptorNode descriptorNode) {
        fields = fields.add(NodeFactory.createRecordFieldNode(
                null,
                null,
                getParameterizedTypeDescriptorNode("map", descriptorNode),
                AbstractNodeFactory.createIdentifierToken(fieldName),
                null,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addStreamField(String fieldName, String streamType, boolean optionalError) {
        Node lhs;
        Node rhs;
        if (streamType.equals("string")) {
            lhs = SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
        } else {
            lhs = getSimpleNameReferenceNode(streamType);
        }
        if (optionalError) {
            rhs = getOptionalTypeDescriptorNode("", "error");
        } else {
            rhs = null;
        }
        fields = fields.add(NodeFactory.createRecordFieldNode(
                null,
                null,
                getStreamTypeDescriptorNode(lhs, rhs),
                AbstractNodeFactory.createIdentifierToken(fieldName),
                null,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }
}
