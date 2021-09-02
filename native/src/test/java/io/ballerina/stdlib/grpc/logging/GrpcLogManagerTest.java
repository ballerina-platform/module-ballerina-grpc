/*
 * Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.grpc.logging;

import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.stdlib.grpc.logging.formatters.GrpcAccessLogFormatter;
import io.ballerina.stdlib.grpc.logging.formatters.GrpcTraceLogFormatter;
import io.ballerina.stdlib.grpc.logging.formatters.JsonLogFormatter;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import java.io.File;
import java.io.IOException;
import java.net.ServerSocket;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.SocketHandler;

import static io.ballerina.stdlib.grpc.GrpcConstants.GRPC_LOG_CONSOLE;
import static io.ballerina.stdlib.grpc.GrpcConstants.GRPC_LOG_FILE_PATH;
import static io.ballerina.stdlib.grpc.GrpcConstants.GRPC_TRACE_LOG_HOST;
import static io.ballerina.stdlib.grpc.GrpcConstants.GRPC_TRACE_LOG_PORT;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.testng.Assert.assertEquals;
import static org.testng.Assert.assertTrue;

/**
 * A unit test class for gRPC module GrpcLogManager class functions.
 */
public class GrpcLogManagerTest {

    File tempLogTestFile;
    public static final int SOCKET_SERVER_PORT = 8001;

    @BeforeClass
    public void setup() throws IOException {

        tempLogTestFile = File.createTempFile("logTestFile", ".txt");
    }

    @Test
    public void testGrpcLogManagerWithTraceLogConsole1() {

        BMap traceLogAdvancedConfig = mock(BMap.class);
        when(traceLogAdvancedConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(true);
        BString traceFilePath = mock(BString.class);
        BString host = mock(BString.class);
        BString accessFilePath = mock(BString.class);
        long port = 0;
        when(traceFilePath.getValue()).thenReturn("");
        when(accessFilePath.getValue()).thenReturn("");
        when(host.getValue()).thenReturn("testHost");
        when(traceLogAdvancedConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(traceFilePath);
        when(traceLogAdvancedConfig.getStringValue(GRPC_TRACE_LOG_HOST)).thenReturn(host);
        when(traceLogAdvancedConfig.getIntValue(GRPC_TRACE_LOG_PORT)).thenReturn(port);

        BMap accessLogConfig = mock(BMap.class);
        when(accessLogConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        when(accessLogConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(accessFilePath);

        GrpcLogManager grpcLogManager = new GrpcLogManager(false, traceLogAdvancedConfig, accessLogConfig);
        Handler[] handlers = grpcLogManager.grpcTraceLogger.getHandlers();
        assertTrue(handlers.length > 0);
        Handler handler = handlers[handlers.length - 1];
        assertTrue(handler instanceof ConsoleHandler);
        assertTrue(handler.getFormatter() instanceof GrpcTraceLogFormatter);
        assertEquals(Level.FINEST, handler.getLevel());
    }

    @Test
    public void testGrpcLogManagerWithTraceLogConsole2() {

        BMap traceLogAdvancedConfig = mock(BMap.class);
        when(traceLogAdvancedConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        BString traceFilePath = mock(BString.class);
        BString host = mock(BString.class);
        BString accessFilePath = mock(BString.class);
        long port = 0;
        when(traceFilePath.getValue()).thenReturn("");
        when(accessFilePath.getValue()).thenReturn("");
        when(host.getValue()).thenReturn("testHost");
        when(traceLogAdvancedConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(traceFilePath);
        when(traceLogAdvancedConfig.getStringValue(GRPC_TRACE_LOG_HOST)).thenReturn(host);
        when(traceLogAdvancedConfig.getIntValue(GRPC_TRACE_LOG_PORT)).thenReturn(port);

        BMap accessLogConfig = mock(BMap.class);
        when(accessLogConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        when(accessLogConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(accessFilePath);

        GrpcLogManager grpcLogManager = new GrpcLogManager(true, traceLogAdvancedConfig, accessLogConfig);
        Handler[] handlers = grpcLogManager.grpcTraceLogger.getHandlers();
        assertTrue(handlers.length > 0);
        Handler handler = handlers[handlers.length - 1];
        assertTrue(handler instanceof ConsoleHandler);
        assertTrue(handler.getFormatter() instanceof GrpcTraceLogFormatter);
        assertEquals(Level.FINEST, handler.getLevel());
    }

    @Test
    public void testGrpcLogManagerWithTraceLogConsole3() {

        BMap traceLogAdvancedConfig = mock(BMap.class);
        when(traceLogAdvancedConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(true);
        BString traceFilePath = mock(BString.class);
        BString host = mock(BString.class);
        BString accessFilePath = mock(BString.class);
        long port = 0;
        when(traceFilePath.getValue()).thenReturn("");
        when(accessFilePath.getValue()).thenReturn("");
        when(host.getValue()).thenReturn("testHost");
        when(traceLogAdvancedConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(traceFilePath);
        when(traceLogAdvancedConfig.getStringValue(GRPC_TRACE_LOG_HOST)).thenReturn(host);
        when(traceLogAdvancedConfig.getIntValue(GRPC_TRACE_LOG_PORT)).thenReturn(port);

        BMap accessLogConfig = mock(BMap.class);
        when(accessLogConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        when(accessLogConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(accessFilePath);

        GrpcLogManager grpcLogManager = new GrpcLogManager(true, traceLogAdvancedConfig, accessLogConfig);
        Handler[] handlers = grpcLogManager.grpcTraceLogger.getHandlers();
        assertTrue(handlers.length > 0);
        Handler handler = handlers[handlers.length - 1];
        assertTrue(handler instanceof ConsoleHandler);
        assertTrue(handler.getFormatter() instanceof GrpcTraceLogFormatter);
        assertEquals(Level.FINEST, handler.getLevel());
    }

    @Test
    public void testGrpcLogManagerWithTraceLogFile() {

        BMap traceLogAdvancedConfig = mock(BMap.class);
        when(traceLogAdvancedConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        BString traceFilePath = mock(BString.class);
        BString host = mock(BString.class);
        BString accessFilePath = mock(BString.class);
        String path = tempLogTestFile.getPath();
        long port = SOCKET_SERVER_PORT;
        when(traceFilePath.getValue()).thenReturn(path);
        when(accessFilePath.getValue()).thenReturn("");
        when(host.getValue()).thenReturn("");
        when(traceLogAdvancedConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(traceFilePath);
        when(traceLogAdvancedConfig.getStringValue(GRPC_TRACE_LOG_HOST)).thenReturn(host);
        when(traceLogAdvancedConfig.getIntValue(GRPC_TRACE_LOG_PORT)).thenReturn(port);

        BMap accessLogConfig = mock(BMap.class);
        when(accessLogConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        when(accessLogConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(accessFilePath);

        GrpcLogManager grpcLogManager = new GrpcLogManager(false, traceLogAdvancedConfig, accessLogConfig);
        Handler[] handlers = grpcLogManager.grpcTraceLogger.getHandlers();
        assertTrue(handlers.length > 0);
        Handler handler = handlers[handlers.length - 1];
        assertTrue(handler instanceof FileHandler);
        assertTrue(handler.getFormatter() instanceof GrpcTraceLogFormatter);
        assertEquals(Level.FINEST, handler.getLevel());
    }

    @Test
    public void testGrpcLogManagerWithTraceLogSocket() throws IOException {

        BMap traceLogAdvancedConfig = mock(BMap.class);
        when(traceLogAdvancedConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        BString traceFilePath = mock(BString.class);
        BString host = mock(BString.class);
        BString accessFilePath = mock(BString.class);
        long port = SOCKET_SERVER_PORT;
        ServerSocket serverSocket = new ServerSocket(SOCKET_SERVER_PORT);
        when(traceFilePath.getValue()).thenReturn("");
        when(accessFilePath.getValue()).thenReturn("");
        when(host.getValue()).thenReturn("localhost");
        when(traceLogAdvancedConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(traceFilePath);
        when(traceLogAdvancedConfig.getStringValue(GRPC_TRACE_LOG_HOST)).thenReturn(host);
        when(traceLogAdvancedConfig.getIntValue(GRPC_TRACE_LOG_PORT)).thenReturn(port);

        BMap accessLogConfig = mock(BMap.class);
        when(accessLogConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        when(accessLogConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(accessFilePath);

        GrpcLogManager grpcLogManager = new GrpcLogManager(false, traceLogAdvancedConfig, accessLogConfig);
        Handler[] handlers = grpcLogManager.grpcTraceLogger.getHandlers();
        assertTrue(handlers.length > 0);
        Handler handler = handlers[handlers.length - 1];
        assertTrue(handler instanceof SocketHandler);
        assertTrue(handler.getFormatter() instanceof JsonLogFormatter);
        assertEquals(Level.FINEST, handler.getLevel());
        serverSocket.close();
    }

    @Test
    public void testGrpcLogManagerWithAccessLogConsole() {

        BMap traceLogAdvancedConfig = mock(BMap.class);
        when(traceLogAdvancedConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        BString traceFilePath = mock(BString.class);
        BString host = mock(BString.class);
        BString accessFilePath = mock(BString.class);
        long port = 0;
        when(traceFilePath.getValue()).thenReturn("");
        when(accessFilePath.getValue()).thenReturn("");
        when(host.getValue()).thenReturn("");
        when(traceLogAdvancedConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(traceFilePath);
        when(traceLogAdvancedConfig.getStringValue(GRPC_TRACE_LOG_HOST)).thenReturn(host);
        when(traceLogAdvancedConfig.getIntValue(GRPC_TRACE_LOG_PORT)).thenReturn(port);

        BMap accessLogConfig = mock(BMap.class);
        when(accessLogConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(true);
        when(accessLogConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(accessFilePath);

        GrpcLogManager grpcLogManager = new GrpcLogManager(false, traceLogAdvancedConfig, accessLogConfig);
        assertEquals(grpcLogManager.grpcAccessLogger.getLevel(), Level.INFO);
        Handler[] handlers = grpcLogManager.grpcAccessLogger.getHandlers();
        assertTrue(handlers.length > 0);
        Handler handler = handlers[handlers.length - 1];
        assertTrue(handler instanceof ConsoleHandler);
        assertTrue(handler.getFormatter() instanceof GrpcAccessLogFormatter);
        assertEquals(Level.INFO, handler.getLevel());
    }

    @Test
    public void testGrpcLogManagerWithAccessLogFile() {

        BMap traceLogAdvancedConfig = mock(BMap.class);
        when(traceLogAdvancedConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        BString traceFilePath = mock(BString.class);
        BString host = mock(BString.class);
        BString accessFilePath = mock(BString.class);
        String path = tempLogTestFile.getPath();
        long port = 0;
        when(traceFilePath.getValue()).thenReturn("");
        when(accessFilePath.getValue()).thenReturn(path);
        when(host.getValue()).thenReturn("");
        when(traceLogAdvancedConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(traceFilePath);
        when(traceLogAdvancedConfig.getStringValue(GRPC_TRACE_LOG_HOST)).thenReturn(host);
        when(traceLogAdvancedConfig.getIntValue(GRPC_TRACE_LOG_PORT)).thenReturn(port);

        BMap accessLogConfig = mock(BMap.class);
        when(accessLogConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        when(accessLogConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(accessFilePath);

        GrpcLogManager grpcLogManager = new GrpcLogManager(false, traceLogAdvancedConfig, accessLogConfig);
        assertEquals(grpcLogManager.grpcAccessLogger.getLevel(), Level.INFO);
        Handler[] handlers = grpcLogManager.grpcAccessLogger.getHandlers();
        assertTrue(handlers.length > 0);
        Handler handler = handlers[handlers.length - 1];
        assertTrue(handler instanceof FileHandler);
        assertTrue(handler.getFormatter() instanceof GrpcAccessLogFormatter);
        assertEquals(Level.INFO, handler.getLevel());
    }

    @Test(expectedExceptions = RuntimeException.class,
            expectedExceptionsMessageRegExp = "Failed to setup gRPC trace log file: /test/logTestFile.txt")
    public void testGrpcLogManagerWithInvalidTraceLogFilePath() {

        BMap traceLogAdvancedConfig = mock(BMap.class);
        when(traceLogAdvancedConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        BString traceFilePath = mock(BString.class);
        BString host = mock(BString.class);
        BString accessFilePath = mock(BString.class);
        String path = "/test/logTestFile.txt";
        long port = 0;
        when(traceFilePath.getValue()).thenReturn(path);
        when(accessFilePath.getValue()).thenReturn("");
        when(host.getValue()).thenReturn("");
        when(traceLogAdvancedConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(traceFilePath);
        when(traceLogAdvancedConfig.getStringValue(GRPC_TRACE_LOG_HOST)).thenReturn(host);
        when(traceLogAdvancedConfig.getIntValue(GRPC_TRACE_LOG_PORT)).thenReturn(port);

        BMap accessLogConfig = mock(BMap.class);
        when(accessLogConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        when(accessLogConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(accessFilePath);

        GrpcLogManager grpcLogManager = new GrpcLogManager(false, traceLogAdvancedConfig, accessLogConfig);
    }

    @Test(expectedExceptions = RuntimeException.class,
            expectedExceptionsMessageRegExp = "Failed to connect to testHost:8080")
    public void testGrpcLogManagerWithNonExistingSocket() {

        BMap traceLogAdvancedConfig = mock(BMap.class);
        when(traceLogAdvancedConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        BString traceFilePath = mock(BString.class);
        BString host = mock(BString.class);
        BString accessFilePath = mock(BString.class);
        long port = 8080;
        when(traceFilePath.getValue()).thenReturn("");
        when(accessFilePath.getValue()).thenReturn("");
        when(host.getValue()).thenReturn("testHost");
        when(traceLogAdvancedConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(traceFilePath);
        when(traceLogAdvancedConfig.getStringValue(GRPC_TRACE_LOG_HOST)).thenReturn(host);
        when(traceLogAdvancedConfig.getIntValue(GRPC_TRACE_LOG_PORT)).thenReturn(port);

        BMap accessLogConfig = mock(BMap.class);
        when(accessLogConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        when(accessLogConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(accessFilePath);

        GrpcLogManager grpcLogManager = new GrpcLogManager(false, traceLogAdvancedConfig, accessLogConfig);
    }

    @Test(expectedExceptions = RuntimeException.class,
            expectedExceptionsMessageRegExp = "Failed to setup gRPC access log file: /test/logTestFile.txt")
    public void testGrpcLogManagerWithInvalidAccessLogPath() {

        BMap traceLogAdvancedConfig = mock(BMap.class);
        when(traceLogAdvancedConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        BString traceFilePath = mock(BString.class);
        BString host = mock(BString.class);
        BString accessFilePath = mock(BString.class);
        String path = "/test/logTestFile.txt";
        long port = 0;
        when(traceFilePath.getValue()).thenReturn("");
        when(accessFilePath.getValue()).thenReturn(path);
        when(host.getValue()).thenReturn("");
        when(traceLogAdvancedConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(traceFilePath);
        when(traceLogAdvancedConfig.getStringValue(GRPC_TRACE_LOG_HOST)).thenReturn(host);
        when(traceLogAdvancedConfig.getIntValue(GRPC_TRACE_LOG_PORT)).thenReturn(port);

        BMap accessLogConfig = mock(BMap.class);
        when(accessLogConfig.getBooleanValue(GRPC_LOG_CONSOLE)).thenReturn(false);
        when(accessLogConfig.getStringValue(GRPC_LOG_FILE_PATH)).thenReturn(accessFilePath);

        GrpcLogManager grpcLogManager = new GrpcLogManager(false, traceLogAdvancedConfig, accessLogConfig);
    }

    @AfterClass
    public void cleanUp() throws IOException {

        tempLogTestFile.deleteOnExit();
    }

}
