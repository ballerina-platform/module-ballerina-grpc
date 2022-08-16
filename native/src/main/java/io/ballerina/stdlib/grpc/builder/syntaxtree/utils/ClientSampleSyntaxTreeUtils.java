/*
 *  Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package io.ballerina.stdlib.grpc.builder.syntaxtree.utils;

import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.AnonymousFunctionExpressionNode;
import io.ballerina.compiler.syntax.tree.CaptureBindingPatternNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.ExpressionStatementNode;
import io.ballerina.compiler.syntax.tree.ImportDeclarationNode;
import io.ballerina.compiler.syntax.tree.ListConstructorExpressionNode;
import io.ballerina.compiler.syntax.tree.MappingConstructorExpressionNode;
import io.ballerina.compiler.syntax.tree.MethodCallExpressionNode;
import io.ballerina.compiler.syntax.tree.ModuleMemberDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModulePartNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.compiler.syntax.tree.TypedBindingPatternNode;
import io.ballerina.compiler.syntax.tree.VariableDeclarationNode;
import io.ballerina.stdlib.grpc.builder.BallerinaFileBuilder;
import io.ballerina.stdlib.grpc.builder.stub.Field;
import io.ballerina.stdlib.grpc.builder.stub.Message;
import io.ballerina.stdlib.grpc.builder.stub.Method;
import io.ballerina.stdlib.grpc.builder.stub.ServiceStub;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Function;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.Imports;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.ModuleVariable;
import io.ballerina.stdlib.grpc.builder.syntaxtree.components.VariableDeclaration;
import io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants;
import io.ballerina.tools.text.TextDocument;
import io.ballerina.tools.text.TextDocuments;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static io.ballerina.stdlib.grpc.GrpcConstants.ORG_NAME;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getCheckExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getImplicitNewExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getListConstructorExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Expression.getRemoteMethodCallActionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Literal.createBasicLiteralNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Literal.getBooleanLiteralNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Literal.getByteArrayLiteralNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Literal.getDecimalLiteralNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Literal.getNumericLiteralNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Literal.getStringLiteralNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Literal.getTupleLiteralNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Statement.getCallStatementNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.Statement.getFunctionCallExpressionNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getBuiltinSimpleNameReferenceNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getCaptureBindingPatternNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getSimpleNameReferenceNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getStreamTypeDescriptorNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.components.TypeDescriptor.getTypedBindingPatternNode;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.constants.SyntaxTreeConstants.STREAMING_CLIENT;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.addSubModuleImports;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.capitalize;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.checkForImportsInServices;
import static io.ballerina.stdlib.grpc.builder.syntaxtree.utils.CommonUtils.getMethodType;

/**
 * Syntax tree generation class for the client sample.
 */
public class ClientSampleSyntaxTreeUtils {
    
    private static final String CONST_RESPONSE = "response";
    private static final String CONST_REQUEST = "request";
    private static final String CONST_ENDPOINT = "ep";
    private static final String CONST_STREAMING_CLIENT = "streamingClient";

    public static SyntaxTree generateSyntaxTreeForClientSample(ServiceStub serviceStub, String filename,
                                                               Map<String, Message> msgMap) {
        NodeList<ModuleMemberDeclarationNode> moduleMembers = AbstractNodeFactory.createEmptyNodeList();
        NodeList<ImportDeclarationNode> imports = AbstractNodeFactory.createEmptyNodeList();

        Function main = new Function("main");
        main.addQualifiers(new String[]{"public"});
        main.addReturns(SyntaxTreeConstants.SYNTAX_TREE_ERROR_OPTIONAL);
        ModuleVariable clientEp = new ModuleVariable(
                getTypedBindingPatternNode(
                        getSimpleNameReferenceNode(serviceStub.getServiceName() + "Client"),
                        getCaptureBindingPatternNode(CONST_ENDPOINT)
                ),
                getCheckExpressionNode(
                        getImplicitNewExpressionNode("\"http://localhost:9090\"")
                )
        );

        if (serviceStub.getUnaryFunctions().size() > 0) {
            imports = addImports(imports, serviceStub.getUnaryFunctions().get(0), filename);
            addUnaryCallMethodBody(main, serviceStub.getUnaryFunctions().get(0), filename, msgMap);
        } else if (serviceStub.getServerStreamingFunctions().size() > 0) {
            imports = addImports(imports, serviceStub.getServerStreamingFunctions().get(0), filename);
            addServerStreamingCallMethodBody(main, serviceStub.getServerStreamingFunctions().get(0), filename, msgMap);
        } else if (serviceStub.getClientStreamingFunctions().size() > 0) {
            imports = addImports(imports, serviceStub.getClientStreamingFunctions().get(0), filename);
            addClientBidiStreamingCallMethodBody(main,
                    serviceStub.getClientStreamingFunctions().get(0), filename, msgMap);
        } else if (serviceStub.getBidiStreamingFunctions().size() > 0) {
            imports = addImports(imports, serviceStub.getBidiStreamingFunctions().get(0), filename);
            addClientBidiStreamingCallMethodBody(main,
                    serviceStub.getBidiStreamingFunctions().get(0), filename, msgMap);
        }

        moduleMembers = moduleMembers.add(clientEp.getModuleVariableDeclarationNode());
        moduleMembers = moduleMembers.add(main.getFunctionDefinitionNode());

        Token eofToken = AbstractNodeFactory.createIdentifierToken("");
        ModulePartNode modulePartNode = NodeFactory.createModulePartNode(imports, moduleMembers, eofToken);
        TextDocument textDocument = TextDocuments.from("");
        SyntaxTree syntaxTree = SyntaxTree.from(textDocument);
        return syntaxTree.modifyWith(modulePartNode);
    }

    private static void addUnaryCallMethodBody(Function main, Method method, String filename,
                                               Map<String, Message> msgMap) {
        if (method.getInputType() != null) {
            main.addVariableStatement(getInputDeclarationStatement(method, filename, msgMap));
        }
        if (method.getOutputType() != null) {
            main.addVariableStatement(getUnaryCallDeclarationNode(method, filename));
            main.addExpressionStatement(getPrintlnStatement(CONST_RESPONSE));
        } else {
            main.addExpressionStatement(getUnaryCallExpressionStatement(method));
        }
    }

    private static void addServerStreamingCallMethodBody(Function main, Method method, String filename,
                                                         Map<String, Message> msgMap) {
        if (method.getInputType() != null) {
            main.addVariableStatement(getInputDeclarationStatement(method, filename, msgMap));
        }
        main.addVariableStatement(getServerStreamingCallDeclarationNode(method, filename));
        main.addExpressionStatement(getForEachExpressionNode(method, filename));
    }

    private static void addClientBidiStreamingCallMethodBody(Function main, Method method, String filename,
                                                             Map<String, Message> msgMap) {
        if (method.getInputType() != null) {
            main.addVariableStatement(getInputDeclarationStatement(method, filename, msgMap));
        }
        main.addVariableStatement(getClientStreamingCallDeclarationNode(method));
        main.addExpressionStatement(getStreamSendValueStatementNode(method));
        main.addExpressionStatement(getStreamCompleteStatementNode());
        if (method.getOutputType() != null) {
            main.addVariableStatement(getStreamReceiveValueDeclarationNode(method, filename));
            main.addExpressionStatement(getPrintlnStatement(CONST_RESPONSE));
        } else {
            main.addExpressionStatement(getStreamReceiveValueExpressionStatement(method));
        }
    }

    private static ExpressionStatementNode getStreamReceiveValueExpressionStatement(Method method) {
        ExpressionNode checkExpressionNode = getCheckExpressionNode(getRemoteMethodCallActionNode(
                getSimpleNameReferenceNode(CONST_STREAMING_CLIENT), "receive" + getMethodType(method.getOutputType())));
        return getCallStatementNode(checkExpressionNode);
    }

    private static VariableDeclarationNode getUnaryCallDeclarationNode(Method method, String filename) {
        TypedBindingPatternNode bindingPatternNode = getTypedBindingPatternNode(
                getBuiltinSimpleNameReferenceNode(method.getOutputPackageType(filename) + method.getOutputType() + " "),
                getCaptureBindingPatternNode(CONST_RESPONSE));
        ExpressionNode node = getCheckExpressionNode(getRemoteMethodCallActionNode(
                getBuiltinSimpleNameReferenceNode(CONST_ENDPOINT), method.getMethodName(),
                method.getInputType() != null ? CONST_REQUEST : ""));
        VariableDeclaration unaryCallVariable = new VariableDeclaration(bindingPatternNode, node);
        return unaryCallVariable.getVariableDeclarationNode();
    }

    private static ExpressionStatementNode getUnaryCallExpressionStatement(Method method) {
        ExpressionNode node = getCheckExpressionNode(getRemoteMethodCallActionNode(
                getBuiltinSimpleNameReferenceNode(CONST_ENDPOINT), method.getMethodName(),
                method.getInputType() != null ? CONST_REQUEST : ""));
        return getCallStatementNode(node);
    }

    private static VariableDeclarationNode getClientStreamingCallDeclarationNode(Method method) {
        TypedBindingPatternNode bindingPatternNode = getTypedBindingPatternNode(
                getBuiltinSimpleNameReferenceNode(
                        capitalize(method.getMethodName()) + STREAMING_CLIENT + " "),
                getCaptureBindingPatternNode(CONST_STREAMING_CLIENT));
        ExpressionNode node = getCheckExpressionNode(getRemoteMethodCallActionNode(
                getBuiltinSimpleNameReferenceNode(CONST_ENDPOINT), method.getMethodName()));
        VariableDeclaration streamingCallVariable = new VariableDeclaration(bindingPatternNode, node);
        return streamingCallVariable.getVariableDeclarationNode();
    }

    private static ExpressionStatementNode getForEachExpressionNode(Method method, String filename) {
        AnonymousFunctionExpressionNode functionExpressionNode = getAnonymousFunctionExpressionNode(method, filename);
        MethodCallExpressionNode methodCallExpressionNode = getForEachMethodCall(functionExpressionNode);
        return getCallStatementNode(getCheckExpressionNode(methodCallExpressionNode));
    }

    private static AnonymousFunctionExpressionNode getAnonymousFunctionExpressionNode(Method method, String filename) {
        Function function = new Function();
        function.addRequiredParameter(getSimpleNameReferenceNode(method.getOutputPackageType(filename) +
                method.getOutputType() + " "), "value");
        function.addExpressionStatement(getPrintlnStatement("value"));
        return NodeFactory.createExplicitAnonymousFunctionExpressionNode(AbstractNodeFactory.createEmptyNodeList(),
                AbstractNodeFactory.createEmptyNodeList(), SyntaxTreeConstants.SYNTAX_TREE_KEYWORD_FUNCTION,
                function.getFunctionSignature(), function.getFunctionBody());
    }

    private static MethodCallExpressionNode getForEachMethodCall(AnonymousFunctionExpressionNode expressionNode) {
        return NodeFactory.createMethodCallExpressionNode(getSimpleNameReferenceNode(CONST_RESPONSE),
                SyntaxTreeConstants.SYNTAX_TREE_DOT, getSimpleNameReferenceNode("forEach"),
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_PAREN,
                AbstractNodeFactory.createSeparatedNodeList(NodeFactory.createPositionalArgumentNode(expressionNode)),
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_PAREN);
    }

    private static VariableDeclarationNode getServerStreamingCallDeclarationNode(Method method, String filename) {
        TypedBindingPatternNode bindingPatternNode = getTypedBindingPatternNode(
                getStreamTypeDescriptorNode(getSimpleNameReferenceNode(method.getOutputPackageType(filename) +
                        method.getOutputType()), SyntaxTreeConstants.SYNTAX_TREE_ERROR_OPTIONAL),
                getCaptureBindingPatternNode(CONST_RESPONSE));
        ExpressionNode node = getCheckExpressionNode(getRemoteMethodCallActionNode(
                getBuiltinSimpleNameReferenceNode(CONST_ENDPOINT), method.getMethodName(),
                method.getInputType() != null ? CONST_REQUEST : ""));
        VariableDeclaration streamingCallVariable = new VariableDeclaration(bindingPatternNode, node);
        return streamingCallVariable.getVariableDeclarationNode();
    }

    private static ExpressionStatementNode getStreamSendValueStatementNode(Method method) {
        ExpressionNode node = getCheckExpressionNode(getRemoteMethodCallActionNode(
                getBuiltinSimpleNameReferenceNode(CONST_STREAMING_CLIENT),
                "send" + getMethodType(method.getInputType()),
                method.getInputType() != null ? CONST_REQUEST : ""));
        return getCallStatementNode(node);
    }

    private static ExpressionStatementNode getStreamCompleteStatementNode() {
        ExpressionNode node = getCheckExpressionNode(getRemoteMethodCallActionNode(
                getBuiltinSimpleNameReferenceNode(CONST_STREAMING_CLIENT), "complete"));
        return getCallStatementNode(node);
    }

    private static VariableDeclarationNode getStreamReceiveValueDeclarationNode(Method method, String filename) {
        TypedBindingPatternNode bindingPatternNode = getTypedBindingPatternNode(
                getSimpleNameReferenceNode(method.getOutputPackageType(filename) + method.getOutputType() + "? "),
                getCaptureBindingPatternNode(CONST_RESPONSE));
        ExpressionNode checkExpressionNode = getCheckExpressionNode(getRemoteMethodCallActionNode(
                getSimpleNameReferenceNode(CONST_STREAMING_CLIENT), "receive" + getMethodType(method.getOutputType())));
        VariableDeclaration streamingCallVariable = new VariableDeclaration(bindingPatternNode, checkExpressionNode);
        return streamingCallVariable.getVariableDeclarationNode();
    }

    private static VariableDeclarationNode getInputDeclarationStatement(Method method, String filename,
                                                                        Map<String, Message> msgMap) {
        TypedBindingPatternNode bindingPatternNode = getTypedBindingPatternNode(
                NodeFactory.createSimpleNameReferenceNode(AbstractNodeFactory.createIdentifierToken(
                        method.getInputPackagePrefix(filename) + method.getInputType() + " ")),
                getCaptureBindingPatternNode(CONST_REQUEST));
        ExpressionNode node = null;
        switch (method.getInputType()) {
            case "int":
            case "float":
            case "decimal":
                node = getNumericLiteralNode(1);
                break;
            case "boolean":
                node = getBooleanLiteralNode(true);
                break;
            case "string":
                node = getStringLiteralNode("ballerina");
                break;
            case "byte[]":
                node = getByteArrayLiteralNode("[72,101,108,108,111]");
                break;
            case "time:Utc":
                node = getTupleLiteralNode("[1659688553,0.310073000d]");
                break;
            case "time:Seconds":
                node = getDecimalLiteralNode("0.310073000d");
                break;
            case "map<anydata>":
                node = createBasicLiteralNode(SyntaxKind.MAP_TYPE_DESC, "{message: \"Hello Ballerina\"}");
                break;
            case "'any:Any":
                node = getCheckExpressionNode(getFunctionCallExpressionNode("'any", "pack", "\"Hello\""));
                break;
            default:
                if (msgMap.containsKey(method.getInputType())) {
                    Message msg = msgMap.get(method.getInputType());
                    node = NodeFactory.createMappingConstructorExpressionNode(
                            SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE,
                            NodeFactory.createSeparatedNodeList(getFieldNodes(msg, msgMap)),
                            SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE);
                }
        }
        VariableDeclaration valueVariable = new VariableDeclaration(bindingPatternNode, node);
        return valueVariable.getVariableDeclarationNode();
    }

    private static ArrayList<Node> getFieldNodes(Message message, Map<String, Message> msgMap) {
        ArrayList<Node> nodes = new ArrayList<>();
        for (Field field : message.getFieldList()) {
            nodes.add(NodeFactory.createFieldMatchPatternNode(
                    AbstractNodeFactory.createIdentifierToken(
                            field.getFieldName() + " "), SyntaxTreeConstants.SYNTAX_TREE_COLON,
                    getFieldPatternNode(field, msgMap, false)));
            nodes.add(NodeFactory.createCaptureBindingPatternNode(SyntaxTreeConstants.SYNTAX_TREE_COMMA));
        }
        nodes.remove(nodes.size() - 1);
        return nodes;
    }

    private static Node getFieldPatternNode(Field field, Map<String, Message> msgMap, boolean isRepeated) {
        switch (field.getFieldType()) {
            case "int":
            case "float":
            case "decimal":
                return getCaptureBindingPatternNode("1");
            case "boolean":
                return getCaptureBindingPatternNode("true");
            case "byte[]":
                return getCaptureBindingPatternNode("[72,101,108,108,111]");
            case "Timestamp":
                return getCaptureBindingPatternNode("[1659688553,0.310073000d]");
            case "Duration":
                return getCaptureBindingPatternNode("0.310073000d");
            case "Struct":
                return getCaptureBindingPatternNode("{message: \"Hello Ballerina\"}");
            case "string":
                return getCaptureBindingPatternNode("\"ballerina\"");
            case "'any:Any":
                return getCheckExpressionNode(getFunctionCallExpressionNode("'any", "pack", "\"ballerina\""));
            default:
                if (msgMap.containsKey(field.getFieldType())) {
                    if (field.getFieldLabel() != null && field.getFieldLabel().equals("[]") && !isRepeated) {
                        return handleRepeatedTypes(field, msgMap);
                    }
                    return handleMessageTypes(field, msgMap);
                }
                if (BallerinaFileBuilder.enumDefaultValueMap.containsKey(field.getFieldType())) {
                    return handleEnumTypes(field);
                }
                return getCaptureBindingPatternNode("{}");
        }
    }

    private static CaptureBindingPatternNode handleEnumTypes(Field field) {
        return getCaptureBindingPatternNode("\"" + BallerinaFileBuilder.enumDefaultValueMap
                .get(field.getFieldType()) + "\"");
    }

    private static MappingConstructorExpressionNode handleMessageTypes(Field field, Map<String, Message> msgMap) {
        Message msg = msgMap.get(field.getFieldType());
        ArrayList<Node> subRecordNodes = getFieldNodes(msg, msgMap);
        return NodeFactory.createMappingConstructorExpressionNode(
                SyntaxTreeConstants.SYNTAX_TREE_OPEN_BRACE,
                NodeFactory.createSeparatedNodeList(subRecordNodes),
                SyntaxTreeConstants.SYNTAX_TREE_CLOSE_BRACE);
    }

    private static ListConstructorExpressionNode handleRepeatedTypes(Field field, Map<String, Message> msgMap) {
        List<Node> subRecordNodes = Collections.singletonList(getFieldPatternNode(field, msgMap, true));
        return getListConstructorExpressionNode(subRecordNodes);
    }

    private static NodeList<ImportDeclarationNode> addImports(NodeList<ImportDeclarationNode> imports, Method method,
                                                              String filename) {
        imports = addIoImport(method, imports);
        imports = addSubModuleImports(Collections.singletonList(method), filename, imports);
        imports = addAnyImportIfExists(method, imports);
        return getTimeImportsIfExists(imports, method);
    }

    private static NodeList<ImportDeclarationNode> addIoImport(Method method, NodeList<ImportDeclarationNode> imports) {
        if (method.getOutputType() != null) {
            return imports.add(Imports.getImportDeclarationNode(ORG_NAME, "io"));
        }
        return imports;
    }

    private static NodeList<ImportDeclarationNode> addAnyImportIfExists(Method method,
                                                                        NodeList<ImportDeclarationNode> imports) {
        if ((method.getInputType() != null && method.getInputType().equals("'any:Any")) ||
                (method.getOutputType() != null && method.getOutputType().equals("'any:Any"))) {
            return imports.add(Imports.getImportDeclarationNode(ORG_NAME, "protobuf.types.'any"));
        }
        return imports;
    }

    private static NodeList<ImportDeclarationNode> getTimeImportsIfExists(NodeList<ImportDeclarationNode> imports,
                                                                          Method method) {
        if (checkForImportsInServices(Collections.singletonList(method), "time:Utc") ||
                checkForImportsInServices(Collections.singletonList(method), "time:Seconds")) {
            return imports.add(Imports.getImportDeclarationNode(ORG_NAME, "time"));
        }
        return imports;
    }

    private static ExpressionStatementNode getPrintlnStatement(String input) {
        return getCallStatementNode(getFunctionCallExpressionNode("io", "println", input));
    }
}
