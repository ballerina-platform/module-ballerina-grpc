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
package io.ballerina.stdlib.grpc;

import com.google.protobuf.Descriptors;

import java.util.HashMap;
import java.util.Map;

import static io.ballerina.stdlib.grpc.GrpcConstants.ANY_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.DURATION_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.EMPTY_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.STRUCT_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.TIMESTAMP_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_BOOL_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_BYTES_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_DOUBLE_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_FLOAT_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_INT32_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_INT64_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_STRING_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_UINT32_TYPE_NAME;
import static io.ballerina.stdlib.grpc.GrpcConstants.WRAPPER_UINT64_TYPE_NAME;

/**
 * Provides protobuf descriptor for well known dependency.
 */
public class StandardDescriptorBuilder {

    private static final Map<String, Descriptors.FileDescriptor> standardLibDescriptorMapForPackageKey;
    private static final Map<String, Descriptors.FileDescriptor> standardLibDescriptorMapForMessageName;

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
        standardLibDescriptorMapForPackageKey = new HashMap<>();
        standardLibDescriptorMapForPackageKey.put(EMPTY_PROTO_PACKAGE_KEY,
                com.google.protobuf.EmptyProto.getDescriptor());
        standardLibDescriptorMapForPackageKey.put(ANY_PROTO_PACKAGE_KEY,
                com.google.protobuf.AnyProto.getDescriptor());
        standardLibDescriptorMapForPackageKey.put(API_PROTO_PACKAGE_KEY,
                com.google.protobuf.ApiProto.getDescriptor());
        standardLibDescriptorMapForPackageKey.put(DESCRIPTOR_PROTO_PACKAGE_KEY,
                com.google.protobuf.DescriptorProtos.getDescriptor());
        standardLibDescriptorMapForPackageKey.put(DURATION_PROTO_PACKAGE_KEY,
                com.google.protobuf.DurationProto.getDescriptor());
        standardLibDescriptorMapForPackageKey.put(FIELD_MASK_PROTO_PACKAGE_KEY,
                com.google.protobuf.FieldMaskProto.getDescriptor());
        standardLibDescriptorMapForPackageKey.put(SOURCE_CONTEXT_PROTO_PACKAGE_KEY,
                com.google.protobuf.SourceContextProto.getDescriptor());
        standardLibDescriptorMapForPackageKey.put(WRAPPERS_PROTO_PACKAGE_KEY,
                com.google.protobuf.WrappersProto.getDescriptor());
        standardLibDescriptorMapForPackageKey.put(STRUCT_PROTO_PACKAGE_KEY,
                com.google.protobuf.StructProto.getDescriptor());
        standardLibDescriptorMapForPackageKey.put(TIMESTAMP_PROTO_PACKAGE_KEY,
                com.google.protobuf.TimestampProto.getDescriptor());
        standardLibDescriptorMapForPackageKey.put(TYPE_PROTO_PACKAGE_KEY,
                com.google.protobuf.TypeProto.getDescriptor());
        standardLibDescriptorMapForPackageKey.put(COMPILER_PLUGIN_PROTO_PACKAGE_KEY,
                com.google.protobuf.compiler.PluginProtos.getDescriptor());
    }

    static {
        standardLibDescriptorMapForMessageName = new HashMap<>();
        standardLibDescriptorMapForMessageName.put(ANY_TYPE_NAME,
                com.google.protobuf.AnyProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(EMPTY_TYPE_NAME,
                com.google.protobuf.EmptyProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(TIMESTAMP_TYPE_NAME,
                com.google.protobuf.TimestampProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(DURATION_TYPE_NAME,
                com.google.protobuf.DurationProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(STRUCT_TYPE_NAME,
                com.google.protobuf.StructProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(WRAPPER_DOUBLE_TYPE_NAME,
                com.google.protobuf.WrappersProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(WRAPPER_FLOAT_TYPE_NAME,
                com.google.protobuf.WrappersProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(WRAPPER_INT64_TYPE_NAME,
                com.google.protobuf.WrappersProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(WRAPPER_UINT64_TYPE_NAME,
                com.google.protobuf.WrappersProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(WRAPPER_INT32_TYPE_NAME,
                com.google.protobuf.WrappersProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(WRAPPER_UINT32_TYPE_NAME,
                com.google.protobuf.WrappersProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(WRAPPER_BOOL_TYPE_NAME,
                com.google.protobuf.WrappersProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(WRAPPER_STRING_TYPE_NAME,
                com.google.protobuf.WrappersProto.getDescriptor());
        standardLibDescriptorMapForMessageName.put(WRAPPER_BYTES_TYPE_NAME,
                com.google.protobuf.WrappersProto.getDescriptor());
    }

    public static Descriptors.FileDescriptor getFileDescriptor(String libName) {
        return standardLibDescriptorMapForPackageKey.get(libName);
    }

    public static Descriptors.FileDescriptor getFileDescriptorFromMessageName(String messageName) {
        return standardLibDescriptorMapForMessageName.get(messageName);
    }
}
