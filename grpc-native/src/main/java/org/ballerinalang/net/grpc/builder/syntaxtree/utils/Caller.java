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

import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Class;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionBody;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionDefinition;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionSignature;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.Returns;
import org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor;

import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getFieldAccessExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getMethodCallExpressionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getRemoteMethodCallActionNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.Expression.getSimpleNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.FunctionParam.getRequiredParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getObjectFieldNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.components.TypeDescriptor.getQualifiedNameReferenceNode;

public class Caller {

    public static Class getCallerClass(String key, String value) {
        Class caller = new Class(key, true);
        caller.addQualifiers(new String[]{"client"});

        caller.addMember(
                getObjectFieldNode(
                        "private",
                        new String[]{},
                        getQualifiedNameReferenceNode("grpc", "Caller"),
                        "caller"));

        FunctionSignature initSignature = new FunctionSignature();
        initSignature.addParameter(
                getRequiredParamNode(
                        TypeDescriptor.getQualifiedNameReferenceNode("grpc", "Caller"),
                        "caller"));
        FunctionBody initBody = new FunctionBody();
        initBody.addAssignmentStatement(
                getFieldAccessExpressionNode("self", "caller"),
                getSimpleNameReferenceNode("caller"));
        FunctionDefinition initDefinition = new FunctionDefinition(
                "init",
                initSignature.getFunctionSignature(),
                initBody.getFunctionBody());
        initDefinition.addQualifiers(new String[]{"public", "isolated"});
        caller.addMember(initDefinition.getFunctionDefinitionNode());

        FunctionSignature getIdSignature = new FunctionSignature();
        getIdSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        NodeFactory.createBuiltinSimpleNameReferenceNode(
                                SyntaxKind.INT_TYPE_DESC,
                                AbstractNodeFactory.createIdentifierToken("int"))));
        FunctionBody getIdBody = new FunctionBody();
        getIdBody.addReturnStatement(
                getMethodCallExpressionNode(
                        getFieldAccessExpressionNode("self", "caller"),
                        "getId",
                        new String[]{}));
        FunctionDefinition getIdDefinition = new FunctionDefinition(
                "getId",
                getIdSignature.getFunctionSignature(),
                getIdBody.getFunctionBody());
        getIdDefinition.addQualifiers(new String[]{"public", "isolated"});
        caller.addMember(getIdDefinition.getFunctionDefinitionNode());

        FunctionSignature sendSignature = new FunctionSignature();
        sendSignature.addParameter(
                getRequiredParamNode(
                        getSimpleNameReferenceNode(value),
                        "response"));
        sendSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody sendBody = new FunctionBody();
        sendBody.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "caller"),
                        "send",
                        new String[]{"response"}));
        FunctionDefinition sendDefinition = new FunctionDefinition(
                "send" + value,
                sendSignature.getFunctionSignature(),
                sendBody.getFunctionBody());
        sendDefinition.addQualifiers(new String[]{"isolated", "remote"});
        caller.addMember(sendDefinition.getFunctionDefinitionNode());

        FunctionSignature sendContextSignature = new FunctionSignature();
        sendContextSignature.addParameter(
                getRequiredParamNode(
                        getSimpleNameReferenceNode("Context" + value),
                        "response"));
        sendContextSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody sendContextBody = new FunctionBody();
        sendContextBody.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "caller"),
                        "send",
                        new String[]{"response"}));
        FunctionDefinition sendContextDefinition = new FunctionDefinition("" +
                "sendContext" + value,
                sendContextSignature.getFunctionSignature(),
                sendContextBody.getFunctionBody());
        sendContextDefinition.addQualifiers(new String[]{"isolated", "remote"});
        caller.addMember(sendContextDefinition.getFunctionDefinitionNode());

        FunctionSignature sendErrorSignature = new FunctionSignature();
        sendErrorSignature.addParameter(
                getRequiredParamNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR,
                        "response"));
        sendErrorSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody sendErrorBody = new FunctionBody();
        sendErrorBody.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "caller"),
                        "sendError",
                        new String[]{"response"}));
        FunctionDefinition sendErrorDefinition = new FunctionDefinition(
                "sendError",
                sendErrorSignature.getFunctionSignature(),
                sendErrorBody.getFunctionBody());
        sendErrorDefinition.addQualifiers(new String[]{"isolated", "remote"});
        caller.addMember(sendErrorDefinition.getFunctionDefinitionNode());

        FunctionSignature completeSignature = new FunctionSignature();
        completeSignature.addReturns(
                Returns.getReturnTypeDescriptorNode(
                        SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR_OPTIONAL));
        FunctionBody completeBody = new FunctionBody();
        completeBody.addReturnStatement(
                getRemoteMethodCallActionNode(
                        getFieldAccessExpressionNode("self", "caller"),
                        "complete",
                        new String[]{}));
        FunctionDefinition completeDefinition = new FunctionDefinition(
                "complete",
                completeSignature.getFunctionSignature(),
                completeBody.getFunctionBody());
        completeDefinition.addQualifiers(new String[]{"isolated", "remote"});
        caller.addMember(completeDefinition.getFunctionDefinitionNode());

        return caller;
    }
}
