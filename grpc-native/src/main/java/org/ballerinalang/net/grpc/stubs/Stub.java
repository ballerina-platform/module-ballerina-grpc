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
package org.ballerinalang.net.grpc.stubs;

import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.netty.handler.codec.http.HttpHeaders;
import org.ballerinalang.net.grpc.ClientCall;
import org.ballerinalang.net.grpc.DataContext;
import org.ballerinalang.net.grpc.Message;
import org.ballerinalang.net.grpc.MethodDescriptor;
import org.ballerinalang.net.grpc.MessageUtils;
import org.ballerinalang.net.grpc.Status;
import org.ballerinalang.net.transport.contract.HttpClientConnector;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

import org.ballerinalang.net.grpc.GrpcConstants;

/**
 * This class handles Blocking client connection.
 *
 * @since 0.980.0
 */
public class Stub extends AbstractStub {

    public Stub(HttpClientConnector clientConnector, String url) {
        super(clientConnector, url);
    }

    /**
     * Executes a unary call and blocks on the response.
     *
     * @param request          request message.
     * @param methodDescriptor method descriptor
     * @param dataContext data context
     * @throws Exception if an error occur while processing client call.
     */
    public void executeUnary(Message request, MethodDescriptor methodDescriptor,
                             DataContext dataContext) throws Exception {
        ClientCall call = new ClientCall(getConnector(), createOutboundRequest(request
                .getHeaders()), methodDescriptor, dataContext);
        call.start(new UnaryCallListener(dataContext));
        try {
            call.sendMessage(request);
            call.halfClose();
        } catch (Exception e) {
            cancelThrow(call, e);
        }
    }

    /**
     * Executes server streaming non blocking call.
     *
     * @param request  request message.
     * @param methodDescriptor method descriptor.
     * @param context Data Context.
     * @throws Exception if an error occur while processing client call.
     */
    public Object executeServerStreaming(Message request, MethodDescriptor methodDescriptor,
                                         DataContext context) throws Exception {
        ClientCall call = new ClientCall(getConnector(), createOutboundRequest(request.getHeaders()),
                methodDescriptor, context);
        Stub.StreamingCallListener streamingCallListener = new Stub.StreamingCallListener(true);
        call.start(streamingCallListener);
        try {
            call.sendMessage(request);
            call.halfClose();
        } catch (Exception e) {
            cancelThrow(call, e);
        }
        BObject streamIterator = ValueCreator.createObjectValue(GrpcConstants.PROTOCOL_GRPC_PKG_ID,
                GrpcConstants.ITERATOR_OBJECT_NAME, new Object[1]);
        BlockingQueue<Message> messageQueue = streamingCallListener.getMessageQueue();
        streamIterator.addNativeData(GrpcConstants.MESSAGE_QUEUE, messageQueue);
        return ValueCreator.createStreamValue(TypeCreator.createStreamType(PredefinedTypes.TYPE_ANYDATA),
                streamIterator);
    }

    /**
     *  Callbacks for receiving headers, response messages and completion status in unary calls.
     */
    private static final class UnaryCallListener implements Listener {

        private final DataContext dataContext;
        private Message value;

        // Non private to avoid synthetic class
        private UnaryCallListener(DataContext dataContext) {
            this.dataContext = dataContext;
        }

        @Override
        public void onHeaders(HttpHeaders headers) {
            // Headers are processed at client connector listener. Do not need to further process.
        }

        @Override
        public void onMessage(Message value) {
            if (this.value != null) {
                throw Status.Code.INTERNAL.toStatus().withDescription("More than one value received for unary call")
                        .asRuntimeException();
            }
            this.value = value;
        }

        @Override
        public void onClose(Status status, HttpHeaders trailers) {
            BError httpConnectorError = null;
            Object inboundResponse = null;
            if (status.isOk()) {
                if (value == null) {
                    // No value received so mark the future as an error
                    httpConnectorError = MessageUtils.getConnectorError(Status.Code.INTERNAL.toStatus()
                                    .withDescription("No value received for unary call").asRuntimeException());
                } else {
                    inboundResponse = value.getbMessage();
                }
            } else {
                httpConnectorError = MessageUtils.getConnectorError(status.asRuntimeException());
            }
            if (inboundResponse != null) {
                dataContext.getFuture().complete(inboundResponse);
            } else {
                dataContext.getFuture().complete(httpConnectorError);
            }
        }
    }

    /**
     *  Callbacks for receiving headers, response messages, and completion status in streaming calls.
     */
    private static final class StreamingCallListener implements Listener {

        private final boolean streamingResponse;
        BlockingQueue<Message> messageQueue;
        private boolean firstResponseReceived;

        // Non private to avoid synthetic class
        StreamingCallListener(boolean streamingResponse) {
            this.streamingResponse = streamingResponse;
            this.messageQueue = new LinkedBlockingQueue<>();
        }

        @Override
        public void onHeaders(HttpHeaders headers) {
            // Headers are processed at client connector listener. Do not need to further process.
        }

        @Override
        public void onMessage(Message message) {
            if (firstResponseReceived && !streamingResponse) {
                throw Status.Code.INTERNAL.toStatus()
                        .withDescription("More than one responses received for unary or client-streaming call")
                        .asRuntimeException();
            }
            firstResponseReceived = true;
            messageQueue.add(message);
        }

        @Override
        public void onClose(Status status, HttpHeaders trailers) {
            messageQueue.add(new Message(GrpcConstants.COMPLETED_MESSAGE, null));
        }

        public BlockingQueue<Message> getMessageQueue() {
            return messageQueue;
        }
    }
}
