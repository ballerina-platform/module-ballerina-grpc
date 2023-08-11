/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package io.ballerina.stdlib.grpc;

import com.google.protobuf.CodedInputStream;
import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.types.Type;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Proto Message Parser.
 *
 * @since 1.0.0
 */
public class MessageParser {

    private final String messageName;
    private final Type bType;
    private final Map<Integer, Descriptors.FieldDescriptor> fieldDescriptors;

    public MessageParser(String messageName, Type bType) {
        this.messageName = messageName;
        this.bType = bType;
        Descriptors.Descriptor messageDescriptor = MessageRegistry.getInstance().getMessageDescriptor(messageName);
        this.fieldDescriptors = computeFieldTagValues(messageDescriptor);
    }

    public MessageParser(String messageName, Type bType, Descriptors.Descriptor messageDescriptor) {
        this.messageName = messageName;
        this.bType = bType;
        this.fieldDescriptors = computeFieldTagValues(messageDescriptor);
    }

    MessageParser(Descriptors.Descriptor descriptor, Type bType) {
        this.messageName = descriptor.getFullName();
        this.bType = bType;
        this.fieldDescriptors = computeFieldTagValues(descriptor);
    }

    public Map<Integer, Descriptors.FieldDescriptor> getFieldDescriptors() {
        return fieldDescriptors;
    }

    /**
     * Returns message object parse from {@code input}.
     * @param input CodedInputStream of incoming message.
     * @return Message object with bValue
     */
    Message parseFrom(CodedInputStream input) throws IOException {
        return new Message(messageName, bType, input, fieldDescriptors);
    }

    /**
     * Returns message instance without bValue.
     * @return message instance without bValue.
     */
    Message getDefaultInstance() throws IOException {
        return new Message(messageName, bType, null, fieldDescriptors);
    }

    public static Map<Integer, Descriptors.FieldDescriptor> computeFieldTagValues(
            Descriptors.Descriptor messageDescriptor) {

        Map<Integer, Descriptors.FieldDescriptor> fieldDescriptors = new HashMap<>();
        for (Descriptors.FieldDescriptor fieldDescriptor : messageDescriptor.getFields()) {
            Descriptors.FieldDescriptor.Type fieldType = fieldDescriptor.getType();
            int number = fieldDescriptor.getNumber();
            int byteCode = ((number << 3) + MessageUtils.getFieldWireType(fieldType));
            fieldDescriptors.put(byteCode, fieldDescriptor);
        }
        return fieldDescriptors;
    }
}
