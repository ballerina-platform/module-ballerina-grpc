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
import org.ballerinalang.net.grpc.builder.components.Descriptor;
import org.ballerinalang.net.grpc.builder.components.Method;
import org.ballerinalang.net.grpc.builder.components.ServiceStub;
import org.ballerinalang.net.grpc.builder.components.StubFile;
import org.ballerinalang.net.grpc.builder.constants.SyntaxTreeConstants;
import org.ballerinalang.net.grpc.builder.syntaxtree.Class;
import org.ballerinalang.net.grpc.builder.syntaxtree.Constant;
import org.ballerinalang.net.grpc.builder.syntaxtree.FunctionBody;
import org.ballerinalang.net.grpc.builder.syntaxtree.FunctionDefinition;
import org.ballerinalang.net.grpc.builder.syntaxtree.FunctionSignature;
import org.ballerinalang.net.grpc.builder.syntaxtree.Imports;
import org.ballerinalang.net.grpc.builder.syntaxtree.Map;
import org.ballerinalang.net.grpc.builder.syntaxtree.Record;
import org.ballerinalang.net.grpc.builder.syntaxtree.Returns;
import org.ballerinalang.net.grpc.builder.syntaxtree.Type;
import org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor;

import static org.ballerinalang.net.grpc.builder.syntaxtree.FunctionParam.getIncludedRecordParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.FunctionParam.getRequiredParamNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getObjectFieldNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getQualifiedNameReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getTypeReferenceNode;
import static org.ballerinalang.net.grpc.builder.syntaxtree.TypeDescriptor.getUnionTypeDescriptorNode;

public class SyntaxTreeUtils {

    public static SyntaxTree generateSyntaxTree(StubFile stubFile) {
        NodeList<ModuleMemberDeclarationNode> moduleMembers = AbstractNodeFactory.createEmptyNodeList();

        ImportDeclarationNode importForGrpc = Imports.getImportDeclarationNode("ballerina", "grpc");
        NodeList<ImportDeclarationNode> imports = AbstractNodeFactory.createNodeList(importForGrpc);

        for (ServiceStub service : stubFile.getStubList()) {
            Class client = new Class(service.getServiceName() + "Client", true);

            client.addMember(getTypeReferenceNode(getQualifiedNameReferenceNode("grpc", "AbstractClientEndpoint")));
            client.addMember(getObjectFieldNode("private", new String[]{}, getQualifiedNameReferenceNode("grpc", "Client"), "grpcClient"));

            // init function
            FunctionSignature initSignature = new FunctionSignature();
            initSignature.addParameter(getRequiredParamNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING, "url"));
            initSignature.addParameter(getIncludedRecordParamNode(getQualifiedNameReferenceNode("grpc", "ClientConfiguration"), "config"));
            initSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeDescriptor.getOptionalTypeDescriptorNode("grpc", "Error")));
            FunctionBody initBody = new FunctionBody();
            FunctionDefinition initDefinition = new FunctionDefinition("init",
                    initSignature.getFunctionSignature(), initBody.getFunctionBody());
            initDefinition.addQualifiers(new String[]{"public", "isolated"});
            client.addMember(initDefinition.getFunctionDefinitionNode());

            for (Method method : service.getClientStreamingFunctions()) {
                // HelloWorldClient:hello function
                FunctionSignature helloSignature = new FunctionSignature();
                helloSignature.addParameter(getRequiredParamNode(getUnionTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING, SyntaxTreeConstants.SYNTAX_TREE_CONTEXT_STRING), "req"));
                helloSignature.addReturns(Returns.getReturnTypeDescriptorNode(Returns.getParenthesisedTypeDescriptorNode(getUnionTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING, SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR))));
                FunctionBody helloBody = new FunctionBody();
                FunctionDefinition helloDefinition = new FunctionDefinition(method.getMethodName(),
                        helloSignature.getFunctionSignature(), helloBody.getFunctionBody());
                helloDefinition.addQualifiers(new String[]{"isolated", "remote"});
                client.addMember(helloDefinition.getFunctionDefinitionNode());

//                if (method) {
//                    // HelloWorldClient:helloContext function
//                    FunctionSignature helloContextSignature = new FunctionSignature();
//                    helloContextSignature.addParameter(getRequiredParamNode(TypeDescriptor.getUnionTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING, SyntaxTreeConstants.SYNTAX_TREE_CONTEXT_STRING), "req"));
//                    helloContextSignature.addReturns(Returns.getReturnTypeDescriptorNode(Returns.getParenthesisedTypeDescriptorNode(TypeDescriptor.getUnionTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_CONTEXT_STRING, SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR))));
//                    FunctionBody helloContextBody = new FunctionBody();
//                    FunctionDefinition helloContextDefinition = new FunctionDefinition(method.getName() + "Context",
//                            helloContextSignature.getFunctionSignature(), helloContextBody.getFunctionBody());
//                    helloContextDefinition.addQualifiers(new String[]{"isolated", "remote"});
//                    client.addMember(helloContextDefinition.getFunctionDefinitionNode());
//                }
            }
            moduleMembers = moduleMembers.add(client.getClassDefinitionNode());
        }

        // HelloWorldStringCaller class
        ClassDefinitionNode stringCaller = getHelloWorldStringCaller().getClassDefinitionNode();
        moduleMembers = moduleMembers.add(stringCaller);

        // ContextString record type
        Record contextStringRecord = new Record();
        contextStringRecord.addStringField("content");
        contextStringRecord.addMapField("headers", getUnionTypeDescriptorNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING, SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING_ARRAY));
        Type contextString = new Type(true, "ContextString", contextStringRecord.getRecordTypeDescriptorNode());
        TypeDefinitionNode contextStringTypeDefinitionNode = contextString.getTypeDefinitionNode();
        moduleMembers = moduleMembers.add(contextStringTypeDefinitionNode);

        // ROOT_DESCRIPTOR
        Constant rootDescriptor = new Constant("ROOT_DESCRIPTOR", stubFile.getRootDescriptor());
        moduleMembers = moduleMembers.add(rootDescriptor.getConstantDeclarationNode());

        // getDescriptorMap function
        FunctionSignature getDescriptorMapSignature = new FunctionSignature();
        ParameterizedTypeDescriptorNode mapString = NodeFactory.createParameterizedTypeDescriptorNode(AbstractNodeFactory.createIdentifierToken("map"), TypeDescriptor.getTypeParameterNode(SyntaxTreeConstants.SYNTAX_TREE_VAR_STRING));
        getDescriptorMapSignature.addReturns(Returns.getReturnTypeDescriptorNode(mapString));
        FunctionBody getDescriptorMapBody = new FunctionBody();

        Map descriptorMap = new Map();
        for (Descriptor descriptor : stubFile.getDescriptors()) {
            descriptorMap.addField(descriptor.getKey(), descriptor.getData());
        }
        getDescriptorMapBody.addReturnsStatement(descriptorMap.getMappingConstructorExpressionNode());

        FunctionDefinition getDescriptorMapDefinition = new FunctionDefinition("getDescriptorMap",
                getDescriptorMapSignature.getFunctionSignature(), getDescriptorMapBody.getFunctionBody());
        getDescriptorMapDefinition.addQualifiers(new String[]{"isolated"});
        FunctionDefinitionNode getDescriptorMapFunction = getDescriptorMapDefinition.getFunctionDefinitionNode();
        moduleMembers = moduleMembers.add(getDescriptorMapFunction);

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
        initSignature.addParameter(getRequiredParamNode(TypeDescriptor.getQualifiedNameReferenceNode("grpc", "Caller"), "caller"));
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
        sendStringSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeDescriptor.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody sendStringBody = new FunctionBody();
        FunctionDefinition sendStringDefinition = new FunctionDefinition("sendString",
                sendStringSignature.getFunctionSignature(), sendStringBody.getFunctionBody());
        sendStringDefinition.addQualifiers(new String[]{"isolated", "remote"});
        helloWorldStringCaller.addMember(sendStringDefinition.getFunctionDefinitionNode());

        // HelloWorldStringCaller:sendContextString function
        FunctionSignature sendContextStringSignature = new FunctionSignature();
        sendContextStringSignature.addParameter(getRequiredParamNode(SyntaxTreeConstants.SYNTAX_TREE_CONTEXT_STRING, "response"));
        sendContextStringSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeDescriptor.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody sendContextStringBody = new FunctionBody();
        FunctionDefinition sendContextStringDefinition = new FunctionDefinition("sendContextString",
                sendContextStringSignature.getFunctionSignature(), sendContextStringBody.getFunctionBody());
        sendContextStringDefinition.addQualifiers(new String[]{"isolated", "remote"});
        helloWorldStringCaller.addMember(sendContextStringDefinition.getFunctionDefinitionNode());

        // HelloWorldStringCaller:sendError function
        FunctionSignature sendErrorSignature = new FunctionSignature();
        sendErrorSignature.addParameter(getRequiredParamNode(SyntaxTreeConstants.SYNTAX_TREE_GRPC_ERROR, "response"));
        sendErrorSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeDescriptor.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody sendErrorBody = new FunctionBody();
        FunctionDefinition sendErrorDefinition = new FunctionDefinition("sendError",
                sendErrorSignature.getFunctionSignature(), sendErrorBody.getFunctionBody());
        sendErrorDefinition.addQualifiers(new String[]{"isolated", "remote"});
        helloWorldStringCaller.addMember(sendErrorDefinition.getFunctionDefinitionNode());

        // HelloWorldStringCaller:complete function
        FunctionSignature completeSignature = new FunctionSignature();
        completeSignature.addReturns(Returns.getReturnTypeDescriptorNode(TypeDescriptor.getOptionalTypeDescriptorNode("grpc", "Error")));
        FunctionBody completeBody = new FunctionBody();
        FunctionDefinition completeDefinition = new FunctionDefinition("complete",
                completeSignature.getFunctionSignature(), completeBody.getFunctionBody());
        completeDefinition.addQualifiers(new String[]{"isolated", "remote"});
        helloWorldStringCaller.addMember(completeDefinition.getFunctionDefinitionNode());

        return helloWorldStringCaller;
    }
}
