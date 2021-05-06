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

import io.ballerina.tools.diagnostics.DiagnosticSeverity;

/**
 * gRPC compiler plugin constants.
 */
public class GrpcCompilerPluginConstants {

    // Compiler plugin constants
    public static final String GRPC_ANNOTATION_NAME = "ServiceDescriptor";
    public static final String BALLERINA_ORG_NAME = "ballerina";
    public static final String GRPC_PACKAGE_NAME = "grpc";

    /**
     * Compilation errors: Diagnostic error messages and IDs.
     */
    public enum CompilationErrors {
        UNDEFINED_ANNOTATION("undefined annotation: ", "GRPC_101", DiagnosticSeverity.ERROR),
        ONLY_REMOTE_FUNCTIONS("only remote functions are allowed inside gRPC services", "GRPC_102",
                DiagnosticSeverity.ERROR),
        RETURN_WITH_CALLER("only `error?` return type is allowed with the caller", "GRPC_103",
                DiagnosticSeverity.ERROR),
        MAX_PARAM_COUNT("the maximum number of parameters to a remote function is 2",
                "GRPC_104", DiagnosticSeverity.ERROR),
        TWO_PARAMS_WITHOUT_CALLER("when there are two parameters to a remote function, the first one " +
                "must be a caller type", "GRPC_105", DiagnosticSeverity.ERROR),
        INVALID_CALLER_TYPE("expected caller type \"", "GRPC_106", DiagnosticSeverity.ERROR);

        private final String error;
        private final String errorCode;
        private final DiagnosticSeverity diagnosticSeverity;

        CompilationErrors(String error, String errorCode, DiagnosticSeverity diagnosticSeverity) {

            this.error = error;
            this.errorCode = errorCode;
            this.diagnosticSeverity = diagnosticSeverity;
        }

        public String getError() {

            return error;
        }

        public String getErrorCode() {

            return errorCode;
        }

        public DiagnosticSeverity getDiagnosticSeverity() {

            return this.diagnosticSeverity;
        }
    }
}
