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

package org.ballerinalang.net.grpc.builder.utils;

import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.AnnotationNode;
import io.ballerina.compiler.syntax.tree.BasicLiteralNode;
import io.ballerina.compiler.syntax.tree.BindingPatternNode;
import io.ballerina.compiler.syntax.tree.ErrorTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.ExpressionStatementNode;
import io.ballerina.compiler.syntax.tree.FunctionArgumentNode;
import io.ballerina.compiler.syntax.tree.FunctionBodyBlockNode;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.FunctionSignatureNode;
import io.ballerina.compiler.syntax.tree.IdentifierToken;
import io.ballerina.compiler.syntax.tree.ImplicitNewExpressionNode;
import io.ballerina.compiler.syntax.tree.ImportDeclarationNode;
import io.ballerina.compiler.syntax.tree.ImportOrgNameNode;
import io.ballerina.compiler.syntax.tree.ListenerDeclarationNode;
import io.ballerina.compiler.syntax.tree.MappingFieldNode;
import io.ballerina.compiler.syntax.tree.Minutiae;
import io.ballerina.compiler.syntax.tree.MinutiaeList;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.ParameterNode;
import io.ballerina.compiler.syntax.tree.ParenthesizedArgList;
import io.ballerina.compiler.syntax.tree.PositionalArgumentNode;
import io.ballerina.compiler.syntax.tree.QualifiedNameReferenceNode;
import io.ballerina.compiler.syntax.tree.RequiredParameterNode;
import io.ballerina.compiler.syntax.tree.ReturnStatementNode;
import io.ballerina.compiler.syntax.tree.ReturnTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.compiler.syntax.tree.SimpleNameReferenceNode;
import io.ballerina.compiler.syntax.tree.SpecificFieldNode;
import io.ballerina.compiler.syntax.tree.StatementNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.compiler.syntax.tree.TypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.UnionTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.VariableDeclarationNode;
import org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants;

import java.util.ArrayList;
import java.util.List;

public class SyntaxTreeUtils {

    private final static String HELLO_FUNCTION = "hello";

    public static ImportDeclarationNode getImportDeclarationNode(String orgName, String moduleName) {
        Token orgNameToken = AbstractNodeFactory.createIdentifierToken(orgName);
        ImportOrgNameNode importOrgNameNode = NodeFactory.createImportOrgNameNode(orgNameToken, SyntaxTreeConstants.SYNTAX_TREE_SLASH);
        Token moduleNameToken = AbstractNodeFactory.createIdentifierToken(moduleName);
        SeparatedNodeList<IdentifierToken> moduleNodeList = AbstractNodeFactory.createSeparatedNodeList(moduleNameToken);

        return NodeFactory.createImportDeclarationNode(SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_IMPORT, importOrgNameNode,
                moduleNodeList, null, SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON );
    }

    public static ListenerDeclarationNode getListenerDeclarationNode(Integer port, String host) {
        IdentifierToken identifier = AbstractNodeFactory.createIdentifierToken("Listener");
        QualifiedNameReferenceNode typeDescriptor = NodeFactory.createQualifiedNameReferenceNode(SyntaxTreeConstants.SYNTAX_TREE_MODULE_PREFIX_GRPC,
                SyntaxTreeConstants.SYNTAX_TREE_COLON, identifier);

        Token variableName = AbstractNodeFactory.createIdentifierToken(" ep ");
        MinutiaeList leading = AbstractNodeFactory.createEmptyMinutiaeList();
        Minutiae whitespace = AbstractNodeFactory.createWhitespaceMinutiae(" ");
        MinutiaeList trailing = AbstractNodeFactory.createMinutiaeList(whitespace);
        variableName.modify(leading, trailing);

        Token literalToken = AbstractNodeFactory.createLiteralValueToken(SyntaxKind.DECIMAL_INTEGER_LITERAL_TOKEN
                , String.valueOf(port),leading, trailing);
        BasicLiteralNode expression = NodeFactory.createBasicLiteralNode(SyntaxKind.NUMERIC_LITERAL, literalToken);

        PositionalArgumentNode portNode = NodeFactory.createPositionalArgumentNode(expression);

        SeparatedNodeList<FunctionArgumentNode> arguments = NodeFactory.createSeparatedNodeList(portNode);

        ParenthesizedArgList parenthesizedArgList =
                NodeFactory.createParenthesizedArgList(SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN, arguments, SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN);
        ImplicitNewExpressionNode initializer =
                NodeFactory.createImplicitNewExpressionNode(SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_NEW, parenthesizedArgList);

        return NodeFactory.createListenerDeclarationNode(null, null, SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_LISTENER,
                typeDescriptor, variableName, SyntaxTreeConstants.SYNTAX_TREE_EQUAL, initializer, SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON);
    }

    public static FunctionDefinitionNode getFunctionDefinitionNode(List<Node> functions, List<Node> pathNodes) {
        NodeList<Token> qualifiersList = NodeFactory.createNodeList(SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_REMOTE);
        IdentifierToken functionName = AbstractNodeFactory.createIdentifierToken(HELLO_FUNCTION + " ");
        NodeList<Node> relativeResourcePath = NodeFactory.createNodeList(pathNodes);

        // Function signature
        List<Node> params = new ArrayList<>();
        NodeList<AnnotationNode> annotations = AbstractNodeFactory.createEmptyNodeList();
        SimpleNameReferenceNode typeName = NodeFactory.createSimpleNameReferenceNode(AbstractNodeFactory.
                createIdentifierToken("ContextString"));
        RequiredParameterNode requestNode = NodeFactory.createRequiredParameterNode(annotations, typeName, SyntaxTreeConstants.SYNTAX_TREE_PARAM_REQUEST);
        params.add(requestNode);

        SeparatedNodeList<ParameterNode> parameters = AbstractNodeFactory.createSeparatedNodeList(params);

        //return Type descriptors
        ReturnTypeDescriptorNode returnNode = getReturnTypeDescriptorNode();
        FunctionSignatureNode functionSignatureNode = NodeFactory.createFunctionSignatureNode(SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                parameters, SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN, returnNode);

        // Function Body
        ExpressionNode initializer;
        NodeList<StatementNode> statements = AbstractNodeFactory.createNodeList();

        statements = statements.add(getLogPrintExpressionStatement("\"Invoked the hello RPC call.\""));

        TypeDescriptorNode typeDescriptorNode = NodeFactory.createBuiltinSimpleNameReferenceNode(SyntaxKind.STREAM_TYPE_DESC, AbstractNodeFactory.createIdentifierToken("    string"));
        BindingPatternNode bindingPatternNode = NodeFactory.createCaptureBindingPatternNode(AbstractNodeFactory.createIdentifierToken(" message"));
        Node lhsExpr = NodeFactory.createBasicLiteralNode(SyntaxKind.STRING_LITERAL, AbstractNodeFactory.createIdentifierToken("\"Hello \""));
        Node rhsExpr = NodeFactory.createAnnotAccessExpressionNode(NodeFactory.createSimpleNameReferenceNode(AbstractNodeFactory.createIdentifierToken("request")), SyntaxTreeConstants.SYNTAX_TREE_DOT, NodeFactory.createSimpleNameReferenceNode(AbstractNodeFactory.createIdentifierToken("content")));
        initializer = NodeFactory.createBinaryExpressionNode(SyntaxKind.BINARY_EXPRESSION, lhsExpr, SyntaxTreeConstants.SYNTAX_TREE_CONCAT, rhsExpr);
        VariableDeclarationNode stringMessage = NodeFactory.createVariableDeclarationNode(annotations, null, NodeFactory.createTypedBindingPatternNode(typeDescriptorNode, bindingPatternNode), SyntaxTreeConstants.SYNTAX_TREE_EQUAL, initializer, SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON);
        statements = statements.add(stringMessage);

        Token grpcModulePrefix = AbstractNodeFactory.createIdentifierToken("grpc");
        QualifiedNameReferenceNode grpcFunctionName = NodeFactory.createQualifiedNameReferenceNode(
                grpcModulePrefix, SyntaxTreeConstants.SYNTAX_TREE_COLON, AbstractNodeFactory.createIdentifierToken("getHeader"));
        List<Node> args = new ArrayList<>();
        ExpressionNode expression;
        PositionalArgumentNode arg;

        expression = NodeFactory.createFieldAccessExpressionNode(NodeFactory.createSimpleNameReferenceNode(AbstractNodeFactory.createIdentifierToken("request")), SyntaxTreeConstants.SYNTAX_TREE_DOT, NodeFactory.createSimpleNameReferenceNode(AbstractNodeFactory.createIdentifierToken("headers")));
        arg = NodeFactory.createPositionalArgumentNode(expression);
        args.add(arg);

        args.add(AbstractNodeFactory.createIdentifierToken(",\n"));

        expression = NodeFactory.createBasicLiteralNode(SyntaxKind.STRING_LITERAL, AbstractNodeFactory.createIdentifierToken("client_header_key"));
        arg = NodeFactory.createPositionalArgumentNode(expression);
        args.add(arg);

        SeparatedNodeList<FunctionArgumentNode> arguments = AbstractNodeFactory.createSeparatedNodeList(args);
        expression = NodeFactory.createFunctionCallExpressionNode(grpcFunctionName, SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN, arguments, SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN);

        initializer = NodeFactory.createCheckExpressionNode(SyntaxKind.CHECK_EXPRESSION, SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_CHECK, expression);
        VariableDeclarationNode stringReqHeader = NodeFactory.createVariableDeclarationNode(annotations, null, NodeFactory.createTypedBindingPatternNode(typeDescriptorNode, bindingPatternNode), SyntaxTreeConstants.SYNTAX_TREE_EQUAL, initializer, SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON);
        statements = statements.add(stringReqHeader);

        statements = statements.add(getLogPrintExpressionStatement("\"Server received header value: \" + reqHeader"));

        List<Node> fields = new ArrayList<>();

        SimpleNameReferenceNode message = NodeFactory.createSimpleNameReferenceNode(AbstractNodeFactory.
                createIdentifierToken("message"));
        SpecificFieldNode content = NodeFactory.createSpecificFieldNode(null, AbstractNodeFactory.createIdentifierToken("content"), SyntaxTreeConstants.SYNTAX_TREE_COLON, message);
        fields.add(content);

        fields.add(AbstractNodeFactory.createIdentifierToken(",\n"));

        List<Node> headerValFields = new ArrayList<>();
        SpecificFieldNode serverHeader = NodeFactory.createSpecificFieldNode(null, AbstractNodeFactory.createIdentifierToken("server_header_key"), SyntaxTreeConstants.SYNTAX_TREE_COLON, NodeFactory.createBasicLiteralNode(SyntaxKind.STRING_LITERAL, AbstractNodeFactory.createIdentifierToken("        \"Response Header value\"")));
        headerValFields.add(serverHeader);
        SeparatedNodeList<MappingFieldNode> headerVal = NodeFactory.createSeparatedNodeList(headerValFields);
        expression = NodeFactory.createMappingConstructorExpressionNode(SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE, headerVal, SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE);
        SpecificFieldNode headers = NodeFactory.createSpecificFieldNode(null, AbstractNodeFactory.createIdentifierToken("headers"), SyntaxTreeConstants.SYNTAX_TREE_COLON, expression);
        fields.add(headers);

        SeparatedNodeList<MappingFieldNode> fieldsToken = NodeFactory.createSeparatedNodeList(fields);
        expression = NodeFactory.createMappingConstructorExpressionNode(SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE, fieldsToken, SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE);
        ReturnStatementNode returnStatementNode = NodeFactory.createReturnStatementNode(AbstractNodeFactory.createIdentifierToken("return"), expression, SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON);
        statements = statements.add(returnStatementNode);

        FunctionBodyBlockNode functionBodyBlockNode = NodeFactory
                .createFunctionBodyBlockNode(SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE, null, statements, SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE);
        return NodeFactory
                .createFunctionDefinitionNode(SyntaxKind.RESOURCE_ACCESSOR_DEFINITION, null,
                        qualifiersList, SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_FUNCTION, functionName, relativeResourcePath,
                        functionSignatureNode, functionBodyBlockNode);
    }

    private static ReturnTypeDescriptorNode getReturnTypeDescriptorNode() {
        Token returnKeyWord = AbstractNodeFactory.createIdentifierToken(" returns ");
        NodeList<AnnotationNode> annotations = AbstractNodeFactory.createEmptyNodeList();

        SimpleNameReferenceNode contextStringNode = NodeFactory.createSimpleNameReferenceNode(AbstractNodeFactory.
                createIdentifierToken("ContextString"));
        ErrorTypeDescriptorNode errorTypeDescriptorNode =
                NodeFactory.createErrorTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_ERROR, null);
        UnionTypeDescriptorNode returnNode = NodeFactory.createUnionTypeDescriptorNode(contextStringNode, SyntaxTreeConstants.SYNTAX_TREE_PIPE,
                errorTypeDescriptorNode);

        return NodeFactory.createReturnTypeDescriptorNode(returnKeyWord, annotations, returnNode);
    }

    private static ExpressionStatementNode getLogPrintExpressionStatement(String message) {
        Token logModulePrefix = AbstractNodeFactory.createIdentifierToken("    log");
        QualifiedNameReferenceNode logFunctionName = NodeFactory.createQualifiedNameReferenceNode(
                logModulePrefix, SyntaxTreeConstants.SYNTAX_TREE_COLON, AbstractNodeFactory.createIdentifierToken("print"));
        List<Node> args = new ArrayList<>();
        BasicLiteralNode expression = NodeFactory.createBasicLiteralNode(SyntaxKind.POSITIONAL_ARG, AbstractNodeFactory.createIdentifierToken(message));
        args.add(NodeFactory.createPositionalArgumentNode(expression));
        SeparatedNodeList<FunctionArgumentNode> arguments = AbstractNodeFactory.createSeparatedNodeList(args);
        ExpressionNode logExpressionNode = NodeFactory.createFunctionCallExpressionNode(logFunctionName, SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN, arguments, SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN);
        ExpressionStatementNode logStatementNode = NodeFactory.createExpressionStatementNode(SyntaxKind.CALL_STATEMENT,
                logExpressionNode, SyntaxTreeConstants.SYNTAX_TREE_SEMICOLON);
        return logStatementNode;
    }
}
