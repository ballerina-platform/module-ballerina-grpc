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

import io.ballerina.compiler.syntax.tree.LiteralValueToken;
import io.ballerina.compiler.syntax.tree.NilLiteralNode;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.Token;
import org.ballerinalang.net.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;

public class Literal {

    public static LiteralValueToken getLiteralValueToken(String literal) {
        return NodeFactory.createLiteralValueToken(SyntaxKind.STRING_LITERAL, "\"" + literal +
                "\"", NodeFactory.createEmptyMinutiaeList(), NodeFactory.createEmptyMinutiaeList());
    }

    public static LiteralValueToken getLiteralValueToken(int literal) {
        return NodeFactory.createLiteralValueToken(
                SyntaxKind.DECIMAL_INTEGER_LITERAL_TOKEN,
                String.valueOf(literal), NodeFactory.createEmptyMinutiaeList(),
                NodeFactory.createEmptyMinutiaeList()
        );
    }

    public static Token getLiteralValueToken(boolean literal) {
        if (literal) {
            return NodeFactory.createToken(
                    SyntaxKind.TRUE_KEYWORD,
                    NodeFactory.createEmptyMinutiaeList(),
                    NodeFactory.createEmptyMinutiaeList()
            );
        } else {
            return NodeFactory.createToken(
                    SyntaxKind.FALSE_KEYWORD,
                    NodeFactory.createEmptyMinutiaeList(),
                    NodeFactory.createEmptyMinutiaeList()
            );
        }
    }

    public static NilLiteralNode getNilLiteralNode() {
        return NodeFactory.createNilLiteralNode(
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN
        );
    }
}
