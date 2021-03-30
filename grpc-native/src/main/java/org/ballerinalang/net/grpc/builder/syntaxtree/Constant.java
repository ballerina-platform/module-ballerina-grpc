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
import io.ballerina.compiler.syntax.tree.BasicLiteralNode;
import io.ballerina.compiler.syntax.tree.ConstantDeclarationNode;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.compiler.syntax.tree.TypeDescriptorNode;
import org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.builder.syntaxtree.Literal.getLiteralValueToken;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getBuiltinSimpleNameReferenceNode;

public class Constant {

    private Token visibilityQualifier;
    private final Token constKeyWord = AbstractNodeFactory.createIdentifierToken("const ");
    private final TypeDescriptorNode typeDescriptor;
    private final Token variableName;
    private final BasicLiteralNode initializer;

    public Constant(String type, String name, String value, boolean isPublic) {
        if (isPublic) {
            visibilityQualifier = AbstractNodeFactory.createIdentifierToken("\npublic ");
        }
        typeDescriptor = getBuiltinSimpleNameReferenceNode(type);
        variableName = AbstractNodeFactory.createIdentifierToken(name);
        initializer = NodeFactory.createBasicLiteralNode(SyntaxKind.STRING_LITERAL, getLiteralValueToken(value));
    }

    public ConstantDeclarationNode getConstantDeclarationNode() {
        return NodeFactory.createConstantDeclarationNode(
                null,
                null,
                constKeyWord,
                typeDescriptor,
                variableName,
                SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                initializer,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        );
    }
}
