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

package org.ballerinalang.net.grpc.builder.utils;

import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.ClassDefinitionNode;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.ImportDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModuleMemberDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModulePartNode;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.ParameterizedTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.compiler.syntax.tree.TypeDefinitionNode;
import io.ballerina.tools.text.TextDocument;
import io.ballerina.tools.text.TextDocuments;
import org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants;
import org.ballerinalang.net.grpc.builder.syntaxtree.Class;
import org.ballerinalang.net.grpc.builder.syntaxtree.FunctionBody;
import org.ballerinalang.net.grpc.builder.syntaxtree.FunctionDefinition;
import org.ballerinalang.net.grpc.builder.syntaxtree.FunctionSignature;
import org.ballerinalang.net.grpc.builder.syntaxtree.Imports;
import org.ballerinalang.net.grpc.builder.syntaxtree.Record;
import org.ballerinalang.net.grpc.builder.syntaxtree.Returns;
import org.ballerinalang.net.grpc.builder.syntaxtree.Type;
import org.ballerinalang.net.grpc.builder.syntaxtree.TypeName;

import static org.ballerinalang.net.grpc.builder.syntaxtree.FunctionParam.getIncludedRecordParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.FunctionParam.getRequiredParamNode;

public class SyntaxTreeUtils {

    public static SyntaxTree generateSyntaxTree() {
        ImportDeclarationNode importForGrpc = Imports.getImportDeclarationNode("ballerina", "grpc");
        NodeList<ImportDeclarationNode> imports = AbstractNodeFactory.createNodeList(importForGrpc);

        // HelloWorldClient class
        Class helloWorldClient = new Class("HelloWorldClient", true);

        // HelloWorldClient:init function
        FunctionSignature initSignature = new FunctionSignature();
        initSignature.addParameter(getRequiredParamNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING, "url"));
        initSignature.addParameter(getIncludedRecordParamNode(TypeName.getQualifiedNameReferenceNode("grpc", "ClientConfiguration"), "config"));
        initSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeName.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody initBody = new FunctionBody();
        FunctionDefinition initDefinition = new FunctionDefinition("init",
                initSignature.getFunctionSignature(), initBody.getFunctionBody());
        initDefinition.addQualifiers(new String[]{"public", "isolated"});
        helloWorldClient.addMember(initDefinition.getFunctionDefinitionNode());

        // HelloWorldClient:hello function
        FunctionSignature helloSignature = new FunctionSignature();
        helloSignature.addParameter(getRequiredParamNode(TypeName.getUnionTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING, SyntaxTreeConstants.SYNTAX_TREE_CONTEXT_STRING), "req"));
        helloSignature.addReturns(Returns.getReturnTypeDescriptorNode(Returns.getParenthesisedTypeDescriptorNode(TypeName.getUnionTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING, SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR))));
        FunctionBody helloBody = new FunctionBody();
        FunctionDefinition helloDefinition = new FunctionDefinition("hello",
                helloSignature.getFunctionSignature(), helloBody.getFunctionBody());
        helloDefinition.addQualifiers(new String[]{"isolated", "remote"});
        helloWorldClient.addMember(helloDefinition.getFunctionDefinitionNode());

        // HelloWorldClient:helloContext function
        FunctionSignature helloContextSignature = new FunctionSignature();
        helloContextSignature.addParameter(getRequiredParamNode(TypeName.getUnionTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING, SyntaxTreeConstants.SYNTAX_TREE_CONTEXT_STRING), "req"));
        helloContextSignature.addReturns(Returns.getReturnTypeDescriptorNode(Returns.getParenthesisedTypeDescriptorNode(TypeName.getUnionTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_CONTEXT_STRING, SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR))));
        FunctionBody helloContextBody = new FunctionBody();
        FunctionDefinition helloContextDefinition = new FunctionDefinition("helloContext",
                helloContextSignature.getFunctionSignature(), helloContextBody.getFunctionBody());
        helloContextDefinition.addQualifiers(new String[]{"isolated", "remote"});
        helloWorldClient.addMember(helloContextDefinition.getFunctionDefinitionNode());

        ClassDefinitionNode helloWorldClientClassDefinitionNode = helloWorldClient.getClassDefinitionNode();

        // HelloWorldStringCaller class
        ClassDefinitionNode helloWorldStringCallerClassDefinitionNode = getHelloWorldStringCaller().getClassDefinitionNode();

        // ContextString record type
        Record contextStringRecord = new Record();
        Type contextString = new Type(true, "ContextString", contextStringRecord.getRecordTypeDescriptorNode());
        TypeDefinitionNode contextStringTypeDefinitionNode = contextString.getTypeDefinitionNode();

        // getDescriptorMap function
        FunctionSignature getDescriptorMapSignature = new FunctionSignature();
        ParameterizedTypeDescriptorNode mapString = NodeFactory.createParameterizedTypeDescriptorNode(AbstractNodeFactory.createIdentifierToken("map"), TypeName.getTypeParameterNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING));
        getDescriptorMapSignature.addReturns(Returns.getReturnTypeDescriptorNode(mapString));
        FunctionBody getDescriptorMapBody = new FunctionBody();
        FunctionDefinition getDescriptorMapDefinition = new FunctionDefinition("getDescriptorMap",
                getDescriptorMapSignature.getFunctionSignature(), getDescriptorMapBody.getFunctionBody());
        getDescriptorMapDefinition.addQualifiers(new String[]{"isolated"});
        FunctionDefinitionNode getDescriptorMapFunctionDefinitionNode = getDescriptorMapDefinition.getFunctionDefinitionNode();

        // Create module member declaration
        NodeList<ModuleMemberDeclarationNode> moduleMembers = AbstractNodeFactory.createNodeList(
                helloWorldClientClassDefinitionNode,
                helloWorldStringCallerClassDefinitionNode,
                contextStringTypeDefinitionNode,
                getDescriptorMapFunctionDefinitionNode
        );

        Token eofToken = AbstractNodeFactory.createIdentifierToken("");
        ModulePartNode modulePartNode = NodeFactory.createModulePartNode(imports, moduleMembers, eofToken);
        TextDocument textDocument = TextDocuments.from("");
        SyntaxTree syntaxTree = SyntaxTree.from(textDocument);
        return syntaxTree.modifyWith(modulePartNode);
    }

    private static Class getHelloWorldStringCaller() {
        // HelloWorldStringCaller class
        Class helloWorldStringCaller = new Class("HelloWorldStringCaller", true);

        // HelloWorldStringCaller:init function
        FunctionSignature initSignature = new FunctionSignature();
        initSignature.addParameter(getRequiredParamNode(TypeName.getQualifiedNameReferenceNode("grpc", "Caller"), "caller"));
        FunctionBody initBody = new FunctionBody();
        FunctionDefinition initDefinition = new FunctionDefinition("init",
                initSignature.getFunctionSignature(), initBody.getFunctionBody());
        initDefinition.addQualifiers(new String[]{"public", "isolated"});
        helloWorldStringCaller.addMember(initDefinition.getFunctionDefinitionNode());

        // HelloWorldStringCaller:getId function
        FunctionSignature getIdSignature = new FunctionSignature();
        getIdSignature.addReturns(Returns.getReturnTypeDescriptorNode(NodeFactory.createBuiltinSimpleNameReferenceNode(SyntaxKind.INT_TYPE_DESC, AbstractNodeFactory.createIdentifierToken("int"))));
        FunctionBody getIdBody = new FunctionBody();
        FunctionDefinition getIdDefinition = new FunctionDefinition("getId",
                getIdSignature.getFunctionSignature(), getIdBody.getFunctionBody());
        getIdDefinition.addQualifiers(new String[]{"public", "isolated"});
        helloWorldStringCaller.addMember(getIdDefinition.getFunctionDefinitionNode());

        // HelloWorldStringCaller:sendString function
        FunctionSignature sendStringSignature = new FunctionSignature();
        sendStringSignature.addParameter(getRequiredParamNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING, "response"));
        sendStringSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeName.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody sendStringBody = new FunctionBody();
        FunctionDefinition sendStringDefinition = new FunctionDefinition("sendString",
                sendStringSignature.getFunctionSignature(), sendStringBody.getFunctionBody());
        sendStringDefinition.addQualifiers(new String[]{"isolated", "remote"});
        helloWorldStringCaller.addMember(sendStringDefinition.getFunctionDefinitionNode());

        // HelloWorldStringCaller:sendContextString function
        FunctionSignature sendContextStringSignature = new FunctionSignature();
        sendContextStringSignature.addParameter(getRequiredParamNode(SyntaxTreeConstants.SYNTAX_TREE_CONTEXT_STRING, "response"));
        sendContextStringSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeName.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody sendContextStringBody = new FunctionBody();
        FunctionDefinition sendContextStringDefinition = new FunctionDefinition("sendContextString",
                sendContextStringSignature.getFunctionSignature(), sendContextStringBody.getFunctionBody());
        sendContextStringDefinition.addQualifiers(new String[]{"isolated", "remote"});
        helloWorldStringCaller.addMember(sendContextStringDefinition.getFunctionDefinitionNode());

        // HelloWorldStringCaller:sendError function
        FunctionSignature sendErrorSignature = new FunctionSignature();
        sendErrorSignature.addParameter(getRequiredParamNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR, "response"));
        sendErrorSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeName.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody sendErrorBody = new FunctionBody();
        FunctionDefinition sendErrorDefinition = new FunctionDefinition("sendError",
                sendErrorSignature.getFunctionSignature(), sendErrorBody.getFunctionBody());
        sendErrorDefinition.addQualifiers(new String[]{"isolated", "remote"});
        helloWorldStringCaller.addMember(sendErrorDefinition.getFunctionDefinitionNode());

        // HelloWorldStringCaller:complete function
        FunctionSignature completeSignature = new FunctionSignature();
        completeSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeName.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody completeBody = new FunctionBody();
        FunctionDefinition completeDefinition = new FunctionDefinition("complete",
                completeSignature.getFunctionSignature(), completeBody.getFunctionBody());
        completeDefinition.addQualifiers(new String[]{"isolated", "remote"});
        helloWorldStringCaller.addMember(completeDefinition.getFunctionDefinitionNode());

        return helloWorldStringCaller;
    }
}
