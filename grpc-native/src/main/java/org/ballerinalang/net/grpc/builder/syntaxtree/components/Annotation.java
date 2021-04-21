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
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import java.util.ArrayList;
import java.util.List;

/**
 * Class representing AnnotationNode.
 *
 * @since 0.8.0
 */
public class Annotation {

    private final String modulePrefix;
    private final String identifier;
    private final List<Node> fields;

    public Annotation(String modulePrefix, String identifier) {
        fields = new ArrayList<>();
        this.modulePrefix = modulePrefix;
        this.identifier = identifier;
    }

    public AnnotationNode getAnnotationNode() {
        return NodeFactory.createAnnotationNode(
                SyntaxTreeConstants.SYNTAX_TREE_AT,
                NodeFactory.createQualifiedNameReferenceNode(
                        AbstractNodeFactory.createIdentifierToken(modulePrefix),
                        SyntaxTreeConstants.SYNTAX_TREE_COLON,
                        AbstractNodeFactory.createIdentifierToken(identifier)
                ),
                NodeFactory.createMappingConstructorExpressionNode(
                        SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE,
                        NodeFactory.createSeparatedNodeList(fields),
                        SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE
                )
        );
    }

    public void addField(String fieldName, String fieldValue) {
        if (fields.size() > 0) {
            fields.add(SyntaxTreeConstants.SYNTAX_TREE_COMMA);
        }
        fields.add(
                NodeFactory.createSpecificFieldNode(
                        null,
                        AbstractNodeFactory.createIdentifierToken(fieldName),
                        SyntaxTreeConstants.SYNTAX_TREE_COLON,
                        NodeFactory.createSimpleNameReferenceNode(AbstractNodeFactory.createIdentifierToken(fieldValue))
                )
        );
    }

    public void addField(String fieldName, ExpressionNode fieldValue) {
        if (fields.size() > 0) {
            fields.add(SyntaxTreeConstants.SYNTAX_TREE_COMMA);
        }
        fields.add(
                NodeFactory.createSpecificFieldNode(
                        null,
                        AbstractNodeFactory.createIdentifierToken(fieldName),
                        SyntaxTreeConstants.SYNTAX_TREE_COLON,
                        fieldValue
                )
        );
    }
}
