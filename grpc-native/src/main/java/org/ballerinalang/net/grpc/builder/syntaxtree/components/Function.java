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
import io.ballerina.compiler.syntax.tree.AnnotationNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.ExpressionStatementNode;
import io.ballerina.compiler.syntax.tree.FunctionBodyNode;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.FunctionSignatureNode;
import io.ballerina.compiler.syntax.tree.IdentifierToken;
import io.ballerina.compiler.syntax.tree.IfElseStatementNode;
import io.ballerina.compiler.syntax.tree.IncludedRecordParameterNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.RequiredParameterNode;
import io.ballerina.compiler.syntax.tree.ReturnTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.StatementNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.compiler.syntax.tree.TypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.VariableDeclarationNode;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import java.util.ArrayList;
import java.util.List;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Returns.getReturnTypeDescriptorNode;

public class Function {

    private final SyntaxKind kind = SyntaxKind.OBJECT_METHOD_DEFINITION;
    private NodeList<Token> qualifierList;
    private final Token finalKeyWord = AbstractNodeFactory.createIdentifierToken("function ");
    private final IdentifierToken functionName;
    private final NodeList<Node> relativeResourcePath;
    private final FunctionSignatureNode functionSignature;
    private final FunctionBodyNode functionBody;

    private final List<Node> parameters;
    private ReturnTypeDescriptorNode returnTypeDescriptorNode;

    private NodeList<StatementNode> statements;

    public Function(String name) {
        qualifierList = AbstractNodeFactory.createEmptyNodeList();
        functionName = AbstractNodeFactory.createIdentifierToken(name);
        relativeResourcePath = AbstractNodeFactory.createEmptyNodeList();

        parameters = new ArrayList<>();
        functionSignature = getFunctionSignature();

        statements = NodeFactory.createEmptyNodeList();
        functionBody = getFunctionBody();
    }

    public FunctionDefinitionNode getFunctionDefinitionNode() {
        return NodeFactory.createFunctionDefinitionNode(
                kind,
                null,
                qualifierList,
                finalKeyWord,
                functionName,
                relativeResourcePath,
                getFunctionSignature(),
                getFunctionBody()

        );
    }

    public void addQualifiers(String[] qualifiers) {
        for (String qualifier: qualifiers) {
            qualifierList = qualifierList.add(AbstractNodeFactory.createIdentifierToken(qualifier + " "));
        }
    }

    private FunctionSignatureNode getFunctionSignature() {
        return NodeFactory.createFunctionSignatureNode(
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                AbstractNodeFactory.createSeparatedNodeList(parameters),
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN,
                returnTypeDescriptorNode
        );
    }

    public void addParameter(Node parameterNode) {
        if (parameters.size() > 0) {
            parameters.add(SyntaxTreeConstants.SYNTAX_TREE_COMMA);
        }
        parameters.add(parameterNode);
    }

    public void addReturns(TypeDescriptorNode node) {
        returnTypeDescriptorNode = getReturnTypeDescriptorNode(node);
    }

    private FunctionBodyNode getFunctionBody() {
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

    public static RequiredParameterNode getRequiredParamNode(Node typeName, String name) {
        NodeList<AnnotationNode> annotations = NodeFactory.createEmptyNodeList();
        return NodeFactory.createRequiredParameterNode(
                annotations,
                typeName,
                AbstractNodeFactory.createIdentifierToken(name)
        );
    }

    public static IncludedRecordParameterNode getIncludedRecordParamNode(Node typeName, String name) {
        NodeList<AnnotationNode> annotations = NodeFactory.createEmptyNodeList();
        return NodeFactory.createIncludedRecordParameterNode(
                annotations,
                SyntaxTreeConstants.SYNTAX_TREE_ASTERISK,
                typeName,
                AbstractNodeFactory.createIdentifierToken(name)
        );
    }
}
