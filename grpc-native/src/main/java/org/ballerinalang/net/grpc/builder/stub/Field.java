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
import org.wso2.ballerinalang.compiler.util.Names;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import static org.ballerinalang.net.grpc.GrpcConstants.DOT;
import static org.ballerinalang.net.grpc.GrpcConstants.REGEX_DOT_SEPERATOR;

/**
 * Field definition bean class.
 *
 * @since 0.982.0
 */
public class Field {
    private String fieldType;
    private String fieldLabel;
    private String fieldName;
    private String defaultValue;

    private Field(String fieldName, String fieldType, String fieldLabel, String defaultValue) {
        this.fieldName = fieldName;
        this.fieldType = fieldType;
        this.fieldLabel = fieldLabel;
        this.defaultValue = defaultValue;
    }

    public static Field.Builder newBuilder(DescriptorProtos.FieldDescriptorProto fieldDescriptor) {
        return new Field.Builder(fieldDescriptor);
    }

    public String getFieldType() {
        return fieldType;
    }

    public String getFieldLabel() {
        return fieldLabel;
    }

    public String getFieldName() {
        return fieldName;
    }

    public String getDefaultValue() {
        return defaultValue;
    }

    /**
     * Field Definition.Builder.
     */
    public static class Builder {
        private DescriptorProtos.FieldDescriptorProto fieldDescriptor;

        public Field build() {
            String fieldType = fieldDescriptor.getTypeName();
            String fieldDefaultValue = null;
            if (CUSTOM_FIELD_TYPE_MAP.get(fieldDescriptor.getTypeName()) != null) {
                fieldType = CUSTOM_FIELD_TYPE_MAP.get(fieldDescriptor.getTypeName());
                fieldDefaultValue = CUSTOM_DEFAULT_VALUE_MAP.get(fieldDescriptor.getTypeName());
            } else if (FIELD_TYPE_MAP.get(fieldDescriptor.getType()) != null) {
                fieldType = FIELD_TYPE_MAP.get(fieldDescriptor.getType());
                fieldDefaultValue = FIELD_DEFAULT_VALUE_MAP.get(fieldDescriptor.getType());
            }

            if (fieldType.startsWith(DOT)) {
                String[] fieldTypeArray = fieldType.split(REGEX_DOT_SEPERATOR);
                fieldType = fieldTypeArray[fieldTypeArray.length - 1];
            }

            String fieldLabel = FIELD_LABEL_MAP.get(fieldDescriptor.getLabel());
            if (fieldDescriptor.getLabel() == DescriptorProtos.FieldDescriptorProto.Label.LABEL_REPEATED) {
                fieldDefaultValue = fieldLabel;
            }
            String fieldName = fieldDescriptor.getName();
            if (Arrays.stream(RESERVED_LITERAL_NAMES).anyMatch(fieldName::equalsIgnoreCase) || Names.ERROR.value
                    .equalsIgnoreCase(fieldName)) {
                fieldName = "'" + fieldName;
            }
            return new Field(fieldName, fieldType, fieldLabel, fieldDefaultValue);
        }

        private Builder(DescriptorProtos.FieldDescriptorProto fieldDescriptor) {
            this.fieldDescriptor = fieldDescriptor;
        }
    }

    private static final Map<DescriptorProtos.FieldDescriptorProto.Type, String> FIELD_TYPE_MAP;
    private static final Map<String, String> CUSTOM_FIELD_TYPE_MAP;
    private static final Map<DescriptorProtos.FieldDescriptorProto.Label, String> FIELD_LABEL_MAP;
    private static final Map<DescriptorProtos.FieldDescriptorProto.Type, String> FIELD_DEFAULT_VALUE_MAP;
    private static final Map<String, String> CUSTOM_DEFAULT_VALUE_MAP;

    static {
        FIELD_TYPE_MAP = new HashMap<>();
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_DOUBLE, "float");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_FLOAT, "float");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT32, "int");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT64, "int");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_UINT32, "int");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_UINT64, "int");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_SINT32, "int");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_SINT64, "int");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED32, "int");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED64, "int");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_SFIXED32, "int");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_SFIXED64, "int");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_BOOL, "boolean");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_STRING, "string");
        FIELD_TYPE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_BYTES, "byte[]");

        CUSTOM_FIELD_TYPE_MAP = new HashMap<>();
        CUSTOM_FIELD_TYPE_MAP.put(".google.protobuf.Any", "anydata");

        FIELD_DEFAULT_VALUE_MAP = new HashMap<>();
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_DOUBLE, "0.0");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_FLOAT, "0.0");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT32, "0");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT64, "0");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_UINT32, "0");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_UINT64, "0");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_SINT32, "0");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_SINT64, "0");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED32, "0");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED64, "0");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_SFIXED32, "0");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_SFIXED64, "0");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_BOOL, "false");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_STRING, "");
        FIELD_DEFAULT_VALUE_MAP.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_BYTES, "[]");

        CUSTOM_DEFAULT_VALUE_MAP = new HashMap<>();
        CUSTOM_DEFAULT_VALUE_MAP.put(".google.protobuf.Any", "()");

        FIELD_LABEL_MAP = new HashMap<>();
        FIELD_LABEL_MAP.put(DescriptorProtos.FieldDescriptorProto.Label.LABEL_OPTIONAL, null);
        FIELD_LABEL_MAP.put(DescriptorProtos.FieldDescriptorProto.Label.LABEL_REQUIRED, null);
        FIELD_LABEL_MAP.put(DescriptorProtos.FieldDescriptorProto.Label.LABEL_REPEATED, "[]");
    }

    private static final String[] RESERVED_LITERAL_NAMES = {
            "import", "as", "public", "private", "external", "final", "service", "resource", "function", "object",
            "record", "annotation", "parameter", "transformer", "worker", "listener", "remote", "xmlns", "returns",
            "version", "channel", "abstract", "client", "const", "typeof", "source", "from", "on", "group", "by",
            "having", "order", "where", "followed", "for", "window", "every", "within", "snapshot", "inner", "outer",
            "right", "left", "full", "unidirectional", "forever", "limit", "ascending", "descending", "int", "byte",
            "float", "decimal", "boolean", "string", "error", "map", "json", "xml", "table", "stream", "any",
            "typedesc", "type", "future", "anydata", "handle", "var", "new", "init", "if", "match", "else",
            "foreach", "while", "continue", "break", "fork", "join", "some", "all", "try", "catch", "finally", "throw",
            "panic", "trap", "return", "transaction", "abort", "retry", "onretry", "retries", "committed", "aborted",
            "with", "in", "lock", "untaint", "start", "but", "check", "checkpanic", "primarykey", "is", "flush",
            "wait", "default"};
}
