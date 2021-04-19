/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package org.ballerinalang.net.grpc.builder.stub;

import org.ballerinalang.net.grpc.exception.CodeBuilderException;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.ballerinalang.net.grpc.MessageUtils.getCallerTypeName;

/**
 * Service stub definition bean class.
 *
 * @since 0.982.0
 */
public class ServiceStub {
    private String serviceName;
    private String stubType = "blocking";
    private List<Method> unaryFunctions = new ArrayList<>();
    private List<Method> serverStreamingFunctions = new ArrayList<>();
    //both client streaming and bidirectional streaming have same client side behaviour.
    private List<Method> clientStreamingFunctions = new ArrayList<>();

    private List<Method> bidiStreamingFunctions = new ArrayList<>();
    private Map<String, String> callerMap = new HashMap<>();
    // this map uses to generate content context record types. Boolean value contains whether the content is stream
    // type or not.
    private Map<String, Boolean> valueTypeMap = new HashMap<>();

    private ServiceStub(String serviceName) {
        this.serviceName = serviceName;
    }

    public static ServiceStub.Builder newBuilder(String serviceName) {
        return new ServiceStub.Builder(serviceName);
    }

    public String getServiceName() {
        return serviceName;
    }

    public List<Method> getUnaryFunctions() {
        return Collections.unmodifiableList(unaryFunctions);
    }

    public List<Method> getServerStreamingFunctions() {
        return Collections.unmodifiableList(serverStreamingFunctions);
    }

    public List<Method> getClientStreamingFunctions() {
        return Collections.unmodifiableList(clientStreamingFunctions);
    }

    public List<Method> getBidiStreamingFunctions() {
        return Collections.unmodifiableList(bidiStreamingFunctions);
    }

    public Map<String, Boolean> getValueTypeMap() {
        return Collections.unmodifiableMap(valueTypeMap);
    }

    public Map<String, String> getCallerMap() {
        return Collections.unmodifiableMap(callerMap);
    }

    /**
     * Service stub definition builder.
     */
    public static class Builder {
        String serviceName;
        List<Method> methodList = new ArrayList<>();

        private Builder(String serviceName) {
            this.serviceName = serviceName;
        }

        public void addMethod(Method method) {
            methodList.add(method);
        }

        public ServiceStub build() throws CodeBuilderException {
            ServiceStub serviceStub = new ServiceStub(serviceName);
            for (Method method : methodList) {
                String callerTypeName = getCallerTypeName(serviceName, method.getOutputType());
                serviceStub.callerMap.put(callerTypeName, method.getOutputType());
                switch (method.getMethodType()) {
                    case UNARY:
                        serviceStub.valueTypeMap.put(method.getInputType(), Boolean.FALSE);
                        serviceStub.valueTypeMap.put(method.getOutputType(), Boolean.FALSE);
                        serviceStub.unaryFunctions.add(method);
                        break;
                    case SERVER_STREAMING:
                        serviceStub.valueTypeMap.put(method.getInputType(), Boolean.FALSE);
                        serviceStub.valueTypeMap.put(method.getOutputType(), Boolean.TRUE);
                        serviceStub.serverStreamingFunctions.add(method);
                        break;
                    case CLIENT_STREAMING:
                        serviceStub.valueTypeMap.put(method.getInputType(), Boolean.TRUE);
                        serviceStub.valueTypeMap.put(method.getOutputType(), Boolean.FALSE);
                        serviceStub.clientStreamingFunctions.add(method);
                        break;
                    case BIDI_STREAMING:
                        serviceStub.valueTypeMap.put(method.getInputType(), Boolean.TRUE);
                        serviceStub.valueTypeMap.put(method.getOutputType(), Boolean.TRUE);
                        serviceStub.bidiStreamingFunctions.add(method);
                        break;
                    default:
                        throw new CodeBuilderException("Method type is unknown or not supported.");
                }
            }
            return serviceStub;
        }
    }
}
