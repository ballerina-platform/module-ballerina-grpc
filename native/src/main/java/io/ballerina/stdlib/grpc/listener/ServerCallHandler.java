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
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.TypeTags;
import io.ballerina.runtime.api.async.Callback;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.ArrayType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.observability.ObservabilityConstants;
import io.ballerina.runtime.observability.ObserveUtils;
import io.ballerina.runtime.observability.ObserverContext;
import io.ballerina.stdlib.grpc.CallStreamObserver;
import io.ballerina.stdlib.grpc.GrpcConstants;
import io.ballerina.stdlib.grpc.Message;
import io.ballerina.stdlib.grpc.MessageUtils;
import io.ballerina.stdlib.grpc.ServerCall;
import io.ballerina.stdlib.grpc.ServiceResource;
import io.ballerina.stdlib.grpc.Status;
import io.ballerina.stdlib.grpc.StreamObserver;
import io.ballerina.stdlib.grpc.callback.UnaryCallableUnitCallBack;
import io.netty.handler.codec.http.DefaultHttpHeaders;
import io.netty.handler.codec.http.HttpHeaders;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static io.ballerina.stdlib.grpc.GrpcConstants.AUTHORIZATION;
import static io.ballerina.stdlib.grpc.GrpcUtil.getTypeName;
import static io.ballerina.stdlib.grpc.nativeimpl.ModuleUtils.getModule;
import static java.util.Map.entry;

/**
 * Interface to initiate processing of incoming remote calls.
 * <p>
 * Referenced from grpc-java implementation.
 * <p>
 * @since 0.980.0
 */

public abstract class ServerCallHandler {

    static final String TOO_MANY_REQUESTS = "Too many requests";
    static final String MISSING_REQUEST = "Half-closed without a request";
    static final String CALLER_TYPE = "Caller";
    protected Descriptors.MethodDescriptor methodDescriptor;

    ServerCallHandler(Descriptors.MethodDescriptor methodDescriptor) {
        this.methodDescriptor = methodDescriptor;
    }

    /**
     * Returns a listener for the incoming call.
     *
     * @param call object for responding to the remote client.
     * @return listener for processing incoming request messages for {@code call}
     */
    public abstract Listener startCall(ServerCall call);

    /**
     * Receives notifications from an observable stream of response messages from server side.
     *
     */
    public static final class ServerCallStreamObserver implements CallStreamObserver {

        final ServerCall call;
        volatile boolean cancelled;
        private boolean sentHeaders;

        ServerCallStreamObserver(ServerCall call) {
            this.call = call;
        }

        @Override
        public void setMessageCompression(boolean enable) {
            call.setMessageCompression(enable);
        }

        @Override
        public void onNext(Message response) {
            if (cancelled) {
                throw Status.Code.CANCELLED.toStatus().withDescription("call already cancelled").asRuntimeException();
            }
            if (!sentHeaders) {
                call.sendHeaders(response.getHeaders());
                sentHeaders = true;
            }
            call.sendMessage(response);
        }

        @Override
        public void onError(Message error) {
            if (!sentHeaders) {
                call.sendHeaders(error.getHeaders());
                sentHeaders = true;
            }
            call.close(Status.fromThrowable(error.getError()), new DefaultHttpHeaders());
        }

        @Override
        public void onCompleted() {
            if (cancelled) {
                throw Status.Code.CANCELLED.toStatus().withDescription("call already cancelled").asRuntimeException();
            } else {
                call.close(Status.Code.OK.toStatus(), new DefaultHttpHeaders());
            }
        }

        @Override
        public boolean isReady() {
            return call.isReady();
        }

        public boolean isCancelled() {
            return call.isCancelled();
        }
    }

    /**
     * Returns endpoint instance which is used to respond to the caller.
     *
     * @param resource service resource.
     * @param responseObserver client responder instance.
     * @return instance of endpoint type.
     */
    BObject getConnectionParameter(ServiceResource resource, StreamObserver responseObserver) {
        // generate client responder struct on request message with response observer and response msg type.
        BObject clientEndpoint = ValueCreator.createObjectValue(getModule(), GrpcConstants.CALLER);
        clientEndpoint.set(GrpcConstants.CALLER_ID, responseObserver.hashCode());
        clientEndpoint.addNativeData(GrpcConstants.RESPONSE_OBSERVER, responseObserver);
        clientEndpoint.addNativeData(GrpcConstants.RESPONSE_MESSAGE_DEFINITION, methodDescriptor.getOutputType());
        String serviceName = resource.getServiceName();
        Type returnType = resource.getRpcOutputType() instanceof ArrayType ?
                ((ArrayType) resource.getRpcOutputType()).getElementType() : resource.getRpcOutputType();
        String outputType = returnType != PredefinedTypes.TYPE_NULL ? getTypeName(returnType) : null;
        return ValueCreator.createObjectValue(resource.getService().getType().getPackage(),
                MessageUtils.getCallerTypeName(serviceName, outputType), clientEndpoint);
    }

    /**
     * Checks whether service method has a response message.
     *
     * @return true if method response is empty, false otherwise
     */
    private boolean isEmptyResponse() {
        return methodDescriptor != null && MessageUtils.isEmptyResponse(methodDescriptor.getOutputType());
    }

    void onMessageInvoke(ServiceResource resource, Message request, StreamObserver responseObserver,
                         ObserverContext context) {
        Callback callback = new UnaryCallableUnitCallBack(resource.getRuntime(), responseObserver, isEmptyResponse(),
                this.methodDescriptor.getOutputType(), context);
        Object requestParam = request != null ? request.getbMessage() : null;
        HttpHeaders headers = request != null ? request.getHeaders() : null;
        Object[] requestParams = computeResourceParams(resource, requestParam, headers, responseObserver);
        Map<String, Object> properties = new HashMap<>();
        if (ObserveUtils.isObservabilityEnabled()) {
            properties.put(ObservabilityConstants.KEY_OBSERVER_CONTEXT, context);
        }
        properties.put(AUTHORIZATION, headers.get(AUTHORIZATION));
        resource.getRuntime().invokeMethodAsync(resource.getService(), resource.getFunctionName(), null,
                GrpcConstants.ON_MESSAGE_METADATA, callback, properties,
                resource.getReturnType(), requestParams);
    }

    Object[] computeResourceParams(ServiceResource resource, Object requestParam, HttpHeaders headers,
                                   StreamObserver responseObserver) {
        List<Type> signatureParams = resource.getParamTypes();
        int signatureParamSize = signatureParams.size();
        Object[] paramValues;
        int i = 0;
        if ((signatureParamSize >= 1) && (signatureParams.get(0).getTag() == TypeTags.OBJECT_TYPE_TAG) &&
                signatureParams.get(0).getName().contains(CALLER_TYPE)) {
            paramValues = new Object[signatureParams.size() * 2];
            paramValues[i] = getConnectionParameter(resource, responseObserver);
            paramValues[i + 1] = true;
            i = i + 2;
        } else {
            paramValues = new Object[2];
        }
        if (resource.isHeaderRequired()) {
            BMap headerValues = MessageUtils.createHeaderMap(headers);
            Map<String, Object> valueMap;
            if (requestParam != null) {
                valueMap = Map.ofEntries(
                        entry("content", requestParam),
                        entry("headers", headerValues)
                );
            } else {
                valueMap = Map.ofEntries(
                        entry("headers", headerValues)
                );
            }
            BMap contentContext;
            if (signatureParamSize >= 1) {
                Type inputParameter = signatureParams.get(signatureParamSize - 1);

                // Here the logic is:
                // IF (inputParaName contains stream) AND ((firstParam is recordType) OR (secondParam is recordType))
                // ELSE part execute for non-streaming cases with context param
                if (inputParameter.getName().contains("Stream") &&
                        ((signatureParamSize == 1 && (signatureParams.get(0).getTag() == TypeTags.RECORD_TYPE_TAG)) ||
                                (signatureParamSize > 1 &&
                                        (signatureParams.get(1).getTag() == TypeTags.RECORD_TYPE_TAG)))) {
                    contentContext = ValueCreator.createRecordValue(inputParameter.getPackage(),
                            MessageUtils.getContextStreamTypeName(resource.getRpcInputType()), valueMap);
                } else {
                    contentContext = ValueCreator.createRecordValue(inputParameter.getPackage(),
                            MessageUtils.getContextTypeName(resource.getRpcInputType()), valueMap);
                }
                paramValues[i] = contentContext;
                paramValues[i + 1] = true;
            }
        } else if (requestParam != null) {
            paramValues[i] = requestParam;
            paramValues[i + 1] = true;
        }
        return paramValues;
    }

    /**
     * Callbacks for consuming incoming RPC messages.
     *
     * <p>Any contexts are guaranteed to arrive before any messages, which are guaranteed before half
     * close, which is guaranteed before completion.
     *
     * <p>Implementations are free to block for extended periods of time. Implementations are not
     * required to be thread-safe.
     */
    public interface Listener {

        /**
         * A request message has been received. For streaming calls, there may be zero or more request
         * messages.
         *
         * @param message a received request message.
         */
        void onMessage(Message message);

        /**
         * The client completed all message sending. However, the call may still be cancelled.
         */
        void onHalfClose();

        /**
         * The call was cancelled and the server is encouraged to abort processing to save resources,
         * since the client will not process any further messages. Cancellations can be caused by
         * timeouts, explicit cancellation by the client, network errors, etc.
         *
         * <p>There will be no further callbacks for the call.
         *
         * @param message a received error message.
         */
        void onCancel(Message message);

        /**
         * The call is considered complete and {@link #onCancel} is guaranteed not to be called.
         * However, the client is not guaranteed to have received all messages.
         *
         * <p>There will be no further callbacks for the call.
         */
        void onComplete();
    }
}
