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

import com.google.protobuf.AnyProto;
import com.google.protobuf.CodedInputStream;
import com.google.protobuf.CodedOutputStream;
import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.Descriptors;
import com.google.protobuf.DurationProto;
import com.google.protobuf.EmptyProto;
import com.google.protobuf.InvalidProtocolBufferException;
import com.google.protobuf.StructProto;
import com.google.protobuf.TimestampProto;
import com.google.protobuf.WireFormat;
import com.google.protobuf.WrappersProto;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.TypeTags;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.AnydataType;
import io.ballerina.runtime.api.types.ArrayType;
import io.ballerina.runtime.api.types.MapType;
import io.ballerina.runtime.api.types.RecordType;
import io.ballerina.runtime.api.types.TupleType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.types.UnionType;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BDecimal;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.netty.handler.codec.http.HttpHeaders;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.MathContext;
import java.util.Arrays;
import java.util.List;
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
 * Generic Proto3 Message.
 *
 * @since 1.0.0
 */
public class Message {

    private static final String GOOGLE_PROTOBUF_ANY = "google.protobuf.Any";
    private static final String GOOGLE_PROTOBUF_ANY_VALUE = "google.protobuf.Any.value";
    private static final String GOOGLE_PROTOBUF_ANY_TYPE_URL = "google.protobuf.Any.type_url";
    private static final String GOOGLE_PROTOBUF_ANY_MESSAGE_NAME = "Any";
    private static final String GOOGLE_PROTOBUF_TIMESTAMP = "google.protobuf.Timestamp";
    private static final String GOOGLE_PROTOBUF_TIMESTAMP_SECONDS = "google.protobuf.Timestamp.seconds";
    private static final String GOOGLE_PROTOBUF_TIMESTAMP_NANOS = "google.protobuf.Timestamp.nanos";
    private static final String GOOGLE_PROTOBUF_DURATION = "google.protobuf.Duration";
    private static final String GOOGLE_PROTOBUF_DURATION_SECONDS = "google.protobuf.Duration.seconds";
    private static final String GOOGLE_PROTOBUF_DURATION_NANOS = "google.protobuf.Duration.nanos";
    private static final String GOOGLE_PROTOBUF_STRUCT = "google.protobuf.Struct";
    private static final String GOOGLE_PROTOBUF_STRUCT_FIELDS = "google.protobuf.Struct.fields";
    private static final String GOOGLE_PROTOBUF_STRUCT_FIELDSENTRY_KEY = "google.protobuf.Struct.FieldsEntry.key";
    private static final String GOOGLE_PROTOBUF_STRUCT_FIELDSENTRY_VALUE = "google.protobuf.Struct.FieldsEntry.value";
    private static final String GOOGLE_PROTOBUF_VALUE_LIST_VALUE = "google.protobuf.Value.list_value";
    private static final String GOOGLE_PROTOBUF_VALUE_STRUCT_VALUE = "google.protobuf.Value.struct_value";
    private static final String GOOGLE_PROTOBUF_LISTVALUE_VALUES = "google.protobuf.ListValue.values";
    private static final String GOOGLE_PROTOBUF_STRUCTVALUE_VALUES = "google.protobuf.StructValue.values";
    private static final String BALLERINA_ANY_VALUE_ENTRY = "value";
    private static final String BALLERINA_TYPE_URL_ENTRY = "typeUrl";
    private static final BigDecimal ANALOG_GIGA = new BigDecimal(1000000000);

    private String messageName;
    private int memoizedSize = -1;
    private HttpHeaders headers;
    private Object bMessage = null;
    private Descriptors.Descriptor descriptor = null;

    private static final ArrayType stringArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_STRING);
    private static final ArrayType booleanArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_BOOLEAN);
    private static final ArrayType intArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_INT);
    private static final ArrayType int32ArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_INT_UNSIGNED_32);
    private static final ArrayType sint32ArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_INT_SIGNED_32);
    private static final ArrayType floatArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_FLOAT);

    private boolean isError = false;
    private Throwable error;

    public Message(String messageName, Object bMessage) {
        this.messageName = messageName;
        this.bMessage = bMessage;
        this.descriptor = MessageRegistry.getInstance().getMessageDescriptor(messageName);
    }

    public Message(Descriptors.Descriptor descriptor, Object bMessage) {
        this.descriptor = descriptor;
        this.bMessage = bMessage;
        this.messageName = descriptor.getName();
    }

    private Message(String messageName) {
        this.messageName = messageName;
    }

    public HttpHeaders getHeaders() {
        return headers;
    }

    public void setHeaders(HttpHeaders headers) {
        this.headers = headers;
    }

    public boolean isError() {
        return isError;
    }

    public Throwable getError() {
        return error;
    }

    public Object getbMessage() {
        return bMessage;
    }

    public Message(Throwable error) {
        this.error = error;
        this.isError = true;
    }

    public Message(
            String messageName,
            Type type,
            com.google.protobuf.CodedInputStream input,
            Map<Integer, Descriptors.FieldDescriptor> fieldDescriptors)
            throws IOException {
        this(messageName);
        boolean isAnyTypedMessage = false;
        boolean isTimestampMessage = false;
        String typeUrl = "";

        if (type instanceof UnionType && !(type instanceof AnydataType) && type.isNilable()) {
            List<Type> memberTypes = ((UnionType) type).getMemberTypes();
            if (memberTypes.size() != 2) {
                throw Status.Code.INTERNAL.toStatus().withDescription("Error while decoding request " +
                        "message. Field type is not a valid optional field type : " +
                        type.getName()).asRuntimeException();
            }
            for (Type memberType : memberTypes) {
                if (memberType.getTag() != TypeTags.NULL_TAG) {
                    type = memberType;
                    break;
                }
            }
        }

        BMap<BString, Object> bBMap = null;
        BArray bArray = null;
        isAnyTypedMessage = GOOGLE_PROTOBUF_ANY.equals(messageName) &&
                fieldDescriptors.values().stream().allMatch(fd -> fd.getFullName().contains(GOOGLE_PROTOBUF_ANY));
        isTimestampMessage = (type.getTag() == TypeTags.INTERSECTION_TAG || type.getTag() == TypeTags.TUPLE_TAG)
                && messageName.equals(TIMESTAMP_TYPE_NAME);
        if (type.getTag() == TypeTags.RECORD_TYPE_TAG && !isAnyTypedMessage) {
            bBMap = ValueCreator.createRecordValue(type.getPackage(), type.getName());
            bMessage = bBMap;
        } else if (isTimestampMessage) { // for Timestamp
            TupleType tupleType = TypeCreator.createTupleType(
                    Arrays.asList(PredefinedTypes.TYPE_INT, PredefinedTypes.TYPE_DECIMAL));
            bArray = ValueCreator.createTupleValue(tupleType);
            bMessage = bArray;
        } else if (type.getTag() == TypeTags.DECIMAL_TAG) { // for Duration type
            bMessage = ValueCreator.createDecimalValue(new BigDecimal(0));
        } else if (type.getTag() == TypeTags.MAP_TAG && !isAnyTypedMessage) { // for Struct type
            bBMap = ValueCreator.createMapValue(TypeCreator.createMapType(PredefinedTypes.TYPE_ANYDATA));
            bMessage = bBMap;
        } else if (type.getTag() == TypeTags.TUPLE_TAG) { // for each field in Struct type
            TupleType tupleType = TypeCreator.createTupleType(
                    Arrays.asList(PredefinedTypes.TYPE_STRING, PredefinedTypes.TYPE_ANYDATA));
            bArray = ValueCreator.createTupleValue(tupleType);
            bMessage = bArray;
        } else if (type.getTag() == TypeTags.ARRAY_TAG) { // for array values inside structs
            bArray = ValueCreator.createArrayValue(TypeCreator.createArrayType(PredefinedTypes.TYPE_ANYDATA));
            bMessage = bArray;
        } else if (isAnyTypedMessage && input != null) {
            int typeUrlTag = input.readTag();

            if (typeUrlTag == DescriptorProtos.FieldDescriptorProto.Type.TYPE_GROUP_VALUE) {
                typeUrl = input.readStringRequireUtf8();
                String typeName = anyMessageTypeNameFromTypeUrl(typeUrl);
                fieldDescriptors = findFieldDescriptorsMapFromTypeUrl(typeName, type);
                switch (typeName) {
                    case WRAPPER_DOUBLE_TYPE_NAME:
                    case WRAPPER_FLOAT_TYPE_NAME: {
                        bMessage = (double) 0;
                        break;
                    }
                    case WRAPPER_INT64_TYPE_NAME:
                    case WRAPPER_UINT64_TYPE_NAME:
                    case WRAPPER_INT32_TYPE_NAME:
                    case WRAPPER_UINT32_TYPE_NAME: {
                        bMessage = (long) 0;
                        break;
                    }
                    case WRAPPER_STRING_TYPE_NAME: {
                        bMessage = StringUtils.fromString("");
                        break;
                    }
                    case WRAPPER_BYTES_TYPE_NAME: {
                        bArray = ValueCreator.createArrayValue(
                                TypeCreator.createArrayType(PredefinedTypes.TYPE_ANYDATA));
                        bMessage = bArray;
                        break;
                    }
                    case WRAPPER_BOOL_TYPE_NAME: {
                        bMessage = Boolean.FALSE;
                        break;
                    }
                    case TIMESTAMP_TYPE_NAME: {
                        TupleType tupleType = TypeCreator.createTupleType(
                                Arrays.asList(PredefinedTypes.TYPE_INT, PredefinedTypes.TYPE_DECIMAL));
                        bArray = ValueCreator.createTupleValue(tupleType);
                        bMessage = bArray;
                        break;
                    }
                    case DURATION_TYPE_NAME: {
                        bMessage = ValueCreator.createDecimalValue(new BigDecimal(0));
                        break;
                    }
                    default: {
                        bBMap = ValueCreator.createMapValue(TypeCreator.createMapType(PredefinedTypes.TYPE_ANYDATA));
                        bMessage = bBMap;
                    }
                }
                // Unwanted tag readings for Any type
                skipUnnecessaryAnyTypeTags(input);
            }
        }

        if (input == null) {
            if (bBMap != null) {
                for (Map.Entry<Integer, Descriptors.FieldDescriptor> entry : fieldDescriptors.entrySet()) {
                    BString bFieldName =
                            StringUtils.fromString(entry.getValue().getName());
                    if (entry.getValue().getType().toProto().getNumber() ==
                            DescriptorProtos.FieldDescriptorProto.Type.TYPE_MESSAGE_VALUE &&
                            !entry.getValue().isRepeated()) {
                        bBMap.put(bFieldName, null);
                    } else if (entry.getValue().getType().toProto().getNumber() ==
                            DescriptorProtos.FieldDescriptorProto.Type.TYPE_ENUM_VALUE) {
                        bBMap.put(bFieldName, StringUtils
                                .fromString(entry.getValue().getEnumType().findValueByNumber(0).toString()));
                    }
                }
            } else {
                // Here fieldDescriptors map size should be one. Because the value can assign to one scalar field.
                for (Map.Entry<Integer, Descriptors.FieldDescriptor> entry : fieldDescriptors.entrySet()) {
                    switch (entry.getValue().getType().toProto().getNumber()) {
                        case DescriptorProtos.FieldDescriptorProto.Type.TYPE_DOUBLE_VALUE:
                        case DescriptorProtos.FieldDescriptorProto.Type.TYPE_FLOAT_VALUE: {
                            bMessage = (double) 0;
                            break;
                        }
                        case DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT64_VALUE:
                        case DescriptorProtos.FieldDescriptorProto.Type.TYPE_UINT64_VALUE:
                        case DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT32_VALUE:
                        case DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED64_VALUE:
                        case DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED32_VALUE: {
                            bMessage = (long) 0;
                            break;
                        }
                        case DescriptorProtos.FieldDescriptorProto.Type.TYPE_STRING_VALUE: {
                            bMessage = StringUtils.fromString("");
                            break;
                        }
                        case DescriptorProtos.FieldDescriptorProto.Type.TYPE_BOOL_VALUE: {
                            bMessage = Boolean.FALSE;
                            break;
                        }
                        default: {
                            throw Status.Code.INTERNAL.toStatus().withDescription("Error while decoding request " +
                                    "message. Field type is not supported : " +
                                    entry.getValue().getType()).asRuntimeException();
                        }
                    }
                }
            }
            return;
        }
        boolean done = false;
        while (!done) {
            int tag;
            try {
                tag = input.readTag();
            } catch (InvalidProtocolBufferException e) {
                tag = input.getLastTag();
            }

            if (tag == 0) {
                done = true;
            } else if (fieldDescriptors.containsKey(tag)) {
                Descriptors.FieldDescriptor fieldDescriptor = fieldDescriptors.get(tag);
                BString bFieldName = StringUtils.fromString(fieldDescriptor.getName());
                switch (fieldDescriptor.getType().toProto().getNumber()) {
                    case DescriptorProtos.FieldDescriptorProto.Type.TYPE_DOUBLE_VALUE: {
                        if (bBMap != null) {
                            if (fieldDescriptor.isRepeated()) {
                                BArray floatArray = ValueCreator.createArrayValue(floatArrayType);
                                if (bBMap.containsKey(bFieldName)) {
                                    floatArray = (BArray) bBMap.get(bFieldName);
                                } else {
                                    bBMap.put(bFieldName, floatArray);
                                }
                                floatArray.add(floatArray.size(), input.readDouble());
                            } else if (fieldDescriptor.getContainingOneof() != null) {
                                updateBBMap(bBMap, fieldDescriptor, input.readDouble());
                            } else {
                                bBMap.put(bFieldName, input.readDouble());
                            }
                        } else {
                            bMessage = input.readDouble();
                        }
                        break;
                    }
                    case DescriptorProtos.FieldDescriptorProto.Type.TYPE_FLOAT_VALUE: {
                        if (bBMap != null) {
                            if (fieldDescriptor.isRepeated()) {
                                BArray floatArray = ValueCreator.createArrayValue(floatArrayType);
                                if (bBMap.containsKey(bFieldName)) {
                                    floatArray = (BArray) bBMap.get(bFieldName);
                                } else {
                                    bBMap.put(bFieldName, floatArray);
                                }
                                floatArray.add(floatArray.size(),
                                        Double.parseDouble(String.valueOf(input.readFloat())));
                            } else if (fieldDescriptor.getContainingOneof() != null) {
                                double bValue = Double.parseDouble(String.valueOf(input.readFloat()));
                                updateBBMap(bBMap, fieldDescriptor, bValue);
                            } else {
                                bBMap.put(bFieldName, Double.parseDouble(String.valueOf(input.readFloat())));
                            }
                        } else {
                            bMessage = Double.parseDouble(String.valueOf(input.readFloat()));
                        }
                        break;
                    }
                    case DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT64_VALUE: {
                        if (bBMap != null) {
                            if (fieldDescriptor.isRepeated()) {
                                BArray intArray = ValueCreator.createArrayValue(intArrayType);
                                if (bBMap.containsKey(bFieldName)) {
                                    intArray = (BArray) bBMap.get(bFieldName);
                                } else {
                                    bBMap.put(bFieldName, intArray);
                                }
                                intArray.add(intArray.size(), input.readInt64());
                            } else if (fieldDescriptor.getContainingOneof() != null) {
                                updateBBMap(bBMap, fieldDescriptor, input.readInt64());
                            } else {
                                bBMap.put(bFieldName, input.readInt64());
                            }
                        } else if (bArray != null
                                && fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_TIMESTAMP_SECONDS)) {
                            bArray.add(0, input.readInt64());
                        } else if (bMessage instanceof BDecimal
                                && fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_DURATION_SECONDS)) {
                            bMessage = ValueCreator.createDecimalValue(new BigDecimal(input.readInt64()));
                        } else {
                            bMessage = input.readInt64();
                        }
                        break;
                    }
                    case DescriptorProtos.FieldDescriptorProto.Type.TYPE_UINT64_VALUE: {
                        if (bBMap != null) {
                            if (fieldDescriptor.isRepeated()) {
                                BArray intArray = ValueCreator.createArrayValue(intArrayType);
                                if (bBMap.containsKey(bFieldName)) {
                                    intArray = (BArray) bBMap.get(bFieldName);
                                } else {
                                    bBMap.put(bFieldName, intArray);
                                }
                                intArray.add(intArray.size(), input.readUInt64());
                            } else if (fieldDescriptor.getContainingOneof() != null) {
                                updateBBMap(bBMap, fieldDescriptor, input.readUInt64());
                            } else {
                                bBMap.put(bFieldName, input.readUInt64());
                            }
                        } else {
                            bMessage = input.readUInt64();
                        }
                        break;
                    }
                    case DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT32_VALUE: {
                        if (bBMap != null) {
                            if (fieldDescriptor.isRepeated()) {
                                BArray int32Array = ValueCreator.createArrayValue(int32ArrayType);
                                if (bBMap.containsKey(bFieldName)) {
                                    int32Array = (BArray) bBMap.get(bFieldName);
                                } else {
                                    bBMap.put(bFieldName, int32Array);
                                }
                                int32Array.add(int32Array.size(), input.readInt32());
                            } else if (fieldDescriptor.getContainingOneof() != null) {
                                updateBBMap(bBMap, fieldDescriptor, input.readInt32());
                            } else {
                                bBMap.put(bFieldName, input.readInt32());
                            }
                        } else if (bArray != null
                                && fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_TIMESTAMP_NANOS)) {
                            BigDecimal nanos = new BigDecimal(input.readInt32())
                                    .divide(ANALOG_GIGA, MathContext.DECIMAL128);
                            bArray.add(1, ValueCreator.createDecimalValue(nanos));
                        } else if (bMessage instanceof BDecimal
                                && fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_DURATION_NANOS)) {
                            BigDecimal nanos = new BigDecimal(input.readInt32())
                                    .divide(ANALOG_GIGA, MathContext.DECIMAL128);
                            BigDecimal secondsValue = ((BDecimal) bMessage).value();
                            bMessage = ValueCreator.createDecimalValue(secondsValue.add(nanos));
                        } else {
                            bMessage = input.readInt32();
                        }
                        break;
                    }
                    case DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED64_VALUE: {
                        if (bBMap != null) {
                            if (fieldDescriptor.isRepeated()) {
                                BArray intArray = ValueCreator.createArrayValue(intArrayType);
                                if (bBMap.containsKey(bFieldName)) {
                                    intArray = (BArray) bBMap.get(bFieldName);
                                } else {
                                    bBMap.put(bFieldName, intArray);
                                }
                                intArray.add(intArray.size(), input.readFixed64());
                            } else if (fieldDescriptor.getContainingOneof() != null) {
                                updateBBMap(bBMap, fieldDescriptor, input.readFixed64());
                            } else {
                                bBMap.put(bFieldName, input.readFixed64());
                            }
                        } else {
                            bMessage = input.readFixed64();
                        }
                        break;
                    }
                    case DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED32_VALUE: {
                        if (bBMap != null) {
                            if (fieldDescriptor.isRepeated()) {
                                BArray int32Array = ValueCreator.createArrayValue(int32ArrayType);
                                if (bBMap.containsKey(bFieldName)) {
                                    int32Array = (BArray) bBMap.get(bFieldName);
                                } else {
                                    bBMap.put(bFieldName, int32Array);
                                }
                                int32Array.add(int32Array.size(), input.readFixed32());
                            } else if (fieldDescriptor.getContainingOneof() != null) {
                                updateBBMap(bBMap, fieldDescriptor, input.readFixed32());
                            } else {
                                bBMap.put(bFieldName, input.readFixed32());
                            }
                        } else {
                            bMessage = input.readFixed32();
                        }
                        break;
                    }
                    case DescriptorProtos.FieldDescriptorProto.Type.TYPE_BOOL_VALUE: {
                        if (bBMap != null) {
                            if (fieldDescriptor.isRepeated()) {
                                BArray booleanArray = ValueCreator.createArrayValue(booleanArrayType);
                                if (bBMap.containsKey(bFieldName)) {
                                    booleanArray = (BArray) bBMap.get(bFieldName);
                                } else {
                                    bBMap.put(bFieldName, booleanArray);
                                }
                                booleanArray.add(booleanArray.size(), input.readBool());
                            } else if (fieldDescriptor.getContainingOneof() != null) {
                                updateBBMap(bBMap, fieldDescriptor, input.readBool());
                            } else {
                                bBMap.put(bFieldName, input.readBool());
                            }
                        } else {
                            bMessage = input.readBool();
                        }
                        break;
                    }
                    case DescriptorProtos.FieldDescriptorProto.Type.TYPE_STRING_VALUE: {
                        if (bBMap != null) {
                            if (fieldDescriptor.isRepeated()) {
                                BArray stringArray = ValueCreator.createArrayValue(stringArrayType);
                                if (bBMap.containsKey(bFieldName)) {
                                    stringArray = (BArray) bBMap.get(bFieldName);
                                } else {
                                    bBMap.put(bFieldName, stringArray);
                                }
                                stringArray.add(stringArray.size(), StringUtils
                                                .fromString(input.readStringRequireUtf8()));
                                bBMap.put(bFieldName, stringArray);
                            } else if (fieldDescriptor.getContainingOneof() != null) {
                                updateBBMap(bBMap, fieldDescriptor, StringUtils
                                                .fromString(input.readStringRequireUtf8()));
                            } else {
                                bBMap.put(bFieldName, StringUtils.fromString(
                                                input.readStringRequireUtf8()));
                            }
                        } else if (bArray != null &&
                                fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_STRUCT_FIELDSENTRY_KEY)) {
                            bArray.add(0, StringUtils.fromString(input.readStringRequireUtf8()));
                        } else if (!fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_ANY_TYPE_URL)) {
                            bMessage = StringUtils.fromString(
                                    input.readStringRequireUtf8());
                        }
                        break;
                    }
                    case DescriptorProtos.FieldDescriptorProto.Type.TYPE_ENUM_VALUE: {
                        if (bBMap != null) {
                            if (fieldDescriptor.isRepeated()) {
                                BArray stringArray = ValueCreator.createArrayValue(stringArrayType);
                                if (bBMap.containsKey(bFieldName)) {
                                    stringArray = (BArray) bBMap.get(bFieldName);
                                } else {
                                    bBMap.put(bFieldName, stringArray);
                                }
                                stringArray.add(stringArray.size(),
                                        StringUtils.fromString(
                                        fieldDescriptor.getEnumType().findValueByNumber(input.readEnum()).toString()));
                                bBMap.put(bFieldName, stringArray);
                            } else if (fieldDescriptor.getContainingOneof() != null) {
                                String bValue = fieldDescriptor.getEnumType().findValueByNumber(input
                                        .readEnum()).toString();
                                updateBBMap(bBMap, fieldDescriptor,
                                        StringUtils.fromString(bValue));
                            } else {
                                bBMap.put(bFieldName, StringUtils.fromString(
                                        fieldDescriptor.getEnumType().findValueByNumber(input.readEnum()).toString()));
                            }
                        } else {
                            bMessage = StringUtils.fromString(
                                    fieldDescriptor.getEnumType().findValueByNumber(input.readEnum()).toString());
                        }
                        break;
                    }
                    case DescriptorProtos.FieldDescriptorProto.Type.TYPE_BYTES_VALUE: {
                        if (bBMap != null) {
                             if (fieldDescriptor.getContainingOneof() != null) {
                                Object bValue = ValueCreator.createArrayValue(input.readByteArray());
                                updateBBMap(bBMap, fieldDescriptor, bValue);
                             } else {
                                 bBMap.put(bFieldName, ValueCreator.createArrayValue(input.readByteArray()));
                             }
                        } else {
                            bMessage = ValueCreator.createArrayValue(input.readByteArray());
                        }
                        break;
                    }
                    case DescriptorProtos.FieldDescriptorProto.Type.TYPE_MESSAGE_VALUE: {
                        RecordType recordType;
                        if (type instanceof RecordType) {
                            recordType = (RecordType) type;
                        } else if (type instanceof MapType || type instanceof TupleType ||
                                type instanceof AnydataType ||
                                type.getTag() == TypeCreator.createArrayType(PredefinedTypes.TYPE_ANYDATA).getTag()) {
                            recordType = null;
                        } else {
                            throw Status.Code.INTERNAL.toStatus().withDescription("Error while decoding request " +
                                    "message. record type is not supported : " +
                                    fieldDescriptor.getType()).asRuntimeException();
                        }
                        if (bBMap != null) {
                            if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_STRUCT_FIELDS) ||
                                    fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_STRUCTVALUE_VALUES)) {
                                BArray tupleval = (BArray) readMessage(fieldDescriptor,
                                        TypeCreator.createTupleType(Arrays.asList(PredefinedTypes.TYPE_STRING,
                                                PredefinedTypes.TYPE_ANYDATA)), input).bMessage;
                                bBMap.put(tupleval.getBString(0), tupleval.get(1));
                            } else if (fieldDescriptor.isRepeated()) {
                                BArray valueArray = bBMap.get(bFieldName) != null ?
                                        (BArray) bBMap.get(bFieldName) : null;
                                Type fieldType = recordType.getFields().get(bFieldName.getValue()).getFieldType();
                                if (valueArray == null || valueArray.size() == 0) {
                                    valueArray = ValueCreator.createArrayValue((ArrayType) fieldType);
                                    bBMap.put(bFieldName, valueArray);
                                }
                                valueArray.add(valueArray.size(), readMessage(fieldDescriptor,
                                        ((ArrayType) fieldType).getElementType(), input).bMessage);
                            } else if (fieldDescriptor.getContainingOneof() != null) {
                                Type fieldType = recordType.getFields().get(bFieldName.getValue()).getFieldType();
                                Object bValue = readMessage(fieldDescriptor, fieldType, input).bMessage;
                                updateBBMap(bBMap, fieldDescriptor, bValue);
                            } else if (fieldDescriptor.getMessageType().getFullName().equals(GOOGLE_PROTOBUF_STRUCT) &&
                                    recordType instanceof RecordType) {
                                Type fieldType = TypeCreator.createMapType(PredefinedTypes.TYPE_ANYDATA);
                                bBMap.put(bFieldName, readMessage(fieldDescriptor, fieldType, input).bMessage);
                            } else {
                                Type fieldType = recordType.getFields().get(bFieldName.getValue()).getFieldType();
                                bBMap.put(bFieldName, readMessage(fieldDescriptor, fieldType, input).bMessage);
                            }
                        } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_STRUCT_FIELDSENTRY_VALUE)) {
                            bArray.add(1, readMessage(fieldDescriptor, PredefinedTypes.TYPE_ANYDATA, input).bMessage);
                        } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_VALUE_LIST_VALUE)) {
                            bMessage = readMessage(fieldDescriptor,
                                    TypeCreator.createArrayType(PredefinedTypes.TYPE_ANYDATA), input).bMessage;
                        } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_LISTVALUE_VALUES)) {
                            bArray.add(bArray.size(), readMessage(fieldDescriptor,
                                    PredefinedTypes.TYPE_ANYDATA, input).bMessage);
                        } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_VALUE_STRUCT_VALUE)) {
                            bMessage = readMessage(fieldDescriptor,
                                    TypeCreator.createMapType(PredefinedTypes.TYPE_ANYDATA), input).bMessage;
                        } else {
                            Type fieldType = recordType.getFields().get(bFieldName.getValue()).getFieldType();
                            bMessage = readMessage(fieldDescriptor, fieldType, input).bMessage;
                        }
                        break;
                    }
                    default: {
                        throw Status.Code.INTERNAL.toStatus().withDescription("Error while decoding request message. " +
                                "Field type is not supported : " + fieldDescriptor.getType()).asRuntimeException();
                    }
                }
            }
        }

        if (isAnyTypedMessage) {
            BMap<BString, Object> anyMap = ValueCreator.createRecordValue(type.getPackage(), type.getName());
            anyMap.put(StringUtils.fromString(BALLERINA_TYPE_URL_ENTRY), StringUtils.fromString(typeUrl));
            anyMap.put(StringUtils.fromString(BALLERINA_ANY_VALUE_ENTRY), bMessage);
            bMessage = anyMap;
        }
        if (isTimestampMessage && bMessage instanceof BArray) {
            ((BArray) bMessage).freezeDirect();
        }
    }

    private void updateBBMap(BMap<BString, Object> bBMap,
                                 Descriptors.FieldDescriptor fieldDescriptor, Object bValue) {
        bBMap.put(StringUtils.fromString(fieldDescriptor.getName()), bValue);
    }

    public com.google.protobuf.Descriptors.Descriptor getDescriptor() {
        if (descriptor != null) {
            return descriptor;
        }
        return MessageRegistry.getInstance().getMessageDescriptor(messageName);
    }

    @SuppressWarnings("unchecked")
    void writeTo(com.google.protobuf.CodedOutputStream output)
            throws java.io.IOException {
        if (bMessage == null) {
            return;
        }
        Descriptors.Descriptor messageDescriptor = getDescriptor();
        if (messageDescriptor == null) {
            throw Status.Code.INTERNAL.toStatus()
                    .withDescription("Error while processing the message, Couldn't find message descriptor for " +
                            "message name: " + messageName)
                    .asRuntimeException();
        }

        BMap<BString, Object> bBMap = null;
        BArray bArray = null;
        if (bMessage instanceof BMap) {
            bBMap = (BMap<BString, Object>) bMessage;
        } else if (bMessage instanceof BArray) {
            bArray = (BArray) bMessage;
        }
        for (Descriptors.FieldDescriptor fieldDescriptor : messageDescriptor.getFields()) {
            BString bFieldName = StringUtils.fromString(fieldDescriptor.getName());
            switch (fieldDescriptor.getType().toProto().getNumber()) {
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_DOUBLE_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                output.writeDouble(fieldDescriptor.getNumber(), valueArray.getFloat(i));
                            }
                        } else {
                            output.writeDouble(fieldDescriptor.getNumber(), (Double) bValue);
                        }
                    } else if (bMessage instanceof Double) {
                        output.writeDouble(fieldDescriptor.getNumber(), (Double) bMessage);
                    } else if (bMessage instanceof Integer) {
                        output.writeDouble(fieldDescriptor.getNumber(), (Integer) bMessage);
                    } else if (bMessage instanceof Long) {
                        output.writeDouble(fieldDescriptor.getNumber(), (Long) bMessage);
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_FLOAT_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                output.writeFloat(fieldDescriptor.getNumber(), Float.parseFloat(String.valueOf
                                        (valueArray.getFloat(i))));
                            }
                        } else {
                            output.writeFloat(fieldDescriptor.getNumber(), Float.parseFloat(String.valueOf(bValue)));
                        }
                    } else if (bMessage instanceof Double) {
                        output.writeFloat(fieldDescriptor.getNumber(), Float.parseFloat(String.valueOf
                                (bMessage)));
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT64_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                output.writeInt64(fieldDescriptor.getNumber(), valueArray.getInt(i));
                            }
                        } else {
                            output.writeInt64(fieldDescriptor.getNumber(), (long) bValue);
                        }
                    } else if (bMessage instanceof BArray
                            && fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_TIMESTAMP_SECONDS)) {
                        output.writeInt64(fieldDescriptor.getNumber(), (long) (bArray.get(0)));
                    } else if (bMessage instanceof BDecimal
                            && fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_DURATION_SECONDS)) {
                        output.writeInt64(fieldDescriptor.getNumber(), ((BDecimal) bMessage).value().intValue());
                    } else if (bMessage instanceof Long) {
                        output.writeInt64(fieldDescriptor.getNumber(), (long) bMessage);
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_UINT64_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                output.writeUInt64(fieldDescriptor.getNumber(), valueArray.getInt(i));
                            }
                        } else {
                            output.writeUInt64(fieldDescriptor.getNumber(), (long) bValue);
                        }
                    } else if (bMessage instanceof Long) {
                        output.writeUInt64(fieldDescriptor.getNumber(), (long) bMessage);
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT32_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                output.writeInt32(fieldDescriptor.getNumber(),
                                                  getIntValue(valueArray.getInt(i)));
                            }
                        } else {
                            output.writeInt32(fieldDescriptor.getNumber(), getIntValue(bValue));
                        }
                    } else if (bMessage instanceof BArray
                            && fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_TIMESTAMP_NANOS)) {
                        BigDecimal nanos = new BigDecimal((bArray).get(1)
                                .toString()).multiply(ANALOG_GIGA);
                        output.writeInt32(fieldDescriptor.getNumber(), nanos.intValue());
                    } else if (bMessage instanceof BDecimal
                            && fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_DURATION_NANOS)) {
                        int intVal = ((BDecimal) bMessage).value().intValue();
                        BigDecimal b = ((BDecimal) bMessage).value().subtract(new BigDecimal(intVal));
                        output.writeInt32(fieldDescriptor.getNumber(), b.multiply(ANALOG_GIGA).intValue());
                    } else if (bMessage instanceof Long) {
                        output.writeInt32(fieldDescriptor.getNumber(), getIntValue(bMessage));
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED64_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                output.writeFixed64(fieldDescriptor.getNumber(), valueArray.getInt(i));
                            }
                        } else {
                            output.writeFixed64(fieldDescriptor.getNumber(), (long) bValue);
                        }
                    } else if (bMessage instanceof Long) {
                        output.writeFixed64(fieldDescriptor.getNumber(), (long) bMessage);
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED32_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                output.writeFixed32(fieldDescriptor.getNumber(),
                                                    getIntValue(valueArray.getInt(i)));
                            }
                        } else {
                            output.writeFixed32(fieldDescriptor.getNumber(), getIntValue(bValue));
                        }
                    } else if (bMessage instanceof Long) {
                        output.writeFixed32(fieldDescriptor.getNumber(), getIntValue(bMessage));
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_BOOL_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                output.writeBool(fieldDescriptor.getNumber(), valueArray.getBoolean(i));
                            }
                        } else {
                            output.writeBool(fieldDescriptor.getNumber(), ((boolean) bValue));
                        }
                    } else if (bMessage instanceof Boolean) {
                        output.writeBool(fieldDescriptor.getNumber(), (boolean) bMessage);
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_STRING_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                output.writeString(fieldDescriptor.getNumber(), valueArray.getBString(i).getValue());
                            }
                        } else {
                            output.writeString(fieldDescriptor.getNumber(), ((BString) bValue).getValue());
                        }
                    } else if (bArray != null &&
                            fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_STRUCT_FIELDSENTRY_KEY)) {
                        output.writeString(fieldDescriptor.getNumber(), ((BString) bArray.get(0)).getValue());
                    } else if (bMessage instanceof BString
                            && !fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_ANY_TYPE_URL)) {
                        output.writeString(fieldDescriptor.getNumber(), ((BString) bMessage).getValue());
                    } else if (GOOGLE_PROTOBUF_ANY_MESSAGE_NAME.equals(this.messageName)) {
                        output.writeString(fieldDescriptor.getNumber(), ((BMap) bMessage)
                                .getStringValue(StringUtils.fromString(BALLERINA_TYPE_URL_ENTRY)).getValue());
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_MESSAGE_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (fieldDescriptor.isRepeated() && bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                Object value = valueArray.getRefValue(i);
                                Message message = new Message(fieldDescriptor.getMessageType(), value);
                                output.writeTag(fieldDescriptor.getNumber(), WireFormat.WIRETYPE_LENGTH_DELIMITED);
                                output.writeUInt32NoTag(message.getSerializedSize());
                                message.writeTo(output);
                            }
                        } else {
                            Message message = new Message(fieldDescriptor.getMessageType(), bValue);
                            output.writeTag(fieldDescriptor.getNumber(), WireFormat.WIRETYPE_LENGTH_DELIMITED);
                            output.writeUInt32NoTag(message.getSerializedSize());
                            message.writeTo(output);
                        }
                    } else if (bBMap != null && fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_STRUCT_FIELDS)) {
                        for (Map.Entry<BString, Object> entry : bBMap.entrySet()) {
                            BArray valueArray = ValueCreator.createArrayValue(TypeCreator
                                    .createArrayType(PredefinedTypes.TYPE_ANY), 2);
                            valueArray.add(0, (Object) entry.getKey());
                            valueArray.add(1, entry.getValue());
                            Message message = new Message(fieldDescriptor.getMessageType(), valueArray);
                            output.writeTag(fieldDescriptor.getNumber(), WireFormat.WIRETYPE_LENGTH_DELIMITED);
                            output.writeUInt32NoTag(message.getSerializedSize());
                            message.writeTo(output);
                        }
                    } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_STRUCT_FIELDSENTRY_VALUE) &&
                            bArray != null) {
                        Message message = new Message(fieldDescriptor.getMessageType(), bArray.get(1));
                        output.writeTag(fieldDescriptor.getNumber(), WireFormat.WIRETYPE_LENGTH_DELIMITED);
                        output.writeUInt32NoTag(message.getSerializedSize());
                        message.writeTo(output);
                    } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_VALUE_LIST_VALUE) &&
                            bArray != null) {
                            Message message = new Message(fieldDescriptor.getMessageType(), bArray);
                            output.writeTag(fieldDescriptor.getNumber(), WireFormat.WIRETYPE_LENGTH_DELIMITED);
                            output.writeUInt32NoTag(message.getSerializedSize());
                            message.writeTo(output);
                    } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_VALUE_STRUCT_VALUE) &&
                            bBMap != null) {
                        Message message = new Message(fieldDescriptor.getMessageType(), bBMap);
                        output.writeTag(fieldDescriptor.getNumber(), WireFormat.WIRETYPE_LENGTH_DELIMITED);
                        output.writeUInt32NoTag(message.getSerializedSize());
                        message.writeTo(output);
                    } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_LISTVALUE_VALUES)) {
                        for (int i = 0; i < bArray.size(); i++) {
                            Message message = new Message(fieldDescriptor.getMessageType(), bArray.get(i));
                            output.writeTag(fieldDescriptor.getNumber(), WireFormat.WIRETYPE_LENGTH_DELIMITED);
                            output.writeUInt32NoTag(message.getSerializedSize());
                            message.writeTo(output);
                        }
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_ENUM_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        output.writeEnum(fieldDescriptor.getNumber(), fieldDescriptor.getEnumType()
                                .findValueByName(((BString) bValue).getValue()).getNumber());
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_BYTES_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray && !GOOGLE_PROTOBUF_ANY_MESSAGE_NAME.equals(this.messageName)) {
                            BArray valueArray = (BArray) bValue;
                            output.writeByteArray(fieldDescriptor.getNumber(), valueArray.getBytes());
                        } else if (GOOGLE_PROTOBUF_ANY_MESSAGE_NAME.equals(this.messageName)) {
                            String typeUrl = ((BMap<BString, Object>) this.bMessage).getStringValue(
                                    StringUtils.fromString(BALLERINA_TYPE_URL_ENTRY)).getValue();
                            String typeName = anyMessageTypeNameFromTypeUrl(typeUrl);
                            Descriptors.Descriptor descriptor = findFieldDescriptorFromTypeUrl(typeName);
                            Object value = ((BMap<BString, Object>) this.bMessage).get(
                                    StringUtils.fromString(BALLERINA_ANY_VALUE_ENTRY));
                            Message message = new Message(descriptor, value);
                            output.writeTag(fieldDescriptor.getNumber(), WireFormat.WIRETYPE_LENGTH_DELIMITED);
                            output.writeUInt32NoTag(message.getSerializedSize());
                            message.writeTo(output);
                        }
                    } else if (bMessage instanceof BArray) {
                        BArray valueArray = (BArray) bMessage;
                        output.writeByteArray(fieldDescriptor.getNumber(), valueArray.getBytes());
                    }
                    break;
                }
                default: {
                    throw Status.Code.INTERNAL.toStatus().withDescription("Error while writing output stream. " +
                            "Field type is not supported : " + fieldDescriptor.getType()).asRuntimeException();
                }
            }
        }
    }

    @SuppressWarnings("unchecked")
    public int getSerializedSize() {
        int size = memoizedSize;
        if (size != -1) {
            return size;
        }
        size = 0;
        if (bMessage == null) {
            memoizedSize = size;
            return size;
        }
        Descriptors.Descriptor messageDescriptor = getDescriptor();
        if (messageDescriptor == null) {
            throw Status.Code.INTERNAL.toStatus()
                    .withDescription("Error while processing the message, Couldn't find message descriptor for " +
                            "message name: " + messageName)
                    .asRuntimeException();
        }
        BMap<BString, Object> bBMap = null;
        if (bMessage instanceof BMap) {
            bBMap = (BMap<BString, Object>) bMessage;
        }

        for (Descriptors.FieldDescriptor fieldDescriptor : messageDescriptor.getFields()) {
            BString bFieldName = StringUtils.fromString(fieldDescriptor.getName());
            switch (fieldDescriptor.getType().toProto().getNumber()) {
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_DOUBLE_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                size += com.google.protobuf.CodedOutputStream.computeDoubleSize(
                                        fieldDescriptor.getNumber(), valueArray.getFloat(i));
                            }
                        } else {
                            size += com.google.protobuf.CodedOutputStream.computeDoubleSize(fieldDescriptor.getNumber(),
                                                                                            (double) bValue);
                        }
                    } else if (bMessage instanceof Integer) {
                        size += com.google.protobuf.CodedOutputStream.computeDoubleSize(fieldDescriptor.getNumber(),
                                (int) bMessage);
                    } else if (bMessage instanceof Long) {
                        size += com.google.protobuf.CodedOutputStream.computeDoubleSize(fieldDescriptor.getNumber(),
                                (long) bMessage);
                    } else if (bMessage instanceof Double) {
                        size += com.google.protobuf.CodedOutputStream.computeDoubleSize(fieldDescriptor.getNumber(),
                                ((double) bMessage));
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_FLOAT_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                size += com.google.protobuf.CodedOutputStream.computeFloatSize(
                                        fieldDescriptor.getNumber(),
                                        Float.parseFloat(String.valueOf(valueArray.getFloat(i))));
                            }
                        } else {
                            size += com.google.protobuf.CodedOutputStream.computeFloatSize(
                                    fieldDescriptor.getNumber(), Float.parseFloat(String.valueOf(bValue)));
                        }
                    } else if (bMessage instanceof Double) {
                        size += com.google.protobuf.CodedOutputStream.computeFloatSize(fieldDescriptor
                                .getNumber(), Float.parseFloat(String.valueOf(bMessage)));
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT64_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                size += com.google.protobuf.CodedOutputStream.computeInt64Size(
                                        fieldDescriptor.getNumber(), valueArray.getInt(i));
                            }
                        } else {
                            size += com.google.protobuf.CodedOutputStream.computeInt64Size(
                                    fieldDescriptor.getNumber(), (long) bValue);
                        }
                    } else if (bMessage instanceof Long) {
                        size += com.google.protobuf.CodedOutputStream.computeInt64Size(fieldDescriptor
                                .getNumber(), (long) bMessage);
                    } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_TIMESTAMP_SECONDS)
                            && bMessage instanceof BArray) {
                        BArray array = (BArray) bMessage;
                        size += com.google.protobuf.CodedOutputStream.computeInt64Size(fieldDescriptor
                                .getNumber(), array.getInt(0));
                    } else if (bMessage instanceof BDecimal
                            && fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_DURATION_SECONDS)) {
                        size += com.google.protobuf.CodedOutputStream.computeInt64Size(fieldDescriptor
                                .getNumber(), ((BDecimal) bMessage).value().intValue());
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_UINT64_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                size += com.google.protobuf.CodedOutputStream.computeUInt64Size(
                                        fieldDescriptor.getNumber(), valueArray.getInt(i));
                            }
                        } else {
                            size += com.google.protobuf.CodedOutputStream.computeUInt64Size(
                                    fieldDescriptor.getNumber(), (long) bValue);
                        }
                    } else if (bMessage instanceof Long) {
                        size += com.google.protobuf.CodedOutputStream.computeUInt64Size(fieldDescriptor
                                .getNumber(), (long) bMessage);
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT32_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                size += com.google.protobuf.CodedOutputStream.computeInt32Size(
                                        fieldDescriptor.getNumber(), getIntValue(valueArray.getInt(i)));
                            }
                        } else {
                            size += com.google.protobuf.CodedOutputStream.computeInt32Size(
                                    fieldDescriptor.getNumber(), getIntValue(bValue));
                        }
                    } else if (bMessage instanceof Long) {
                        size += com.google.protobuf.CodedOutputStream.computeInt32Size(fieldDescriptor
                                .getNumber(), getIntValue(bMessage));
                    } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_TIMESTAMP_NANOS)
                            && bMessage instanceof BArray) {
                        BArray array = (BArray) bMessage;
                        BigDecimal nanos = new BigDecimal(array.get(1)
                                .toString()).multiply(ANALOG_GIGA, MathContext.DECIMAL128);
                        size += com.google.protobuf.CodedOutputStream.computeInt32Size(fieldDescriptor
                                .getNumber(), nanos.intValue());
                    } else if (bMessage instanceof BDecimal
                            && fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_DURATION_NANOS)) {
                        int intVal = ((BDecimal) bMessage).value().intValue();
                        BigDecimal b = ((BDecimal) bMessage).value().subtract(new BigDecimal(intVal))
                                .multiply(ANALOG_GIGA, MathContext.DECIMAL128);
                        size += com.google.protobuf.CodedOutputStream.computeInt32Size(fieldDescriptor
                                .getNumber(), b.intValue());
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED64_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                size += com.google.protobuf.CodedOutputStream.computeFixed64Size(
                                        fieldDescriptor.getNumber(), valueArray.getInt(i));
                            }
                        } else {
                            size += com.google.protobuf.CodedOutputStream.computeFixed64Size(
                                    fieldDescriptor.getNumber(), (long) bValue);
                        }
                    } else if (bMessage instanceof Long) {
                        size += com.google.protobuf.CodedOutputStream.computeFixed64Size(fieldDescriptor
                                .getNumber(), (long) bMessage);
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED32_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                size += com.google.protobuf.CodedOutputStream.computeFixed32Size(
                                        fieldDescriptor.getNumber(), getIntValue(valueArray.getInt(i)));
                            }
                        } else {
                            size += com.google.protobuf.CodedOutputStream.computeFixed32Size(
                                    fieldDescriptor.getNumber(), getIntValue(bValue));
                        }
                    } else if (bMessage instanceof Long) {
                        size += com.google.protobuf.CodedOutputStream.computeFixed32Size(fieldDescriptor
                                .getNumber(), getIntValue(bMessage));
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_BOOL_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                size += com.google.protobuf.CodedOutputStream.computeBoolSize(
                                        fieldDescriptor.getNumber(), valueArray.getBoolean(i));
                            }
                        } else {
                            size += com.google.protobuf.CodedOutputStream.computeBoolSize(
                                    fieldDescriptor.getNumber(), (boolean) bValue);
                        }
                    } else if (bMessage instanceof Boolean) {
                        size += com.google.protobuf.CodedOutputStream.computeBoolSize(fieldDescriptor
                                .getNumber(), (boolean) bMessage);
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_STRING_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                size += CodedOutputStream.computeStringSize(fieldDescriptor.getNumber(), valueArray
                                        .getBString(i).getValue());
                            }
                        } else {
                            size += CodedOutputStream.computeStringSize(fieldDescriptor.getNumber(),
                                    ((BString) bValue).getValue());
                        }
                    } else if (bMessage instanceof BArray &&
                            fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_STRUCT_FIELDSENTRY_KEY)) {
                        size += CodedOutputStream.computeStringSize(fieldDescriptor.getNumber(),
                                ((BArray) bMessage).getBString(0).getValue());
                    } else if (bMessage instanceof BString) {
                        size += CodedOutputStream.computeStringSize(fieldDescriptor.getNumber(),
                                ((BString) bMessage).getValue());
                    } else if (GOOGLE_PROTOBUF_ANY_MESSAGE_NAME.equals(this.messageName)) {
                        size += CodedOutputStream.computeStringSize(fieldDescriptor.getNumber(), ((BMap) bMessage)
                                .getStringValue(StringUtils.fromString(BALLERINA_TYPE_URL_ENTRY)).getValue());
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_MESSAGE_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (fieldDescriptor.isRepeated() && bValue instanceof BArray) {
                            BArray valueArray = (BArray) bValue;
                            for (int i = 0; i < valueArray.size(); i++) {
                                Object value = valueArray.getRefValue(i);
                                Message message = new Message(fieldDescriptor.getMessageType(), value);
                                size += computeMessageSize(fieldDescriptor, message);
                            }
                        } else {
                            Message message = new Message(fieldDescriptor.getMessageType(), bValue);
                            size += computeMessageSize(fieldDescriptor, message);
                        }
                    } else if (bBMap != null && fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_STRUCT_FIELDS)) {
                        for (Map.Entry<BString, Object> entry : bBMap.entrySet()) {
                            BArray valueArray = ValueCreator.createArrayValue(TypeCreator
                                    .createArrayType(PredefinedTypes.TYPE_ANY), 2);
                            valueArray.add(0, (Object) entry.getKey());
                            valueArray.add(1, entry.getValue());
                            Message message = new Message(fieldDescriptor.getMessageType(), valueArray);
                            size += computeMessageSize(fieldDescriptor, message);
                        }
                    } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_STRUCT_FIELDSENTRY_VALUE)) {
                        Message message = new Message(fieldDescriptor.getMessageType(), ((BArray) bMessage).get(1));
                        size += computeMessageSize(fieldDescriptor, message);
                    } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_VALUE_LIST_VALUE) &&
                            bMessage instanceof BArray) {
                        Message message = new Message(fieldDescriptor.getMessageType(), bMessage);
                        size += computeMessageSize(fieldDescriptor, message);
                    } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_VALUE_STRUCT_VALUE) &&
                            bMessage instanceof BMap) {
                        Message message = new Message(fieldDescriptor.getMessageType(), bBMap);
                        size += computeMessageSize(fieldDescriptor, message);
                    } else if (fieldDescriptor.getFullName().equals(GOOGLE_PROTOBUF_LISTVALUE_VALUES) &&
                            bMessage instanceof BArray) {
                        BArray bArray = (BArray) bMessage;
                        for (int i = 0; i < bArray.size(); i++) {
                            Message message = new Message(fieldDescriptor.getMessageType(), bArray.get(i));
                            size += computeMessageSize(fieldDescriptor, message);
                        }
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_ENUM_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);

                        size += com.google.protobuf.CodedOutputStream.computeEnumSize(
                                fieldDescriptor.getNumber(),
                                fieldDescriptor.getEnumType().findValueByName(((BString) bValue).getValue())
                                        .getNumber());
                    }
                    break;
                }
                case DescriptorProtos.FieldDescriptorProto.Type.TYPE_BYTES_VALUE: {
                    if (bBMap != null && bBMap.containsKey(bFieldName)) {
                        Object bValue = bBMap.get(bFieldName);
                        if (bValue instanceof BArray && !GOOGLE_PROTOBUF_ANY_MESSAGE_NAME.equals(this.messageName)) {
                            BArray valueArray = (BArray) bValue;
                            size += com.google.protobuf.CodedOutputStream
                                    .computeByteArraySize(fieldDescriptor.getNumber(), valueArray.getBytes());
                        } else if (GOOGLE_PROTOBUF_ANY_MESSAGE_NAME.equals(this.messageName)) {
                            String typeUrl = ((BMap<BString, Object>) this.bMessage)
                                    .getStringValue(StringUtils.fromString(BALLERINA_TYPE_URL_ENTRY)).getValue();
                            String typeName = anyMessageTypeNameFromTypeUrl(typeUrl);
                            Descriptors.Descriptor descriptor = findFieldDescriptorFromTypeUrl(typeName);
                            Object value = ((BMap<BString, Object>) this.bMessage)
                                    .get(StringUtils.fromString(BALLERINA_ANY_VALUE_ENTRY));
                            Message message = new Message(descriptor, value);
                            size += computeMessageSize(fieldDescriptor, message);
                        }
                    } else if (bMessage instanceof BArray) {
                        BArray valueArray = (BArray) bMessage;
                        size += com.google.protobuf.CodedOutputStream
                                .computeByteArraySize(fieldDescriptor.getNumber(), valueArray.getBytes());
                    }
                    break;
                }
                default:
                    throw Status.Code.INTERNAL.toStatus().withDescription(
                            "Error while calculating the serialized type. Field type is not supported : "
                                    + fieldDescriptor.getType()).asRuntimeException();

            }
        }
        memoizedSize = size;
        return size;
    }

    private int computeMessageSize(Descriptors.FieldDescriptor fieldDescriptor, Message message) {
        return CodedOutputStream.computeTagSize(fieldDescriptor
                .getNumber()) + CodedOutputStream.computeUInt32SizeNoTag
                (message.getSerializedSize()) + message.getSerializedSize();
    }

    private String anyMessageTypeNameFromTypeUrl(String typeUrl) {

        String[] types = typeUrl.split("/");
        return types[types.length - 1].trim();
    }

    private Map<Integer, Descriptors.FieldDescriptor> findFieldDescriptorsMapFromTypeUrl(String typeName, Type type) {

        Descriptors.Descriptor descriptor = findFieldDescriptorFromTypeUrl(typeName);
        MessageParser messageParser = new MessageParser(typeName, type, descriptor);
        return messageParser.getFieldDescriptors();
    }

    private Descriptors.Descriptor findFieldDescriptorFromTypeUrl(String typeName) {

        if (typeName.startsWith("google.protobuf")) {
            return findGoogleDescriptorFromName(typeName);
        } else {
            return MessageRegistry.getInstance().getFileDescriptor().findMessageTypeByName(typeName);
        }
    }

    private Descriptors.Descriptor findGoogleDescriptorFromName(String typeName) {

        String messageName = typeName.replace("google.protobuf.", "");
        switch (typeName) {
            case WRAPPER_DOUBLE_TYPE_NAME:
            case WRAPPER_FLOAT_TYPE_NAME:
            case WRAPPER_INT64_TYPE_NAME:
            case WRAPPER_UINT64_TYPE_NAME:
            case WRAPPER_INT32_TYPE_NAME:
            case WRAPPER_UINT32_TYPE_NAME:
            case WRAPPER_BOOL_TYPE_NAME:
            case WRAPPER_STRING_TYPE_NAME:
            case WRAPPER_BYTES_TYPE_NAME: {
                return WrappersProto.getDescriptor().findMessageTypeByName(messageName);
            }
            case ANY_TYPE_NAME: {
                return AnyProto.getDescriptor().findMessageTypeByName(messageName);
            }
            case EMPTY_TYPE_NAME: {
                return EmptyProto.getDescriptor().findMessageTypeByName(messageName);
            }
            case TIMESTAMP_TYPE_NAME: {
                return TimestampProto.getDescriptor().findMessageTypeByName(messageName);
            }
            case DURATION_TYPE_NAME: {
                return DurationProto.getDescriptor().findMessageTypeByName(messageName);
            }
            case STRUCT_TYPE_NAME: {
                return StructProto.getDescriptor().findMessageTypeByName(messageName);
            }
            default: {
                return null;
            }
        }
    }

    public void skipUnnecessaryAnyTypeTags(com.google.protobuf.CodedInputStream input) throws IOException {

        try {
            input.readTag();
            input.readTag();
        } catch (InvalidProtocolBufferException e) {
            input.getLastTag();
        }
    }

    public byte[] toByteArray() {
        try {
            final byte[] result = new byte[getSerializedSize()];
            final CodedOutputStream output = CodedOutputStream.newInstance(result);
            writeTo(output);
            output.checkNoSpaceLeft();
            return result;
        } catch (IOException e) {
            throw new RuntimeException("Serializing " + messageName + " to a byte array threw an IOException" +
                    " (should never happen).", e);
        }
    }


    private Message readMessage(final Descriptors.FieldDescriptor fieldDescriptor, final Type type,
                                final CodedInputStream in) throws IOException {
        int length = in.readRawVarint32();
        final int oldLimit = in.pushLimit(length);
        Message result = new MessageParser(fieldDescriptor.getMessageType(), type).parseFrom(in);
        in.popLimit(oldLimit);
        return result;
    }

    private int getIntValue(Object value) {
        if (value instanceof Long) {
            return ((Long) value).intValue();
        }
        return (int) value;
    }

    @Override
    public String toString() {
        StringBuilder payload = new StringBuilder("Message : ");
        if (bMessage != null) {
            payload.append("{ ").append(StringUtils.getJsonString(bMessage)).append(" }");
        } else {
            payload.append("null");
        }
        return payload.toString();
    }
}
