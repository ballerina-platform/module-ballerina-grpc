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

/**
 * gRPC Compiler plugin constants.
 */
public class GrpcConstants {

    public static final String GRPC_ANNOTATION_NAME = "ServiceDescriptor";
    public static final String BALLERINA_ORG_NAME = "ballerina";
    public static final String GRPC_PACKAGE_NAME = "grpc";

    // Diagnostic error messages and IDs
    public static final String UNDEFINED_ANNOTATION_MSG = "undefined annotation: ";
    public static final String ONLY_REMOTE_FUNCTIONS_MSG = "only remote functions are allowed inside gRPC services";
    public static final String RETURN_WITH_CALLER_MSG = "return types are not allowed with the caller";
    public static final String MAX_PARAM_COUNT_MSG = "the maximum number of parameters to a remote function is 2";
    public static final String TWO_PARAMS_WITHOUT_CALLER_MSG = "when there are two parameters to a remote function, " +
            "the first one must be a caller type";
    public static final String INVALID_CALLER_TYPE_MSG = "expected caller type \"";

    public static final String UNDEFINED_ANNOTATION_ID = "GRPC_101";
    public static final String ONLY_REMOTE_FUNCTIONS_ID = "GRPC_102";
    public static final String RETURN_WITH_CALLER_ID = "GRPC_103";
    public static final String MAX_PARAM_COUNT_ID = "GRPC_104";
    public static final String TWO_PARAMS_WITHOUT_CALLER_ID = "GRPC_105";
    public static final String INVALID_CALLER_TYPE_ID = "GRPC_106";
}
