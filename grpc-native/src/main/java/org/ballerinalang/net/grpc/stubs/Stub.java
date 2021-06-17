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
package org.ballerinalang.net.grpc.stubs;

import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.netty.handler.codec.http.HttpHeaders;
import org.ballerinalang.net.grpc.CallStreamObserver;
import org.ballerinalang.net.grpc.ClientCall;
import org.ballerinalang.net.grpc.DataContext;
import org.ballerinalang.net.grpc.GrpcConstants;
import org.ballerinalang.net.grpc.Message;
import org.ballerinalang.net.grpc.MessageUtils;
import org.ballerinalang.net.grpc.MethodDescriptor;
import org.ballerinalang.net.grpc.Status;
import org.ballerinalang.net.transport.contract.HttpClientConnector;

import java.util.Arrays;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

import static org.ballerinalang.net.grpc.MessageUtils.createHeaderMap;
import static org.ballerinalang.net.grpc.nativeimpl.ModuleUtils.getModule;

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
        ClientCall call = new ClientCall(getConnector(), createOutboundRequest(request.getHeaders()),
                methodDescriptor, dataContext);
        call.start(new UnaryCallListener(dataContext));
        try {
            call.sendMessage(request);
            call.halfClose();
        } catch (Exception e) {
            cancelThrow(call, e);
        }
    }

    /**
     * Executes server streaming blocking call.
     *
     * @param request  request message.
     * @param methodDescriptor method descriptor.
     * @param context Data Context.
     * @throws Exception if an error occur while processing client call.
     */
    public void executeServerStreaming(Message request, MethodDescriptor methodDescriptor,
                                         DataContext context) throws Exception {
        ClientCall call = new ClientCall(getConnector(), createOutboundRequest(request.getHeaders()),
                methodDescriptor, context);
        Stub.ServerStreamingCallListener streamingCallListener = new Stub.ServerStreamingCallListener(context);
        call.start(streamingCallListener);
        try {
            call.sendMessage(request);
            call.halfClose();
        } catch (Exception e) {
            cancelThrow(call, e);
        }
    }

    /**
     * Executes client streaming blocking call.
     *
     * @param requestHeaders request headers.
     * @param methodDescriptor method descriptor.
     * @param context Data Context.
     */
    public BObject executeClientStreaming(HttpHeaders requestHeaders, MethodDescriptor methodDescriptor,
                                          DataContext context) {
        ClientCall call = new ClientCall(getConnector(), createOutboundRequest(requestHeaders),
                methodDescriptor, context);
        ClientCallStreamObserver streamObserver = new ClientCallStreamObserver(call);
        Stub.StreamingCallListener streamingCallListener = new Stub.StreamingCallListener(false);
        call.start(streamingCallListener);

        BObject streamingConnection = ValueCreator.createObjectValue(getModule(), GrpcConstants.STREAMING_CLIENT);
        streamingConnection.addNativeData(GrpcConstants.REQUEST_SENDER, streamObserver);
        streamingConnection.addNativeData(GrpcConstants.REQUEST_MESSAGE_DEFINITION,
                methodDescriptor.getSchemaDescriptor().getInputType());

        streamingConnection.addNativeData(GrpcConstants.MESSAGE_QUEUE, streamingCallListener.getMessageQueue());
        streamingConnection.addNativeData(GrpcConstants.HEADERS, streamingCallListener.getHeaderMap());
        streamingConnection.addNativeData(GrpcConstants.IS_BIDI_STREAMING, false);
        return streamingConnection;
    }

    /**
     * Executes bidirectional streaming blocking call.
     *
     * @param requestHeaders request headers.
     * @param methodDescriptor method descriptor.
     * @param context Data Context.
     */
    public BObject executeBidirectionalStreaming(HttpHeaders requestHeaders, MethodDescriptor methodDescriptor,
                                                 DataContext context) {
        ClientCall call = new ClientCall(getConnector(), createOutboundRequest(requestHeaders), methodDescriptor,
                context);
        ClientCallStreamObserver streamObserver = new ClientCallStreamObserver(call);
        Stub.StreamingCallListener streamingCallListener = new Stub.StreamingCallListener(true);
        call.start(streamingCallListener);

        BObject streamingConnection = ValueCreator.createObjectValue(getModule(), GrpcConstants.STREAMING_CLIENT);
        streamingConnection.addNativeData(GrpcConstants.REQUEST_SENDER, streamObserver);
        streamingConnection.addNativeData(GrpcConstants.REQUEST_MESSAGE_DEFINITION,
                methodDescriptor.getSchemaDescriptor().getInputType());

        streamingConnection.addNativeData(GrpcConstants.MESSAGE_QUEUE, streamingCallListener.getMessageQueue());
        streamingConnection.addNativeData(GrpcConstants.HEADERS, streamingCallListener.getHeaderMap());
        streamingConnection.addNativeData(GrpcConstants.IS_BIDI_STREAMING, true);
        return streamingConnection;
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
            BArray inboundResponse = null;
            if (status.isOk()) {
                if (value == null) {
                    // No value received so mark the future as an error
                    httpConnectorError = MessageUtils.getConnectorError(Status.Code.INTERNAL.toStatus()
                            .withDescription("No value received for unary call").asRuntimeException());
                } else {
                    Object responseBValue = value.getbMessage();
                    // Set response headers, when response headers exists in the message context.
                    BMap headerMap = createHeaderMap(value.getHeaders());
                    BArray contentTuple = ValueCreator.createTupleValue(
                            TypeCreator.createTupleType(Arrays.asList(PredefinedTypes.TYPE_ANYDATA,
                                    headerMap.getType())));
                    contentTuple.add(0, responseBValue);
                    contentTuple.add(1, headerMap);
                    inboundResponse = contentTuple;
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
        BMap headerMap = null;
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

            if (!firstResponseReceived) {
                // Set response headers, when response headers exists in the message context.
                headerMap = createHeaderMap(message.getHeaders());
                firstResponseReceived = true;
            }
            messageQueue.add(message);
        }

        @Override
        public void onClose(Status status, HttpHeaders trailers) {
            if (status.isOk()) {
                messageQueue.add(new Message(GrpcConstants.COMPLETED_MESSAGE, null));
            } else {
                messageQueue.add(new Message(status.asRuntimeException()));
            }
        }

        BlockingQueue<Message> getMessageQueue() {
            return messageQueue;
        }

        BMap getHeaderMap() {
            return headerMap;
        }
    }

    /**
     *  Callbacks for receiving headers, response messages, and completion status in streaming calls.
     */
    private static final class ServerStreamingCallListener implements Listener {

        private final DataContext dataContext;
        BlockingQueue<Message> messageQueue;
        private boolean firstResponseReceived;
        Object responseBValue;
        Type streamType = TypeCreator.createStreamType(PredefinedTypes.TYPE_ANYDATA);

        // Non private to avoid synthetic class
        ServerStreamingCallListener(DataContext dataContext) {
            this.messageQueue = new LinkedBlockingQueue<>();
            this.dataContext = dataContext;

            BObject streamIterator = ValueCreator.createObjectValue(getModule(),
                    GrpcConstants.ITERATOR_OBJECT_NAME, new Object[1]);
            streamIterator.addNativeData(GrpcConstants.MESSAGE_QUEUE, messageQueue);
            responseBValue = ValueCreator.createStreamValue(
                    TypeCreator.createStreamType(PredefinedTypes.TYPE_ANYDATA), streamIterator);
        }

        @Override
        public void onHeaders(HttpHeaders headers) {
            // Headers are processed at client connector listener. Do not need to further process.
        }

        @Override
        public void onMessage(Message message) {
            messageQueue.add(message);
            if (!firstResponseReceived) {
                // Set response headers, when response headers exists in the message context.
                BMap headerMap = createHeaderMap(message.getHeaders());

                BArray contentTuple = ValueCreator.createTupleValue(
                        TypeCreator.createTupleType(Arrays.asList(streamType,
                                headerMap.getType())));
                contentTuple.add(0, responseBValue);
                contentTuple.add(1, headerMap);
                dataContext.getFuture().complete(contentTuple);
                firstResponseReceived = true;
            }
        }

        @Override
        public void onClose(Status status, HttpHeaders trailers) {
            if (status.isOk()) {
                messageQueue.add(new Message(GrpcConstants.COMPLETED_MESSAGE, null));
            } else {
                messageQueue.add(new Message(status.asRuntimeException()));
            }
            if (!firstResponseReceived) {
                // Set response headers, when response headers exists in the message context.
                BMap headerMap = createHeaderMap(trailers);
                BArray contentTuple = ValueCreator.createTupleValue(
                        TypeCreator.createTupleType(Arrays.asList(streamType,
                                headerMap.getType())));
                contentTuple.add(0, responseBValue);
                contentTuple.add(1, headerMap);
                dataContext.getFuture().complete(contentTuple);
            }
        }
    }

    private static final class ClientCallStreamObserver implements CallStreamObserver {

        private final ClientCall call;

        // Non private to avoid synthetic class
        ClientCallStreamObserver(ClientCall call) {
            this.call = call;
        }

        @Override
        public void onNext(Message value) {
            if (value.getHeaders() != null) {
                call.injectHeaders(value.getHeaders());
            }
            call.sendMessage(value);
        }

        @Override
        public void onError(Message error) {
            call.cancel("Cancelled by client with StreamObserver.onError()", error.getError());
        }

        @Override
        public void onCompleted() {
            call.halfClose();
        }

        @Override
        public boolean isReady() {
            return call.isReady();
        }

        @Override
        public void setMessageCompression(boolean enable) {
            call.setMessageCompression(enable);
        }

    }
}
