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
import io.ballerina.compiler.syntax.tree.BinaryExpressionNode;
import io.ballerina.compiler.syntax.tree.BracedExpressionNode;
import io.ballerina.compiler.syntax.tree.CheckExpressionNode;
import io.ballerina.compiler.syntax.tree.ExplicitNewExpressionNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.FieldAccessExpressionNode;
import io.ballerina.compiler.syntax.tree.FunctionArgumentNode;
import io.ballerina.compiler.syntax.tree.FunctionCallExpressionNode;
import io.ballerina.compiler.syntax.tree.ImplicitNewExpressionNode;
import io.ballerina.compiler.syntax.tree.ListConstructorExpressionNode;
import io.ballerina.compiler.syntax.tree.MethodCallExpressionNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.OptionalFieldAccessExpressionNode;
import io.ballerina.compiler.syntax.tree.RemoteMethodCallActionNode;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.compiler.syntax.tree.TypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.TypeTestExpressionNode;
import io.ballerina.compiler.syntax.tree.UnaryExpressionNode;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import java.util.ArrayList;
import java.util.List;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getSimpleNameReferenceNode;

/**
 * Class representing different types of ExpressionNodes.
 *
 * @since 0.8.0
 */
public class Expression {

    private Expression() {

    }

    public static FieldAccessExpressionNode getFieldAccessExpressionNode(String var, String fieldName) {
        return NodeFactory.createFieldAccessExpressionNode(
                getSimpleNameReferenceNode(var),
                SyntaxTreeConstants.SYNTAX_TREE_DOT,
                getSimpleNameReferenceNode(fieldName)
        );
    }

    public static OptionalFieldAccessExpressionNode getOptionalFieldAccessExpressionNode(String var, String fieldName) {
        return NodeFactory.createOptionalFieldAccessExpressionNode(
                getSimpleNameReferenceNode(var),
                SyntaxTreeConstants.SYNTAX_TREE_OPTIONAL_CHAINING,
                getSimpleNameReferenceNode(fieldName)
        );
    }

    public static MethodCallExpressionNode getMethodCallExpressionNode(ExpressionNode expression, String methodName,
                                                                       String[] args) {
        List<Node> argList = new ArrayList<>();
        for (String arg : args) {
            if (argList.size() > 0) {
                argList.add(SyntaxTreeConstants.SYNTAX_TREE_COMMA);
            }
            argList.add(NodeFactory.createPositionalArgumentNode(getSimpleNameReferenceNode(arg)));
        }
        SeparatedNodeList<FunctionArgumentNode> arguments = NodeFactory.createSeparatedNodeList(argList);
        return NodeFactory.createMethodCallExpressionNode(
                expression,
                SyntaxTreeConstants.SYNTAX_TREE_DOT,
                getSimpleNameReferenceNode(methodName),
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                arguments,
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN
        );
    }

    public static RemoteMethodCallActionNode getRemoteMethodCallActionNode(ExpressionNode expression, String methodName,
                                                                           String[] args) {
        List<Node> argList = new ArrayList<>();
        for (String arg : args) {
            if (argList.size() > 0) {
                argList.add(SyntaxTreeConstants.SYNTAX_TREE_COMMA);
            }
            argList.add(NodeFactory.createPositionalArgumentNode(getSimpleNameReferenceNode(arg)));
        }
        SeparatedNodeList<FunctionArgumentNode> arguments = NodeFactory.createSeparatedNodeList(argList);
        return NodeFactory.createRemoteMethodCallActionNode(
                expression,
                SyntaxTreeConstants.SYNTAX_TREE_RIGHT_ARROW,
                getSimpleNameReferenceNode(methodName),
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                arguments,
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN
        );
    }

    public static ImplicitNewExpressionNode getImplicitNewExpressionNode(String[] args) {
        List<Node> arguments = new ArrayList<>();
        for (String arg : args) {
            if (arguments.size() > 0) {
                arguments.add(SyntaxTreeConstants.SYNTAX_TREE_COMMA);
            }
            arguments.add(NodeFactory.createPositionalArgumentNode(getSimpleNameReferenceNode(arg)));
        }
        return NodeFactory.createImplicitNewExpressionNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_NEW,
                NodeFactory.createParenthesizedArgList(
                        SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                        NodeFactory.createSeparatedNodeList(arguments),
                        SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN
                )
        );
    }

    public static ExplicitNewExpressionNode getExplicitNewExpressionNode(String type, String[] args) {
        List<Node> arguments = new ArrayList<>();
        for (String arg : args) {
            if (arguments.size() > 0) {
                arguments.add(SyntaxTreeConstants.SYNTAX_TREE_COMMA);
            }
            arguments.add(NodeFactory.createPositionalArgumentNode(getSimpleNameReferenceNode(arg)));
        }
        return NodeFactory.createExplicitNewExpressionNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_NEW,
                getSimpleNameReferenceNode(type),
                NodeFactory.createParenthesizedArgList(
                        SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                        NodeFactory.createSeparatedNodeList(arguments),
                        SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN
                )
        );
    }

    public static ExplicitNewExpressionNode getExplicitNewExpressionNode(TypeDescriptorNode type, String[] args) {
        List<Node> arguments = new ArrayList<>();
        for (String arg : args) {
            if (arguments.size() > 0) {
                arguments.add(SyntaxTreeConstants.SYNTAX_TREE_COMMA);
            }
            arguments.add(NodeFactory.createPositionalArgumentNode(getSimpleNameReferenceNode(arg)));
        }
        return NodeFactory.createExplicitNewExpressionNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_NEW,
                type,
                NodeFactory.createParenthesizedArgList(
                        SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                        NodeFactory.createSeparatedNodeList(arguments),
                        SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN
                )
        );
    }

    public static FunctionCallExpressionNode getFunctionCallExpressionNode(String name, String[] args) {
        List<Node> arguments = new ArrayList<>();
        for (String arg : args) {
            arguments.add(
                    NodeFactory.createSpecificFieldNode(
                            null,
                            AbstractNodeFactory.createIdentifierToken(arg),
                            SyntaxTreeConstants.SYNTAX_TREE_COLON,
                            NodeFactory.createSimpleNameReferenceNode(AbstractNodeFactory.createIdentifierToken(arg))
                    )
            );
        }
        return NodeFactory.createFunctionCallExpressionNode(
                getSimpleNameReferenceNode(name),
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                NodeFactory.createSeparatedNodeList(arguments),
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN
        );
    }

    public static ListConstructorExpressionNode getListConstructorExpressionNode(List<Node> expressions) {
        if (expressions == null) {
            expressions = new ArrayList<>();
        }
        return NodeFactory.createListConstructorExpressionNode(
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACKET,
                NodeFactory.createSeparatedNodeList(expressions),
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACKET
        );
    }

    public static BinaryExpressionNode getBinaryExpressionNode(Node lhs, Node rhs, Token operator) {
        return NodeFactory.createBinaryExpressionNode(
                SyntaxKind.BINARY_EXPRESSION,
                lhs,
                operator,
                rhs
        );
    }

    public static UnaryExpressionNode getUnaryExpressionNode(ExpressionNode expression) {
        return NodeFactory.createUnaryExpressionNode(
                SyntaxTreeConstants.SYNTAX_TREE_OPERATOR_UNARY,
                expression
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

    public static CheckExpressionNode getCheckExpressionNode(ExpressionNode expression) {
        return NodeFactory.createCheckExpressionNode(
                SyntaxKind.CHECK_ACTION,
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_CHECK,
                expression
        );
    }
}
