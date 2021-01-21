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
package org.ballerinalang.net.grpc.callback;

import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.Runtime;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BStream;
import io.ballerina.runtime.observability.ObserverContext;
import io.netty.handler.codec.http.HttpHeaders;
import io.netty.handler.codec.http.HttpResponseStatus;
import org.ballerinalang.net.grpc.Message;
import org.ballerinalang.net.grpc.StreamObserver;

import static io.ballerina.runtime.observability.ObservabilityConstants.PROPERTY_KEY_HTTP_STATUS_CODE;
import static org.ballerinalang.net.grpc.MessageUtils.convertToHttpHeaders;
import static org.ballerinalang.net.grpc.MessageUtils.isContextRecordByValue;
import static org.ballerinalang.net.grpc.MessageUtils.isRecordMapValue;

/**
 * Call back class registered for streaming gRPC service in B7a executor.
 *
 * @since 0.995.0
 */
public class StreamingCallableUnitCallBack extends AbstractCallableUnitCallBack {

    private Runtime runtime;
    private StreamObserver responseSender;
    private Descriptors.Descriptor outputType;
    private ObserverContext observerContext;

    public StreamingCallableUnitCallBack(Runtime runtime, StreamObserver responseSender,
                                         Descriptors.Descriptor outputType, ObserverContext context) {
        available.acquireUninterruptibly();
        this.runtime = runtime;
        this.responseSender = responseSender;
        this.observerContext = context;
        this.outputType = outputType;
    }

    @Override
    public void notifySuccess(Object response) {
        super.notifySuccess(response);
        Object content;
        BMap headerValues = null;
        if (isContextRecordByValue(response)) {
            content = ((BMap) response).get(StringUtils.fromString("content"));
            headerValues = ((BMap) response).getMapValue(StringUtils.fromString("headers"));
        } else {
            content = response;
        }
        // Update response headers when request headers exists in the context.
        HttpHeaders headers = convertToHttpHeaders(headerValues);

        if (content instanceof BStream) {
            BObject bObject = (BObject) ((BStream) content).getIteratorObj();
            ReturnStreamUnitCallBack returnStreamUnitCallBack = new ReturnStreamUnitCallBack(
                    runtime, responseSender, outputType, bObject, headers);
            runtime.invokeMethodAsync(bObject, "next", null, null, returnStreamUnitCallBack);
        } else {
            //Message responseMessage = MessageUtils.generateProtoMessage(responseValue, outputType);
            Message responseMessage = new Message(outputType.getName(), content);
            responseMessage.setHeaders(headers);
            responseSender.onNext(responseMessage);
            responseSender.onCompleted();
        }
    }

    @Override
    public void notifyFailure(io.ballerina.runtime.api.values.BError error) {
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
                if (isRecordMapValue(response)) {
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
                runtime.invokeMethodAsync(bObject, "next", null, null, this);
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
