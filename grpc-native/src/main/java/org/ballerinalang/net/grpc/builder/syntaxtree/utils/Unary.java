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

package org.ballerinalang.net.grpc.builder.syntaxtree.utils;

import io.ballerina.compiler.syntax.tree.BindingPatternNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import org.ballerinalang.net.grpc.builder.stub.Method;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionBody;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionDefinition;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionSignature;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Map;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Returns;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.VariableDeclaration;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getRemoteMethodCallActionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionParam.getRequiredParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getBracedExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.IfElse.getTypeTestExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Initializer.getCheckExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getListBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getParameterizedTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTupleTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getUnionTypeDescriptorNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING;
import static org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY;

public class Unary {

    public static FunctionDefinition getUnaryFunction(Method method) {
        String inputCap = method.getInputType().substring(0, 1).toUpperCase() + method.getInputType().substring(1);
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(
                getRequiredParamNode(
                        getUnionTypeDescriptorNode(
                                getSimpleNameReferenceNode(method.getInputType()),
                                getSimpleNameReferenceNode("Context" + inputCap)),
                        "req"));
        signature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        Returns.getParenthesisedTypeDescriptorNode(
                                getUnionTypeDescriptorNode(
                                        getSimpleNameReferenceNode(method.getOutputType()),
                                        SYNTAX_TREE_GRPC_ERROR))));
        FunctionBody body = addUnaryBody(inputCap, method);
        SeparatedNodeList<Node> payloadArgs = NodeFactory.createSeparatedNodeList(
                getBuiltinSimpleNameReferenceNode("anydata"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getParameterizedTypeDescriptorNode(
                        "map",
                        getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_VAR_STRING_ARRAY))
        );
        SeparatedNodeList<BindingPatternNode> bindingPatterns = NodeFactory.createSeparatedNodeList(
                getCaptureBindingPatternNode("result"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getCaptureBindingPatternNode("_"));
        VariableDeclaration payload = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getTupleTypeDescriptorNode(payloadArgs),
                        getListBindingPatternNode(bindingPatterns)),
                getSimpleNameReferenceNode("payload")
        );
        body.addVariableStatement(payload.getVariableDeclarationNode());
        body.addReturnStatement(
                getMethodCallExpressionNode(
                        getSimpleNameReferenceNode("result"),
                        "toString",
                        new String[]{}
                )
        );
        FunctionDefinition definition = new FunctionDefinition(method.getMethodName(),
                signature.getFunctionSignature(), body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    public static FunctionDefinition getUnaryContextFunction(Method method) {
        String inputCap = method.getInputType().substring(0, 1).toUpperCase() + method.getInputType().substring(1);
        FunctionSignature signature = new FunctionSignature();
        signature.addParameter(
                getRequiredParamNode(
                        getUnionTypeDescriptorNode(
                                getSimpleNameReferenceNode(method.getInputType()),
                                getSimpleNameReferenceNode("Context" + inputCap)),
                        "req"));
        signature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        Returns.getParenthesisedTypeDescriptorNode(
                                getUnionTypeDescriptorNode(
                                        getSimpleNameReferenceNode("Context" + inputCap),
                                        SYNTAX_TREE_GRPC_ERROR))));
        FunctionBody body = addUnaryBody(inputCap, method);
        SeparatedNodeList<Node> payloadArgs = NodeFactory.createSeparatedNodeList(
                getBuiltinSimpleNameReferenceNode("anydata"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getParameterizedTypeDescriptorNode(
                        "map",
                        getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_VAR_STRING_ARRAY))
        );
        SeparatedNodeList<BindingPatternNode> bindingPatterns = NodeFactory.createSeparatedNodeList(
                getCaptureBindingPatternNode("result"),
                SyntaxTreeConstants.SYNTAX_TREE_COMMA,
                getCaptureBindingPatternNode("respHeaders"));
        VariableDeclaration payload = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getTupleTypeDescriptorNode(payloadArgs),
                        getListBindingPatternNode(bindingPatterns)),
                getSimpleNameReferenceNode("payload")
        );
        body.addVariableStatement(payload.getVariableDeclarationNode());
        Map returnMap = new Map();
        returnMap.addMethodCallField(
                "content",
                getSimpleNameReferenceNode("result"),
                "toString",
                new String[]{}
        );
        returnMap.addSimpleNameReferenceField("headers", "respHeaders");
        body.addReturnStatement(returnMap.getMappingConstructorExpressionNode());
        FunctionDefinition definition = new FunctionDefinition(
                method.getMethodName() + "Context",
                signature.getFunctionSignature(),
                body.getFunctionBody());
        definition.addQualifiers(new String[]{"isolated", "remote"});
        return definition;
    }

    private static FunctionBody addUnaryBody(String inputCap, Method method) {
        FunctionBody body = new FunctionBody();
        VariableDeclaration headers = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getParameterizedTypeDescriptorNode(
                                "map",
                                getUnionTypeDescriptorNode(SYNTAX_TREE_VAR_STRING, SYNTAX_TREE_VAR_STRING_ARRAY)),
                        getCaptureBindingPatternNode("headers")),
                new Map().getMappingConstructorExpressionNode()
        );
        body.addVariableStatement(headers.getVariableDeclarationNode());
        VariableDeclaration message = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getBuiltinSimpleNameReferenceNode("string"),
                        getCaptureBindingPatternNode("message")),
                null
        );
        body.addVariableStatement(message.getVariableDeclarationNode());
        IfElse reqIsContext = new IfElse(
                getBracedExpressionNode(
                        getTypeTestExpressionNode(
                                getSimpleNameReferenceNode("req"),
                                getSimpleNameReferenceNode("Context" + inputCap)
                        )));
        reqIsContext.addIfAssignmentStatement(
                "message",
                getFieldAccessExpressionNode("req", "content"));
        reqIsContext.addIfAssignmentStatement(
                "headers",
                getFieldAccessExpressionNode("req", "headers"));
        reqIsContext.addElseBody();
        reqIsContext.addElseAssignmentStatement(
                "message",
                getSimpleNameReferenceNode("req")
        );
        body.addIfElseStatement(reqIsContext.getIfElseStatementNode());

        VariableDeclaration payload = new VariableDeclaration(
                getTypedBindingPatternNode(
                        getBuiltinSimpleNameReferenceNode("var"),
                        getCaptureBindingPatternNode("payload")),
                getCheckExpressionNode(
                        getRemoteMethodCallActionNode(
                                getFieldAccessExpressionNode("self", "grpcClient"),
                                "executeSimpleRPC",
                                new String[]{"\"" + method.getMethodId() +  "\"", "message", "headers"}
                        )
                )
        );
        body.addVariableStatement(payload.getVariableDeclarationNode());
        return body;
    }
}
