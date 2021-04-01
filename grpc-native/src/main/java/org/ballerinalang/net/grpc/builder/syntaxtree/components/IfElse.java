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

import io.ballerina.compiler.syntax.tree.BlockStatementNode;
import io.ballerina.compiler.syntax.tree.BracedExpressionNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.IfElseStatementNode;
import io.ballerina.compiler.syntax.tree.NilTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.StatementNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.TypeTestExpressionNode;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import java.util.ArrayList;

public class IfElse {

    private ExpressionNode condition;
    private Node elseBody;
    private NodeList<StatementNode> statements;

    public IfElse(ExpressionNode condition) {
        this.condition = condition;
        statements = NodeFactory.createEmptyNodeList();
    }

    public IfElseStatementNode getIfElseStatementNode() {
        return NodeFactory.createIfElseStatementNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_IF,
                condition,
                NodeFactory.createBlockStatementNode(
                        SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE,
                        statements,
                        SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE
                ),
                elseBody
        );
    }

    public void addElseBody(IfElse elseBody) {
        this.elseBody = NodeFactory.createElseBlockNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_ELSE,
                elseBody.getIfElseStatementNode()
        );
    }

    public void addElseBody(BlockStatementNode elseBody) {
        this.elseBody = NodeFactory.createElseBlockNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_ELSE,
                elseBody
        );
    }

    public static BracedExpressionNode getBracedExpressionNode(ExpressionNode expression) {
        return NodeFactory.createBracedExpressionNode(
                SyntaxKind.BRACED_EXPRESSION,
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                expression,
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN
        );
    }

    public static TypeTestExpressionNode getTypeTestExpressionNode(ExpressionNode expression, Node typeDescriptor) {
        return NodeFactory.createTypeTestExpressionNode(
                expression,
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_IS,
                typeDescriptor
        );
    }

    public static NilTypeDescriptorNode getNilTypeDescriptorNode() {
        return NodeFactory.createNilTypeDescriptorNode(
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN
        );
    }

    public void addReturnStatement(ExpressionNode expressionNode) {
        statements = statements.add(NodeFactory.createReturnStatementNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_RETURN,
                expressionNode,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public static BlockStatementNode getBlockStatementNode(ArrayList<StatementNode> statements) {
        NodeList<StatementNode> statementNodes;
        if (statements == null) {
            statementNodes = NodeFactory.createEmptyNodeList();
        } else {
            statementNodes = NodeFactory.createNodeList(statements);
        }
        return NodeFactory.createBlockStatementNode(
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE,
                statementNodes,
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE
        );
    }
}
