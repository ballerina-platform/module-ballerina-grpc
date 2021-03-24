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
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
import io.ballerina.projects.plugins.AnalysisTask;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.tools.diagnostics.Diagnostic;
import io.ballerina.tools.diagnostics.DiagnosticFactory;
import io.ballerina.tools.diagnostics.DiagnosticInfo;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;
import org.ballerinalang.util.diagnostic.DiagnosticErrorCode;

/**
 * gRPC service validator for compiler API.
 */
public class GrpcServiceValidator implements AnalysisTask<SyntaxNodeAnalysisContext> {

    @Override
    public void perform(SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {

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
            DiagnosticInfo diagnosticInfo = new DiagnosticInfo(DiagnosticErrorCode.UNDEFINED_ANNOTATION.diagnosticId(),
             "undefined annotation: " + GrpcConstants.GRPC_ANNOTATION_NAME, DiagnosticSeverity.ERROR);
            Diagnostic diagnostic = DiagnosticFactory.createDiagnostic(diagnosticInfo, expressionNode.location());
            syntaxNodeAnalysisContext.reportDiagnostic(diagnostic);
        }
    }
}
