package io.ballerina.stdlib.grpc;

import io.ballerina.stdlib.grpc.exception.GrpcServerException;
import org.testng.annotations.Test;

import static org.testng.Assert.assertEquals;

/**
 * Interface to initiate processing of incoming remote calls.
 * <p>
 * Referenced from grpc-java implementation.
 * <p>
 * @since 0.980.0
 */
public class ServerServiceDefinitionTest {

    @Test()
    public void testServerServiceDefinitionNullServiceName() {
        try {
            ServerServiceDefinition.Builder builder = ServerServiceDefinition.builder(null);
        } catch (GrpcServerException e) {
            assertEquals(e.getMessage(), "Service Name cannot be null");
        }
    }

    @Test()
    public void testServerServiceDefinitionNullServiceDescriptor() {
        try {
            ServerServiceDefinition.Builder builder = ServerServiceDefinition.builder("TestService");
            builder.addMethod(null, null);
        } catch (GrpcServerException e) {
            assertEquals(e.getMessage(), "Method Descriptor cannot be null");
        }
    }

    @Test()
    public void testServerServiceDefinitionNullServerCallHandler() {
        try {
            ServerServiceDefinition.Builder builder = ServerServiceDefinition.builder("TestService");
            MethodDescriptor.Builder methodBuilder = MethodDescriptor.newBuilder();
            methodBuilder = methodBuilder.setFullMethodName("TestMethod");
            MethodDescriptor descriptor = methodBuilder.build();
            builder.addMethod(descriptor, null);
        } catch (GrpcServerException e) {
            assertEquals(e.getMessage(), "Server call handler cannot be null");
        }
    }
}
