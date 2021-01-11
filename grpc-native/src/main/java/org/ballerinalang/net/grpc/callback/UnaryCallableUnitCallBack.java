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
package org.ballerinalang.net.grpc.callback;

import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.Runtime;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BStream;
import io.ballerina.runtime.observability.ObserverContext;
import io.netty.handler.codec.http.HttpResponseStatus;
import org.ballerinalang.net.grpc.Message;
import org.ballerinalang.net.grpc.StreamObserver;
import org.ballerinalang.net.grpc.listener.ServerCallHandler;

import static io.ballerina.runtime.observability.ObservabilityConstants.PROPERTY_KEY_HTTP_STATUS_CODE;
import static org.ballerinalang.net.grpc.GrpcConstants.COMPLETED_MESSAGE;
import static org.ballerinalang.net.grpc.GrpcConstants.EMPTY_DATATYPE_NAME;

/**
 * Call back class registered for streaming gRPC service in B7a executor.
 *
 * @since 0.995.0
 */
public class UnaryCallableUnitCallBack extends AbstractCallableUnitCallBack {

    private Runtime runtime;
    private StreamObserver requestSender;
    private boolean emptyResponse;
    private Descriptors.Descriptor outputType;
    private ObserverContext observerContext;


    public UnaryCallableUnitCallBack(Runtime runtime, StreamObserver requestSender, boolean isEmptyResponse,
                                     Descriptors.Descriptor outputType, ObserverContext context) {
        this.runtime = runtime;
        this.requestSender = requestSender;
        this.emptyResponse = isEmptyResponse;
        this.outputType = outputType;
        this.observerContext = context;
    }

    @Override
    public void notifySuccess(Object response) {
        super.notifySuccess(response);
        // check whether connection is closed.
        if (requestSender instanceof ServerCallHandler.ServerCallStreamObserver) {
            ServerCallHandler.ServerCallStreamObserver serverCallStreamObserver = (ServerCallHandler
                    .ServerCallStreamObserver) requestSender;
            if (!serverCallStreamObserver.isReady()) {
                return;
            }
            if (serverCallStreamObserver.isCancelled()) {
                return;
            }
        }
        if (response instanceof BError) {
            handleFailure(requestSender, (BError) response);
            if (observerContext != null) {
                observerContext.addProperty(PROPERTY_KEY_HTTP_STATUS_CODE,
                        HttpResponseStatus.INTERNAL_SERVER_ERROR.code());
            }
            return;
        }
        // notify success only if response message is empty. Service impl doesn't send empty message. Empty response
        // scenarios handles here.
        if (emptyResponse) {
            requestSender.onNext(new Message(EMPTY_DATATYPE_NAME, null));
        } else if (response instanceof BStream) {
            BObject bObject = (BObject) ((BStream) response).getIteratorObj();
            ReturnStreamUnitCallBack returnStreamUnitCallBack = new ReturnStreamUnitCallBack(
                    runtime, requestSender, outputType, bObject);
            runtime.invokeMethodAsync(bObject, "next", null, null, returnStreamUnitCallBack);
        } else {
            requestSender.onNext(new Message(this.outputType.getName(), response));
        }

        if (observerContext != null) {
            observerContext.addProperty(PROPERTY_KEY_HTTP_STATUS_CODE, HttpResponseStatus.OK.code());
        }
        // Notify complete if service impl doesn't call complete;
        if (!(response instanceof BStream)) {
            requestSender.onCompleted();
        }
    }

    @Override
    public void notifyFailure(BError error) {
        handleFailure(requestSender, error);
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

        public ReturnStreamUnitCallBack(Runtime runtime, StreamObserver requestSender,
                                        Descriptors.Descriptor outputType, BObject bObject) {
            this.runtime = runtime;
            this.requestSender = requestSender;
            this.outputType = outputType;
            this.bObject = bObject;
        }

        @Override
        public void notifySuccess(Object response) {
            if (response != null) {
                requestSender.onNext(new Message(this.outputType.getName(), response));
                runtime.invokeMethodAsync(bObject, "next", null, null, this);
            } else {
                requestSender.onNext(new Message(COMPLETED_MESSAGE, null));
                requestSender.onCompleted();
            }

        }

        @Override
        public void notifyFailure(BError error) {
            super.notifyFailure(error);
        }
    }
}
