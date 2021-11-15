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

import com.google.protobuf.Descriptors;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Proto Message Registry.
 * Contains message descriptor against message name.
 *
 * @since 1.0.0
 */
public class MessageRegistry {

    private Map<String, Descriptors.Descriptor> messageDescriptors = new HashMap<>();
    private Descriptors.FileDescriptor fileDescriptor;

    private static volatile MessageRegistry messageRegistry = new MessageRegistry();

    private MessageRegistry() {}

    public static MessageRegistry getInstance() {
        return messageRegistry;
    }

    public void addMessageDescriptor(String messageName, Descriptors.Descriptor messageDescriptor) {
        messageDescriptors.put(messageName, messageDescriptor);
    }

    public Descriptors.Descriptor getMessageDescriptor(String messageName) {
        return messageDescriptors.get(messageName);
    }

    public void setFileDescriptor(Descriptors.FileDescriptor fileDescriptor) {

        this.fileDescriptor = fileDescriptor;
    }

    public Descriptors.FileDescriptor getFileDescriptor() {

        return fileDescriptor;
    }

    public Map<String, Descriptors.Descriptor> getMessageDescriptorMap() {
        return Collections.unmodifiableMap(messageDescriptors);
    }
}
