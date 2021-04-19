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

/**
 * Enum Field definition.
 *
 * @since 0.982.0
 */
public class EnumField {
    private String name;
    private int number;
    
    EnumField(String name, int number) {
        this.name = name;
        this.number = number;
    }

    public static EnumField.Builder newBuilder(DescriptorProtos.EnumValueDescriptorProto fieldDescriptor) {
        return new EnumField.Builder(fieldDescriptor);
    }

    public String getName() {
        return name;
    }

    public int getNumber() {
        return number;
    }

    /**
     * Enum Field.Builder.
     */
    public static class Builder {
        private DescriptorProtos.EnumValueDescriptorProto fieldDescriptor;
        
        public EnumField build() {
            return new EnumField(fieldDescriptor.getName(), fieldDescriptor.getNumber());
        }

        private Builder(DescriptorProtos.EnumValueDescriptorProto fieldDescriptor) {
            this.fieldDescriptor = fieldDescriptor;
        }
    }
}
