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
package org.ballerinalang.net.grpc.nativeimpl.client;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.Module;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.internal.values.ValueCreator;
import org.ballerinalang.net.grpc.MethodDescriptor;
import org.ballerinalang.net.grpc.nativeimpl.ModuleUtils;
import org.ballerinalang.net.grpc.stubs.Stub;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import java.util.HashMap;

import static org.ballerinalang.net.grpc.GrpcConstants.METHOD_DESCRIPTORS;
import static org.ballerinalang.net.grpc.GrpcConstants.SERVICE_STUB;
import static org.ballerinalang.net.grpc.util.TestUtils.getBObject;
import static org.ballerinalang.net.grpc.util.TestUtils.getValueCreatorWithErrorValue;
import static org.testng.Assert.assertEquals;

/**
 * Interface to initiate processing of incoming remote calls.
 * <p>
 * Referenced from grpc-java implementation.
 * <p>
 * @since 0.980.0
 */
public class FunctionUtilsTest {
    
    private Module module;
    ValueCreator valueCreator;
    
    @BeforeTest()
    public void setupEnvironment() {
        module = new Module("testOrg", "test", "1.2");
        valueCreator = getValueCreatorWithErrorValue();
        ValueCreator.addValueCreator("testOrg", "test", "1.2", valueCreator);
        ModuleUtils.setModule(new Environment(null, module));
    }

    @Test()
    public void testExternInitStubNullRootDescriptor() {
        BObject genericEndpoint = getBObject();
        Object result = FunctionUtils.externInitStub(genericEndpoint, null, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(), "Error while initializing connector. " +
                "message descriptor keys not exist. Please check the generated sub file");
    }

    @Test()
    public void testExternExecuteSimpleRPCNullClientEndpoint() {
        Object result = FunctionUtils.externExecuteSimpleRPC(null, null, null, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while getting connector. gRPC client connector is not initialized properly");
    }

    @Test()
    public void testExternExecuteSimpleRPCNullConnectionStub() {
        BObject clientEndpoint = getBObject();

        Object result = FunctionUtils.externExecuteSimpleRPC(null, clientEndpoint, null, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while getting connection stub. gRPC Client connector is not initialized properly");
    }

    @Test()
    public void testExternExecuteSimpleRPCNullMethodName() {
        BObject clientEndpoint = getBObject();
        clientEndpoint.addNativeData(SERVICE_STUB, new Stub(null, null));

        Object result = FunctionUtils.externExecuteSimpleRPC(null, clientEndpoint, null, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while processing the request. RPC endpoint doesn't set properly");
    }

    @Test()
    public void testExternExecuteSimpleRPCNullDescriptor() {
        BObject clientEndpoint = getBObject();
        clientEndpoint.addNativeData(SERVICE_STUB, new Stub(null, null));
        BString methodName = StringUtils.fromString("test");

        Object result = FunctionUtils.externExecuteSimpleRPC(null, clientEndpoint, methodName, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while processing the request. method descriptors doesn't set properly");
    }

    @Test()
    public void testExternExecuteServerStreamingNullClientEndpoint() {
        Object result = FunctionUtils.externExecuteServerStreaming(null, null, null, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while getting connector. gRPC Client connector is not initialized properly");

    }

    @Test()
    public void testExternExecuteServerStreamingNullConnectionStub() {
        BObject clientEndpoint = getBObject();
        
        Object result = FunctionUtils.externExecuteServerStreaming(null, clientEndpoint, null, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while getting connection stub. gRPC Client connector is not initialized properly");

    }

    @Test()
    public void testExternExecuteServerStreamingNullMethodName() {
        BObject clientEndpoint = getBObject();
        clientEndpoint.addNativeData(SERVICE_STUB, new Stub(null, null));

        Object result = FunctionUtils.externExecuteServerStreaming(null, clientEndpoint, null, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while processing the request. RPC endpoint doesn't set properly");
    }

    @Test()
    public void testExternExecuteServerStreamingNullDescriptor() {
        BObject clientEndpoint = getBObject();
        clientEndpoint.addNativeData(SERVICE_STUB, new Stub(null, null));
        BString methodName = StringUtils.fromString("test");

        Object result = FunctionUtils.externExecuteServerStreaming(null, clientEndpoint, methodName, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while processing the request. method descriptors doesn't set properly");
    }

    @Test()
    public void testExternExecuteServerStreamingNullMethodDescriptor() {
        BObject clientEndpoint = getBObject();
        clientEndpoint.addNativeData(SERVICE_STUB, new Stub(null, null));
        clientEndpoint.addNativeData(METHOD_DESCRIPTORS, new HashMap<String, MethodDescriptor>());
        BString methodName = StringUtils.fromString("test");

        Object result = FunctionUtils.externExecuteServerStreaming(null, clientEndpoint, methodName, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "No registered method descriptor for '" + methodName.getValue() + "'");
    }

    @Test()
    public void testExternExecuteClientStreamingNullClientEndpoint() {
        Object result = FunctionUtils.externExecuteClientStreaming(null, null, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while getting connector. gRPC Client connector is not initialized properly");

    }

    @Test()
    public void testExternExecuteClientStreamingNullConnectionStub() {
        BObject clientEndpoint = getBObject();

        Object result = FunctionUtils.externExecuteClientStreaming(null, clientEndpoint, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while getting connection stub. gRPC Client connector is not initialized properly");

    }

    @Test()
    public void testExternExecuteClientStreamingNullMethodName() {
        BObject clientEndpoint = getBObject();
        clientEndpoint.addNativeData(SERVICE_STUB, new Stub(null, null));

        Object result = FunctionUtils.externExecuteClientStreaming(null, clientEndpoint, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while processing the request. RPC endpoint doesn't set properly");
    }

    @Test()
    public void testExternExecuteClientStreamingNullDescriptor() {
        BObject clientEndpoint = getBObject();
        clientEndpoint.addNativeData(SERVICE_STUB, new Stub(null, null));
        BString methodName = StringUtils.fromString("test");

        Object result = FunctionUtils.externExecuteClientStreaming(null, clientEndpoint, methodName, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while processing the request. method descriptors doesn't set properly");
    }

    @Test()
    public void testExternExecuteClientStreamingNullMethodDescriptor() {
        BObject clientEndpoint = getBObject();
        clientEndpoint.addNativeData(SERVICE_STUB, new Stub(null, null));
        clientEndpoint.addNativeData(METHOD_DESCRIPTORS, new HashMap<String, MethodDescriptor>());
        BString methodName = StringUtils.fromString("test");

        Object result = FunctionUtils.externExecuteClientStreaming(null, clientEndpoint, methodName, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "No registered method descriptor for '" + methodName.getValue() + "'");
    }

    @Test()
    public void testExternExecuteBidirectionalStreamingNullClientEndpoint() {
        Object result = FunctionUtils.externExecuteBidirectionalStreaming(null, null, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while getting connector. gRPC Client connector is not initialized properly");

    }

    @Test()
    public void testExternExecuteBidirectionalStreamingNullConnectionStub() {
        BObject clientEndpoint = getBObject();

        Object result = FunctionUtils.externExecuteBidirectionalStreaming(null, clientEndpoint, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while getting connection stub. gRPC Client connector is not initialized properly");

    }

    @Test()
    public void testExternExecuteBidirectionalStreamingNullMethodName() {
        BObject clientEndpoint = getBObject();
        clientEndpoint.addNativeData(SERVICE_STUB, new Stub(null, null));

        Object result = FunctionUtils.externExecuteBidirectionalStreaming(null, clientEndpoint, null, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while processing the request. RPC endpoint doesn't set properly");
    }

    @Test()
    public void testExternExecuteBidirectionalStreamingNullDescriptor() {
        BObject clientEndpoint = getBObject();
        clientEndpoint.addNativeData(SERVICE_STUB, new Stub(null, null));
        BString methodName = StringUtils.fromString("test");

        Object result = FunctionUtils.externExecuteBidirectionalStreaming(null, clientEndpoint, methodName, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "Error while processing the request. method descriptors doesn't set properly");
    }

    @Test()
    public void testExternExecuteBidirectionalStreamingNullMethodDescriptor() {
        BObject clientEndpoint = getBObject();
        clientEndpoint.addNativeData(SERVICE_STUB, new Stub(null, null));
        clientEndpoint.addNativeData(METHOD_DESCRIPTORS, new HashMap<String, MethodDescriptor>());
        BString methodName = StringUtils.fromString("test");

        Object result = FunctionUtils.externExecuteBidirectionalStreaming(null, clientEndpoint, methodName, null);
        assertEquals(((BError) result).getErrorMessage().getValue(),
                "No registered method descriptor for '" + methodName.getValue() + "'");
    }

}
