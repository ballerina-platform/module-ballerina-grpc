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

import io.ballerina.compiler.syntax.tree.AnnotationNode;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.FunctionSignatureNode;
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
import org.ballerinalang.util.diagnostic.DiagnosticErrorCode;

import java.util.Locale;

/**
 * gRPC service validator for compiler API.
 */
public class GrpcServiceValidator implements AnalysisTask<SyntaxNodeAnalysisContext> {

    private static final String GRPC_GENERIC_CALLER = "caller";

    @Override
    public void perform(SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {
        // Check the gRPC annotations are present
        ServiceDeclarationNode expressionNode = (ServiceDeclarationNode) syntaxNodeAnalysisContext.node();
        boolean isServiceDescAnnotationPresents = false;
        if (expressionNode.metadata().isPresent()) {
            NodeList<AnnotationNode> nodeList = expressionNode.metadata().get().annotations();
            for (AnnotationNode annotationNode : nodeList) {
                if (GrpcConstants.GRPC_ANNOTATION_NAME.equals(annotationNode.annotReference().toString().strip())) {
                    isServiceDescAnnotationPresents = true;
                    break;
                }
            }
        }
        if (!isServiceDescAnnotationPresents) {
            reportServiceErrorDiagnostic(expressionNode, syntaxNodeAnalysisContext,
                    (GrpcConstants.UNDEFINED_ANNOTATION_MSG + GrpcConstants.GRPC_ANNOTATION_NAME));
        }

        expressionNode.members().stream().filter(child -> child.kind() == SyntaxKind.OBJECT_METHOD_DEFINITION
                || child.kind() == SyntaxKind.RESOURCE_ACCESSOR_DEFINITION).forEach(node -> {

            FunctionDefinitionNode functionDefinitionNode = (FunctionDefinitionNode) node;
            // Check functions are remote or not
            validateServiceFunctions(functionDefinitionNode, syntaxNodeAnalysisContext);
            // Check params and return types
            validateFunctionSignature(functionDefinitionNode, syntaxNodeAnalysisContext);

        });
    }

    public void validateServiceFunctions(FunctionDefinitionNode functionDefinitionNode,
                                         SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {

        boolean hasRemoteKeyword = functionDefinitionNode.qualifierList().stream()
                .filter(q -> q.kind() == SyntaxKind.REMOTE_KEYWORD).toArray().length == 1;
        if (!hasRemoteKeyword) {
            reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                    GrpcConstants.ONLY_REMOTE_FUNCTIONS_MSG);
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
                        GrpcConstants.TWO_PARAMS_WITHOUT_CALLER_MSG);
            } else if (functionSignatureNode.returnTypeDesc().isPresent()) {
                SyntaxKind returnTypeKind = functionSignatureNode.returnTypeDesc().get().type().kind();
                if (!SyntaxKind.NIL_TYPE_DESC.name().equals(returnTypeKind.name())) {
                    reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                            GrpcConstants.RETURN_WITH_CALLER_MSG);
                }
            }
        } else if (parameterNodes.size() > 2) {
            reportErrorDiagnostic(functionDefinitionNode, syntaxNodeAnalysisContext,
                    GrpcConstants.MAX_PARAM_COUNT_MSG);
        }

    }

    public void reportErrorDiagnostic(FunctionDefinitionNode functionDefinitionNode,
                                      SyntaxNodeAnalysisContext syntaxNodeAnalysisContext, String message) {

        DiagnosticInfo diagnosticErrInfo = new DiagnosticInfo(
                DiagnosticErrorCode.UNDEFINED_ANNOTATION.diagnosticId(), message, DiagnosticSeverity.ERROR);
        Diagnostic diagnostic = DiagnosticFactory.createDiagnostic(diagnosticErrInfo,
                functionDefinitionNode.location());
        syntaxNodeAnalysisContext.reportDiagnostic(diagnostic);
    }

    public void reportServiceErrorDiagnostic(ServiceDeclarationNode serviceDeclarationNode,
                                             SyntaxNodeAnalysisContext syntaxNodeAnalysisContext, String message) {

        DiagnosticInfo diagnosticErrInfo = new DiagnosticInfo(DiagnosticErrorCode.UNDEFINED_ANNOTATION.diagnosticId(),
                message, DiagnosticSeverity.ERROR);
        Diagnostic diagnostic = DiagnosticFactory.createDiagnostic(diagnosticErrInfo,
                serviceDeclarationNode.location());
        syntaxNodeAnalysisContext.reportDiagnostic(diagnostic);
    }
}
