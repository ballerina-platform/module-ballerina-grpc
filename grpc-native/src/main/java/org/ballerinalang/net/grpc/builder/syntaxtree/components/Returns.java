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

import io.ballerina.compiler.syntax.tree.AnnotationNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.ParenthesisedTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.ReturnTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.TypeDescriptorNode;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

public class Returns {

    public static ReturnTypeDescriptorNode getReturnTypeDescriptorNode(Node type) {
        NodeList<AnnotationNode> annotations = NodeFactory.createEmptyNodeList();

        return NodeFactory.createReturnTypeDescriptorNode(
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_RETURNS,
                annotations,
                type
        );
    }

    public static ParenthesisedTypeDescriptorNode getParenthesisedTypeDescriptorNode(TypeDescriptorNode typeDesc) {
        return NodeFactory.createParenthesisedTypeDescriptorNode(
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                typeDesc,
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN
        );
    }
}
