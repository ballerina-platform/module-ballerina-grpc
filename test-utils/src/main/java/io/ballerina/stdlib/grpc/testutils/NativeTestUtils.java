/*
 * Copyright (c) 2023 WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.grpc.testutils;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.stdlib.grpc.GrpcConstants;
import io.ballerina.stdlib.grpc.MessageUtils;
import io.ballerina.stdlib.grpc.MethodDescriptor;
import io.ballerina.stdlib.grpc.Status;
import io.ballerina.stdlib.grpc.exception.StatusRuntimeException;
import io.ballerina.stdlib.grpc.nativeimpl.client.FunctionUtils;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.TimeUnit;

import static io.ballerina.stdlib.grpc.GrpcConstants.METHOD_DESCRIPTORS;
import static io.ballerina.stdlib.grpc.GrpcConstants.SERVICE_STUB;
import static io.ballerina.stdlib.grpc.MessageUtils.getConnectorError;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.closeStream;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.externRegister;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.nextResult;

/**
 * Utility methods to test the native functions of client endpoint.
 *
 */
public final class NativeTestUtils {

    private NativeTestUtils() {}

    public static Object externInvokeInitStubNullRootDescriptor(BObject clientEndpoint) {
        return FunctionUtils.externInitStub(clientEndpoint, null, null, null);
    }

    public static Object externInvokeExecuteSimpleRPCNullClientEndpoint() {
        return FunctionUtils.externExecuteSimpleRPC(null, null, null, null, null);
    }

    public static Object externInvokeExecuteSimpleRPCNullConnectionStub(BObject clientEndpoint) {
        return FunctionUtils.externExecuteSimpleRPC(null, clientEndpoint, null, null, null);
    }

    public static Object externInvokeExecuteSimpleRPCNullMethodName(BObject clientEndpoint) {
        clientEndpoint.addNativeData(SERVICE_STUB, new Object());
        return FunctionUtils.externExecuteSimpleRPC(null, clientEndpoint, null, null, null);
    }

    public static Object externInvokeExecuteSimpleRPCNullDescriptor(BObject clientEndpoint) {
        clientEndpoint.addNativeData(SERVICE_STUB, new Object());
        return FunctionUtils.externExecuteSimpleRPC(null, clientEndpoint, StringUtils.fromString("test"), null, null);
    }

    public static Object externInvokeExecuteServerStreamingNullClientEndpoint() {
        return FunctionUtils.externExecuteServerStreaming(null, null, null, null, null);
    }

    public static Object externInvokeExecuteServerStreamingNullConnectionStub(BObject clientEndpoint) {
        return FunctionUtils.externExecuteServerStreaming(null, clientEndpoint, null, null, null);
    }

    public static Object externInvokeExecuteServerStreamingNullMethodName(BObject clientEndpoint) {
        clientEndpoint.addNativeData(SERVICE_STUB, new Object());
        return FunctionUtils.externExecuteServerStreaming(null, clientEndpoint, null, null, null);
    }

    public static Object externInvokeExecuteServerStreamingNullDescriptor(BObject clientEndpoint) {
        clientEndpoint.addNativeData(SERVICE_STUB, new Object());
        return FunctionUtils.externExecuteServerStreaming(null, clientEndpoint,
                StringUtils.fromString("test"), null, null);
    }

    public static Object externInvokeExecuteServerStreamingNullMethodDescriptor(BObject clientEndpoint) {
        clientEndpoint.addNativeData(SERVICE_STUB, new Object());
        clientEndpoint.addNativeData(METHOD_DESCRIPTORS, new HashMap<String, MethodDescriptor>());
        return FunctionUtils.externExecuteServerStreaming(null, clientEndpoint,
                StringUtils.fromString("test"), null, null);
    }

    public static Object externInvokeExecuteClientStreamingNullClientEndpoint() {
        return FunctionUtils.externExecuteClientStreaming(null, null, null, null);
    }

    public static Object externInvokeExecuteClientStreamingNullConnectionStub(BObject clientEndpoint) {
        return FunctionUtils.externExecuteClientStreaming(null, clientEndpoint, null, null);
    }

    public static Object externInvokeExecuteClientStreamingNullMethodName(BObject clientEndpoint) {
        clientEndpoint.addNativeData(SERVICE_STUB, new Object());
        return FunctionUtils.externExecuteClientStreaming(null, clientEndpoint, null, null);
    }

    public static Object externInvokeExecuteClientStreamingNullDescriptor(BObject clientEndpoint) {
        clientEndpoint.addNativeData(SERVICE_STUB, new Object());
        return FunctionUtils.externExecuteClientStreaming(null, clientEndpoint,
                StringUtils.fromString("test"), null);
    }

    public static Object externInvokeExecuteClientStreamingNullMethodDescriptor(BObject clientEndpoint) {
        clientEndpoint.addNativeData(SERVICE_STUB, new Object());
        clientEndpoint.addNativeData(METHOD_DESCRIPTORS, new HashMap<String, MethodDescriptor>());
        return FunctionUtils.externExecuteClientStreaming(null, clientEndpoint,
                StringUtils.fromString("test"), null);
    }

    public static Object externInvokeExecuteBidirectionalStreamingNullClientEndpoint() {
        return FunctionUtils.externExecuteBidirectionalStreaming(null, null, null, null);
    }

    public static Object externInvokeExecuteBidirectionalStreamingNullConnectionStub(BObject clientEndpoint) {
        return FunctionUtils.externExecuteBidirectionalStreaming(null, clientEndpoint, null, null);
    }

    public static Object externInvokeExecuteBidirectionalStreamingNullMethodName(BObject clientEndpoint) {
        clientEndpoint.addNativeData(SERVICE_STUB, new Object());
        return FunctionUtils.externExecuteBidirectionalStreaming(null, clientEndpoint, null, null);
    }

    public static Object externInvokeExecuteBidirectionalStreamingNullDescriptor(BObject clientEndpoint) {
        clientEndpoint.addNativeData(SERVICE_STUB, new Object());
        return FunctionUtils.externExecuteBidirectionalStreaming(null, clientEndpoint,
                StringUtils.fromString("test"), null);
    }

    public static Object externInvokeExecuteBidirectionalStreamingNullMethodDescriptor(BObject clientEndpoint) {
        clientEndpoint.addNativeData(SERVICE_STUB, new Object());
        clientEndpoint.addNativeData(METHOD_DESCRIPTORS, new HashMap<String, MethodDescriptor>());
        return FunctionUtils.externExecuteBidirectionalStreaming(null, clientEndpoint,
                StringUtils.fromString("test"), null);
    }

    public static Object externInvokeCloseStreamErrorCase(BObject clientEndpoint, BObject streamIterator) {
        BlockingQueue<String> messageQueue = new ArrayBlockingQueue(1);
        Object errorVal = MessageUtils.getConnectorError(new Exception("This is a test error"));
        streamIterator.addNativeData(GrpcConstants.MESSAGE_QUEUE, messageQueue);
        streamIterator.addNativeData(GrpcConstants.CLIENT_ENDPOINT_RESPONSE_OBSERVER, clientEndpoint);
        streamIterator.addNativeData(GrpcConstants.ERROR_MESSAGE, errorVal);
        return closeStream(null, streamIterator);
    }

    public static Object externInvokeCloseStreamInvalidErrorCase(Environment env, BObject clientEndpoint,
                                                                 BObject streamIterator, BObject errorVal) {
        BlockingQueue<String> messageQueue = new ArrayBlockingQueue(1);
        streamIterator.addNativeData(GrpcConstants.MESSAGE_QUEUE, messageQueue);
        streamIterator.addNativeData(GrpcConstants.CLIENT_ENDPOINT_RESPONSE_OBSERVER, clientEndpoint);
        streamIterator.addNativeData(GrpcConstants.ERROR_MESSAGE, errorVal);
        return closeStream(env, streamIterator);
    }

    public static Object externInvokeGetConnectorError() {
        Throwable throwable = new RuntimeException();
        BError error1 = getConnectorError(throwable);

        Status status = Status.fromCode(Status.Code.INVALID_ARGUMENT);
        throwable = new StatusRuntimeException(status);
        StatusRuntimeException sre = (StatusRuntimeException) throwable;
        BError error2 = getConnectorError(sre);

        status = status.withCause(new RuntimeException("Test runtime exception"));
        throwable = new StatusRuntimeException(status);
        sre = (StatusRuntimeException) throwable;
        BError error3 = getConnectorError(sre);

        return  error1.getMessage().equals("Unknown error occurred") &&
                error2.getMessage().equals("Unknown error occurred") &&
                error3.getMessage().equals(status.getCause().getMessage());
    }

    public static Object externInvokeCompleteErrorCase(Environment env, BObject clientEndpoint) {
        return io.ballerina.stdlib.grpc.nativeimpl.caller.FunctionUtils.externComplete(env, clientEndpoint);
    }

    public static Object externInvokeSendErrorCase(Environment env, BObject clientEndpoint) {
        return io.ballerina.stdlib.grpc.nativeimpl.caller.FunctionUtils.externSend(env, clientEndpoint, null);
    }

    public static Object externInvokeSendErrorErrorCase(Environment env, BObject clientEndpoint) {
        return io.ballerina.stdlib.grpc.nativeimpl.caller.FunctionUtils.externSendError(env, clientEndpoint, null);
    }

    public static Object externInvokeRegisterErrorCase(BObject serviceEndpoint) {
        return externRegister(null, serviceEndpoint, null, null);
    }

    public static Object externInvokeNextResultErrorCase(BObject streamIterator) {
        BlockingQueue b = new BlockingQueue() {
            @Override
            public boolean add(Object o) {
                return false;
            }
            @Override
            public boolean offer(Object o) {
                return false;
            }
            @Override
            public void put(Object o) throws InterruptedException {}
            @Override
            public boolean offer(Object o, long timeout, TimeUnit unit) throws InterruptedException {
                return false;
            }
            @Override
            public Object take() throws InterruptedException {
                throw new InterruptedException("Interrupting for test");
            }
            @Override
            public Object poll(long timeout, TimeUnit unit) throws InterruptedException {
                return null;
            }
            @Override
            public int remainingCapacity() {
                return 0;
            }
            @Override
            public boolean remove(Object o) {
                return false;
            }
            @Override
            public boolean contains(Object o) {
                return false;
            }
            @Override
            public int drainTo(Collection c) {
                return 0;
            }
            @Override
            public int drainTo(Collection c, int maxElements) {
                return 0;
            }
            @Override
            public Object remove() {
                return null;
            }
            @Override
            public Object poll() {
                return null;
            }
            @Override
            public Object element() {
                return null;
            }
            @Override
            public Object peek() {
                return null;
            }
            @Override
            public int size() {
                return 0;
            }
            @Override
            public boolean isEmpty() {
                return false;
            }
            @Override
            public Iterator iterator() {
                return null;
            }
            @Override
            public Object[] toArray() {
                return new Object[0];
            }
            @Override
            public Object[] toArray(Object[] a) {
                return new Object[0];
            }
            @Override
            public boolean containsAll(Collection c) {
                return false;
            }
            @Override
            public boolean addAll(Collection c) {
                return false;
            }
            @Override
            public boolean removeAll(Collection c) {
                return false;
            }
            @Override
            public boolean retainAll(Collection c) {
                return false;
            }
            @Override
            public void clear() {}
        };
        streamIterator.addNativeData(GrpcConstants.MESSAGE_QUEUE, b);
        try {
            nextResult(streamIterator);
        } catch (Exception e) {
            return e;
        }
        return null;
    }

    public static Object externInvokeStreamCompleteCase(BObject streamConnection) {
        return io.ballerina.stdlib.grpc.nativeimpl.streamingclient.FunctionUtils.streamComplete(streamConnection);
    }

    public static Object externInvokeStreamSendErrorCase(BObject streamConnection) {
        return io.ballerina.stdlib.grpc.nativeimpl.streamingclient.FunctionUtils.streamSend(streamConnection, null);
    }

    public static Object externInvokeStreamSendErrorErrorCase(BObject streamConnection) {
        return io.ballerina.stdlib.grpc.nativeimpl.streamingclient
                .FunctionUtils.streamSendError(null, streamConnection, null);
    }
}
