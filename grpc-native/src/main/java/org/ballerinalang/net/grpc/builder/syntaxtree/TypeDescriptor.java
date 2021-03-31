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

package org.ballerinalang.net.grpc.builder.syntaxtree;

import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.ArrayTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.BindingPatternNode;
import io.ballerina.compiler.syntax.tree.BuiltinSimpleNameReferenceNode;
import io.ballerina.compiler.syntax.tree.CaptureBindingPatternNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.ListBindingPatternNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.ObjectFieldNode;
import io.ballerina.compiler.syntax.tree.OptionalTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.ParameterizedTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.QualifiedNameReferenceNode;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.compiler.syntax.tree.StreamTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.compiler.syntax.tree.TupleTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.TypeCastExpressionNode;
import io.ballerina.compiler.syntax.tree.TypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.TypeParameterNode;
import io.ballerina.compiler.syntax.tree.TypeReferenceNode;
import io.ballerina.compiler.syntax.tree.TypedBindingPatternNode;
import io.ballerina.compiler.syntax.tree.UnionTypeDescriptorNode;
import org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants;

public class TypeDescriptor {

    public static QualifiedNameReferenceNode getQualifiedNameReferenceNode(String modulePrefix, String identifier) {
        return NodeFactory.createQualifiedNameReferenceNode(
                AbstractNodeFactory.createIdentifierToken(modulePrefix),
                SyntaxTreeConstants.SYNTAX_TREE_COLON,
                AbstractNodeFactory.createIdentifierToken(identifier + " "));
    }

    public static OptionalTypeDescriptorNode getOptionalTypeDescriptorNode(String modulePrefix, String identifier) {
        return NodeFactory.createOptionalTypeDescriptorNode(
                getQualifiedNameReferenceNode(modulePrefix, identifier), SyntaxTreeConstants.SYNTAX_TREE_QUESTION_MARK);
    }

    public static UnionTypeDescriptorNode getUnionTypeDescriptorNode(TypeDescriptorNode lhs, TypeDescriptorNode rhs) {
        return NodeFactory.createUnionTypeDescriptorNode(lhs, SyntaxTreeConstants.SYNTAX_TREE_PIPE, rhs);
    }

    public static BuiltinSimpleNameReferenceNode getBuiltinSimpleNameReferenceNode(String name) {
        if ("int".equals(name)) {
            return NodeFactory.createBuiltinSimpleNameReferenceNode(SyntaxKind.INT_TYPE_DESC, AbstractNodeFactory.createIdentifierToken(name + " "));
        }
        return NodeFactory.createBuiltinSimpleNameReferenceNode(SyntaxKind.STRING_TYPE_DESC, AbstractNodeFactory.createIdentifierToken(name + " "));
    }

    public static TypeParameterNode getTypeParameterNode(TypeDescriptorNode typeNode) {
        return NodeFactory.createTypeParameterNode(SyntaxTreeConstants.SYNTAX_TREE_IT, typeNode, SyntaxTreeConstants.SYNTAX_TREE_GT);
    }

    public static ParameterizedTypeDescriptorNode getParameterizedTypeDescriptorNode(String type, TypeDescriptorNode descriptorNode) {
        return NodeFactory.createParameterizedTypeDescriptorNode(
                AbstractNodeFactory.createIdentifierToken(type),
                getTypeParameterNode(descriptorNode)
        );
    }

    public static ArrayTypeDescriptorNode getArrayTypeDescriptorNode(String type) {
        return NodeFactory.createArrayTypeDescriptorNode(
                getBuiltinSimpleNameReferenceNode(type),
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACKET,
                null,
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACKET
        );
    }

    public static TypeReferenceNode getTypeReferenceNode(Node typeName) {
        return NodeFactory.createTypeReferenceNode(
                SyntaxTreeConstants.SYNTAX_TREE_ASTERISK,
                typeName,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        );
    }

    public static ObjectFieldNode getObjectFieldNode(String visibility, String[] qualifiers, Node typeName, String fieldName) {
        NodeList qualifierList = NodeFactory.createEmptyNodeList();
        for (String qualifier : qualifiers) {
            qualifierList = qualifierList.add(AbstractNodeFactory.createIdentifierToken(qualifier + " "));
        }
        return NodeFactory.createObjectFieldNode(
                null,
                AbstractNodeFactory.createIdentifierToken("\n" + visibility + " "),
                qualifierList,
                typeName,
                AbstractNodeFactory.createIdentifierToken(fieldName),
                null,
                null,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        );
    }

    public static StreamTypeDescriptorNode getStreamTypeDescriptorNode(Node lhs, Node rhs) {
        Token comma;
        if (rhs == null) {
            comma = null;
        } else {
            comma = SyntaxTreeConstants.SYNTAX_TREE_COMMA;
        }
        return NodeFactory.createStreamTypeDescriptorNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_STREAM,
                NodeFactory.createStreamTypeParamsNode(
                        SyntaxTreeConstants.SYNTAX_TREE_IT,
                        lhs,
                        comma,
                        rhs,
                        SyntaxTreeConstants.SYNTAX_TREE_GT));
    }

    public static CaptureBindingPatternNode getCaptureBindingPatternNode(String name) {
        return NodeFactory.createCaptureBindingPatternNode(AbstractNodeFactory.createIdentifierToken(name));
    }

    public static TypedBindingPatternNode getTypedBindingPatternNode(TypeDescriptorNode typeDescriptorNode,
                                                                     BindingPatternNode bindingPatternNode) {
        return NodeFactory.createTypedBindingPatternNode(typeDescriptorNode, bindingPatternNode);
    }

    public static TupleTypeDescriptorNode getTupleTypeDescriptorNode(SeparatedNodeList<Node> memberTypeDesc) {
        return NodeFactory.createTupleTypeDescriptorNode(
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACKET,
                memberTypeDesc,
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACKET
        );
    }

    public static ListBindingPatternNode getListBindingPatternNode(SeparatedNodeList<BindingPatternNode> bindingPatterns) {
        return NodeFactory.createListBindingPatternNode(
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACKET,
                bindingPatterns,
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACKET
        );
    }

    public static TypeCastExpressionNode getTypeCastExpressionNode(String typeCastParam, ExpressionNode expression) {
        return NodeFactory.createTypeCastExpressionNode(
                SyntaxTreeConstants.SYNTAX_TREE_IT,
                NodeFactory.createTypeCastParamNode(
                        NodeFactory.createEmptyNodeList(),
                        getBuiltinSimpleNameReferenceNode(typeCastParam)
                ),
                SyntaxTreeConstants.SYNTAX_TREE_GT,
                expression
        );
    }
}
