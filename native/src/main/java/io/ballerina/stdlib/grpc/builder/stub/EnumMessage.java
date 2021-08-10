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
package io.ballerina.stdlib.grpc.builder.stub;

import com.google.protobuf.DescriptorProtos;

import java.util.ArrayList;
import java.util.List;

import static io.ballerina.stdlib.grpc.builder.BallerinaFileBuilder.enumDefaultValueMap;

/**
 * Enum Message Definition.
 *
 * @since 0.982.0
 */
public class EnumMessage {
    private final List<EnumField> fieldList;
    private final String messageName;

    private EnumMessage(String messageName, List<EnumField> fieldList) {
        this.messageName = messageName;
        this.fieldList = fieldList;
    }

    public static EnumMessage.Builder newBuilder(DescriptorProtos.EnumDescriptorProto enumDescriptor) {
        return new EnumMessage.Builder(enumDescriptor, enumDescriptor.getName());
    }

    public static EnumMessage.Builder newBuilder(DescriptorProtos.EnumDescriptorProto enumDescriptor,
                                                 String messageName) {
        return new EnumMessage.Builder(enumDescriptor, messageName);
    }

    public List<EnumField> getFieldList() {
        return fieldList;
    }

    public String getMessageName() {
        return messageName;
    }

    /**
     * Enum Message.Builder.
     */
    public static class Builder {
        private final DescriptorProtos.EnumDescriptorProto enumDescriptor;
        private final String messageName;
    
        public EnumMessage build() {
            int index = 0;
            List<EnumField> fieldList = new ArrayList<>();
            for (DescriptorProtos.EnumValueDescriptorProto fieldDescriptor : enumDescriptor.getValueList()) {
                EnumField field = EnumField.newBuilder(fieldDescriptor).build();
                fieldList.add(field);
                if (index == 0) {
                    enumDefaultValueMap.put(messageName, field.getName());
                }
                index++;
            }
            return new EnumMessage(messageName, fieldList);
        }

        private Builder(DescriptorProtos.EnumDescriptorProto enumDescriptor, String messageName) {
            this.enumDescriptor = enumDescriptor;
            this.messageName = messageName;
        }
    }
}
