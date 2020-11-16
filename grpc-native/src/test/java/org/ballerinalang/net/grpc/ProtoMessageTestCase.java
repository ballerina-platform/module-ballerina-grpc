/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package org.ballerinalang.net.grpc;

import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.Module;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import org.ballerinalang.net.grpc.protobuf.exception.CodeGeneratorException;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static io.ballerina.runtime.api.constants.RuntimeConstants.ANON_ORG;
import static io.ballerina.runtime.api.constants.RuntimeConstants.DOT;

/**
 * Test class for Proto message.
 *
 * @since 0.982.0
 */
public class ProtoMessageTestCase {

    private File compilerFile;
    private Module defaultPkg = new Module(ANON_ORG, DOT);

    @BeforeClass
    private void setup() throws Exception {
        compilerFile = ProtoDescriptorUtils.getProtocCompiler();
        Path resourceDir = Paths.get("src", "test", "resources").toAbsolutePath();
        Path protoPath = resourceDir.resolve(Paths.get("grpc", "src", "tool", "testMessage.proto"));
        //read message descriptor from proto file.
        readMessageDescriptor(protoPath);

        Path balFilePath = Paths.get("src", "test", "resources", "grpc", "src", "tool", "testMessage_pb.bal");
    }

    @Test(description = "Test case for parsing proto message with string field")
    public void testStringTypeProtoMessage() {
        // convert message to byte array.
        BMap<BString, Object> bBMap = ValueCreator.createRecordValue(defaultPkg, "Test1");
        bBMap.put(StringUtils.fromString("name"), StringUtils.fromString("John"));
        Message message = new Message("Test1", bBMap);
        Assert.assertEquals(message.getSerializedSize(), 6);
        byte[] msgArray = message.toByteArray();
        //convert byte array back to message object.
        InputStream messageStream = new ByteArrayInputStream(msgArray);
        Message message1 = ProtoUtils.marshaller(new MessageParser("Test1", TypeCreator.createRecordType("Test1",
                new Module(null, ".", null), 0, false, 0))).parse(messageStream);
        Assert.assertEquals(message1.toString(), message.toString());
        Assert.assertFalse(message1.isError());
    }

    @Test(description = "Test case for parsing proto message with primitive field")
    public void testPrimitiveTypeProtoMessage() {
        // convert message to byte array.
        BMap<BString, Object> bBMap = ValueCreator.createRecordValue(defaultPkg, "Test2");
        bBMap.put(StringUtils.fromString("a"), StringUtils.fromString("John"));
        bBMap.put(StringUtils.fromString("b"), 1.2D);
        bBMap.put(StringUtils.fromString("c"), 2.5D);
        bBMap.put(StringUtils.fromString("d"), 1);
        bBMap.put(StringUtils.fromString("e"), 2L);
        bBMap.put(StringUtils.fromString("f"), 3L);
        bBMap.put(StringUtils.fromString("g"), 4);
        bBMap.put(StringUtils.fromString("h"), 5L);

        Message message = new Message("Test2", bBMap);
        Assert.assertEquals(message.getSerializedSize(), 40);
        byte[] msgArray = message.toByteArray();
        //convert byte array back to message object.
        InputStream messageStream = new ByteArrayInputStream(msgArray);
        Message message1 = ProtoUtils.marshaller(new MessageParser("Test2", TypeCreator.createRecordType("Test2",
                new Module(null, ".", null), 0, false, 0))).parse(messageStream);
        Assert.assertEquals(message1.toString(), message.toString());
        Assert.assertFalse(message1.isError());
    }

    @Test(description = "Test case for parsing proto message with array field")
    public void testArrayFieldTypeProtoMessage() {
        // convert message to byte array.
        BMap<BString, Object> bBMap = ValueCreator.createRecordValue(defaultPkg, "Test3");
        bBMap.put(StringUtils.fromString("a"), ValueCreator.createArrayValue(new BString[]{StringUtils.fromString(
                "John")}));
        bBMap.put(StringUtils.fromString("b"), ValueCreator.createArrayValue(new double[]{1.2}));
        bBMap.put(StringUtils.fromString("c"), ValueCreator.createArrayValue(new double[]{2.5F}));
        bBMap.put(StringUtils.fromString("d"), ValueCreator.createArrayValue(new long[]{1}));
        bBMap.put(StringUtils.fromString("e"), ValueCreator.createArrayValue(new long[]{2L}));
        bBMap.put(StringUtils.fromString("f"), ValueCreator.createArrayValue(new long[]{3L}));
        bBMap.put(StringUtils.fromString("g"), ValueCreator.createArrayValue(new long[]{4}));
        bBMap.put(StringUtils.fromString("h"), ValueCreator.createArrayValue(new long[]{5L}));
        Message message = new Message("Test3", bBMap);
        Assert.assertEquals(message.getSerializedSize(), 40);
        byte[] msgArray = message.toByteArray();
        //convert byte array back to message object.
        InputStream messageStream = new ByteArrayInputStream(msgArray);
        Message message1 = ProtoUtils.marshaller(new MessageParser("Test3", TypeCreator.createRecordType("Test3",
                new Module(null, ".", null), 0, false, 0))).parse(messageStream);
        Assert.assertEquals(((BMap<String, Object>) message1.getbMessage()).size(), bBMap.size());
        Assert.assertFalse(message1.isError());
    }

    private void readMessageDescriptor(Path protoPath)
            throws IOException, Descriptors.DescriptorValidationException, CodeGeneratorException {
        DescriptorProtos.FileDescriptorSet descriptorSet = ProtoDescriptorUtils.getProtoFileDescriptor(compilerFile,
                protoPath.toString());
        DescriptorProtos.FileDescriptorProto fileDescriptorProto = descriptorSet.getFile(0);
        Descriptors.FileDescriptor fileDescriptor = Descriptors.FileDescriptor.buildFrom(fileDescriptorProto, new
                Descriptors.FileDescriptor[0]);
        Assert.assertEquals(fileDescriptor.getMessageTypes().size(), 3);
        MessageRegistry messageRegistry = MessageRegistry.getInstance();
        for (Descriptors.Descriptor messageDescriptor : fileDescriptor.getMessageTypes()) {
            messageRegistry.addMessageDescriptor(messageDescriptor.getName(), messageDescriptor);
        }
    }

    @AfterClass
    private void clear() throws Exception {
        Files.deleteIfExists(compilerFile.toPath());
    }
}
