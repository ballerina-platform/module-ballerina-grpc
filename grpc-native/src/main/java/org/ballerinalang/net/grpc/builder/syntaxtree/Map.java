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

import io.ballerina.compiler.syntax.tree.MappingConstructorExpressionNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants;

import java.util.ArrayList;
import java.util.List;

import static org.ballerinalang.net.grpc.builder.syntaxtree.Literal.getLiteralValueToken;

public class Map {

    private final List<Node> fields;

    public Map() {
        fields = new ArrayList<>();
    }

    public MappingConstructorExpressionNode getMappingConstructorExpressionNode() {
        return NodeFactory.createMappingConstructorExpressionNode(
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE,
                NodeFactory.createSeparatedNodeList(fields),
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE
        );
    }

    public void addField(String key, String value) {
        if (fields.size() > 0) {
            fields.add(SyntaxTreeConstants.SYNTAX_TREE_COMMA);
        }
        fields.add(
                NodeFactory.createSpecificFieldNode(null,
                        NodeFactory.createBasicLiteralNode(SyntaxKind.STRING_LITERAL, getLiteralValueToken(key)),
                        SyntaxTreeConstants.SYNTAX_TREE_COLON,
                        NodeFactory.createBasicLiteralNode(SyntaxKind.STRING_LITERAL, getLiteralValueToken(value)))
        );
    }
}
