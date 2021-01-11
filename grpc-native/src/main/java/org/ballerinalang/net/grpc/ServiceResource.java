/*
 *  Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package org.ballerinalang.net.grpc;

import io.ballerina.runtime.api.Runtime;
import io.ballerina.runtime.api.types.MethodType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.values.BObject;

import java.util.List;

import static org.ballerinalang.net.grpc.MessageUtils.headersRequired;

/**
 * gRPC service resource class containing metadata to dispatch service request.
 *
 * @since 0.990.4
 */
public class ServiceResource {

    private final BObject service;
    private final String serviceName;
    private final String functionName;
    private final Type[] paramTypes;
    private final boolean headerRequired;
    private final Runtime runtime;
    private final Type returnType;
    private final Type callerReturnType;

    public ServiceResource(Runtime runtime, BObject service, String serviceName, MethodType function,
                           Type callerReturnType) {
        this.service = service;
        this.serviceName = serviceName;
        this.functionName = function.getName();
        this.paramTypes = function.getParameterTypes();
        this.returnType = function.getReturnType();
        this.callerReturnType = callerReturnType;
        this.headerRequired = headersRequired(function);
        this.runtime = runtime;
    }

    public BObject getService() {
        return service;
    }

    public List<Type> getParamTypes() {
        return List.of(paramTypes);
    }

    public boolean isHeaderRequired() {
        return headerRequired;
    }

    public String getFunctionName() {
        return functionName;
    }

    public Runtime getRuntime() {
        return runtime;
    }

    public Type getReturnType() {
        return returnType;
    }

    public String getServiceName() {
        return serviceName;
    }

    public Type getCallerReturnType() {
        return callerReturnType;
    }
}
