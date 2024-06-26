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
package io.ballerina.stdlib.grpc;

import io.ballerina.runtime.observability.ObserverContext;
import io.ballerina.stdlib.grpc.exception.StatusRuntimeException;
import io.ballerina.stdlib.grpc.listener.ServerCallHandler;
import io.ballerina.stdlib.http.transport.contract.exceptions.ServerConnectorException;
import io.netty.handler.codec.http.DefaultHttpHeaders;
import io.netty.handler.codec.http.HttpHeaders;

import java.io.InputStream;
import java.util.Map;

import static io.ballerina.stdlib.grpc.GrpcConstants.MAX_INBOUND_MESSAGE_SIZE;

/**
 * Encapsulates a single call received from a remote client.
 * A call will receive zero or more request messages from the client and send zero or more response messages back.
 *
 * <p>
 * Referenced from grpc-java implementation.
 * <p>
 *
 * @since 0.980.0
 */
public final class ServerCall {

    /**
     * The accepted message encodings (i.e. compression) that can be used in the stream.
     */
    private static final String MESSAGE_ACCEPT_ENCODING = "grpc-accept-encoding";

    private static final String TOO_MANY_RESPONSES = "Too many responses";
    private static final String MISSING_RESPONSE = "Completed without a response";

    private final InboundMessage inboundMessage;
    private final OutboundMessage outboundMessage;
    private final MethodDescriptor method;

    private volatile boolean cancelled;
    private boolean sendHeadersCalled;
    private boolean closeCalled;
    private boolean messageSent;
    private Compressor compressor;
    private final String messageAcceptEncoding;
    private ObserverContext context = null;
    private Map<String, Long> messageSizeMap;

    private DecompressorRegistry decompressorRegistry;
    private CompressorRegistry compressorRegistry;

    ServerCall(InboundMessage inboundMessage, OutboundMessage outboundMessage, MethodDescriptor method,
               DecompressorRegistry decompressorRegistry, CompressorRegistry compressorRegistry,
               Map<String, Long> messageSizeMap) {
        this.inboundMessage = inboundMessage;
        this.outboundMessage = outboundMessage;
        this.method = method;
        this.decompressorRegistry = decompressorRegistry;
        this.compressorRegistry = compressorRegistry;
        this.messageAcceptEncoding = inboundMessage.getHeader(MESSAGE_ACCEPT_ENCODING);
        this.messageSizeMap = messageSizeMap;
    }

    public void sendHeaders(HttpHeaders headers) {
        if (sendHeadersCalled) {
            throw new IllegalStateException("sendHeaders has already been called");
        }
        if (closeCalled) {
            throw new IllegalStateException("call is closed");
        }
        outboundMessage.removeHeader(GrpcConstants.MESSAGE_ENCODING);

        if (headers != null && headers.contains(GrpcConstants.MESSAGE_ENCODING)) {
            compressor = compressorRegistry.lookupCompressor(headers.get(GrpcConstants.MESSAGE_ENCODING));
            if (compressor == null) {
                compressor = Codec.Identity.NONE;
            }
        } else {
            compressor = Codec.Identity.NONE;
        }
        // Always put compressor, even if it's identity.
        outboundMessage.setHeader(GrpcConstants.MESSAGE_ENCODING, compressor.getMessageEncoding());
        outboundMessage.framer().setCompressor(compressor);
        outboundMessage.removeHeader(MESSAGE_ACCEPT_ENCODING);
        String advertisedEncodings = String.join(",", decompressorRegistry.getAdvertisedMessageEncodings());
        outboundMessage.setHeader(MESSAGE_ACCEPT_ENCODING, advertisedEncodings);
        if (headers != null) {
            outboundMessage.addHeaders(headers);
        }
        try {
            // Send response headers.
            inboundMessage.respond(outboundMessage.getResponseMessage());
        } catch (ServerConnectorException e) {
            throw Status.Code.CANCELLED.toStatus().withCause(e).withDescription("Failed to send response headers. "
                    + e.getMessage()).asRuntimeException();
        }
        sendHeadersCalled = true;
    }

    public void sendMessage(Message message) {
        if (!sendHeadersCalled) {
            throw Status.Code.CANCELLED.toStatus().withDescription("Response headers has not been sent properly.")
                    .asRuntimeException();
        }
        if (closeCalled) {
            throw Status.Code.CANCELLED.toStatus().withDescription("Call already closed.")
                    .asRuntimeException();
        }
        if (method.getType().serverSendsOneMessage() && messageSent) {
            outboundMessage.complete(Status.Code.INTERNAL.toStatus().withDescription(TOO_MANY_RESPONSES), new
                    DefaultHttpHeaders());
            return;
        }

        try {
            InputStream resp = method.streamResponse(message);
            outboundMessage.sendMessage(resp);
            messageSent = true;
        } catch (StatusRuntimeException ex) {
            close(ex.getStatus(), new DefaultHttpHeaders());
        } catch (Exception e) {
            close(Status.fromThrowable(e), new DefaultHttpHeaders());
        }
    }

    void setObserverContext(ObserverContext context) {
        this.context = context;
    }

    public ObserverContext getObserverContext() {
        return context;
    }

    public void setMessageCompression(boolean enable) {
        outboundMessage.setMessageCompression(enable);
    }

    public boolean isReady() {
        return outboundMessage.isReady();
    }

    public void close(Status status, HttpHeaders trailers) {
        if (closeCalled) {
            throw Status.Code.CANCELLED.toStatus().withDescription("Call already closed.")
                    .asRuntimeException();
        }
        closeCalled = true;

        if (status.isOk() && method.getType().serverSendsOneMessage() && !messageSent) {
            outboundMessage.complete(Status.Code.INTERNAL.toStatus().withDescription(MISSING_RESPONSE), new
                    DefaultHttpHeaders());
            return;
        }
        outboundMessage.complete(status, trailers);
    }

    public boolean isCancelled() {
        return cancelled;
    }

    ServerStreamListener newServerStreamListener(ServerCallHandler.Listener listener) {
        return new ServerStreamListener(this, listener, messageSizeMap);
    }

    public MethodDescriptor getMethodDescriptor() {
        return method;
    }

    public HttpHeaders getHeaders() {
        return inboundMessage.getHeaders();
    }

    /**
     * Server Stream Listener instance.
     */
    public static final class ServerStreamListener implements StreamListener {

        private final ServerCall call;
        private final ServerCallHandler.Listener listener;
        private Map<String, Long> messageSizeMap;

        ServerStreamListener(ServerCall call, ServerCallHandler.Listener listener, Map<String, Long> messageSizeMap) {
            this.call = call;
            this.listener = listener;
            this.messageSizeMap = messageSizeMap;
        }

        @Override
        public void messagesAvailable(final InputStream message) {
            if (call.cancelled) {
                MessageUtils.closeQuietly(message);
                return;
            }
            try {
                Message request = call.method.parseRequest(message, messageSizeMap.get(MAX_INBOUND_MESSAGE_SIZE));
                request.setHeaders(call.inboundMessage.getHeaders());
                listener.onMessage(request);
            } catch (StatusRuntimeException ex) {
                throw ex;
            } catch (Exception ex) {
                throw Status.Code.CANCELLED.toStatus().withCause(ex).withDescription("Failed to dispatch inbound " +
                        "message. " + ex.getMessage()).asRuntimeException();
            } finally {
                MessageUtils.closeQuietly(message);
            }
        }

        public void halfClosed() {
            if (call.cancelled) {
                return;
            }
            listener.onHalfClose();
        }

        public void closed(Status status) {
            if (status.isOk()) {
                listener.onComplete();
            } else {
                call.cancelled = true;
                listener.onCancel(new Message(status.asRuntimeException()));
            }
        }
    }
}
