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

package org.ballerinalang.net.grpc.nativeimpl.streamingclient;

import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.observability.ObserveUtils;
import io.ballerina.runtime.observability.ObserverContext;
import org.ballerinalang.net.grpc.GrpcConstants;
import org.ballerinalang.net.grpc.Message;
import org.ballerinalang.net.grpc.MessageUtils;
import org.ballerinalang.net.grpc.Status;
import org.ballerinalang.net.grpc.StreamObserver;
import org.ballerinalang.net.grpc.exception.StatusRuntimeException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.ballerinalang.net.grpc.GrpcConstants.REQUEST_SENDER;
import static org.ballerinalang.net.grpc.GrpcConstants.STATUS_ERROR_MAP;
import static org.ballerinalang.net.grpc.GrpcConstants.TAG_KEY_GRPC_ERROR_MESSAGE;
import static org.ballerinalang.net.grpc.GrpcConstants.getKeyByValue;
import static org.ballerinalang.net.grpc.MessageUtils.getMappingHttpStatusCode;

/**
 * Utility methods represents actions for the streaming client.
 *
 * @since 1.0.0
 */
public class FunctionUtils {

    private static final Logger LOG = LoggerFactory.getLogger(FunctionUtils.class);

    /**
     * Extern function to send a streaming request messages to the server.
     *
     * @param streamConnection streaming connection instance.
     * @param responseValue message.
     * @return Error if there is an error while sending message to the server, else returns nil.
     */
    public static Object streamSend(BObject streamConnection, Object responseValue) {
        StreamObserver requestSender = (StreamObserver) streamConnection.getNativeData(REQUEST_SENDER);
        if (requestSender == null) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Error while sending the " +
                            "message. endpoint does not exist")));
        } else {
            Descriptors.Descriptor inputType = (Descriptors.Descriptor) streamConnection.getNativeData(GrpcConstants
                    .REQUEST_MESSAGE_DEFINITION);
            try {
                Message requestMessage = new Message(inputType.getName(), responseValue);
                requestSender.onNext(requestMessage);
            } catch (Exception e) {
                LOG.error("Error while sending request message to server.", e);
                return MessageUtils.getConnectorError(e);
            }
        }
        return null;
    }

    public static Object streamReceive(BObject streamConnection) {
        // TODO: implement the logic.
        return "";
    }

    /**
     * Extern function to send a error message to the server.
     *
     * @param streamingConnection streaming connection instance.
     * @param errorValue gRPC error instance.
     * @return Error if there is an error while sending error message to the server, else returns nil.
     */
    public static Object streamSendError(Environment env, BObject streamingConnection, BError errorValue) {
        StreamObserver requestSender = (StreamObserver) streamingConnection.getNativeData(REQUEST_SENDER);
        if (requestSender == null) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Error while sending the " +
                            "error. endpoint does not exist")));
        } else {
            try {
                Integer statusCode = getKeyByValue(STATUS_ERROR_MAP, errorValue.getType().getName());
                if (statusCode == null) {
                    statusCode = Status.Code.INTERNAL.value();
                }
                requestSender.onError(new Message(new StatusRuntimeException(Status.fromCodeValue(statusCode)
                        .withDescription(errorValue.getErrorMessage().getValue()))));
                // Add message content to observer context.
                ObserverContext observerContext = ObserveUtils.getObserverContextOfCurrentFrame(env);
                observerContext.addTag(TAG_KEY_GRPC_ERROR_MESSAGE,
                        getMappingHttpStatusCode(statusCode) + " : " + errorValue.getErrorMessage().getValue());

            } catch (Exception e) {
                LOG.error("Error while sending error to server.", e);
                return MessageUtils.getConnectorError(e);
            }
        }
        return null;
    }

    /**
     * Extern function to inform the server, client finished sending messages.
     *
     * @param streamingConnection streaming connection instance.
     * @return Error if there is an error while informing the server, else returns nil.
     */
    public static Object streamComplete(BObject streamingConnection) {
        StreamObserver requestSender = (StreamObserver) streamingConnection.getNativeData(REQUEST_SENDER);
        if (requestSender == null) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Error while completing the " +
                            "message. endpoint does not exist")));
        } else {
            try {
                requestSender.onCompleted();
            } catch (Exception e) {
                LOG.error("Error while sending complete message to server.", e);
                return MessageUtils.getConnectorError(e);
            }
        }
        return null;
    }
}
