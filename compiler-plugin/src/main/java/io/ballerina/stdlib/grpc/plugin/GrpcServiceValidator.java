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

package io.ballerina.stdlib.grpc.plugin;

import io.ballerina.compiler.api.symbols.AnnotationSymbol;
import io.ballerina.compiler.api.symbols.ServiceDeclarationSymbol;
import io.ballerina.compiler.api.symbols.Symbol;
import io.ballerina.compiler.api.symbols.TypeDescKind;
import io.ballerina.compiler.api.symbols.TypeReferenceTypeSymbol;
import io.ballerina.compiler.api.symbols.TypeSymbol;
import io.ballerina.compiler.api.symbols.UnionTypeSymbol;
import io.ballerina.compiler.syntax.tree.DefaultableParameterNode;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.FunctionSignatureNode;
import io.ballerina.compiler.syntax.tree.IncludedRecordParameterNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.OptionalTypeDescriptorNode;
import io.ballerina.compiler.syntax.tree.ParameterNode;
import io.ballerina.compiler.syntax.tree.RequiredParameterNode;
import io.ballerina.compiler.syntax.tree.RestParameterNode;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.UnionTypeDescriptorNode;
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
    private static final String GRPC_EXACT_CALLER = "Caller";
    private static final String GRPC_RETURN_TYPE = "<RPC_RETURN_TYPE>";

    @Override
    public void perform(SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {

        List<Diagnostic> diagnostics = syntaxNodeAnalysisContext.semanticModel().diagnostics();
        for (Diagnostic diagnostic : diagnostics) {
            if (diagnostic.diagnosticInfo().severity() == DiagnosticSeverity.ERROR) {
                return;
            }
        }
        ServiceDeclarationNode serviceDeclarationNode = (ServiceDeclarationNode) syntaxNodeAnalysisContext.node();
        Optional<Symbol> optionalServiceDeclarationSymbol = syntaxNodeAnalysisContext.semanticModel()
                .symbol(serviceDeclarationNode);
        if (optionalServiceDeclarationSymbol.isPresent() &&
                (optionalServiceDeclarationSymbol.get() instanceof ServiceDeclarationSymbol)) {

            ServiceDeclarationSymbol serviceDeclarationSymbol = (ServiceDeclarationSymbol)
                    optionalServiceDeclarationSymbol.get();

            if (isBallerinaGrpcService(serviceDeclarationSymbol)) {
                String serviceName = serviceNameFromServiceDeclarationNode(serviceDeclarationNode);
                validateServiceAnnotation(serviceDeclarationNode, syntaxNodeAnalysisContext, serviceDeclarationSymbol);
                validateServiceName(serviceDeclarationNode, syntaxNodeAnalysisContext,
                        getFullServiceNameFromServiceDeclarationNode(serviceDeclarationNode));
                serviceDeclarationNode.members().stream().filter(child ->
                        child.kind() == SyntaxKind.OBJECT_METHOD_DEFINITION
                                || child.kind() == SyntaxKind.RESOURCE_ACCESSOR_DEFINITION).forEach(node -> {

                    FunctionDefinitionNode functionDefinitionNode = (FunctionDefinitionNode) node;
                    // Check functions are remote or not
                    validateServiceFunctions(functionDefinitionNode, syntaxNodeAnalysisContext);
                    // Check params and return types
                    boolean isRemoteFunction = functionDefinitionNode.qualifierList().stream()
                            .filter(q -> q.kind() == SyntaxKind.REMOTE_KEYWORD).toArray().length == 1;
                    if (isRemoteFunction) {
                        validateFunctionSignature(functionDefinitionNode, syntaxNodeAnalysisContext, serviceName);
                    }
                });
            }

        }

    }

    private boolean isBallerinaGrpcService(ServiceDeclarationSymbol serviceDeclarationSymbol) {

        List<TypeSymbol> listenerTypes = serviceDeclarationSymbol.listenerTypes();
        for (TypeSymbol listenerType : listenerTypes) {
            if (listenerType.typeKind() == TypeDescKind.UNION) {
                List<TypeSymbol> memberDescriptors = ((UnionTypeSymbol) listenerType).memberTypeDescriptors();
                for (TypeSymbol typeSymbol : memberDescriptors) {
                    if (typeSymbol.getModule().isPresent() && typeSymbol.getModule().get().id().orgName()
                            .equals(GrpcCompilerPluginConstants.BALLERINA_ORG_NAME) && typeSymbol.getModule()
                            .flatMap(Symbol::getName).orElse("")
                            .equals(GrpcCompilerPluginConstants.GRPC_PACKAGE_NAME)) {

                        return true;
                    }
                }
            } else if (listenerType.typeKind() == TypeDescKind.TYPE_REFERENCE
                    && listenerType.getModule().isPresent()
                    && listenerType.getModule().get().id().orgName()
                    .equals(GrpcCompilerPluginConstants.BALLERINA_ORG_NAME)
                    && ((TypeReferenceTypeSymbol) listenerType).typeDescriptor().getModule()
                    .flatMap(Symbol::getName).orElse("").equals(GrpcCompilerPluginConstants.GRPC_PACKAGE_NAME)) {

                return true;
            }
        }
        return false;
    }

    private void validateServiceName(ServiceDeclarationNode serviceDeclarationNode,
                                     SyntaxNodeAnalysisContext syntaxNodeAnalysisContext, String serviceName) {

        if (serviceDeclarationNode.absoluteResourcePath().isEmpty()) {
            reportErrorDiagnostic(serviceDeclarationNode, syntaxNodeAnalysisContext,
                    (GrpcCompilerPluginConstants.CompilationErrors.INVALID_SERVICE_NAME.getError() +
                            ". Service name cannot be nil"),
                    GrpcCompilerPluginConstants.CompilationErrors.INVALID_SERVICE_NAME.getErrorCode());
        } else if (serviceName.equals("")) {
            reportErrorDiagnostic(serviceDeclarationNode.absoluteResourcePath().get(0), syntaxNodeAnalysisContext,
                    (GrpcCompilerPluginConstants.CompilationErrors.INVALID_SERVICE_NAME.getError() +
                            ". Service name cannot be nil"),
                    GrpcCompilerPluginConstants.CompilationErrors.INVALID_SERVICE_NAME.getErrorCode());
        } else if (serviceName.contains("/")) {
            reportErrorDiagnostic(serviceDeclarationNode.absoluteResourcePath().get(0), syntaxNodeAnalysisContext,
                    (GrpcCompilerPluginConstants.CompilationErrors.INVALID_SERVICE_NAME.getError() +
                            " " + serviceName + ". Service name should not be a hierarchical name"),
                    GrpcCompilerPluginConstants.CompilationErrors.INVALID_SERVICE_NAME.getErrorCode());
        }
    }

    private void validateServiceAnnotation(ServiceDeclarationNode serviceDeclarationNode,
                                           SyntaxNodeAnalysisContext syntaxNodeAnalysisContext,
                                           ServiceDeclarationSymbol serviceDeclarationSymbol) {

        boolean isServiceDescAnnotationPresents = false;
        List<AnnotationSymbol> annotationSymbols = serviceDeclarationSymbol.annotations();
        for (AnnotationSymbol annotationSymbol : annotationSymbols) {
            if (annotationSymbol.getModule().isPresent()
                    && GrpcCompilerPluginConstants.GRPC_PACKAGE_NAME.equals(
                    annotationSymbol.getModule().get().id().moduleName())
                    && annotationSymbol.getName().isPresent()
                    && GrpcCompilerPluginConstants.GRPC_ANNOTATION_NAME.equals(annotationSymbol.getName().get())) {

                isServiceDescAnnotationPresents = true;
                break;
            }
        }
        if (!isServiceDescAnnotationPresents) {
            reportErrorDiagnostic(serviceDeclarationNode, syntaxNodeAnalysisContext,
                    (GrpcCompilerPluginConstants.CompilationErrors.UNDEFINED_ANNOTATION.getError() +
                            GrpcCompilerPluginConstants.GRPC_PACKAGE_NAME + ":" +
                            GrpcCompilerPluginConstants.GRPC_ANNOTATION_NAME),
                    GrpcCompilerPluginConstants.CompilationErrors.UNDEFINED_ANNOTATION.getErrorCode());
        }
    }

    private void validateServiceFunctions(FunctionDefinitionNode functionDefinitionNode,
                                          SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {

        boolean hasResourceKeyword = functionDefinitionNode.qualifierList().stream()
                .filter(q -> q.kind() == SyntaxKind.RESOURCE_KEYWORD).toArray().length == 1;
        if (hasResourceKeyword) {
            reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                    GrpcCompilerPluginConstants.CompilationErrors.RESOURCES_NOT_ALLOWED.getError(),
                    GrpcCompilerPluginConstants.CompilationErrors.RESOURCES_NOT_ALLOWED.getErrorCode());
        }
    }

    private void validateFunctionSignature(FunctionDefinitionNode functionDefinitionNode,
                                           SyntaxNodeAnalysisContext syntaxNodeAnalysisContext, String serviceName) {

        FunctionSignatureNode functionSignatureNode = functionDefinitionNode.functionSignature();
        SeparatedNodeList<ParameterNode> parameterNodes = functionSignatureNode.parameters();
        if (parameterNodes.size() == 2) {
            String firstParameter = typeNameFromParameterNode(functionSignatureNode.parameters().get(0));

            if (!firstParameter.toLowerCase(Locale.ENGLISH).contains(GRPC_GENERIC_CALLER)) {
                reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                        GrpcCompilerPluginConstants.CompilationErrors.TWO_PARAMS_WITHOUT_CALLER.getError(),
                        GrpcCompilerPluginConstants.CompilationErrors.TWO_PARAMS_WITHOUT_CALLER.getErrorCode());
            } else if (!isValidCallerParameter(firstParameter, serviceName)) {
                String expectedCaller = serviceName.substring(0, 1).toUpperCase(Locale.ENGLISH) + serviceName.substring(1) +
                        GRPC_RETURN_TYPE + GRPC_EXACT_CALLER;
                String diagnosticMessage = GrpcCompilerPluginConstants.CompilationErrors
                        .INVALID_CALLER_TYPE.getError() +
                        expectedCaller + "\" but found \"" + firstParameter + "\"";
                reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext, diagnosticMessage,
                        GrpcCompilerPluginConstants.CompilationErrors.INVALID_CALLER_TYPE.getErrorCode());
            } else if (functionSignatureNode.returnTypeDesc().isPresent()) {
                Node returnTypeNode = functionSignatureNode.returnTypeDesc().get().type();
                if (!(SyntaxKind.NIL_TYPE_DESC == returnTypeNode.kind())) {
                    if (SyntaxKind.OPTIONAL_TYPE_DESC == returnTypeNode.kind() &&
                            ((OptionalTypeDescriptorNode) returnTypeNode).children().size() == 2) {
                        for (Node value : ((OptionalTypeDescriptorNode) returnTypeNode).children()) {
                            if (!(value.kind() == SyntaxKind.ERROR_TYPE_DESC ||
                                    value.kind() == SyntaxKind.QUESTION_MARK_TOKEN)) {
                                reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                                        GrpcCompilerPluginConstants.CompilationErrors.RETURN_WITH_CALLER.getError(),
                                        GrpcCompilerPluginConstants.CompilationErrors
                                                .RETURN_WITH_CALLER.getErrorCode());
                                break;
                            }
                        }
                    } else if (SyntaxKind.UNION_TYPE_DESC == returnTypeNode.kind() &&
                            ((UnionTypeDescriptorNode) returnTypeNode).children().size() == 3) {
                        for (Node value : ((UnionTypeDescriptorNode) returnTypeNode).children()) {
                            if (!(value.kind() == SyntaxKind.ERROR_TYPE_DESC ||
                                    value.kind() == SyntaxKind.PIPE_TOKEN ||
                                    value.kind() == SyntaxKind.NIL_TYPE_DESC)) {
                                reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                                        GrpcCompilerPluginConstants.CompilationErrors.RETURN_WITH_CALLER.getError(),
                                        GrpcCompilerPluginConstants.CompilationErrors
                                                .RETURN_WITH_CALLER.getErrorCode());
                                break;
                            }
                        }
                    } else {
                        reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                                GrpcCompilerPluginConstants.CompilationErrors.RETURN_WITH_CALLER.getError(),
                                GrpcCompilerPluginConstants.CompilationErrors
                                        .RETURN_WITH_CALLER.getErrorCode());
                    }
                }
            }
        } else if (parameterNodes.size() > 2) {
            reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                    GrpcCompilerPluginConstants.CompilationErrors.MAX_PARAM_COUNT.getError(),
                    GrpcCompilerPluginConstants.CompilationErrors.MAX_PARAM_COUNT.getErrorCode());
        }
    }

    private boolean isValidCallerParameter(String callerTypeName, String serviceName) {

        return callerTypeName.startsWith(serviceName.substring(0, 1).toUpperCase(Locale.ENGLISH) + serviceName.substring(1))
                && callerTypeName.endsWith(GRPC_EXACT_CALLER);
    }

    private void reportErrorDiagnostic(Node node, SyntaxNodeAnalysisContext syntaxNodeAnalysisContext, String message,
                                       String diagnosticId) {

        DiagnosticInfo diagnosticErrInfo = new DiagnosticInfo(diagnosticId, message, DiagnosticSeverity.ERROR);
        Diagnostic diagnostic = DiagnosticFactory.createDiagnostic(diagnosticErrInfo,
                node.location());
        syntaxNodeAnalysisContext.reportDiagnostic(diagnostic);
    }

    private String serviceNameFromServiceDeclarationNode(ServiceDeclarationNode serviceDeclarationNode) {

        NodeList<Node> nodeList = serviceDeclarationNode.absoluteResourcePath();
        if (nodeList.size() > 0) {
            String serviceName = serviceDeclarationNode.absoluteResourcePath().get(0).toString();
            return serviceName.replaceAll("\"", "").strip();
        }
        return "";
    }

    private String getFullServiceNameFromServiceDeclarationNode(ServiceDeclarationNode serviceDeclarationNode) {

        NodeList<Node> nodeList = serviceDeclarationNode.absoluteResourcePath();
        StringBuilder serviceNameBuilder = new StringBuilder();
        for (Node node : nodeList) {
            serviceNameBuilder.append(node.toString());
        }
        return serviceNameBuilder.toString().replaceAll("\"", "").strip();
    }

    private String typeNameFromParameterNode(ParameterNode parameterNode) {

        if (parameterNode instanceof RequiredParameterNode) {
            RequiredParameterNode requiredParameterNode = (RequiredParameterNode) parameterNode;
            return requiredParameterNode.typeName().toString().strip();
        } else if (parameterNode instanceof DefaultableParameterNode) {
            DefaultableParameterNode defaultableParameterNode = (DefaultableParameterNode) parameterNode;
            return defaultableParameterNode.typeName().toString().strip();
        } else if (parameterNode instanceof IncludedRecordParameterNode) {
            IncludedRecordParameterNode includedParameterNode = (IncludedRecordParameterNode) parameterNode;
            return includedParameterNode.typeName().toString().strip();
        } else if (parameterNode instanceof RestParameterNode) {
            RestParameterNode restParameterNode = (RestParameterNode) parameterNode;
            return restParameterNode.typeName().toString().strip();
        }
        return "";
    }
}
