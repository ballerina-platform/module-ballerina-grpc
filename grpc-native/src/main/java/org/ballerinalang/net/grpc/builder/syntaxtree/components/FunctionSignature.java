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
import io.ballerina.compiler.syntax.tree.FunctionSignatureNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.ReturnTypeDescriptorNode;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import java.util.ArrayList;
import java.util.List;

public class FunctionSignature {

    List<Node> parameters;
    ReturnTypeDescriptorNode returnTypeDescriptorNode;

    public FunctionSignature() {
        parameters = new ArrayList<>();
    }

    public FunctionSignatureNode getFunctionSignature() {
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

    public void addReturns(ReturnTypeDescriptorNode returns) {
        returnTypeDescriptorNode = returns;
    }
}
