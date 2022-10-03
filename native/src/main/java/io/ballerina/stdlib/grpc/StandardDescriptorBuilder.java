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

import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.Descriptors;
import com.google.protobuf.InvalidProtocolBufferException;

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

    private static final String EMPTY_PROTO_PACKAGE_KEY = "google/protobuf/empty.proto";
    private static final String ANY_PROTO_PACKAGE_KEY = "google/protobuf/any.proto";
    private static final String API_PROTO_PACKAGE_KEY = "google/protobuf/api.proto";
    private static final String DESCRIPTOR_PROTO_PACKAGE_KEY = "google/protobuf/descriptor.proto";
    private static final String BALLERINA_DESCRIPTOR_PROTO_PACKAGE_KEY = "ballerina/protobuf/descriptor.proto";
    private static final String DURATION_PROTO_PACKAGE_KEY = "google/protobuf/duration.proto";
    private static final String FIELD_MASK_PROTO_PACKAGE_KEY = "google/protobuf/field_mask.proto";
    private static final String SOURCE_CONTEXT_PROTO_PACKAGE_KEY = "google/protobuf/source_context.proto";
    private static final String WRAPPERS_PROTO_PACKAGE_KEY = "google/protobuf/wrappers.proto";
    private static final String STRUCT_PROTO_PACKAGE_KEY = "google/protobuf/struct.proto";
    private static final String TIMESTAMP_PROTO_PACKAGE_KEY = "google/protobuf/timestamp.proto";
    private static final String TYPE_PROTO_PACKAGE_KEY = "google/protobuf/type.proto";
    private static final String COMPILER_PLUGIN_PROTO_PACKAGE_KEY = "google/protobuf/compiler/plugin.proto";

    // This is the proto descriptor of ballerina/protobuf/descriptor.proto. This needs to be regenerated if the proto
    // file changes.
    private static final byte[] BALLERINA_PROTOBUF_DESC_BYTES = {10, 35, 98, 97, 108, 108, 101, 114, 105, 110, 97,
            47, 112, 114, 111, 116, 111, 98, 117, 102, 47, 100, 101, 115, 99, 114, 105, 112, 116, 111, 114, 46, 112,
            114, 111, 116, 111, 18, 18, 98, 97, 108, 108, 101, 114, 105, 110, 97, 46, 112, 114, 111, 116, 111, 98, 117,
            102, 26, 32, 103, 111, 111, 103, 108, 101, 47, 112, 114, 111, 116, 111, 98, 117, 102, 47, 100, 101, 115, 99,
            114, 105, 112, 116, 111, 114, 46, 112, 114, 111, 116, 111, 58, 72, 10, 16, 98, 97, 108, 108, 101, 114, 105,
            110, 97, 95, 109, 111, 100, 117, 108, 101, 18, 28, 46, 103, 111, 111, 103, 108, 101, 46, 112, 114, 111, 116,
            111, 98, 117, 102, 46, 70, 105, 108, 101, 79, 112, 116, 105, 111, 110, 115, 24, -4, 8, 32, 1, 40, 9, 82, 15,
            98, 97, 108, 108, 101, 114, 105, 110, 97, 77, 111, 100, 117, 108, 101, 98, 6, 112, 114, 111, 116, 111, 51};

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
        standardLibDescriptorMapForPackageKey.put(BALLERINA_DESCRIPTOR_PROTO_PACKAGE_KEY,
                getBallerinaProtobufFileDescriptor());
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

    private static Descriptors.FileDescriptor getBallerinaProtobufFileDescriptor() {
        try {
            return Descriptors.FileDescriptor.buildFrom(DescriptorProtos.FileDescriptorProto
                    .parseFrom(BALLERINA_PROTOBUF_DESC_BYTES), new Descriptors.FileDescriptor[]{
                    standardLibDescriptorMapForPackageKey.get(DESCRIPTOR_PROTO_PACKAGE_KEY)});
        } catch (InvalidProtocolBufferException | Descriptors.DescriptorValidationException e) {
            return null;
        }
    }

    public static Descriptors.FileDescriptor getFileDescriptor(String libName) {
        return standardLibDescriptorMapForPackageKey.get(libName);
    }

    public static Descriptors.FileDescriptor getFileDescriptorFromMessageName(String messageName) {
        return standardLibDescriptorMapForMessageName.get(messageName);
    }

    public static Map<String, Descriptors.FileDescriptor> getDescriptorMapForPackageKey() {
        return standardLibDescriptorMapForPackageKey;
    }
}
