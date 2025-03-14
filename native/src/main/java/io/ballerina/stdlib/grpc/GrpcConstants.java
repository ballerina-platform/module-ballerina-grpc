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

import com.google.protobuf.DescriptorProtos;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BString;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import static io.ballerina.runtime.api.constants.RuntimeConstants.ORG_NAME_SEPARATOR;
import static io.ballerina.stdlib.grpc.nativeimpl.ModuleUtils.getModule;

/**
 * Proto Message Constants Class.
 *
 * @since 1.0.0
 */
public class GrpcConstants {
    //gRPC package name.
    public static final String PROTOCOL_PACKAGE_GRPC = "grpc";
    public static final String PROTOCOL_PACKAGE_VERSION_GRPC = getModule().getMajorVersion();
    public static final String ORG_NAME = "ballerina";
    public static final String PROTOCOL_STRUCT_PACKAGE_GRPC = ORG_NAME + ORG_NAME_SEPARATOR +
            "grpc:" + PROTOCOL_PACKAGE_VERSION_GRPC;
    public static final String PROTOCOL_STRUCT_PACKAGE_PROTOBUF = ORG_NAME + ORG_NAME_SEPARATOR +
            "protobuf:" + PROTOCOL_PACKAGE_VERSION_GRPC;

    public static final String HTTPS_ENDPOINT_STARTED = "[ballerina/grpc] started HTTPS/WSS listener ";
    public static final String HTTP_ENDPOINT_STARTED = "[ballerina/grpc] started HTTP/WS listener ";
    public static final String HTTPS_ENDPOINT_STOPPED = "[ballerina/grpc] stopped HTTPS/WSS listener ";
    public static final String HTTP_ENDPOINT_STOPPED = "[ballerina/grpc] stopped HTTP/WS listener ";

    //server side endpoint constants.
    public static final String SERVICE_REGISTRY_BUILDER = "SERVICE_REGISTRY_BUILDER";
    public static final String SERVER_CONNECTOR = "SERVER_CONNECTOR";
    public static final String CONNECTOR_STARTED = "CONNECTOR_STARTED";
    public static final String CALLER = "Caller";
    public static final String RESPONSE_OBSERVER = "RESPONSE_OBSERVER";
    public static final String RESPONSE_MESSAGE_DEFINITION = "RESPONSE_DEFINITION";
    public static final BString CALLER_ID = StringUtils.fromString("instanceId");
    public static final String MESSAGE_QUEUE = "messageQueue";
    public static final String COMPLETED_MESSAGE = "completedMessage";
    public static final String ERROR_MESSAGE = "errorMessage";
    public static final String ITERATOR_OBJECT_NAME = "StreamIterator";
    public static final String ITERATOR_OBJECT_ENTRY = "streamIterator";

    // Service Descriptor Annotation
    public static final String ROOT_DESCRIPTOR = "ROOT_DESCRIPTOR";
    public static final String ANN_SERVICE_DESCRIPTOR = "ServiceDescriptor";
    public static final BString ANN_SERVICE_DESCRIPTOR_FQN = StringUtils.fromString(PROTOCOL_STRUCT_PACKAGE_GRPC +
            ":" + ANN_SERVICE_DESCRIPTOR);
    public static final String ANN_DESCRIPTOR = "Descriptor";
    public static final BString ANN_DESCRIPTOR_FQN = StringUtils.fromString(PROTOCOL_STRUCT_PACKAGE_GRPC + ":" +
            ANN_DESCRIPTOR);
    public static final BString ANN_PROTOBUF_DESCRIPTOR = StringUtils.fromString(PROTOCOL_STRUCT_PACKAGE_PROTOBUF +
            ":" + ANN_DESCRIPTOR);

    //client side endpoint constants
    public static final String CLIENT_ENDPOINT_RESPONSE_OBSERVER = "ResponseObserver";
    public static final String CLIENT_CONNECTOR = "ClientConnector";
    public static final String ENDPOINT_URL = "url";
    public static final String RECEIVE_ENTRY = "receive";
    public static final String CONTEXT_ENTRY = "context";

    public static final String SERVICE_STUB = "Stub";
    public static final String METHOD_DESCRIPTORS = "MethodDescriptors";
    public static final String REQUEST_SENDER = "REQUEST_SENDER";
    public static final String REQUEST_MESSAGE_DEFINITION = "REQUEST_DEFINITION";
    public static final String REGEX_DOT_SEPERATOR = "\\.";
    public static final String DOT = ".";

    public static final String STREAMING_CLIENT = "StreamingClient";
    public static final String HEADERS = "Headers";

    public static final String MAX_INBOUND_MESSAGE_SIZE = "maxInboundMessageSize";
    
    public static final Map<DescriptorProtos.FieldDescriptorProto.Type, Integer> WIRE_TYPE_MAP;

    static {
        Map<DescriptorProtos.FieldDescriptorProto.Type, Integer> wireMap = new HashMap<>();
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_DOUBLE, 1);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_FLOAT, 5);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT32, 0);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_INT64, 0);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_UINT32, 0);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_UINT64, 0);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_SINT32, 0);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_SINT64, 0);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED32, 5);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_FIXED64, 1);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_SFIXED32, 5);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_SFIXED64, 1);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_BOOL, 0);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_ENUM, 0);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_STRING, 2);
        wireMap.put(DescriptorProtos.FieldDescriptorProto.Type.TYPE_BYTES, 2);
        WIRE_TYPE_MAP = Collections.unmodifiableMap(wireMap);
    }

    // proto wrapper message constants
    public static final String WRAPPER_DOUBLE_MESSAGE = "DoubleValue";
    public static final String WRAPPER_FLOAT_MESSAGE = "FloatValue";
    public static final String WRAPPER_INT64_MESSAGE = "Int64Value";
    public static final String WRAPPER_UINT64_MESSAGE = "UInt64Value";
    public static final String WRAPPER_INT32_MESSAGE = "Int32Value";
    public static final String WRAPPER_UINT32_MESSAGE = "UInt32Value";
    public static final String WRAPPER_BOOL_MESSAGE = "BoolValue";
    public static final String WRAPPER_STRING_MESSAGE = "StringValue";
    public static final String WRAPPER_BYTES_MESSAGE = "BytesValue";
    public static final String TIMESTAMP_MESSAGE = "Timestamp";
    public static final String DURATION_MESSAGE = "Duration";
    public static final String STRUCT_MESSAGE = "Struct";
    public static final String ANY_MESSAGE = "Any";
    public static final String IS_BIDI_STREAMING = "isBidiStreaming";
    public static final String IS_STREAM_CANCELLED = "isStreamCancelled";

    // proto predefined messages paths
    public static final String WRAPPER_DOUBLE_TYPE_NAME = "google.protobuf.DoubleValue";
    public static final String WRAPPER_FLOAT_TYPE_NAME = "google.protobuf.FloatValue";
    public static final String WRAPPER_INT64_TYPE_NAME = "google.protobuf.Int64Value";
    public static final String WRAPPER_UINT64_TYPE_NAME = "google.protobuf.UInt64Value";
    public static final String WRAPPER_INT32_TYPE_NAME = "google.protobuf.Int32Value";
    public static final String WRAPPER_UINT32_TYPE_NAME = "google.protobuf.UInt32Value";
    public static final String WRAPPER_BOOL_TYPE_NAME = "google.protobuf.BoolValue";
    public static final String WRAPPER_STRING_TYPE_NAME = "google.protobuf.StringValue";
    public static final String WRAPPER_BYTES_TYPE_NAME = "google.protobuf.BytesValue";
    public static final String ANY_TYPE_NAME = "google.protobuf.Any";
    public static final String EMPTY_TYPE_NAME = "google.protobuf.Empty";
    public static final String TIMESTAMP_TYPE_NAME = "google.protobuf.Timestamp";
    public static final String DURATION_TYPE_NAME = "google.protobuf.Duration";
    public static final String STRUCT_TYPE_NAME = "google.protobuf.Struct";

    // Server Streaming method resources.
    public static final String ON_MESSAGE_RESOURCE = "onMessage";

    //stub template builder constants
    public static final String EMPTY_DATATYPE_NAME = "Empty";

    //Header keys
    static final String GRPC_STATUS_KEY = "grpc-status";
    static final String GRPC_MESSAGE_KEY = "grpc-message";
    static final String CONTENT_TYPE_KEY = "content-type";
    static final String TE_KEY = "te";
    static final String TO_HEADER = "TO";
    public static final String SCHEME_HEADER = "scheme";
    public static final String AUTHORITY = "authority";
    public static final String AUTHORIZATION = "authorization";

    //Content-Type used for GRPC-over-HTTP/2.
    public static final String CONTENT_TYPE_GRPC = "application/grpc";

    //The HTTP method used for GRPC requests.
    public static final String HTTP_METHOD = "POST";


    //The TE (transport encoding) header for requests over HTTP/2.
    public static final String TE_TRAILERS = "trailers";

    //The message encoding (i.e. compression) that can be used in the stream.
    static final String MESSAGE_ENCODING = "grpc-encoding";

    //The accepted message encodings (i.e. compression) that can be used in the stream.
    static final String MESSAGE_ACCEPT_ENCODING = "grpc-accept-encoding";

    //The content-encoding used to compress the full gRPC stream.
    static final String CONTENT_ENCODING = "content-encoding";

    private GrpcConstants() {
    }

    // Error codes
    public static final String CANCELLED_ERROR = "CancelledError";
    public static final String UNKNOWN_ERROR = "UnKnownError";
    public static final String INVALID_ARGUMENT_ERROR = "InvalidArgumentError";
    public static final String DEADLINE_EXCEEDED_ERROR = "DeadlineExceededError";
    public static final String NOT_FOUND_ERROR = "NotFoundError";
    public static final String ALREADY_EXISTS_ERROR = "AlreadyExistsError";
    public static final String PERMISSION_DENIED_ERROR = "PermissionDeniedError";
    public static final String RESOURCE_EXHAUSTED_ERROR = "ResourceExhaustedError";
    public static final String FAILED_PRECONDITION_ERROR = "FailedPreconditionError";
    public static final String ABORTED_ERROR = "AbortedError";
    public static final String OUT_OF_RANGE_ERROR = "OutOfRangeError";
    public static final String UNIMPLEMENTED_ERROR = "UnimplementedError";
    public static final String INTERNAL_ERROR = "InternalError";
    public static final String UNAVAILABLE_ERROR = "UnavailableError";
    public static final String DATA_LOSS_ERROR = "DataLossError";
    public static final String UNAUTHENTICATED_ERROR = "UnauthenticatedError";
    public static final String INTERNAL_UNAUTHENTICATED_ERROR = "InternalUnauthenticatedError";
    public static final String INTERNAL_PERMISSION_DENIED_ERROR = "InternalPermissionDeniedError";

    public static final Map<Integer, String> STATUS_ERROR_MAP;

    static {
        STATUS_ERROR_MAP = Map.ofEntries(Map.entry(Status.Code.CANCELLED.value(), CANCELLED_ERROR),
                Map.entry(Status.Code.UNKNOWN.value(), UNKNOWN_ERROR),
                Map.entry(Status.Code.INVALID_ARGUMENT.value(), INVALID_ARGUMENT_ERROR),
                Map.entry(Status.Code.DEADLINE_EXCEEDED.value(), DEADLINE_EXCEEDED_ERROR),
                Map.entry(Status.Code.NOT_FOUND.value(), NOT_FOUND_ERROR),
                Map.entry(Status.Code.ALREADY_EXISTS.value(), ALREADY_EXISTS_ERROR),
                Map.entry(Status.Code.PERMISSION_DENIED.value(), PERMISSION_DENIED_ERROR),
                Map.entry(Status.Code.RESOURCE_EXHAUSTED.value(), RESOURCE_EXHAUSTED_ERROR),
                Map.entry(Status.Code.FAILED_PRECONDITION.value(), FAILED_PRECONDITION_ERROR),
                Map.entry(Status.Code.ABORTED.value(), ABORTED_ERROR),
                Map.entry(Status.Code.OUT_OF_RANGE.value(), OUT_OF_RANGE_ERROR),
                Map.entry(Status.Code.UNIMPLEMENTED.value(), UNIMPLEMENTED_ERROR),
                Map.entry(Status.Code.INTERNAL.value(), INTERNAL_ERROR),
                Map.entry(Status.Code.UNAVAILABLE.value(), UNAVAILABLE_ERROR),
                Map.entry(Status.Code.DATA_LOSS.value(), DATA_LOSS_ERROR),
                Map.entry(Status.Code.UNAUTHENTICATED.value(), UNAUTHENTICATED_ERROR));
    }

    public static <T, E> T getKeyByValue(Map<T, E> map, E value) {
        for (Map.Entry<T, E> entry : map.entrySet()) {
            if (Objects.equals(value, entry.getValue())) {
                return entry.getKey();
            }
        }
        return null;
    }

    //Observability tag keys
    public static final String TAG_KEY_GRPC_ERROR_MESSAGE = "grpc.error_message";

    public static final BString ENDPOINT_CONFIG_SECURESOCKET = StringUtils.fromString("secureSocket");
    public static final BString SECURESOCKET_CONFIG_DISABLE_SSL = StringUtils.fromString("enable");
    public static final BString SECURESOCKET_CONFIG_CERT = StringUtils.fromString("cert");
    public static final BString SECURESOCKET_CONFIG_TRUSTSTORE_FILE_PATH = StringUtils.fromString("path");
    public static final BString SECURESOCKET_CONFIG_TRUSTSTORE_PASSWORD = StringUtils.fromString("password");
    public static final BString SECURESOCKET_CONFIG_KEY = StringUtils.fromString("key");
    public static final BString SECURESOCKET_CONFIG_CERTKEY_CERT_FILE = StringUtils.fromString("certFile");
    public static final BString SECURESOCKET_CONFIG_CERTKEY_KEY_FILE = StringUtils.fromString("keyFile");
    public static final BString SECURESOCKET_CONFIG_CERTKEY_KEY_PASSWORD = StringUtils.fromString("keyPassword");
    public static final BString SECURESOCKET_CONFIG_KEYSTORE_FILE_PATH = StringUtils.fromString("path");
    public static final BString SECURESOCKET_CONFIG_KEYSTORE_PASSWORD = StringUtils.fromString("password");
    public static final BString SECURESOCKET_CONFIG_PROTOCOL = StringUtils.fromString("protocol");
    public static final BString SECURESOCKET_CONFIG_PROTOCOL_NAME = StringUtils.fromString("name");
    public static final BString SECURESOCKET_CONFIG_PROTOCOL_VERSIONS = StringUtils.fromString("versions");
    public static final BString SECURESOCKET_CONFIG_CERT_VALIDATION = StringUtils.fromString("certValidation");
    public static final BString SECURESOCKET_CONFIG_CERT_VALIDATION_TYPE = StringUtils.fromString("type");
    public static final BString SECURESOCKET_CONFIG_CERT_VALIDATION_CACHE_SIZE = StringUtils.fromString("cacheSize");
    public static final BString SECURESOCKET_CONFIG_CERT_VALIDATION_CACHE_VALIDITY_PERIOD =
            StringUtils.fromString("cacheValidityPeriod");
    public static final BString SECURESOCKET_CONFIG_CIPHERS = StringUtils.fromString("ciphers");
    public static final BString SECURESOCKET_CONFIG_HOST_NAME_VERIFICATION_ENABLED =
            StringUtils.fromString("verifyHostName");
    public static final BString SECURESOCKET_CONFIG_SHARE_SESSION = StringUtils.fromString("shareSession");
    public static final BString SECURESOCKET_CONFIG_HANDSHAKE_TIMEOUT = StringUtils.fromString("handshakeTimeout");
    public static final BString SECURESOCKET_CONFIG_SESSION_TIMEOUT = StringUtils.fromString("sessionTimeout");
    public static final BString SECURESOCKET_CONFIG_MUTUAL_SSL = StringUtils.fromString("mutualSsl");
    public static final BString SECURESOCKET_CONFIG_VERIFY_CLIENT = StringUtils.fromString("verifyClient");

    public static final BString SECURESOCKET_CONFIG_CERT_VALIDATION_TYPE_OCSP_STAPLING =
            StringUtils.fromString("OCSP_STAPLING");

    //context message field name constants
    public static final String CONTENT_FIELD = "content";
    public static final String HEADER_FIELD = "headers";

    public static final String STREAMING_NEXT_FUNCTION = "next";

    public static final BString CONFIG = StringUtils.fromString("config");
}
