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
package org.ballerinalang.net.grpc;

import com.google.protobuf.Descriptors;

import java.util.HashMap;
import java.util.Map;

/**
 * Provides protobuf descriptor for well known dependency.
 */
public class StandardDescriptorBuilder {

    private static Map<String, Descriptors.FileDescriptor> standardLibDescriptor;

    public static final String EMPTY_PROTO_PACKAGE_KEY = "google/protobuf/empty.proto";
    public static final String ANY_PROTO_PACKAGE_KEY = "google/protobuf/any.proto";
    public static final String API_PROTO_PACKAGE_KEY = "google/protobuf/api.proto";
    public static final String DESCRIPTOR_PROTO_PACKAGE_KEY = "google/protobuf/descriptor.proto";
    public static final String DURATION_PROTO_PACKAGE_KEY = "google/protobuf/duration.proto";
    public static final String FIELD_MASK_PROTO_PACKAGE_KEY = "google/protobuf/field_mask.proto";
    public static final String SOURCE_CONTEXT_PROTO_PACKAGE_KEY = "google/protobuf/source_context.proto";
    public static final String WRAPPERS_PROTO_PACKAGE_KEY = "google/protobuf/wrappers.proto";
    public static final String STRUCT_PROTO_PACKAGE_KEY = "google/protobuf/struct.proto";
    public static final String TIMESTAMP_PROTO_PACKAGE_KEY = "google/protobuf/timestamp.proto";
    public static final String TYPE_PROTO_PACKAGE_KEY = "google/protobuf/type.proto";
    public static final String COMPILER_PLUGIN_PROTO_PACKAGE_KEY = "google/protobuf/compiler/plugin.proto";

    static {
        standardLibDescriptor = new HashMap<>();
        standardLibDescriptor.put(EMPTY_PROTO_PACKAGE_KEY, com.google.protobuf.EmptyProto.getDescriptor());
        standardLibDescriptor.put(ANY_PROTO_PACKAGE_KEY, com.google.protobuf.AnyProto.getDescriptor());
        standardLibDescriptor.put(API_PROTO_PACKAGE_KEY, com.google.protobuf.ApiProto.getDescriptor());
        standardLibDescriptor.put(DESCRIPTOR_PROTO_PACKAGE_KEY, com.google.protobuf.DescriptorProtos
                .getDescriptor());
        standardLibDescriptor.put(DURATION_PROTO_PACKAGE_KEY, com.google.protobuf.DurationProto.getDescriptor());
        standardLibDescriptor.put(FIELD_MASK_PROTO_PACKAGE_KEY, com.google.protobuf.FieldMaskProto
                .getDescriptor());
        standardLibDescriptor.put(SOURCE_CONTEXT_PROTO_PACKAGE_KEY, com.google.protobuf.SourceContextProto
                .getDescriptor());
        standardLibDescriptor.put(WRAPPERS_PROTO_PACKAGE_KEY, com.google.protobuf.WrappersProto.getDescriptor());
        standardLibDescriptor.put(STRUCT_PROTO_PACKAGE_KEY, com.google.protobuf.StructProto.getDescriptor());
        standardLibDescriptor.put(TIMESTAMP_PROTO_PACKAGE_KEY, com.google.protobuf.TimestampProto
                .getDescriptor());
        standardLibDescriptor.put(TYPE_PROTO_PACKAGE_KEY, com.google.protobuf.TypeProto.getDescriptor());
        standardLibDescriptor.put(COMPILER_PLUGIN_PROTO_PACKAGE_KEY, com.google.protobuf.compiler.PluginProtos
                .getDescriptor());
    }

    public static Descriptors.FileDescriptor getFileDescriptor(String libName) {
        return standardLibDescriptor.get(libName);
    }
}
