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

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

import static io.ballerina.stdlib.grpc.ProtoUtils.copy;
import static org.testng.Assert.assertEquals;
import static org.testng.Assert.fail;

/**
 * A test class to test ProtoUtils class functions.
 */
public class ProtoUtilsTest {

    @Test()
    public void testCopy() {
        String s = "Test gRPC native";
        InputStream is = new ByteArrayInputStream(s.getBytes(StandardCharsets.UTF_8));
        OutputStream os = new ByteArrayOutputStream();
        try {
            long result = copy(is, os);
            assertEquals(result, s.length());
        } catch (IOException e) {
            fail(e.getMessage());
        }
    }
}
