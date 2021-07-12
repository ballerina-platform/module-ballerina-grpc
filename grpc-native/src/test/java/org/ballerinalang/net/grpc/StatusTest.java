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
package org.ballerinalang.net.grpc;

import org.testng.Assert;
import org.testng.annotations.Test;

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
            Assert.assertEquals(e.getMessage(), "Cause is null");
        }
    }
}
