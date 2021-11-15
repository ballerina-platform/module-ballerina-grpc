/*
 *  Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
package io.ballerina.stdlib.grpc.callback;

import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.Runtime;
import io.ballerina.runtime.api.types.ObjectType;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BStream;
import io.ballerina.runtime.observability.ObserverContext;
import io.ballerina.stdlib.grpc.GrpcConstants;
import io.ballerina.stdlib.grpc.Message;
import io.ballerina.stdlib.grpc.MessageUtils;
import io.ballerina.stdlib.grpc.StreamObserver;
import io.ballerina.stdlib.grpc.listener.ServerCallHandler;
import io.netty.handler.codec.http.HttpHeaders;
import io.netty.handler.codec.http.HttpResponseStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static io.ballerina.runtime.observability.ObservabilityConstants.PROPERTY_KEY_HTTP_STATUS_CODE;
import static io.ballerina.stdlib.grpc.GrpcConstants.STREAMING_NEXT_FUNCTION;

/**
 * Call back class registered for streaming gRPC service in B7a executor.
 *
 * @since 0.995.0
 */
public class StreamingCallableUnitCallBack extends AbstractCallableUnitCallBack {

    private static final Logger LOG = LoggerFactory.getLogger(StreamingCallableUnitCallBack.class);

    private Runtime runtime;
    private StreamObserver responseSender;
    private boolean emptyResponse;
    private Descriptors.Descriptor outputType;
    private ObserverContext observerContext;

    public StreamingCallableUnitCallBack(Runtime runtime, StreamObserver responseSender, boolean isEmptyResponse,
                                         Descriptors.Descriptor outputType, ObserverContext context) {
        available.acquireUninterruptibly();
        this.runtime = runtime;
        this.responseSender = responseSender;
        this.emptyResponse = isEmptyResponse;
        this.observerContext = context;
        this.outputType = outputType;
    }

    @Override
    public void notifySuccess(Object response) {
        super.notifySuccess(response);
        // check whether connection is closed.
        if (responseSender instanceof ServerCallHandler.ServerCallStreamObserver) {
            ServerCallHandler.ServerCallStreamObserver serverCallStreamObserver = (ServerCallHandler
                    .ServerCallStreamObserver) responseSender;
            if (!serverCallStreamObserver.isReady()) {
                return;
            }
            if (serverCallStreamObserver.isCancelled()) {
                return;
            }
        }
        if (response instanceof BError) {
            handleFailure(responseSender, (BError) response);
            if (observerContext != null) {
                observerContext.addProperty(PROPERTY_KEY_HTTP_STATUS_CODE,
                        HttpResponseStatus.INTERNAL_SERVER_ERROR.code());
            }
            return;
        }

        Object content;
        BMap headerValues = null;
        if (MessageUtils.isContextRecordByValue(response)) {
            content = ((BMap) response).get(StringUtils.fromString(GrpcConstants.CONTENT_FIELD));
            headerValues = ((BMap) response).getMapValue(StringUtils.fromString(GrpcConstants.HEADER_FIELD));
        } else {
            content = response;
        }
        // Update response headers when request headers exists in the context.
        HttpHeaders headers = MessageUtils.convertToHttpHeaders(headerValues);

        if (content instanceof BStream) {
            BObject bObject = ((BStream) content).getIteratorObj();
            ReturnStreamUnitCallBack returnStreamUnitCallBack = new ReturnStreamUnitCallBack(
                    runtime, responseSender, outputType, bObject, headers);
            ObjectType serviceObjectType = bObject.getType();
            if (serviceObjectType.isIsolated() && serviceObjectType.isIsolated(STREAMING_NEXT_FUNCTION)) {
                runtime.invokeMethodAsyncConcurrently(bObject, STREAMING_NEXT_FUNCTION, null, null,
                        returnStreamUnitCallBack, null, PredefinedTypes.TYPE_NULL);
            } else {
                runtime.invokeMethodAsyncSequentially(bObject, STREAMING_NEXT_FUNCTION, null, null,
                        returnStreamUnitCallBack, null, PredefinedTypes.TYPE_NULL);
            }
        } else {
            // If content is null and remote function doesn't return empty response means. response is already sent
            // to client via caller object, but connection is not closed already by calling complete function.
            // Hence closing the connection.
            if (content == null) {
                if (this.emptyResponse) {
                    Message responseMessage = new Message(GrpcConstants.EMPTY_DATATYPE_NAME, null);
                    responseMessage.setHeaders(headers);
                    responseSender.onNext(responseMessage);
                }
            } else {
                Message responseMessage = new Message(outputType.getName(), content);
                responseMessage.setHeaders(headers);
                responseSender.onNext(responseMessage);
            }
            responseSender.onCompleted();
        }
    }

    @Override
    public void notifyFailure(io.ballerina.runtime.api.values.BError error) {
        if (responseSender instanceof ServerCallHandler.ServerCallStreamObserver) {
            ServerCallHandler.ServerCallStreamObserver serverCallStreamObserver = (ServerCallHandler
                    .ServerCallStreamObserver) responseSender;
            if (!serverCallStreamObserver.isReady() || serverCallStreamObserver.isCancelled()) {
                LOG.warn("Call already closed");
                return;
            }
        }
        if (responseSender != null) {
            handleFailure(responseSender, error);
        }
        if (observerContext != null) {
            observerContext.addProperty(PROPERTY_KEY_HTTP_STATUS_CODE, HttpResponseStatus.INTERNAL_SERVER_ERROR.code());
        }
        super.notifyFailure(error);
    }

    /**
     * Call back class registered to send returned stream from a remote function.
     *
     */
    public class ReturnStreamUnitCallBack extends AbstractCallableUnitCallBack {
        private StreamObserver requestSender;
        private Descriptors.Descriptor outputType;
        private Runtime runtime;
        private BObject bObject;
        private HttpHeaders headers;

        public ReturnStreamUnitCallBack(Runtime runtime, StreamObserver requestSender,
                                        Descriptors.Descriptor outputType, BObject bObject, HttpHeaders headers) {
            this.runtime = runtime;
            this.requestSender = requestSender;
            this.outputType = outputType;
            this.bObject = bObject;
            this.headers = headers;
        }

        @Override
        public void notifySuccess(Object response) {
            if (response != null) {
                Message msg;
                if (MessageUtils.isRecordMapValue(response)) {
                    msg = new Message(this.outputType.getName(),
                            ((BMap) response).get(StringUtils.fromString("value")));
                } else {
                    msg = new Message(this.outputType.getName(), response);
                }
                if (headers != null) {
                    msg.setHeaders(headers);
                    headers = null;
                }
                requestSender.onNext(msg);
                ObjectType serviceObjectType = bObject.getType();
                if (serviceObjectType.isIsolated() && serviceObjectType.isIsolated(STREAMING_NEXT_FUNCTION)) {
                    runtime.invokeMethodAsyncConcurrently(bObject, STREAMING_NEXT_FUNCTION, null,
                            null, this, null, PredefinedTypes.TYPE_NULL);
                } else {
                    runtime.invokeMethodAsyncSequentially(bObject, STREAMING_NEXT_FUNCTION, null,
                            null, this, null, PredefinedTypes.TYPE_NULL);
                }
            } else {
                requestSender.onCompleted();
            }

        }

        @Override
        public void notifyFailure(BError error) {
            super.notifyFailure(error);
        }
    }
}
