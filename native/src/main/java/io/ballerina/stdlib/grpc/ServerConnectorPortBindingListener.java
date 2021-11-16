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

import io.ballerina.stdlib.http.transport.contract.PortBindingEventListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static io.ballerina.stdlib.grpc.GrpcConstants.HTTPS_ENDPOINT_STARTED;
import static io.ballerina.stdlib.grpc.GrpcConstants.HTTPS_ENDPOINT_STOPPED;
import static io.ballerina.stdlib.grpc.GrpcConstants.HTTP_ENDPOINT_STARTED;
import static io.ballerina.stdlib.grpc.GrpcConstants.HTTP_ENDPOINT_STOPPED;

/**
 * Server Connector Port Binding Listener.
 *
 * @since 0.980.0
 */
public class ServerConnectorPortBindingListener implements PortBindingEventListener {

    private static final Logger log = LoggerFactory.getLogger(ServerConnectorPortBindingListener.class);

    public void onOpen(String serverConnectorId, boolean isHttps) {

        if (log.isDebugEnabled()) {
            String message = isHttps ? HTTPS_ENDPOINT_STARTED : HTTP_ENDPOINT_STARTED;
            log.debug(message + serverConnectorId);
        }
    }

    public void onClose(String serverConnectorId, boolean isHttps) {

        if (log.isDebugEnabled()) {
            String message = isHttps ? HTTPS_ENDPOINT_STOPPED : HTTP_ENDPOINT_STOPPED;
            log.debug(message + serverConnectorId);
        }
    }

    public void onError(Throwable throwable) {
        log.error("Error in http endpoint", throwable);
    }
}
