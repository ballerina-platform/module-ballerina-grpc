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
package io.ballerina.stdlib.grpc;

import org.testng.annotations.Test;

import static org.testng.Assert.assertEquals;
import static org.testng.Assert.fail;

/**
 * Interface to initiate processing of incoming remote calls.
 * <p>
 * Referenced from grpc-java implementation.
 * <p>
 * @since 0.980.0
 */
public class StatusTest {

    @Test(description = "Test which will read text records from a given channel using async io framework")
    public void testFromThrowable() {
        try {
            Status.fromThrowable(null);
            fail();
        } catch (IllegalArgumentException e) {
            assertEquals(e.getMessage(), "Cause is null");
        }
        Throwable t = new IllegalStateException();
        t.initCause(new IllegalArgumentException());
        Status status = Status.fromThrowable(t);
        assertEquals(status.getDescription(), null);
    }

    @Test(description = "Test which will read text records from a given channel using async io framework")
    public void testFromCodeValueInt() {
        Status status = Status.fromCodeValue(-1);
        assertEquals(status.getDescription(), "Unknown code -1");
        status = Status.fromCodeValue(19);
        assertEquals(status.getDescription(), "Unknown code 19");
    }

    @Test(description = "Test which will read text records from a given channel using async io framework")
    public void testFromCodeValueSlow() {
        byte[] asciiCodeValue = {'a'};
        Status status = Status.CODE_MARSHALLER.parseAsciiString(asciiCodeValue);
        assertEquals(status.getDescription(), "Unknown code a");
        asciiCodeValue = new byte[]{'a', 'b'};
        status = Status.CODE_MARSHALLER.parseAsciiString(asciiCodeValue);
        assertEquals(status.getDescription(), "Unknown code ab");
    }

    @Test()
    public void testAugmentDescription() {
        Status status = Status.fromCodeValue(Status.Code.OK.value());
        Status result = status.augmentDescription(null);
        assertEquals(result, status);

        result = status.augmentDescription("Additional description");
        assertEquals(result.getDescription(), "Additional description");

        status = status.withDescription("StatusOK");
        result = status.augmentDescription("Additional description");
        assertEquals(result.getDescription(), "StatusOK\nAdditional description");
    }

    @Test()
    public void testToString() {
        Status status = Status.fromCodeValue(Status.Code.OK.value());
        status = status.withDescription("StatusOK");
        assertEquals(status.toString(), "Status{ code OK, description StatusOK, cause null}");
    }

    @Test()
    public void testToAsciiString() {
        byte[] bytes = Status.MESSAGE_MARSHALLER.toAsciiString("Test~String");
        assertEquals(new String(bytes), "Test%7EString");
    }

    @Test()
    public void testWithCause() {
        Throwable throwable = new IllegalArgumentException("Illegal test argument");
        Status status = Status.fromThrowable(throwable);
        Status result = status.withCause(throwable);
        assertEquals(result, status);
    }
}
