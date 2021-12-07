/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package io.ballerina.stdlib.grpc;

import io.ballerina.runtime.observability.ObservabilityConstants;
import io.ballerina.runtime.observability.ObserveUtils;
import io.ballerina.runtime.observability.ObserverContext;
import io.ballerina.stdlib.http.transport.contract.exceptions.ClientConnectorException;
import io.ballerina.stdlib.http.transport.message.HttpCarbonMessage;

import static io.ballerina.stdlib.http.api.HttpConstants.RESPONSE_STATUS_CODE_FIELD;

/**
 * Observable Client Connector Listener.
 *
 * @since 1.0.4
 */
public class ObservableClientConnectorListener extends ClientConnectorListener {
    private final DataContext context;

    public ObservableClientConnectorListener(ClientCall.ClientStreamListener streamListener, DataContext context,
                                             Long maxInboundMsgSize) {
        super(streamListener, maxInboundMsgSize);
        this.context = context;
    }

    @Override
    public void onMessage(HttpCarbonMessage httpCarbonMessage) {
        Integer statusCode = (Integer) httpCarbonMessage.getProperty(RESPONSE_STATUS_CODE_FIELD.getValue());
        addHttpStatusCode(statusCode == null ? 0 : statusCode);
        super.onMessage(httpCarbonMessage);
    }

    @Override
    public void onError(Throwable throwable) {
        if (throwable instanceof ClientConnectorException) {
            ClientConnectorException clientConnectorException = (ClientConnectorException) throwable;
            addHttpStatusCode(clientConnectorException.getHttpStatusCode());
            ObserverContext observerContext =
                    ObserveUtils.getObserverContextOfCurrentFrame(context.getEnvironment());
            if (observerContext != null) {
                observerContext.addTag(ObservabilityConstants.TAG_KEY_ERROR, ObservabilityConstants.TAG_TRUE_VALUE);
            }

        }
        super.onError(throwable);
    }

    private void addHttpStatusCode(int statusCode) {
        ObserverContext observerContext = ObserveUtils.getObserverContextOfCurrentFrame(context.getEnvironment());
        if (observerContext != null) {
            observerContext.addProperty(ObservabilityConstants.PROPERTY_KEY_HTTP_STATUS_CODE, statusCode);
        }
    }
}
