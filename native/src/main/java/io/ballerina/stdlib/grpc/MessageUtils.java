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
import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.TypeTags;
import io.ballerina.runtime.api.creators.ErrorCreator;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.ArrayType;
import io.ballerina.runtime.api.types.MethodType;
import io.ballerina.runtime.api.types.RecordType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.stdlib.grpc.exception.StatusRuntimeException;
import io.ballerina.stdlib.http.transport.message.HttpCarbonMessage;
import io.netty.handler.codec.http.DefaultHttpHeaders;
import io.netty.handler.codec.http.DefaultHttpRequest;
import io.netty.handler.codec.http.DefaultHttpResponse;
import io.netty.handler.codec.http.HttpContent;
import io.netty.handler.codec.http.HttpHeaders;
import io.netty.handler.codec.http.HttpMethod;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.netty.handler.codec.http.HttpVersion;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.Locale;

import static io.ballerina.runtime.api.utils.StringUtils.fromString;
import static io.ballerina.runtime.api.utils.StringUtils.fromStringArray;
import static io.ballerina.runtime.api.utils.TypeUtils.getReferredType;
import static io.ballerina.stdlib.grpc.GrpcConstants.CONTENT_FIELD;
import static io.ballerina.stdlib.grpc.GrpcConstants.HEADER_FIELD;
import static io.ballerina.stdlib.grpc.GrpcUtil.getTypeName;
import static io.ballerina.stdlib.grpc.ServicesBuilderUtils.getParameterTypesFromParameters;
import static io.ballerina.stdlib.grpc.Status.Code.UNKNOWN;
import static io.ballerina.stdlib.grpc.nativeimpl.ModuleUtils.getModule;

/**
 * Util methods to generate protobuf message.
 *
 * @since 1.0.0
 */
public class MessageUtils {

    private static final String UNKNOWN_ERROR_DETAIL = "Unknown error occurred";

    /** maximum buffer to be read is 16 KB. */
    private static final int MAX_BUFFER_LENGTH = 16384;
    private static final String GOOGLE_PROTOBUF_EMPTY = "google.protobuf.Empty";

    // Invalid wire type.
    private static final int INVALID_WIRE_TYPE = -1;
    // Embedded messages, packed repeated fields wire type.
    private static final int MESSAGE_WIRE_TYPE = 2;

    private static final Type HEADER_MAP_TYPE =
                TypeCreator.createMapType(TypeCreator.createUnionType(Arrays.asList(PredefinedTypes.TYPE_STRING,
                        TypeCreator.createArrayType(PredefinedTypes.TYPE_STRING))));

    static boolean headersRequired(MethodType functionType, Type rpcInputType) {
        if (functionType == null || functionType.getParameters() == null) {
            throw new RuntimeException("Invalid resource input arguments");
        }
        boolean headersRequired = false;
        for (Type paramType : getParameterTypesFromParameters(functionType.getParameters())) {
            if (paramType != null && getContextTypeName(rpcInputType).equals(paramType.getName())) {
                headersRequired = true;
                break;
            }
            if (paramType != null && getContextStreamTypeName(rpcInputType).equals(paramType.getName())) {
                headersRequired = true;
                break;
            }
        }
        return headersRequired;
    }

    public static long copy(InputStream from, OutputStream to) throws IOException {
        byte[] buf = new byte[MAX_BUFFER_LENGTH];
        long total = 0;
        while (true) {
            int r = from.read(buf);
            if (r == -1) {
                break;
            }
            to.write(buf, 0, r);
            total += r;
        }
        return total;
    }

    public static StreamObserver getResponseObserver(BObject refType) {
        if (refType instanceof StreamObserver) {
            return ((StreamObserver) refType);
        }
        Object observerObject = refType.getNativeData(GrpcConstants.RESPONSE_OBSERVER);
        if (observerObject instanceof StreamObserver) {
            return ((StreamObserver) observerObject);
        }
        return null;
    }
    
    /**
     * Returns error struct of input type
     * Error type is generic ballerina error type. This utility method is used inside Observer onError
     * method to construct error struct from message.
     *
     * @param error     this is StatusRuntimeException send by opposite party.
     * @return error value.
     */
    public static BError getConnectorError(Throwable error) {
        String errorIdName;
        String message;
        if (error instanceof StatusRuntimeException) {
            StatusRuntimeException statusException = (StatusRuntimeException) error;
            errorIdName = statusException.getStatus().getReason();
            String errorDescription = statusException.getStatus().getDescription();
            if (errorDescription != null) {
                message =  statusException.getStatus().getDescription();
            } else if (statusException.getStatus().getCause() != null) {
                String causeMessage = statusException.getStatus().getCause().getMessage();
                message = causeMessage == null ? UNKNOWN_ERROR_DETAIL : causeMessage;
            } else {
                message = UNKNOWN_ERROR_DETAIL;
            }
        } else {
            if (error.getMessage() == null) {
                errorIdName = GrpcConstants.UNKNOWN_ERROR;
                message = UNKNOWN_ERROR_DETAIL;
            } else {
                errorIdName = GrpcConstants.INTERNAL_ERROR;
                message = error.getMessage();
            }
        }
        return ErrorCreator.createError(getModule(), errorIdName, fromString(message), null, null);
    }
    
    /**
     * Returns wire type corresponding to the field descriptor type.
     * <p>
     * 0 -> int32, int64, uint32, uint64, sint32, sint64, bool, enum
     * 1 -> fixed64, sfixed64, double
     * 2 -> string, bytes, embedded messages, packed repeated fields
     * 5 -> fixed32, sfixed32, float
     *
     * @param fieldType field descriptor type
     * @return wire type
     */
    static int getFieldWireType(Descriptors.FieldDescriptor.Type fieldType) {
        if (fieldType == null) {
            return INVALID_WIRE_TYPE;
        }
        Integer wireType = GrpcConstants.WIRE_TYPE_MAP.get(fieldType.toProto());
        if (wireType != null) {
            return wireType;
        } else {
            // Returns embedded messages, packed repeated fields message type, if field type doesn't map with the
            // predefined proto types.
            return MESSAGE_WIRE_TYPE;
        }
    }

    static void setNestedMessages(Descriptors.Descriptor resMessage, MessageRegistry messageRegistry) {
        for (Descriptors.Descriptor nestedType : resMessage.getNestedTypes()) {
            messageRegistry.addMessageDescriptor(nestedType.getFullName(), nestedType);
        }
        for (Descriptors.FieldDescriptor msgField : resMessage.getFields()) {
            if (Descriptors.FieldDescriptor.Type.MESSAGE.equals(msgField.getType())) {
                Descriptors.Descriptor msgType = msgField.getMessageType();
                messageRegistry.addMessageDescriptor(msgType.getFullName(), msgType);
            }
        }
    }

    /**
     * Util method to get method type.
     *
     * @param methodDescriptorProto method descriptor proto.
     * @return service method type.
     */
    public static MethodDescriptor.MethodType getMethodType(DescriptorProtos.MethodDescriptorProto
                                                                    methodDescriptorProto) {
        if (methodDescriptorProto.getClientStreaming() && methodDescriptorProto.getServerStreaming()) {
            return MethodDescriptor.MethodType.BIDI_STREAMING;
        } else if (!(methodDescriptorProto.getClientStreaming() || methodDescriptorProto.getServerStreaming())) {
            return MethodDescriptor.MethodType.UNARY;
        } else if (methodDescriptorProto.getServerStreaming()) {
            return MethodDescriptor.MethodType.SERVER_STREAMING;
        } else {
            return MethodDescriptor.MethodType.CLIENT_STREAMING;
        }
    }
    
    /**
     * Checks whether method has response message.
     *
     * @param messageDescriptor Message Descriptor
     * @return true if method response is empty, false otherwise
     */
    public static boolean isEmptyResponse(Descriptors.Descriptor messageDescriptor) {
        if (messageDescriptor == null) {
            return false;
        }
        return GOOGLE_PROTOBUF_EMPTY.equals(messageDescriptor.getFullName());
    }

    /** Closes an InputStream, ignoring IOExceptions. */
    static void closeQuietly(InputStream message) {
        try {
            message.close();
        } catch (IOException ignore) {
            // do nothing
        }
    }

    /**
     * Indicates whether or not the given value is a valid gRPC content-type.
     *
     * <p>
     * Referenced from grpc-java implementation.
     *
     * @param contentType gRPC content type
     * @return is valid content type
     */
    static boolean isGrpcContentType(String contentType) {
        if (contentType == null) {
            return false;
        }
        if (GrpcConstants.CONTENT_TYPE_GRPC.length() > contentType.length()) {
            return false;
        }
        contentType = contentType.toLowerCase(Locale.ENGLISH);
        if (!contentType.startsWith(GrpcConstants.CONTENT_TYPE_GRPC)) {
            return false;
        }
        if (contentType.length() == GrpcConstants.CONTENT_TYPE_GRPC.length()) {
            // The strings match exactly.
            return true;
        }
        // The contentType matches, but is longer than the expected string.
        // We need to support variations on the content-type (e.g. +proto, +json) as defined by the gRPC wire spec.
        char nextChar = contentType.charAt(GrpcConstants.CONTENT_TYPE_GRPC.length());
        return nextChar == '+' || nextChar == ';';
    }

    public static HttpCarbonMessage createHttpCarbonMessage(boolean isRequest) {
        HttpCarbonMessage httpCarbonMessage;
        if (isRequest) {
            httpCarbonMessage = new HttpCarbonMessage(
                    new DefaultHttpRequest(HttpVersion.HTTP_1_1, HttpMethod.GET, ""));
        } else {
            httpCarbonMessage = new HttpCarbonMessage(
                    new DefaultHttpResponse(HttpVersion.HTTP_1_1, HttpResponseStatus.OK));
        }
        return httpCarbonMessage;
    }

    static Status httpStatusToGrpcStatus(int httpStatusCode) {
        return httpStatusToGrpcCode(httpStatusCode).toStatus()
                .withDescription("HTTP status code " + httpStatusCode);
    }

    private static Status.Code httpStatusToGrpcCode(int httpStatusCode) {
        if (httpStatusCode >= 100 && httpStatusCode < 200) {
            // 1xx. These headers should have been ignored.
            return Status.Code.INTERNAL;
        }
        switch (httpStatusCode) {
            case HttpURLConnection.HTTP_BAD_REQUEST:  // 400
            case 431:
                return Status.Code.INTERNAL;
            case HttpURLConnection.HTTP_UNAUTHORIZED:  // 401
                return Status.Code.UNAUTHENTICATED;
            case HttpURLConnection.HTTP_FORBIDDEN:  // 403
                return Status.Code.PERMISSION_DENIED;
            case HttpURLConnection.HTTP_NOT_FOUND:  // 404
                return Status.Code.UNIMPLEMENTED;
            case 429:
            case HttpURLConnection.HTTP_BAD_GATEWAY:  // 502
            case HttpURLConnection.HTTP_UNAVAILABLE:  // 503
            case HttpURLConnection.HTTP_GATEWAY_TIMEOUT:  // 504
                return Status.Code.UNAVAILABLE;
            default:
                return UNKNOWN;
        }
    }

    static int statusCodeToHttpCode(Status.Code code) {
        switch (code) {
            case CANCELLED:
                return 499; // Client Closed Request
            case INVALID_ARGUMENT:
            case FAILED_PRECONDITION:
            case OUT_OF_RANGE:
                return 400; // Bad Request
            case DEADLINE_EXCEEDED:
                return 504; // Gateway timeout
            case NOT_FOUND:
                return 404; // Not Found
            case ALREADY_EXISTS:
            case ABORTED:
                return 409; // Conflicts
            case PERMISSION_DENIED:
                return 403; // Forbidden
            case UNAUTHENTICATED:
                return 401; // Unauthorized
            case UNIMPLEMENTED:
                return 501; // Not Implemented
            case UNAVAILABLE:
                return 503; // Service Unavailable
            default:
                return 500; // Internal Server Error
        }
    }

    /**
     * Return Mapping Http Status code to gRPC status code.
     * @see <a href="https://github.com/grpc/grpc/blob/master/doc/statuscodes.md">gRPC status code</a>
     *
     * @param code gRPC Status code
     * @return Http status code
     */
    public static int getMappingHttpStatusCode(int code) {
        switch(code) {
            case 0:
                return HttpResponseStatus.OK.code();
            case 1:
                // The operation was cancelled
                return 499;
            case 3:
            case 9:
            case 11:
                return HttpResponseStatus.BAD_REQUEST.code();
            case 4:
                return HttpResponseStatus.GATEWAY_TIMEOUT.code();
            case 5:
                return HttpResponseStatus.NOT_FOUND.code();
            case 6:
            case 10:
                return HttpResponseStatus.CONFLICT.code();
            case 7:
                return HttpResponseStatus.FORBIDDEN.code();
            case 8:
                return HttpResponseStatus.TOO_MANY_REQUESTS.code();
            case 12:
                return HttpResponseStatus.NOT_IMPLEMENTED.code();
            case 14:
                return HttpResponseStatus.SERVICE_UNAVAILABLE.code();
            case 15:
                return HttpResponseStatus.INTERNAL_SERVER_ERROR.code();
            case 16:
                return HttpResponseStatus.UNAUTHORIZED.code();
            case 2:
            case 13:
            default:
                return HttpResponseStatus.INTERNAL_SERVER_ERROR.code();
        }
    }

    /**
     * Reads an entire {@link HttpContent} to a new array. After calling this method, the buffer
     * will contain no readable bytes.
     */
    private static byte[] readArray(HttpContent httpContent) {
        if (httpContent == null || httpContent.content() == null) {
            throw new RuntimeException("Http content is null");
        }
        int length = httpContent.content().readableBytes();
        byte[] bytes = new byte[length];
        httpContent.content().readBytes(bytes, 0, length);
        return bytes;
    }

    /**
     * Reads the entire {@link HttpContent} to a new {@link String} with the given charset.
     */
    static String readAsString(HttpContent httpContent, Charset charset) {
        if (charset == null) {
            throw new RuntimeException("Charset cannot be null");
        }
        byte[] bytes = readArray(httpContent);
        return new String(bytes, charset);
    }


    /**
     * Extract the response status from trailers.
     *
     * @param trailers Trailer headers in last http content.
     * @return Message status.
     */
    static Status statusFromTrailers(HttpHeaders trailers) {
        String statusString = trailers.get(GrpcConstants.GRPC_STATUS_KEY);
        Status status = null;
        if (statusString != null) {
            status = Status.CODE_MARSHALLER.parseAsciiString(statusString.getBytes(Charset.forName("US-ASCII")));
        }
        if (status != null) {
            return status.withDescription(trailers.get(GrpcConstants.GRPC_MESSAGE_KEY));
        } else {
            return Status.Code.UNKNOWN.toStatus().withDescription("missing GRPC status in response");
        }
    }

    /**
     * Returns Custom Caller Type name using service name and return type.
     *
     * @param serviceName Service name defined in the contract.
     * @param returnType output type.
     * @return Caller type name.
     */
    public static String getCallerTypeName(String serviceName, String returnType) {
        if (returnType != null) {
            if (returnType.equals("time:Utc")) {
                returnType = "Timestamp";
            }
            if (returnType.equals("time:Seconds")) {
                returnType = "Duration";
            }
            if (returnType.equals("map<anydata>")) {
                returnType = "Struct";
            }
            if (returnType.equals("'any:Any")) {
                returnType = "Any";
            }
            returnType = returnType.replaceAll("[^a-zA-Z0-9]", "");
            return serviceName.substring(0, 1).toUpperCase() + serviceName.substring(1) +
                    returnType.substring(0, 1).toUpperCase() + returnType.substring(1) +
                    "Caller";
        } else {
            return serviceName.substring(0, 1).toUpperCase() + serviceName.substring(1) + "NilCaller";
        }
    }

    public static String getContextTypeName(Type inputType) {
        inputType = inputType instanceof ArrayType ?
                getReferredType(((ArrayType) inputType).getElementType()) : inputType;
        String sInputType = inputType != PredefinedTypes.TYPE_NULL ? getTypeName(inputType) : null;
        if (sInputType != null) {
            sInputType = sInputType.replaceAll("[^a-zA-Z0-9]", "");
            return "Context" + sInputType.substring(0, 1).toUpperCase() + sInputType.substring(1);
        } else {
            return "ContextNil";
        }
    }

    public static String getContextStreamTypeName(Type inputType) {
        inputType = inputType instanceof ArrayType ?
                getReferredType(((ArrayType) inputType).getElementType()) : inputType;
        String sInputType = inputType != PredefinedTypes.TYPE_NULL ? getTypeName(inputType) : null;
        if (sInputType != null) {
            sInputType = sInputType.replaceAll("[^a-zA-Z0-9]", "");
            return "Context" + sInputType.substring(0, 1).toUpperCase() + sInputType.substring(1) + "Stream";
        } else {
            return "ContextNil";
        }
    }


    public static boolean isContextRecordByValue(Object value) {
        return value instanceof BMap && ((BMap) value).getType().getName().startsWith("Context")
                && ((BMap) value).size() == 2;
    }

    public static boolean isRecordMapValue(Object value) {
        return value instanceof BMap && ((BMap) value).getType().getTag() == TypeTags.RECORD_TYPE_TAG;
    }

    public static boolean isContextRecordByType(Type type) {
        return type instanceof RecordType && type.getName().startsWith("Context")
                && ((RecordType) type).getFields().size() == 2 && ((RecordType) type).getFields().containsKey(
                CONTENT_FIELD) && ((RecordType) type).getFields().containsKey(HEADER_FIELD);
    }

    /**
     * Returns Ballerina Header Map using HttpHeaders instance.
     *
     * @param httpHeaders Header instance at transport level.
     * @return Ballerina Header Map.
     */
    public static BMap createHeaderMap(HttpHeaders httpHeaders) {

        BMap headerMap = ValueCreator.createMapValue(HEADER_MAP_TYPE);
        for (String key : httpHeaders.names()) {
            String[] values = Arrays.stream(httpHeaders.getAll(key).toArray(new String[0]))
                    .distinct().toArray(String[]::new);
            if (values.length == 1) {
                headerMap.put(fromString(key.toLowerCase(Locale.getDefault())), fromString(values[0]));
            } else {
                headerMap.put(fromString(key.toLowerCase(Locale.getDefault())), fromStringArray(values));
            }
        }
        return headerMap;
    }

    /**
     * Returns HttpHeaders instance using Ballerina Header Map.
     * @param headerValues Ballerina Header Map instance.
     * @return HttpHeader instance.
     */
    public static HttpHeaders convertToHttpHeaders(BMap headerValues) {
        HttpHeaders headers = new DefaultHttpHeaders();
        if (headerValues != null) {
            for (Object key : headerValues.getKeys()) {
                Object headerValue = headerValues.get(key);
                if (headerValue instanceof BString) {
                    headers.set(key.toString(), headerValue.toString());
                } else if (headerValue instanceof BArray) {
                    for (String value : ((BArray) headerValue).getStringArray()) {
                        headers.add(key.toString(), value);
                    }
                }
            }
        }
        return headers;
    }

    private MessageUtils() {
    }
}
