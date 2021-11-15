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

package io.ballerina.stdlib.grpc.listener;

import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.ObjectType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BStream;
import io.ballerina.runtime.observability.ObservabilityConstants;
import io.ballerina.runtime.observability.ObserveUtils;
import io.ballerina.runtime.observability.ObserverContext;
import io.ballerina.stdlib.grpc.GrpcConstants;
import io.ballerina.stdlib.grpc.Message;
import io.ballerina.stdlib.grpc.MessageUtils;
import io.ballerina.stdlib.grpc.ServerCall;
import io.ballerina.stdlib.grpc.ServiceResource;
import io.ballerina.stdlib.grpc.StreamObserver;
import io.ballerina.stdlib.grpc.callback.StreamingCallableUnitCallBack;
import io.ballerina.stdlib.grpc.exception.GrpcServerException;
import io.netty.handler.codec.http.HttpHeaders;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

import static io.ballerina.stdlib.grpc.GrpcConstants.AUTHORIZATION;
import static io.ballerina.stdlib.grpc.nativeimpl.ModuleUtils.getModule;

/**
 * Interface to initiate processing of incoming remote calls for streaming services.
 * This is used in client and bidirectional streaming services.
 * @since 0.980.0
 */
public class StreamingServerCallHandler extends ServerCallHandler {

    private final ServiceResource resource;
    private final Type inputType;

    public StreamingServerCallHandler(Descriptors.MethodDescriptor methodDescriptor, ServiceResource resource,
                                      Type inputType) throws GrpcServerException {

        super(methodDescriptor);
        if (resource == null) {
            String serviceType = "Client streaming";
            if (methodDescriptor.isServerStreaming() && methodDescriptor.isClientStreaming()) {
                serviceType = "Bidirectional streaming";
            }
            throw new GrpcServerException(serviceType + " remote function '" + methodDescriptor.getFullName() +
                    "' does not exist.");
        }
        this.resource = resource;
        this.inputType = inputType;
    }

    @Override
    public Listener startCall(ServerCall call) {
        ServerCallStreamObserver responseObserver = new ServerCallStreamObserver(call);
        StreamObserver requestObserver = invoke(responseObserver, call);
        return new StreamingServerCallHandler.StreamingServerCallListener(requestObserver, responseObserver);
    }

    private StreamObserver invoke(StreamObserver responseObserver, ServerCall call) {

        ObserverContext context = call.getObserverContext();
        BObject streamIterator = ValueCreator.createObjectValue(getModule(),
                GrpcConstants.ITERATOR_OBJECT_NAME, new Object[1]);
        BlockingQueue<Message> messageQueue = new LinkedBlockingQueue<>();
        streamIterator.addNativeData(GrpcConstants.MESSAGE_QUEUE, messageQueue);
        streamIterator.addNativeData(GrpcConstants.CLIENT_ENDPOINT_RESPONSE_OBSERVER, responseObserver);
        BStream requestStream = ValueCreator.createStreamValue(TypeCreator.createStreamType(inputType),
                streamIterator);
        onStreamInvoke(resource, requestStream, call.getHeaders(), responseObserver, context);
        return new StreamingServerRequestObserver(streamIterator, messageQueue);
    }

    private static final class StreamingServerRequestObserver implements StreamObserver {
        private final BlockingQueue<Message> messageQueue;

        StreamingServerRequestObserver(BObject streamIterator, BlockingQueue<Message> messageQueue) {
            this.messageQueue = messageQueue;
        }

        @Override
        public void onNext(Message value) {
            messageQueue.add(value);
        }

        @Override
        public void onError(Message error) {
            messageQueue.add(error);
        }

        @Override
        public void onCompleted() {
            messageQueue.add(new Message(GrpcConstants.COMPLETED_MESSAGE, null));
        }
    }

    private static final class StreamingServerCallListener implements Listener {

        private final StreamObserver requestObserver;
        private final ServerCallStreamObserver responseObserver;
        private boolean halfClosed = false;

        // Non private to avoid synthetic class
        StreamingServerCallListener(
                StreamObserver requestObserver,
                ServerCallStreamObserver responseObserver) {
            this.requestObserver = requestObserver;
            this.responseObserver = responseObserver;
        }

        @Override
        public void onMessage(Message request) {
            requestObserver.onNext(request);
        }

        @Override
        public void onHalfClose() {
            if (!halfClosed) {
                halfClosed = true;
                requestObserver.onCompleted();
            }
            // Once the client is closed the connection, 
            // the client can't send new messages.
        }

        @Override
        public void onCancel(Message message) {
            responseObserver.cancelled = true;
            requestObserver.onError(message);
        }

        @Override
        public void onComplete() {
            if (!halfClosed) {
                halfClosed = true;
                requestObserver.onCompleted();
            }
            // Once the client is closed the connection,
            // the client can't send new messages.
        }
    }

    /**
     * Checks whether service method has a response message.
     *
     * @return true if method response is empty, false otherwise
     */
    private boolean isEmptyResponse() {
        return methodDescriptor != null && MessageUtils.isEmptyResponse(methodDescriptor.getOutputType());
    }

    void onStreamInvoke(ServiceResource resource, BStream requestStream, HttpHeaders headers,
                        StreamObserver responseObserver, ObserverContext context) {

        Object[] requestParams = computeResourceParams(resource, requestStream, headers, responseObserver);
        Map<String, Object> properties = new HashMap<>();
        if (ObserveUtils.isObservabilityEnabled()) {
            properties.put(ObservabilityConstants.KEY_OBSERVER_CONTEXT, context);
        }
        properties.put(AUTHORIZATION, headers.get(AUTHORIZATION));
        StreamingCallableUnitCallBack callback = new StreamingCallableUnitCallBack(resource.getRuntime(),
                responseObserver, isEmptyResponse(), this.methodDescriptor.getOutputType(), context);

        String functionName = resource.getFunctionName();
        ObjectType serviceObjectType = resource.getService().getType();
        if (serviceObjectType.isIsolated() && serviceObjectType.isIsolated(functionName)) {
            resource.getRuntime().invokeMethodAsyncConcurrently(resource.getService(), resource.getFunctionName(), null,
                    GrpcConstants.ON_MESSAGE_METADATA, callback, properties,
                    resource.getReturnType(), requestParams);
        } else {
            resource.getRuntime().invokeMethodAsyncSequentially(resource.getService(), resource.getFunctionName(), null,
                    GrpcConstants.ON_MESSAGE_METADATA, callback, properties,
                    resource.getReturnType(), requestParams);
        }
    }
}
