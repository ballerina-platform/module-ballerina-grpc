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

package io.ballerina.stdlib.grpc.util;

import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.types.Field;
import io.ballerina.runtime.api.types.ObjectType;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.stdlib.grpc.nativeimpl.ModuleUtils;
import org.mockito.Mockito;

import java.util.HashMap;
import java.util.Map;

/**
 * A util class to be used for native tests.
 */
public class TestUtils {

    public static BObject getBObject(Map<String, Field> fieldMap) {
        BObject bObject = Mockito.mock(BObject.class);
        HashMap<String, Object> nativeData = new HashMap();
        if (fieldMap != null) {
            ObjectType type = TypeCreator.createObjectType("testObjectType", ModuleUtils.getModule(), 0);
            type.setFields(fieldMap);
            Mockito.when(bObject.getType()).thenReturn(type);
        }
        Mockito.doAnswer(invocation -> {
            String key = invocation.getArgument(0);
            Object value = invocation.getArgument(1);
            nativeData.put(key, value);
            return null;
        }).when(bObject).addNativeData(Mockito.anyString(), Mockito.any());

        Mockito.when(bObject.getNativeData()).thenReturn(nativeData);
        Mockito.when(bObject.getNativeData(Mockito.anyString())).thenAnswer(i -> nativeData.get(i.getArguments()[0]));
        Mockito.when(bObject.getMapValue(Mockito.any(BString.class))).thenAnswer(i ->
                nativeData.get(((BString) i.getArguments()[0]).getValue()));
        Mockito.when(bObject.getStringValue(Mockito.any(BString.class))).thenAnswer(i ->
                nativeData.get(((BString) i.getArguments()[0]).getValue()));
        return bObject;
    }
}
