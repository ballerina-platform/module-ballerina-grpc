/*
 *  Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
 *
 *  WSO2 LLC. licenses this file to you under the Apache License,
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

import org.mockito.Mockito;
import org.testng.Assert;
import org.testng.annotations.Test;

import static io.ballerina.stdlib.grpc.GrpcConstants.MESSAGE_ACCEPT_ENCODING;

/**
 * A test class to test ServerCall class functions.
 */
public class ServerCallTest {

    @Test()
    public void testServerCallReadHeadersNegative() {
        InboundMessage im = Mockito.mock(InboundMessage.class);
        OutboundMessage om = Mockito.mock(OutboundMessage.class);
        Status status = Status.fromCode(Status.Code.CANCELLED);
        Mockito.when(im.getHeader(MESSAGE_ACCEPT_ENCODING)).thenReturn("Test");
        ServerCall serverCall = new ServerCall(im, om, null, null, null, null);
        serverCall.close(status, null);
        try {
            serverCall.close(status, null);
        } catch (Exception e) {
            Assert.assertEquals(e.getMessage(), "CANCELLED: Call already closed.");
        }
    }

}
