/*
 * Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.ballerinalang.net.grpc.plugin;

import io.ballerina.compiler.api.symbols.ServiceDeclarationSymbol;
import io.ballerina.compiler.api.symbols.Symbol;
import io.ballerina.compiler.api.symbols.TypeDescKind;
import io.ballerina.compiler.api.symbols.TypeReferenceTypeSymbol;
import io.ballerina.compiler.api.symbols.TypeSymbol;
import io.ballerina.compiler.api.symbols.UnionTypeSymbol;
import io.ballerina.compiler.syntax.tree.AnnotationNode;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.FunctionSignatureNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.ParameterNode;
import io.ballerina.compiler.syntax.tree.RequiredParameterNode;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.projects.plugins.AnalysisTask;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.tools.diagnostics.Diagnostic;
import io.ballerina.tools.diagnostics.DiagnosticFactory;
import io.ballerina.tools.diagnostics.DiagnosticInfo;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;

import java.util.List;
import java.util.Locale;
import java.util.Optional;

/**
 * gRPC service validator for compiler API.
 */
public class GrpcServiceValidator implements AnalysisTask<SyntaxNodeAnalysisContext> {

    private static final String GRPC_GENERIC_CALLER = "caller";

    @Override
    public void perform(SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {
        // Check the gRPC annotations are present
        ServiceDeclarationNode serviceDeclarationNode = (ServiceDeclarationNode) syntaxNodeAnalysisContext.node();
        if (isBallerinaGrpcService(syntaxNodeAnalysisContext)) {
            validateServiceAnnotation(serviceDeclarationNode, syntaxNodeAnalysisContext);
            serviceDeclarationNode.members().stream().filter(child ->
            child.kind() == SyntaxKind.OBJECT_METHOD_DEFINITION
            || child.kind() == SyntaxKind.RESOURCE_ACCESSOR_DEFINITION).forEach(node -> {

                FunctionDefinitionNode functionDefinitionNode = (FunctionDefinitionNode) node;
                // Check functions are remote or not
                validateServiceFunctions(functionDefinitionNode, syntaxNodeAnalysisContext);
                // Check params and return types
                validateFunctionSignature(functionDefinitionNode, syntaxNodeAnalysisContext);

            });
        }
    }

    public boolean isBallerinaGrpcService(SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {

        ServiceDeclarationNode serviceDeclarationNode = (ServiceDeclarationNode) syntaxNodeAnalysisContext.node();
        Optional<Symbol> serviceDeclarationSymbol = syntaxNodeAnalysisContext.semanticModel()
                .symbol(serviceDeclarationNode);
        if (serviceDeclarationSymbol.isPresent()) {
            List<TypeSymbol> listenerTypes = ((ServiceDeclarationSymbol) serviceDeclarationSymbol.get())
                    .listenerTypes();
            for (TypeSymbol listenerType : listenerTypes) {
                if (listenerType.typeKind() == TypeDescKind.UNION) {
                    List<TypeSymbol> memberDescriptors = ((UnionTypeSymbol) listenerType).memberTypeDescriptors();
                    for (TypeSymbol typeSymbol : memberDescriptors) {
                        if (typeSymbol.getModule().isPresent() && typeSymbol.getModule().get().id().orgName()
                                .equals(GrpcConstants.BALLERINA_ORG_NAME) && typeSymbol.getModule()
                                .flatMap(Symbol::getName).orElse("").equals(GrpcConstants.GRPC_PACKAGE_NAME)) {

                            return true;
                        }
                    }
                } else if (listenerType.typeKind() == TypeDescKind.TYPE_REFERENCE
                        && listenerType.getModule().isPresent()
                        && listenerType.getModule().get().id().orgName().equals(GrpcConstants.BALLERINA_ORG_NAME)
                        && ((TypeReferenceTypeSymbol) listenerType).typeDescriptor().getModule()
                        .flatMap(Symbol::getName).orElse("").equals(GrpcConstants.GRPC_PACKAGE_NAME)) {

                    return true;
                }
            }
        }
        return false;
    }

    public void validateServiceAnnotation(ServiceDeclarationNode serviceDeclarationNode,
                                          SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {

        boolean isServiceDescAnnotationPresents = false;
        if (serviceDeclarationNode.metadata().isPresent()) {
            NodeList<AnnotationNode> nodeList = serviceDeclarationNode.metadata().get().annotations();
            for (AnnotationNode annotationNode : nodeList) {
                if (GrpcConstants.GRPC_ANNOTATION_NAME.equals(annotationNode.annotReference().toString().strip())) {
                    isServiceDescAnnotationPresents = true;
                    break;
                }
            }
        }
        if (!isServiceDescAnnotationPresents) {
            reportErrorDiagnostic(serviceDeclarationNode, syntaxNodeAnalysisContext,
                    (GrpcConstants.UNDEFINED_ANNOTATION_MSG + GrpcConstants.GRPC_ANNOTATION_NAME),
                    GrpcConstants.UNDEFINED_ANNOTATION_ID);
        }
    }

    public void validateServiceFunctions(FunctionDefinitionNode functionDefinitionNode,
                                         SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {

        boolean hasRemoteKeyword = functionDefinitionNode.qualifierList().stream()
                .filter(q -> q.kind() == SyntaxKind.REMOTE_KEYWORD).toArray().length == 1;
        if (!hasRemoteKeyword) {
            reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                    GrpcConstants.ONLY_REMOTE_FUNCTIONS_MSG, GrpcConstants.ONLY_REMOTE_FUNCTIONS_ID);
        }
    }

    public void validateFunctionSignature(FunctionDefinitionNode functionDefinitionNode,
                                          SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {

        FunctionSignatureNode functionSignatureNode = functionDefinitionNode.functionSignature();
        SeparatedNodeList<ParameterNode> parameterNodes = functionSignatureNode.parameters();

        if (parameterNodes.size() == 2) {
            RequiredParameterNode requiredParameterNode = (RequiredParameterNode)
                    functionSignatureNode.parameters().get(0);
            if (!requiredParameterNode.toString().toLowerCase(Locale.ENGLISH).contains(GRPC_GENERIC_CALLER)) {
                reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                        GrpcConstants.TWO_PARAMS_WITHOUT_CALLER_MSG, GrpcConstants.TWO_PARAMS_WITHOUT_CALLER_ID);
            } else if (functionSignatureNode.returnTypeDesc().isPresent()) {
                SyntaxKind returnTypeKind = functionSignatureNode.returnTypeDesc().get().type().kind();
                if (!SyntaxKind.NIL_TYPE_DESC.name().equals(returnTypeKind.name())) {
                    reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                            GrpcConstants.RETURN_WITH_CALLER_MSG, GrpcConstants.RETURN_WITH_CALLER_ID);
                }
            }
        } else if (parameterNodes.size() > 2) {
            reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                    GrpcConstants.MAX_PARAM_COUNT_MSG, GrpcConstants.MAX_PARAM_COUNT_ID);
        }

    }

    public void reportErrorDiagnostic(Node node, SyntaxNodeAnalysisContext syntaxNodeAnalysisContext, String message,
    String diagnosticId) {

        DiagnosticInfo diagnosticErrInfo = new DiagnosticInfo(diagnosticId, message, DiagnosticSeverity.ERROR);
        Diagnostic diagnostic = DiagnosticFactory.createDiagnostic(diagnosticErrInfo,
                node.location());
        syntaxNodeAnalysisContext.reportDiagnostic(diagnostic);
    }
}
