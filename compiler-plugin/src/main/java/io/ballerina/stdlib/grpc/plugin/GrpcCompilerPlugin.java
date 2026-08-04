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

import io.ballerina.projects.plugins.CompilerPlugin;
import io.ballerina.projects.plugins.CompilerPluginContext;
import io.ballerina.stdlib.grpc.plugin.endpointyaml.generator.Endpoint;
import io.ballerina.stdlib.grpc.plugin.endpointyaml.generator.GrpcEndpointsLifecycleListener;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Map;

import static io.ballerina.stdlib.grpc.plugin.GrpcCompilerPluginConstants.GRPC_EXPORTED_ENDPOINTS;

/**
 * gRPC Compiler plugin.
 */
public class GrpcCompilerPlugin extends CompilerPlugin {

    @Override
    public void init(CompilerPluginContext compilerPluginContext) {
        Map<String, Object> ctxData = compilerPluginContext.userData();
        ctxData.put(GRPC_EXPORTED_ENDPOINTS, Collections.synchronizedList(new ArrayList<Endpoint>()));
        compilerPluginContext.addCodeAnalyzer(new GrpcCodeAnalyzer(ctxData));
        compilerPluginContext.addCompilerLifecycleListener(new GrpcEndpointsLifecycleListener(ctxData));
    }
}
