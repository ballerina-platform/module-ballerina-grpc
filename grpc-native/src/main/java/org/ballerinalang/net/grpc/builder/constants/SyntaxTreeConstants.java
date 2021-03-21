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

package org.ballerinalang.net.grpc.builder.constants;

import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.Token;

public class SyntaxTreeConstants {
    public static final Token SYNTAX_TREE_SEMICOLON = AbstractNodeFactory.createIdentifierToken(";");
    public static final Token SYNTAX_TREE_COLON = AbstractNodeFactory.createIdentifierToken(":");
    public static final Token SYNTAX_TREE_OPEN_BRACE = AbstractNodeFactory.createIdentifierToken("{");
    public static final Token SYNTAX_TREE_CLOSE_BRACE = AbstractNodeFactory.createIdentifierToken("}");
    public static final Token SYNTAX_TREE_OPEN_PAREN = AbstractNodeFactory.createIdentifierToken("(");
    public static final Token SYNTAX_TREE_CLOSE_PAREN = AbstractNodeFactory.createIdentifierToken(")");
    public static final Token SYNTAX_TREE_EQUAL = AbstractNodeFactory.createIdentifierToken("=");
    public static final Token SYNTAX_TREE_PIPE = AbstractNodeFactory.createIdentifierToken("|");
    public static final Token SYNTAX_TREE_SLASH = AbstractNodeFactory.createIdentifierToken("/");
    public static final Token SYNTAX_TREE_AT = AbstractNodeFactory.createIdentifierToken("@");
    public static final Token SYNTAX_TREE_CONCAT = AbstractNodeFactory.createIdentifierToken("+");
    public static final Token SYNTAX_TREE_DOT = AbstractNodeFactory.createIdentifierToken(".");

    public static final Token SYNTAX_TREE_KEYWORD_FUNCTION = AbstractNodeFactory.createIdentifierToken(" function ");
    public static final Token SYNTAX_TREE_KEYWORD_REMOTE = AbstractNodeFactory.createIdentifierToken("    remote");
    public static final Token SYNTAX_TREE_KEYWORD_LISTENER = AbstractNodeFactory.createIdentifierToken("listener");
    public static final Token SYNTAX_TREE_KEYWORD_NEW = AbstractNodeFactory.createIdentifierToken("new");
    public static final Token SYNTAX_TREE_KEYWORD_ERROR = AbstractNodeFactory.createIdentifierToken("error");
    public static final Token SYNTAX_TREE_KEYWORD_IMPORT = AbstractNodeFactory.createIdentifierToken("import ");
    public static final Token SYNTAX_TREE_KEYWORD_CHECK = AbstractNodeFactory.createIdentifierToken("check ");

    public static final Token SYNTAX_TREE_PARAM_REQUEST = AbstractNodeFactory.createIdentifierToken(" request");

    public static final Token SYNTAX_TREE_MODULE_PREFIX_GRPC = AbstractNodeFactory.createIdentifierToken(" grpc");
}
