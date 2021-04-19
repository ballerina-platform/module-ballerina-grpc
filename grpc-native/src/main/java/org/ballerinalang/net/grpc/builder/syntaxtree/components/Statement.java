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

import io.ballerina.compiler.syntax.tree.CompoundAssignmentStatementNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.ReturnStatementNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.Token;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Literal.getLiteralValueToken;

public class Statement {

    public static CompoundAssignmentStatementNode getCompoundAssignmentStatementNode(String lhs, Token binaryOperator, int value) {
        return NodeFactory.createCompoundAssignmentStatementNode(
                getSimpleNameReferenceNode(lhs),
                binaryOperator,
                SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                // Todo: function to return BasicLiteralNode
                NodeFactory.createBasicLiteralNode(
                        SyntaxKind.NUMERIC_LITERAL,
                        getLiteralValueToken(value)
                ),
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        );
    }

    public static ReturnStatementNode getReturnStatementNode(ExpressionNode expression) {
        return NodeFactory.createReturnStatementNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_RETURN,
                expression,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        );
    }
}
