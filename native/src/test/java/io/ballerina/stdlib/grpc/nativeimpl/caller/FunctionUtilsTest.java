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

package io.ballerina.stdlib.grpc.nativeimpl.caller;

import io.ballerina.runtime.api.values.BObject;
import io.ballerina.stdlib.grpc.GrpcConstants;
import org.mockito.Mockito;
import org.testng.Assert;
import org.testng.annotations.Test;

/**
 * A test class to test FunctionUtils class functions.
 */
public class FunctionUtilsTest {

    @Test()
    public void testExternIsCancelledErrorCase() {
        BObject endpointClient = Mockito.mock(BObject.class);
        Mockito.when(endpointClient.getNativeData(GrpcConstants.RESPONSE_MESSAGE_DEFINITION)).thenReturn(new Object());
        boolean result = FunctionUtils.externIsCancelled(endpointClient);
        Assert.assertFalse(result);
    }
}
