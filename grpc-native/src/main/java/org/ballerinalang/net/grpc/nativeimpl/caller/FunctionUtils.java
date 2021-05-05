/*
 *  Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package org.ballerinalang.net.grpc.nativeimpl.caller;

import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.observability.ObserveUtils;
import io.ballerina.runtime.observability.ObserverContext;
import io.netty.handler.codec.http.HttpHeaders;
import io.netty.handler.codec.http.HttpResponseStatus;
import org.ballerinalang.net.grpc.GrpcConstants;
import org.ballerinalang.net.grpc.Message;
import org.ballerinalang.net.grpc.MessageUtils;
import org.ballerinalang.net.grpc.Status;
import org.ballerinalang.net.grpc.StreamObserver;
import org.ballerinalang.net.grpc.exception.StatusRuntimeException;
import org.ballerinalang.net.grpc.listener.ServerCallHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static io.ballerina.runtime.observability.ObservabilityConstants.PROPERTY_KEY_HTTP_STATUS_CODE;
import static org.ballerinalang.net.grpc.GrpcConstants.STATUS_ERROR_MAP;
import static org.ballerinalang.net.grpc.GrpcConstants.getKeyByValue;
import static org.ballerinalang.net.grpc.MessageUtils.convertToHttpHeaders;
import static org.ballerinalang.net.grpc.MessageUtils.getMappingHttpStatusCode;
import static org.ballerinalang.net.grpc.MessageUtils.isContextRecordByValue;

/**
 * Utility methods represents actions for the caller.
 *
 * @since 1.0.0
 */
public class FunctionUtils {
    private static final Logger LOG = LoggerFactory.getLogger(FunctionUtils.class);

    private FunctionUtils() {
    }

    /**
     * Extern function to inform the caller, server finished sending messages.
     *
     * @param endpointClient caller instance.
     * @return Error if there is an error while informing the caller, else returns nil
     */
    public static Object externComplete(Environment env, BObject endpointClient) {
        StreamObserver responseObserver = MessageUtils.getResponseObserver(endpointClient);
        Descriptors.Descriptor outputType = (Descriptors.Descriptor) endpointClient.getNativeData(GrpcConstants
                .RESPONSE_MESSAGE_DEFINITION);
        ObserverContext observerContext = ObserveUtils.getObserverContextOfCurrentFrame(env);

        if (responseObserver == null) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Error while initializing " +
                            "connector. response sender does not exist")));
        } else {
            try {
                if (!MessageUtils.isEmptyResponse(outputType)) {
                    responseObserver.onCompleted();
                }
                if (observerContext != null) {
                    observerContext.addProperty(PROPERTY_KEY_HTTP_STATUS_CODE, HttpResponseStatus.OK.code());
                }
            } catch (Exception e) {
                LOG.error("Error while sending complete message to caller.", e);
                return MessageUtils.getConnectorError(e);
            }
        }
        return null;
    }

    /**
     * Extern function to check whether caller has terminated the connection in between.
     *
     * @param endpointClient caller instance.
     * @return True if caller has terminated the connection, false otherwise.
     */
    public static boolean externIsCancelled(BObject endpointClient) {
        StreamObserver responseObserver = MessageUtils.getResponseObserver(endpointClient);

        if (responseObserver instanceof ServerCallHandler.ServerCallStreamObserver) {
            ServerCallHandler.ServerCallStreamObserver serverCallStreamObserver = (ServerCallHandler
                    .ServerCallStreamObserver) responseObserver;
            return serverCallStreamObserver.isCancelled();
        } else {
            return Boolean.FALSE;
        }
    }

    /**
     * Extern function to respond the caller.
     *
     * @param endpointClient caller instance.
     * @param responseValue response message.
     * @return Error if there is an error while responding the caller, else returns nil
     */
    public static Object externSend(Environment env, BObject endpointClient, Object responseValue) {
        StreamObserver responseObserver = MessageUtils.getResponseObserver(endpointClient);
        Descriptors.Descriptor outputType = (Descriptors.Descriptor) endpointClient.getNativeData(GrpcConstants
                .RESPONSE_MESSAGE_DEFINITION);
        ObserverContext observerContext = ObserveUtils.getObserverContextOfCurrentFrame(env);

        if (responseObserver == null) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Error while initializing " +
                            "connector. Response sender does not exist")));
        } else {
            try {
                // If there is no response message like conn -> send(), system doesn't send the message.
                if (!MessageUtils.isEmptyResponse(outputType)) {
                    Object content;
                    BMap headerValues = null;
                    if (isContextRecordByValue(responseValue)) {
                        content = ((BMap) responseValue).get(StringUtils.fromString("content"));
                        headerValues = ((BMap) responseValue).getMapValue(StringUtils.fromString("headers"));
                    } else {
                        content = responseValue;
                    }
                    //Message responseMessage = MessageUtils.generateProtoMessage(responseValue, outputType);
                    Message responseMessage = new Message(outputType.getName(), content);
                    // Update response headers when request headers exists in the context.
                    HttpHeaders headers = convertToHttpHeaders(headerValues);
                    responseMessage.setHeaders(headers);
                    if (observerContext != null) {
                        headers.entries().forEach(
                                x -> observerContext.addTag(x.getKey(), x.getValue()));
                    }
                    responseObserver.onNext(responseMessage);
                }
            } catch (Exception e) {
                LOG.error("Error while sending client response.", e);
                return MessageUtils.getConnectorError(e);
            }
        }
        return null;
    }

    /**
     * Extern function to send server error the caller.
     *
     * @param endpointClient caller instance.
     * @param errorValue gRPC error instance.
     * @return Error if there is an error while responding the caller, else returns nil
     */
    public static Object externSendError(Environment env, BObject endpointClient, BError errorValue) {
        StreamObserver responseObserver = MessageUtils.getResponseObserver(endpointClient);
        ObserverContext observerContext =
                ObserveUtils.getObserverContextOfCurrentFrame(env);
        if (responseObserver == null) {
            return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                    .fromCode(Status.Code.INTERNAL.toStatus().getCode()).withDescription("Error while sending the " +
                            "error. Response observer not found.")));
        } else {
            try {
                Integer statusCode = getKeyByValue(STATUS_ERROR_MAP, errorValue.getType().getName());
                if (statusCode == null) {
                    statusCode = Status.Code.INTERNAL.value();
                }
                Message errorMessage = new Message(new StatusRuntimeException(Status.fromCodeValue(statusCode)
                        .withDescription(errorValue.getErrorMessage().getValue())));

                int mappedStatusCode = getMappingHttpStatusCode(statusCode);
                if (observerContext != null) {
                    observerContext.addProperty(PROPERTY_KEY_HTTP_STATUS_CODE, mappedStatusCode);
                }
                responseObserver.onError(errorMessage);
            } catch (Exception e) {
                LOG.error("Error while sending error to caller.", e);
                return MessageUtils.getConnectorError(e);
            }
        }
        return null;
    }
}
