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

import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.IfElseStatementNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.StatementNode;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

/**
 * Class representing IfElseStatementNode.
 *
 * @since 0.8.0
 */
public class IfElse {

    private final ExpressionNode condition;
    private Node elseBody;
    private NodeList<StatementNode> ifStatements;
    private NodeList<StatementNode> elseStatements;

    public IfElse(ExpressionNode condition) {
        this.condition = condition;
        ifStatements = NodeFactory.createEmptyNodeList();
        elseStatements = NodeFactory.createEmptyNodeList();
    }

    public IfElseStatementNode getIfElseStatementNode() {
        if (elseStatements.size() > 0) {
            elseBody = NodeFactory.createElseBlockNode(
                    SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_ELSE,
                    NodeFactory.createBlockStatementNode(
                            SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE,
                            elseStatements,
                            SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE
                    )
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

    public void addIfStatement(StatementNode statement) {
        ifStatements = ifStatements.add(statement);
    }

    public void addElseStatement(StatementNode statement) {
        elseStatements = elseStatements.add(statement);
    }
}
