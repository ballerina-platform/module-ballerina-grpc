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

import io.ballerina.runtime.observability.ObserveUtils;
import io.ballerina.runtime.observability.ObserverContext;
import io.ballerina.stdlib.grpc.exception.StatusRuntimeException;
import io.ballerina.stdlib.grpc.stubs.AbstractStub;
import io.ballerina.stdlib.http.transport.contract.Constants;
import io.ballerina.stdlib.http.transport.contract.HttpClientConnector;
import io.ballerina.stdlib.http.transport.contract.HttpResponseFuture;
import io.netty.handler.codec.http.DefaultHttpHeaders;
import io.netty.handler.codec.http.HttpHeaders;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.util.Map;
import java.util.concurrent.CancellationException;

import static io.ballerina.stdlib.grpc.GrpcConstants.CONTENT_TYPE_KEY;
import static io.ballerina.stdlib.grpc.GrpcConstants.MAX_INBOUND_MESSAGE_SIZE;
import static io.ballerina.stdlib.grpc.GrpcConstants.MESSAGE_ACCEPT_ENCODING;
import static io.ballerina.stdlib.grpc.GrpcConstants.MESSAGE_ENCODING;
import static io.ballerina.stdlib.grpc.GrpcConstants.TE_KEY;

/**
 * This class handles a call to a remote method.
 * A call will send zero or more request messages to the server and receive zero or more response messages back.
 *
 * <p>
 * Referenced from grpc-java implementation.
 * <p>
 *
 * @since 0.980.0
 */
public final class ClientCall {

    private static final Logger log = LoggerFactory.getLogger(ClientCall.class);
    private final MethodDescriptor method;
    private final boolean unaryRequest;
    private HttpClientConnector connector;
    private DataContext context;
    private final OutboundMessage outboundMessage;
    private ClientConnectorListener connectorListener;
    private boolean cancelCalled;
    private boolean halfCloseCalled;
    private Map<String, Long> messageSizeMap;
    private DecompressorRegistry decompressorRegistry = DecompressorRegistry.getDefaultInstance();
    private CompressorRegistry compressorRegistry = CompressorRegistry.getDefaultInstance();

    public ClientCall(HttpClientConnector connector, OutboundMessage outboundMessage, MethodDescriptor method,
                      DataContext context, Map<String, Long> messageSizeMap) {
        this.method = method;
        this.unaryRequest = method.getType() == MethodDescriptor.MethodType.UNARY
                || method.getType() == MethodDescriptor.MethodType.SERVER_STREAMING;
        this.connector = connector;
        this.context = context;
        this.outboundMessage = outboundMessage;
        this.messageSizeMap = messageSizeMap;
    }

    private void prepareHeaders(
            Compressor compressor) {
        ObserverContext observerContext = ObserveUtils.getObserverContextOfCurrentFrame(context.getEnvironment());
        outboundMessage.removeHeader(MESSAGE_ENCODING);
        if (compressor != Codec.Identity.NONE) {
            outboundMessage.setHeader(MESSAGE_ENCODING, compressor.getMessageEncoding());
        }
        String advertisedEncodings = String.join(",", decompressorRegistry.getAdvertisedMessageEncodings());
        outboundMessage.setHeader(MESSAGE_ACCEPT_ENCODING, advertisedEncodings);
        if (observerContext != null) {
            outboundMessage.getHeaders().entries().forEach(
                    x -> observerContext.addTag(x.getKey(), x.getValue()));
        }
        outboundMessage.setProperty(Constants.TO, "/" + method.getFullMethodName());
        outboundMessage.setHttpMethod();
        outboundMessage.setHttpVersion("2.0");
        outboundMessage.setHeader(CONTENT_TYPE_KEY, GrpcConstants.CONTENT_TYPE_GRPC);
        outboundMessage.setHeader(TE_KEY, GrpcConstants.TE_TRAILERS);
    }

    public void injectHeaders(HttpHeaders headers) {
        if (this.outboundMessage != null) {
            if (headers != null) {
                headers.forEach(entry -> this.outboundMessage.setHeader(entry.getKey(), entry.getValue()));
            }
        }
    }

    /**
     * Start a call, using {@code responseListener} for processing response messages.
     *
     * @param observer response listener instance
     */
    public void start(final AbstractStub.Listener observer) {
        if (connectorListener != null) {
            throw new IllegalStateException("Client connection already set up.");
        }
        if (cancelCalled) {
            throw new IllegalStateException("Client call was cancelled.");
        }
        Compressor compressor;
        String compressorName = outboundMessage.getHeader("grpc-encoding");
        if (compressorName != null) {
            compressor = compressorRegistry.lookupCompressor(compressorName);
            if (compressor == null) {
                closeObserver(
                        observer,
                        Status.Code.INTERNAL.toStatus().withDescription(
                                String.format("Unable to find compressor by name %s", compressorName)),
                        new DefaultHttpHeaders());

                return;
            }
        } else {
            compressor = Codec.Identity.NONE;
        }
        prepareHeaders(compressor);
        ClientStreamListener clientStreamListener = new ClientStreamListener(observer);
        connectorListener = ObserveUtils.isObservabilityEnabled() ?
                new ObservableClientConnectorListener(clientStreamListener, context,
                        messageSizeMap.get(MAX_INBOUND_MESSAGE_SIZE)) :
                new ClientConnectorListener(clientStreamListener, messageSizeMap.get(MAX_INBOUND_MESSAGE_SIZE));
        outboundMessage.framer().setCompressor(compressor);
        connectorListener.setDecompressorRegistry(decompressorRegistry);
        HttpResponseFuture responseFuture = connector.send(outboundMessage.getResponseMessage());
        responseFuture.setHttpConnectorListener(connectorListener);
    }

    /**
     * Prevent any further processing for the remote call.
     *
     * @param message error message
     * @param cause Throwable
     */
    public void cancel(String message, Throwable cause) {
        if (message == null && cause == null) {
            cause = new CancellationException("Cancelled without a message or cause");
            log.error("Cancelling without a message or cause is suboptimal", cause);
        }
        if (cancelCalled) {
            return;
        }
        cancelCalled = true;
        if (outboundMessage != null) {
            Status status = Status.Code.CANCELLED.toStatus();
            if (cause instanceof StatusRuntimeException) {
                status = ((StatusRuntimeException) cause).getStatus();
            } else {
                if (message != null) {
                    status = status.withDescription(message);
                } else {
                    status = status.withDescription("Call cancelled without message");
                }
                if (cause != null) {
                    status = status.withCause(cause);
                }
            }
            outboundMessage.sendError(status);
        }
    }

    /**
     * Close the call for request message sending. Incoming response messages are unaffected.
     */
    public void halfClose() {
        if (outboundMessage == null) {
            throw new IllegalStateException("Client call did not start properly.");
        }
        if (cancelCalled) {
            throw new IllegalStateException("Client call was cancelled.");
        }
        if (halfCloseCalled) {
            throw new IllegalStateException("Client call was already closed.");
        }
        halfCloseCalled = true;
        outboundMessage.halfClose();
    }

    /**
     * Send a request message to the server.
     *
     * @param message Request message.
     */
    public void sendMessage(Message message) {
        if (connectorListener == null) {
            throw Status.Code.INTERNAL.toStatus().withDescription("Connector listener didn't initialize properly.")
                    .asRuntimeException();
        }
        if (cancelCalled) {
            throw Status.Code.INTERNAL.toStatus().withDescription("Client call was already cancelled.")
                    .asRuntimeException();
        }
        if (halfCloseCalled) {
            throw Status.Code.INTERNAL.toStatus().withDescription("Client call was already closed.")
                    .asRuntimeException();
        }
        try {
            InputStream resp = method.streamRequest(message);
            outboundMessage.sendMessage(resp);
        } catch (StatusRuntimeException ex) {
            throw ex;
        } catch (Exception ex) {
            throw Status.Code.CANCELLED.toStatus().withCause(ex)
                    .withDescription("Failed to send the message. " + ex.getMessage()).asRuntimeException();
        }
        // For unary requests, halfClose call should be coming soon.
        if (!unaryRequest) {
            outboundMessage.flush();
        }
    }

    /**
     * Enables per-message compression.
     *
     * @param enabled enable flag
     */
    public void setMessageCompression(boolean enabled) {
        if (outboundMessage == null) {
            throw Status.Code.INTERNAL.toStatus().withDescription("Client call did not initiate properly.")
                    .asRuntimeException();
        }
        outboundMessage.setMessageCompression(enabled);
    }

    private void closeObserver(AbstractStub.Listener observer, Status status, HttpHeaders trailers) {
        observer.onClose(status, trailers);
    }

    public boolean isReady() {
        return outboundMessage.isReady();
    }

    /**
     * Client Stream Listener instance.
     */
    public class ClientStreamListener implements StreamListener {

        private final AbstractStub.Listener observer;
        private boolean closed;
        private HttpHeaders responseHeaders;

        ClientStreamListener(AbstractStub.Listener observer) {
            this.observer = observer;
        }

        public void headersRead(final HttpHeaders headers) {
            try {
                if (closed) {
                    return;
                }
                responseHeaders = headers;
                observer.onHeaders(headers);
            } catch (Exception ex) {
                Status status = Status.Code.CANCELLED.toStatus().withCause(ex).withDescription("Failed to read " +
                        "headers. " + ex.getMessage());
                close(status, new DefaultHttpHeaders());
            }
        }

        @Override
        public void messagesAvailable(final InputStream message) {
            if (closed) {
                MessageUtils.closeQuietly(message);
                return;
            }
            try {
                Message responseMessage = method.parseResponse(message, messageSizeMap.get(MAX_INBOUND_MESSAGE_SIZE));
                responseMessage.setHeaders(responseHeaders);
                observer.onMessage(responseMessage);
                message.close();
            } catch (Exception ex) {
                MessageUtils.closeQuietly(message);
                Status status = Status.Code.CANCELLED.toStatus().withCause(ex).withDescription("Failed to read " +
                        "message. " + ex.getMessage());
                close(status, new DefaultHttpHeaders());
            }
        }

        private void close(Status status, HttpHeaders trailers) {
            closed = true;
            closeObserver(observer, status, trailers);
        }

        public void closed(Status status, HttpHeaders trailers) {
            if (closed) {
                return;
            }
            close(status, trailers);
        }

        public void cancelCall(Throwable cause) {
            cancel(cause.getMessage(), cause);
        }
    }
}
