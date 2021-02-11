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

import io.ballerina.runtime.api.async.Callback;
import io.ballerina.runtime.api.values.BError;
import org.ballerinalang.net.grpc.Message;
import org.ballerinalang.net.grpc.Status;
import org.ballerinalang.net.grpc.StreamObserver;
import org.ballerinalang.net.grpc.exception.StatusRuntimeException;

import java.util.concurrent.Semaphore;

import static org.ballerinalang.net.grpc.GrpcConstants.STATUS_ERROR_MAP;
import static org.ballerinalang.net.grpc.GrpcConstants.getKeyByValue;

/**
 * Abstract call back class registered for gRPC service in B7a executor.
 *
 * @since 0.995.0
 */
public class AbstractCallableUnitCallBack implements Callback {

    public final Semaphore available = new Semaphore(1, true);

    @Override
    public void notifySuccess(Object o) {
        available.release();
    }

    @Override
    public void notifyFailure(io.ballerina.runtime.api.values.BError error) {
        available.release();
    }

    /**
     * Handles failures in GRPC callable unit callback.
     *
     * @param streamObserver observer used the send the error back
     * @param error          error message struct
     */
    static void handleFailure(StreamObserver streamObserver, BError error) {
        Integer statusCode = getKeyByValue(STATUS_ERROR_MAP, error.getType().getName());
        if (statusCode == null) {
            statusCode = Status.Code.INTERNAL.value();
        }
        if (streamObserver != null) {
            streamObserver.onError(new Message(new StatusRuntimeException(Status.fromCodeValue(statusCode)
                    .withDescription(error.getErrorMessage().getValue()))));
        }
    }
}
