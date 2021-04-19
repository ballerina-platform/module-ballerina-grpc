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
import io.ballerina.compiler.syntax.tree.MetadataNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.compiler.syntax.tree.TypeDescriptorNode;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

import java.util.ArrayList;
import java.util.List;

public class Service {

    private NodeList<Token> qualifierList;
    private MetadataNode metadata;
    private TypeDescriptorNode typeDescriptor;
    private NodeList<Node> absoluteResourcePath;
    private SeparatedNodeList<ExpressionNode> expressions;
    private NodeList<Node> members;
    private NodeList<AnnotationNode> annotations;

    public Service(String[] resourcePaths, String[] expressionList) {
        metadata = null;
        typeDescriptor = null;
        qualifierList = NodeFactory.createEmptyNodeList();
        absoluteResourcePath = NodeFactory.createEmptyNodeList();
        members = NodeFactory.createEmptyNodeList();
        annotations = NodeFactory.createEmptyNodeList();

        for (String path : resourcePaths) {
            absoluteResourcePath = absoluteResourcePath.add(
                    NodeFactory.createBasicLiteralNode(
                            SyntaxKind.STRING_LITERAL,
                            NodeFactory.createLiteralValueToken(
                                    SyntaxKind.STRING_LITERAL_TOKEN,
                                    path,
                                    NodeFactory.createEmptyMinutiaeList(),
                                    NodeFactory.createEmptyMinutiaeList()
                            )
                    )
            );
        }
        List<Node> expressionNodes = new ArrayList<>();
        for (String expr : expressionList) {
            expressionNodes.add(
                    NodeFactory.createSimpleNameReferenceNode(AbstractNodeFactory.createIdentifierToken(expr))
            );
        }
        expressions = NodeFactory.createSeparatedNodeList(expressionNodes);
    }

    public ServiceDeclarationNode getServiceDeclarationNode() {
        return NodeFactory.createServiceDeclarationNode(
                NodeFactory.createMetadataNode(
                        null,
                        annotations
                ),
                qualifierList,
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_SERVICE,
                typeDescriptor,
                absoluteResourcePath,
                SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_ON,
                expressions,
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE,
                members,
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE
        );
    }

    public void addMember(Node member) {
        if (members.size() == 0) {
            members = members.add(SyntaxTreeConstants.SYNTAX_TREE_BLANK_LINE);
        }
        members = members.add(member);
    }

    public void addAnnotation(AnnotationNode annotation) {
        annotations = annotations.add(annotation);
    }
}
