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

import com.google.protobuf.DescriptorProtos;
import org.ballerinalang.net.grpc.MessageUtils;
import org.ballerinalang.net.grpc.MethodDescriptor;

import java.util.Map;

import static org.ballerinalang.net.grpc.builder.balgen.BalGenerationUtils.getMappingBalType;

/**
 * Method definition bean class.
 *
 * @since 0.982.0
 */
public class Method {
    private final String methodName;
    private final String methodId;
    private final String inputType;
    private final String outputType;
    private final MethodDescriptor.MethodType methodType;

    private Method(String methodName, String methodId, String inputType, String outputType,
                   MethodDescriptor.MethodType methodType) {
        this.methodName = methodName;
        this.methodType = methodType;
        this.methodId = methodId;
        this.inputType = inputType;
        this.outputType = outputType;
    }

    public static Method.Builder newBuilder(String methodId) {
        return new Method.Builder(methodId);
    }

    public String getMethodName() {
        return methodName;
    }

    public String getMethodId() {
        return methodId;
    }

    public String getInputType() {
        return inputType;
    }

    public String getOutputType() {
        return outputType;
    }

    public MethodDescriptor.MethodType getMethodType() {
        return methodType;
    }

    public boolean containsEmptyType() {
        return inputType == null || outputType == null;
    }

    /**
     * Method Definition.Builder.
     */
    public static class Builder {
        String methodId;
        DescriptorProtos.MethodDescriptorProto methodDescriptor;
        Map<String, Message> messageMap;

        private Builder(String methodId) {
            this.methodId = methodId;
        }

        public Builder setMethodDescriptor(DescriptorProtos.MethodDescriptorProto methodDescriptor) {
            this.methodDescriptor = methodDescriptor;
            return this;
        }

        public Builder setMessageMap(Map<String, Message> messageMap) {
            this.messageMap = messageMap;
            return this;
        }

        public Method build() {
            MethodDescriptor.MethodType methodType = MessageUtils.getMethodType(methodDescriptor);
            String methodName = methodDescriptor.getName();
            String inputType = methodDescriptor.getInputType();
            inputType = getMappingBalType(inputType);
            String outputType = methodDescriptor.getOutputType();
            outputType = getMappingBalType(outputType);
            return new Method(methodName, methodId, inputType, outputType, methodType);
        }
    }
}
