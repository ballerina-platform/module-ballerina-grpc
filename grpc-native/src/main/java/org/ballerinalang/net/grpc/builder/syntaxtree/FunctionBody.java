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

import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.ExpressionStatementNode;
import io.ballerina.compiler.syntax.tree.FunctionBodyNode;
import io.ballerina.compiler.syntax.tree.IfElseStatementNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.StatementNode;
import io.ballerina.compiler.syntax.tree.VariableDeclarationNode;
import org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants;

public class FunctionBody {

    private NodeList<StatementNode> statements;

    public FunctionBody() {
        statements = NodeFactory.createEmptyNodeList();
    }

    public FunctionBodyNode getFunctionBody() {
        return NodeFactory.createFunctionBodyBlockNode(
            SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE,
            null,
            statements,
            SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE
        );
    }

    public void addReturnStatement(ExpressionNode expressionNode) {
        statements = statements.add(NodeFactory.createReturnStatementNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_RETURN,
                expressionNode,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addVariableStatement(VariableDeclarationNode node) {
        statements = statements.add(node);
    }

    public void addAssignmentStatement(Node varRef, ExpressionNode expressionNode) {
        statements = statements.add(NodeFactory.createAssignmentStatementNode(
                varRef,
                SyntaxTreeConstants.SYNTAX_TREE_EQUAL,
                expressionNode,
                SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON
        ));
    }

    public void addIfElseStatement(IfElseStatementNode node) {
        statements = statements.add(node);
    }

    public void addExpressionStatement(ExpressionStatementNode expressionStatement) {
        statements = statements.add(expressionStatement);
    }
}
