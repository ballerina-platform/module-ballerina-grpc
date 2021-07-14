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

import io.ballerina.stdlib.http.transport.message.HttpCarbonMessage;
import org.testng.annotations.Test;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

import static io.ballerina.stdlib.grpc.MessageUtils.createHttpCarbonMessage;
import static org.testng.Assert.fail;

/**
 * A test class to test MessageFramer class functions.
 */
public class MessageFramerTest {

    @Test(description = "Code coverage identifies MessageFramer class as a new file and does not show " +
            "testerina code coverage. This test is added to trigger the code coverage.")
    public void testWritePayload() {
        HttpCarbonMessage result = createHttpCarbonMessage(false);
        MessageFramer framer = new MessageFramer(result);
        framer.setMessageCompression(false);
        InputStream stream = new ByteArrayInputStream("Test Message".getBytes());
        try {
            framer.writePayload(stream);
            framer.flush();
            framer.close();
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test(description = "Code coverage identifies MessageFramer class as a new file and does not show " +
            "testerina code coverage. This test is added to trigger the code coverage.")
    public void testWritePayloadWithCompression() {
        HttpCarbonMessage result = createHttpCarbonMessage(false);
        Compressor compressor = new Codec.Identity.Gzip();
        MessageFramer framer = new MessageFramer(result);
        framer.setCompressor(compressor);
        framer.setMessageCompression(true);
        try {
            InputStream stream = new ByteArrayInputStream("Test Message".getBytes());
            framer.writePayload(stream);
            framer.flush();
            framer.dispose();
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }
}
