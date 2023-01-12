package io.ballerina.stdlib.grpc;

import com.google.protobuf.Descriptors;
import org.mockito.Mockito;
import org.testng.Assert;
import org.testng.annotations.Test;

/**
 * A test class to test MessageRegistry class functions.
 */
public class MessageRegistryTest {

    @Test()
    public void testMessageRegistryGetFileDescriptor() {
        MessageRegistry messageRegistry = MessageRegistry.getInstance();
        Descriptors.FileDescriptor mockFileDescriptor = Mockito.mock(Descriptors.FileDescriptor.class);
        messageRegistry.setFileDescriptor(mockFileDescriptor);
        Descriptors.FileDescriptor fileDescriptor = messageRegistry.getFileDescriptor();
        Assert.assertEquals(fileDescriptor, mockFileDescriptor);
    }
}
