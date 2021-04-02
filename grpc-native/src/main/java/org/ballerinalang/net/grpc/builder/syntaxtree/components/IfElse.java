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
import io.ballerina.compiler.syntax.tree.VariableDeclarationNode;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getSimpleNameReferenceNode;

public class IfElse {

    private ExpressionNode condition;
    private Node elseBody;
    private NodeList<StatementNode> ifStatements;
    private NodeList<StatementNode> elseStatements;

    public IfElse(ExpressionNode condition) {
        this.condition = condition;
        ifStatements = NodeFactory.createEmptyNodeList();
        elseStatements = NodeFactory.createEmptyNodeList();
    }

    public IfElseStatementNode getIfElseStatementNode() {
        if (elseBody == null && elseStatements.size() > 0) {
            elseBody = NodeFactory.createBlockStatementNode(
                    SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE,
                    elseStatements,
                    SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE
            );
        }
        return NodeFactory.createIfElseStatementNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_IF,
                condition,
                NodeFactory.createBlockStatementNode(
                        SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE,
                        ifStatements,
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

    public void addElseBody() {
        elseBody = NodeFactory.createElseBlockNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_ELSE,
                NodeFactory.createBlockStatementNode(
                        SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE,
                        elseStatements,
                        SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE
                )
        );
    }

    public void addIfReturnStatement(ExpressionNode expressionNode) {
        ifStatements = ifStatements.add(
                NodeFactory.createReturnStatementNode(
                        SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_RETURN,
                        expressionNode,
                        SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
                ));
    }

    public void addElseReturnStatement(ExpressionNode expressionNode) {
        elseStatements = elseStatements.add(
                NodeFactory.createReturnStatementNode(
                        SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_RETURN,
                        expressionNode,
                        SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
                ));
        addElseBody();
    }

    public void addIfAssignmentStatement(String varRef, ExpressionNode expression) {
        ifStatements =  ifStatements.add(
                NodeFactory.createAssignmentStatementNode(
                        getSimpleNameReferenceNode(varRef),
                        SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                        expression,
                        SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
                )
        );
    }

    public void addElseAssignmentStatement(String varRef, ExpressionNode expression) {
        elseStatements =  elseStatements.add(
                NodeFactory.createAssignmentStatementNode(
                        getSimpleNameReferenceNode(varRef),
                        SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                        expression,
                        SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
                )
        );
        addElseBody();
    }

    public void addElseVariableDeclarationStatement(VariableDeclarationNode variableDeclarationNode) {
        elseStatements = elseStatements.add(variableDeclarationNode);
        addElseBody();
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
}
