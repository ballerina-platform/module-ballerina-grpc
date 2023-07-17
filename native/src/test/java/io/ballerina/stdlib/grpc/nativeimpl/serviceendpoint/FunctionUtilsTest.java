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

package io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint;

import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.stdlib.grpc.nativeimpl.ModuleUtils;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import static io.ballerina.stdlib.grpc.ServicesBuilderUtils.fileDescriptorHashMapByFilename;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.externGetAllExtensionNumbersOfType;
import static io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint.FunctionUtils.externGetFileContainingExtension;

/**
 * A test class to test FunctionUtils class functions.
 */
public class FunctionUtilsTest {

    @Test()
    public void testExternGetFileContainingExtensionStaticMapUsageCase() {
        Descriptors.FileDescriptor fileDescriptor = Mockito.mock(Descriptors.FileDescriptor.class);
        List<Descriptors.FieldDescriptor> fieldDescriptors = new ArrayList<>();
        Descriptors.FieldDescriptor fieldDescriptor = Mockito.mock(Descriptors.FieldDescriptor.class);
        fieldDescriptors.add(fieldDescriptor);
        Descriptors.Descriptor descriptor = Mockito.mock(Descriptors.Descriptor.class);
        DescriptorProtos.FileDescriptorProto proto = Mockito.mock(DescriptorProtos.FileDescriptorProto.class);
        Mockito.when(fieldDescriptor.getContainingType()).thenReturn(descriptor);
        Mockito.when(fieldDescriptor.getNumber()).thenReturn(12);
        Mockito.when(descriptor.getFullName()).thenReturn("TestMessage");
        Mockito.when(fileDescriptor.getExtensions()).thenReturn(fieldDescriptors);
        Mockito.when(fileDescriptor.toProto()).thenReturn(proto);
        Mockito.when(proto.toByteArray()).thenReturn("bytes".getBytes(StandardCharsets.UTF_8));
        fileDescriptorHashMapByFilename.put("TestFile", fileDescriptor);
        BMap bMap = Mockito.mock(BMap.class);
        try (MockedStatic<ValueCreator> mockedStatic = Mockito.mockStatic(ValueCreator.class)) {
            mockedStatic.when(() -> ValueCreator.createRecordValue(ModuleUtils.getModule(),
                    "FileDescriptorResponse")).thenReturn(bMap);
            mockedStatic.when(() -> ValueCreator.createArrayValue(fileDescriptor.toProto().toByteArray()))
                    .thenReturn(null);

            Object result = externGetFileContainingExtension(StringUtils.fromString("TestMessage"), 12);
            Assert.assertTrue(result instanceof BMap);
        }
    }

    @Test()
    public void testExternGetAllExtensionNumbersOfTypeStaticMapUsageCase() {
        Descriptors.FileDescriptor fileDescriptor = Mockito.mock(Descriptors.FileDescriptor.class);
        List<Descriptors.FieldDescriptor> fieldDescriptors = new ArrayList<>();
        Descriptors.FieldDescriptor fieldDescriptor = Mockito.mock(Descriptors.FieldDescriptor.class);
        fieldDescriptors.add(fieldDescriptor);
        Descriptors.Descriptor descriptor = Mockito.mock(Descriptors.Descriptor.class);
        Mockito.when(fieldDescriptor.getContainingType()).thenReturn(descriptor);
        Mockito.when(fieldDescriptor.getNumber()).thenReturn(10);
        Mockito.when(descriptor.getFullName()).thenReturn("TestMessage");
        Mockito.when(fileDescriptor.getExtensions()).thenReturn(fieldDescriptors);
        fileDescriptorHashMapByFilename.put("TestFile", fileDescriptor);
        BMap bMap = Mockito.mock(BMap.class);
        BArray extensionArray = ValueCreator.createArrayValue(TypeCreator.createArrayType(PredefinedTypes.TYPE_INT));
        try (MockedStatic<ValueCreator> mockedStatic = Mockito.mockStatic(ValueCreator.class)) {
            mockedStatic.when(() -> ValueCreator.createRecordValue(ModuleUtils.getModule(),
                    "ExtensionNumberResponse")).thenReturn(bMap);
            mockedStatic.when(() -> ValueCreator.createArrayValue(TypeCreator
                    .createArrayType(PredefinedTypes.TYPE_INT))).thenReturn(extensionArray);

            Object result = externGetAllExtensionNumbersOfType(StringUtils.fromString("TestMessage"));
            Assert.assertTrue(result instanceof BMap);
        }
    }

}
