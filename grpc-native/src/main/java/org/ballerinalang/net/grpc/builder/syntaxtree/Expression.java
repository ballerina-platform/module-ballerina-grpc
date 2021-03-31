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
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.FieldAccessExpressionNode;
import io.ballerina.compiler.syntax.tree.FunctionArgumentNode;
import io.ballerina.compiler.syntax.tree.ImplicitNewExpressionNode;
import io.ballerina.compiler.syntax.tree.MethodCallExpressionNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.RemoteMethodCallActionNode;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.compiler.syntax.tree.SimpleNameReferenceNode;
import org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants;

import java.util.ArrayList;
import java.util.List;

import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getBuiltinSimpleNameReferenceNode;

public class Expression {

    public static SimpleNameReferenceNode getSimpleNameReferenceNode(String name) {
        return NodeFactory.createSimpleNameReferenceNode(AbstractNodeFactory.createIdentifierToken(name + " "));
    }
    public static FieldAccessExpressionNode getFieldAccessExpressionNode(String var, String fieldName) {
        return NodeFactory.createFieldAccessExpressionNode(
                getSimpleNameReferenceNode(var),
                SyntaxTreeConstants.SYNTAX_TREE_DOT,
                getBuiltinSimpleNameReferenceNode(fieldName)
        );
    }

    public static MethodCallExpressionNode getMethodCallExpressionNode(ExpressionNode expression, String methodName, String[] args) {
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

    public static RemoteMethodCallActionNode getRemoteMethodCallActionNode(ExpressionNode expression, String methodName, String[] args) {
        List<Node> argList = new ArrayList<>();
        for (String arg : args) {
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
}
