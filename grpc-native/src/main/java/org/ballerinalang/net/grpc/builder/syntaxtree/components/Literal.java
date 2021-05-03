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
import io.ballerina.compiler.syntax.tree.BasicLiteralNode;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.SyntaxKind;

/**
 * Class representing different types of BasicLiteralNodes.
 *
 * @since 0.8.0
 */
public class Literal {

    private Literal() {

    }

    public static BasicLiteralNode getNumericLiteralNode(int value) {
        return NodeFactory.createBasicLiteralNode(
                SyntaxKind.NUMERIC_LITERAL,
                NodeFactory.createLiteralValueToken(
                        SyntaxKind.DECIMAL_INTEGER_LITERAL_TOKEN,
                        String.valueOf(value), NodeFactory.createEmptyMinutiaeList(),
                        NodeFactory.createEmptyMinutiaeList()
                )
        );
    }

    public static BasicLiteralNode getNumericLiteralNode(float value) {
        return NodeFactory.createBasicLiteralNode(
                SyntaxKind.NUMERIC_LITERAL,
                NodeFactory.createLiteralValueToken(
                        SyntaxKind.DECIMAL_FLOATING_POINT_LITERAL_TOKEN,
                        String.valueOf(value), NodeFactory.createEmptyMinutiaeList(),
                        NodeFactory.createEmptyMinutiaeList()
                )
        );
    }

    public static BasicLiteralNode getStringLiteralNode(String value) {
        return NodeFactory.createBasicLiteralNode(
                SyntaxKind.STRING_LITERAL,
                AbstractNodeFactory.createIdentifierToken("\"" + value + "\"")
        );
    }

    public static BasicLiteralNode getBooleanLiteralNode(boolean value) {
        if (value) {
            return NodeFactory.createBasicLiteralNode(
                    SyntaxKind.BOOLEAN_LITERAL,
                    NodeFactory.createToken(
                            SyntaxKind.TRUE_KEYWORD,
                            NodeFactory.createEmptyMinutiaeList(),
                            NodeFactory.createEmptyMinutiaeList()
                    )
            );
        } else {
            return NodeFactory.createBasicLiteralNode(
                    SyntaxKind.BOOLEAN_LITERAL,
                    NodeFactory.createToken(
                            SyntaxKind.FALSE_KEYWORD,
                            NodeFactory.createEmptyMinutiaeList(),
                            NodeFactory.createEmptyMinutiaeList()
                    )
            );
        }
    }
}
