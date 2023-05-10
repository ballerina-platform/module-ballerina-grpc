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

import com.google.protobuf.InvalidProtocolBufferException;
import org.mockito.Mockito;
import org.testng.annotations.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import static org.testng.Assert.assertEquals;
import static org.testng.Assert.fail;

/**
 * A test class to test ProtoInputStream class functions.
 */
public class ProtoInputStreamTest {

    @Test()
    public void testReadWithExceptionMessage() {
        Message message = new Message(new IllegalStateException("Illegal test case"));
        ProtoInputStream pis = new ProtoInputStream(message);
        assertEquals(pis.read(), -1);
    }

    @Test()
    public void testReadBytesWithExceptionMessage() {
        Message message = new Message(new IllegalStateException("Illegal test case"));
        ProtoInputStream pis = new ProtoInputStream(message);
        try {
            assertEquals(pis.read("Test input stream".getBytes(), 1, 4), -1);
        } catch (IOException e) {
            fail(e.getMessage());
        }
    }

    @Test()
    public void testMessageNullCase() {
        ProtoInputStream pis = new ProtoInputStream(null);
        try {
            pis.message();
            fail();
        } catch (IllegalStateException e) {
            assertEquals(e.getMessage(), "message not available");
        }
        Message message = new Message(new IllegalStateException("Illegal test case"));
        pis = new ProtoInputStream(message);
        assertEquals(pis.message(), message);
    }

    @Test()
    public void testMessageReadNullCase() {
        ProtoInputStream pis = new ProtoInputStream(null);
        int result = pis.read();
        assertEquals(result, -1);
    }

    @Test()
    public void testMessageReadSpecificLocationNullCase() {
        ProtoInputStream pis = new ProtoInputStream(null);
        byte[] b = {};
        int result = 0;
        try {
            result = pis.read(b, 0, 2);
        } catch (IOException e) {
            fail(e.getMessage());
        }
        assertEquals(result, -1);
    }

    @Test(enabled = false)
    public void testMessageReadSpecificLocationReadPartialCase() throws InvalidProtocolBufferException {
        Message m = Mockito.mock(Message.class);
        ProtoInputStream pis = new ProtoInputStream(m);

        Mockito.when(m.getSerializedSize()).thenReturn(4);

        byte[] b = {};
        int result = 0;
        try {
            result = pis.read("Test".getBytes(StandardCharsets.UTF_8), 0, 6);
        } catch (IOException e) {
            fail(e.getMessage());
        }
        assertEquals(result, -1);
    }

    @Test()
    public void testAvailableWithExceptionMessage() throws InvalidProtocolBufferException {
        Message message = new Message(new IllegalStateException("Illegal test case"));
        ProtoInputStream pis = new ProtoInputStream(message);
        assertEquals(pis.available(), 0);
    }
}
