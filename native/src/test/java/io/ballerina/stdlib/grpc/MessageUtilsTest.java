/*
 *  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import io.ballerina.runtime.api.values.BError;
import io.ballerina.stdlib.grpc.exception.StatusRuntimeException;
import io.ballerina.stdlib.http.transport.message.HttpCarbonMessage;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.ByteBufAllocator;
import io.netty.buffer.ByteBufUtil;
import io.netty.handler.codec.http.DefaultHttpContent;
import io.netty.handler.codec.http.DefaultHttpHeaders;
import io.netty.handler.codec.http.HttpContent;
import io.netty.handler.codec.http.HttpHeaders;
import org.testng.annotations.Test;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

import static io.ballerina.stdlib.grpc.GrpcConstants.GRPC_MESSAGE_KEY;
import static io.ballerina.stdlib.grpc.GrpcConstants.GRPC_STATUS_KEY;
import static io.ballerina.stdlib.grpc.MessageUtils.copy;
import static io.ballerina.stdlib.grpc.MessageUtils.createHttpCarbonMessage;
import static io.ballerina.stdlib.grpc.MessageUtils.getConnectorError;
import static io.ballerina.stdlib.grpc.MessageUtils.getFieldWireType;
import static io.ballerina.stdlib.grpc.MessageUtils.getMappingHttpStatusCode;
import static io.ballerina.stdlib.grpc.MessageUtils.getResponseObserver;
import static io.ballerina.stdlib.grpc.MessageUtils.headersRequired;
import static io.ballerina.stdlib.grpc.MessageUtils.httpStatusToGrpcStatus;
import static io.ballerina.stdlib.grpc.MessageUtils.isEmptyResponse;
import static io.ballerina.stdlib.grpc.MessageUtils.isGrpcContentType;
import static io.ballerina.stdlib.grpc.MessageUtils.readAsString;
import static io.ballerina.stdlib.grpc.MessageUtils.statusCodeToHttpCode;
import static io.ballerina.stdlib.grpc.MessageUtils.statusFromTrailers;
import static io.ballerina.stdlib.grpc.util.TestUtils.getBObject;
import static io.netty.handler.codec.http.HttpResponseStatus.BAD_REQUEST;
import static io.netty.handler.codec.http.HttpResponseStatus.CONFLICT;
import static io.netty.handler.codec.http.HttpResponseStatus.FORBIDDEN;
import static io.netty.handler.codec.http.HttpResponseStatus.GATEWAY_TIMEOUT;
import static io.netty.handler.codec.http.HttpResponseStatus.INTERNAL_SERVER_ERROR;
import static io.netty.handler.codec.http.HttpResponseStatus.NOT_FOUND;
import static io.netty.handler.codec.http.HttpResponseStatus.NOT_IMPLEMENTED;
import static io.netty.handler.codec.http.HttpResponseStatus.OK;
import static io.netty.handler.codec.http.HttpResponseStatus.SERVICE_UNAVAILABLE;
import static io.netty.handler.codec.http.HttpResponseStatus.TOO_MANY_REQUESTS;
import static io.netty.handler.codec.http.HttpResponseStatus.UNAUTHORIZED;
import static java.net.HttpURLConnection.HTTP_BAD_GATEWAY;
import static java.net.HttpURLConnection.HTTP_BAD_REQUEST;
import static java.net.HttpURLConnection.HTTP_FORBIDDEN;
import static java.net.HttpURLConnection.HTTP_GATEWAY_TIMEOUT;
import static java.net.HttpURLConnection.HTTP_NOT_FOUND;
import static java.net.HttpURLConnection.HTTP_UNAUTHORIZED;
import static java.net.HttpURLConnection.HTTP_UNAVAILABLE;
import static org.testng.Assert.assertEquals;
import static org.testng.Assert.assertFalse;
import static org.testng.Assert.assertTrue;
import static org.testng.Assert.fail;

/**
 * A test class to test MessageUtils class functions.
 */
public class MessageUtilsTest {

    @Test()
    public void testHeadersRequiredNegative() {
        try {
            headersRequired(null, null);
            fail("");
        } catch (RuntimeException e) {
            assertEquals(e.getMessage(), "Invalid resource input arguments");
        }
    }

    @Test()
    public void testCopy() {
        String s = "Test gRPC native";
        InputStream is = new ByteArrayInputStream(s.getBytes(StandardCharsets.UTF_8));
        OutputStream os = new ByteArrayOutputStream();
        try {
            long result = copy(is, os);
            assertEquals(result, s.length());
        } catch (IOException e) {
            fail(e.getMessage());
        }
    }

    @Test()
    public void testGetResponseObserverNegative() {
        StreamObserver result = getResponseObserver(getBObject(null));
        assertEquals(result, null);
    }

    @Test()
    public void testGetConnectorError() {
        Throwable throwable = new RuntimeException();
        BError error = getConnectorError(throwable);
        assertEquals(error.getMessage(), "Unknown error occurred");

        Status status = Status.fromCode(Status.Code.INVALID_ARGUMENT);
        throwable = new StatusRuntimeException(status);
        StatusRuntimeException sre = (StatusRuntimeException) throwable;
        error = getConnectorError(sre);
        assertEquals(error.getMessage(), "Unknown error occurred");

        status = status.withCause(new RuntimeException("Test runtime exception"));
        throwable = new StatusRuntimeException(status);
        sre = (StatusRuntimeException) throwable;
        error = getConnectorError(sre);
        assertEquals(error.getMessage(), status.getCause().getMessage());
    }

    @Test()
    public void testGetFieldWireTypeNegative() {
        int result = getFieldWireType(null);
        assertEquals(result, -1);
    }

    @Test()
    public void testIsEmptyResponseNegative() {
        boolean result = isEmptyResponse(null);
        assertFalse(result);
    }

    @Test()
    public void testIsGrpcContentTypeNegative() {
        boolean result = isGrpcContentType(null);
        assertFalse(result);

        result = isGrpcContentType("application/xml");
        assertFalse(result);

        result = isGrpcContentType("application/x-www-form-urlencoded");
        assertFalse(result);

        result = isGrpcContentType("application/grpc+json");
        assertTrue(result);

        result = isGrpcContentType("application/grpc;");
        assertTrue(result);
    }

    @Test()
    public void testCreateHttpCarbonMessage() {
        HttpCarbonMessage result = createHttpCarbonMessage(false);
        assertEquals(result.getNettyHttpResponse().status().code(), OK.code());
    }

    @Test()
    public void testHttpStatusToGrpcStatus() {
        Status status = httpStatusToGrpcStatus(101);
        assertEquals(status.getCode(), Status.Code.INTERNAL);

        status = httpStatusToGrpcStatus(HTTP_BAD_REQUEST);
        assertEquals(status.getCode(), Status.Code.INTERNAL);

        status = httpStatusToGrpcStatus(431);
        assertEquals(status.getCode(), Status.Code.INTERNAL);

        status = httpStatusToGrpcStatus(HTTP_UNAUTHORIZED);
        assertEquals(status.getCode(), Status.Code.UNAUTHENTICATED);

        status = httpStatusToGrpcStatus(HTTP_FORBIDDEN);
        assertEquals(status.getCode(), Status.Code.PERMISSION_DENIED);

        status = httpStatusToGrpcStatus(HTTP_NOT_FOUND);
        assertEquals(status.getCode(), Status.Code.UNIMPLEMENTED);

        status = httpStatusToGrpcStatus(429);
        assertEquals(status.getCode(), Status.Code.UNAVAILABLE);

        status = httpStatusToGrpcStatus(HTTP_BAD_GATEWAY);
        assertEquals(status.getCode(), Status.Code.UNAVAILABLE);

        status = httpStatusToGrpcStatus(HTTP_UNAVAILABLE);
        assertEquals(status.getCode(), Status.Code.UNAVAILABLE);

        status = httpStatusToGrpcStatus(HTTP_GATEWAY_TIMEOUT);
        assertEquals(status.getCode(), Status.Code.UNAVAILABLE);

        status = httpStatusToGrpcStatus(600);
        assertEquals(status.getCode(), Status.Code.UNKNOWN);
    }

    @Test()
    public void testStatusCodeToHttpCode() {
        int result = statusCodeToHttpCode(Status.Code.CANCELLED);
        assertEquals(result, 499);

        result = statusCodeToHttpCode(Status.Code.INVALID_ARGUMENT);
        assertEquals(result, 400);

        result = statusCodeToHttpCode(Status.Code.FAILED_PRECONDITION);
        assertEquals(result, 400);

        result = statusCodeToHttpCode(Status.Code.OUT_OF_RANGE);
        assertEquals(result, 400);

        result = statusCodeToHttpCode(Status.Code.DEADLINE_EXCEEDED);
        assertEquals(result, 504);

        result = statusCodeToHttpCode(Status.Code.NOT_FOUND);
        assertEquals(result, 404);

        result = statusCodeToHttpCode(Status.Code.ALREADY_EXISTS);
        assertEquals(result, 409);

        result = statusCodeToHttpCode(Status.Code.ABORTED);
        assertEquals(result, 409);

        result = statusCodeToHttpCode(Status.Code.PERMISSION_DENIED);
        assertEquals(result, 403);

        result = statusCodeToHttpCode(Status.Code.UNAUTHENTICATED);
        assertEquals(result, 401);

        result = statusCodeToHttpCode(Status.Code.UNIMPLEMENTED);
        assertEquals(result, 501);

        result = statusCodeToHttpCode(Status.Code.UNAVAILABLE);
        assertEquals(result, 503);

        result = statusCodeToHttpCode(Status.Code.UNKNOWN);
        assertEquals(result, 500);
    }

    @Test()
    public void testGetMappingHttpStatusCode() {
        int result = getMappingHttpStatusCode(0);
        assertEquals(result, OK.code());

        result = getMappingHttpStatusCode(1);
        assertEquals(result, 499);

        result = getMappingHttpStatusCode(3);
        assertEquals(result, BAD_REQUEST.code());

        result = getMappingHttpStatusCode(9);
        assertEquals(result, BAD_REQUEST.code());

        result = getMappingHttpStatusCode(11);
        assertEquals(result, BAD_REQUEST.code());

        result = getMappingHttpStatusCode(4);
        assertEquals(result, GATEWAY_TIMEOUT.code());

        result = getMappingHttpStatusCode(5);
        assertEquals(result, NOT_FOUND.code());

        result = getMappingHttpStatusCode(6);
        assertEquals(result, CONFLICT.code());

        result = getMappingHttpStatusCode(10);
        assertEquals(result, CONFLICT.code());

        result = getMappingHttpStatusCode(7);
        assertEquals(result, FORBIDDEN.code());

        result = getMappingHttpStatusCode(8);
        assertEquals(result, TOO_MANY_REQUESTS.code());

        result = getMappingHttpStatusCode(12);
        assertEquals(result, NOT_IMPLEMENTED.code());

        result = getMappingHttpStatusCode(14);
        assertEquals(result, SERVICE_UNAVAILABLE.code());

        result = getMappingHttpStatusCode(15);
        assertEquals(result, INTERNAL_SERVER_ERROR.code());

        result = getMappingHttpStatusCode(16);
        assertEquals(result, UNAUTHORIZED.code());

        result = getMappingHttpStatusCode(2);
        assertEquals(result, INTERNAL_SERVER_ERROR.code());

        result = getMappingHttpStatusCode(13);
        assertEquals(result, INTERNAL_SERVER_ERROR.code());
    }

    @Test()
    public void testReadAsString() {
        CharSequence charSequence = "Test char sequence";
        ByteBuf byteBuf = ByteBufUtil.writeUtf8(ByteBufAllocator.DEFAULT, charSequence);
        HttpContent httpContent = new DefaultHttpContent(byteBuf);
        try {
            String result = readAsString(httpContent, Charset.defaultCharset());
            assertEquals(result, charSequence.toString());
        } catch (RuntimeException e) {
            fail(e.getMessage());
        }
    }

    @Test()
    public void testReadAsStringNegative() {
        try {
            readAsString(null, null);
            fail();
        } catch (RuntimeException e) {
            assertEquals(e.getMessage(), "Charset cannot be null");
        }

        try {
            readAsString(null, Charset.defaultCharset());
            fail();
        } catch (RuntimeException e) {
            assertEquals(e.getMessage(), "Http content is null");
        }
    }

    @Test()
    public void testStatusFromTrailers() {
        String grpcMessageHeader = "Test Message";

        HttpHeaders headers = new DefaultHttpHeaders();
        headers.add(GRPC_STATUS_KEY, "Test Status");
        headers.add(GRPC_MESSAGE_KEY, grpcMessageHeader);
        Status status = statusFromTrailers(headers);
        assertEquals(status.getDescription(), grpcMessageHeader);
    }

    @Test()
    public void testStatusFromTrailersNegative() {
        HttpHeaders headers = new DefaultHttpHeaders();
        Status status = statusFromTrailers(headers);
        assertEquals(status.getDescription(), "missing GRPC status in response");
    }
}
