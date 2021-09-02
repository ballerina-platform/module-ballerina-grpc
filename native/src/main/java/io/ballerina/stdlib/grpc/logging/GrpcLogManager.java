/*
 * Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.grpc.logging;

import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.stdlib.grpc.logging.formatters.GrpcAccessLogFormatter;
import io.ballerina.stdlib.grpc.logging.formatters.GrpcTraceLogFormatter;
import io.ballerina.stdlib.grpc.logging.formatters.JsonLogFormatter;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.LogManager;
import java.util.logging.Logger;
import java.util.logging.SocketHandler;

import static io.ballerina.stdlib.grpc.GrpcConstants.GRPC_LOG_CONSOLE;
import static io.ballerina.stdlib.grpc.GrpcConstants.GRPC_LOG_FILE_PATH;
import static io.ballerina.stdlib.grpc.GrpcConstants.GRPC_TRACE_LOG_HOST;
import static io.ballerina.stdlib.grpc.GrpcConstants.GRPC_TRACE_LOG_PORT;
import static io.ballerina.stdlib.grpc.GrpcConstants.HTTP_ACCESS_LOG;
import static io.ballerina.stdlib.grpc.GrpcConstants.HTTP_ACCESS_LOG_ENABLED;
import static io.ballerina.stdlib.grpc.GrpcConstants.HTTP_TRACE_LOG;
import static io.ballerina.stdlib.grpc.GrpcConstants.HTTP_TRACE_LOG_ENABLED;

/**
 * Java util logging manager for ballerina which overrides the readConfiguration method to replace placeholders
 * having system or environment variables.
 */
public class GrpcLogManager extends LogManager {

    static {
        // loads logging.properties from the classpath
        try (InputStream is = GrpcLogManager.class.getClassLoader().
                getResourceAsStream("logging.properties")) {
            LogManager.getLogManager().readConfiguration(is);
        } catch (IOException e) {
            throw new RuntimeException("failed to read logging.properties file from the classpath", e);
        }
    }

    protected Logger grpcTraceLogger;
    protected Logger grpcAccessLogger;

    public GrpcLogManager(boolean traceLogConsole, BMap traceLogAdvancedConfig, BMap accessLogConfig) {

        this.setHttpTraceLogHandler(traceLogConsole, traceLogAdvancedConfig);
        this.setHttpAccessLogHandler(accessLogConfig);
    }

    /**
     * Initializes the GRPC trace logger.
     */
    public void setHttpTraceLogHandler(boolean traceLogConsole, BMap traceLogAdvancedConfig) {

        if (grpcTraceLogger == null) {
            // keep a reference to prevent this logger from being garbage collected
            grpcTraceLogger = Logger.getLogger(HTTP_TRACE_LOG);
        }
        PrintStream stdErr = System.err;
        boolean traceLogsEnabled = false;

        Boolean consoleLogEnabled = traceLogAdvancedConfig.getBooleanValue(GRPC_LOG_CONSOLE);
        if (traceLogConsole || consoleLogEnabled) {
            ConsoleHandler consoleHandler = new ConsoleHandler();
            consoleHandler.setFormatter(new GrpcTraceLogFormatter());
            consoleHandler.setLevel(Level.FINEST);
            grpcTraceLogger.addHandler(consoleHandler);
            traceLogsEnabled = true;
        }

        BString logFilePath = traceLogAdvancedConfig.getStringValue(GRPC_LOG_FILE_PATH);
        if (logFilePath != null && !logFilePath.getValue().trim().isEmpty()) {
            try {
                FileHandler fileHandler = new FileHandler(logFilePath.getValue(), true);
                fileHandler.setFormatter(new GrpcTraceLogFormatter());
                fileHandler.setLevel(Level.FINEST);
                grpcTraceLogger.addHandler(fileHandler);
                traceLogsEnabled = true;
            } catch (IOException e) {
                throw new RuntimeException("failed to setup GRPC trace log file: " + logFilePath.getValue(), e);
            }
        }

        BString host = traceLogAdvancedConfig.getStringValue(GRPC_TRACE_LOG_HOST);
        Long port = traceLogAdvancedConfig.getIntValue(GRPC_TRACE_LOG_PORT);
        if ((host != null && !host.getValue().trim().isEmpty()) && (port != null && port != 0)) {
            try {
                SocketHandler socketHandler = new SocketHandler(host.getValue(), port.intValue());
                socketHandler.setFormatter(new JsonLogFormatter());
                socketHandler.setLevel(Level.FINEST);
                grpcTraceLogger.addHandler(socketHandler);
                traceLogsEnabled = true;
            } catch (IOException e) {
                throw new RuntimeException("failed to connect to " + host.getValue() + ":" + port.intValue(), e);
            }
        }

        if (traceLogsEnabled) {
            grpcTraceLogger.setLevel(Level.FINEST);
            System.setProperty(HTTP_TRACE_LOG_ENABLED, "true");
            stdErr.println("ballerina: GRPC trace log enabled");
        }
    }

    /**
     * Initializes the GRPC access logger.
     */
    public void setHttpAccessLogHandler(BMap accessLogConfig) {

        if (grpcAccessLogger == null) {
            // keep a reference to prevent this logger from being garbage collected
            grpcAccessLogger = Logger.getLogger(HTTP_ACCESS_LOG);
        }
        PrintStream stdErr = System.err;
        boolean accessLogsEnabled = false;

        Boolean consoleLogEnabled = accessLogConfig.getBooleanValue(GRPC_LOG_CONSOLE);
        if (consoleLogEnabled) {
            ConsoleHandler consoleHandler = new ConsoleHandler();
            consoleHandler.setFormatter(new GrpcAccessLogFormatter());
            consoleHandler.setLevel(Level.INFO);
            grpcAccessLogger.addHandler(consoleHandler);
            grpcAccessLogger.setLevel(Level.INFO);
            accessLogsEnabled = true;
        }

        BString filePath = accessLogConfig.getStringValue(GRPC_LOG_FILE_PATH);
        if (filePath != null && !filePath.getValue().trim().isEmpty()) {
            try {
                FileHandler fileHandler = new FileHandler(filePath.getValue(), true);
                fileHandler.setFormatter(new GrpcAccessLogFormatter());
                fileHandler.setLevel(Level.INFO);
                grpcAccessLogger.addHandler(fileHandler);
                grpcAccessLogger.setLevel(Level.INFO);
                accessLogsEnabled = true;
            } catch (IOException e) {
                throw new RuntimeException("failed to setup GRPC access log file: " + filePath.getValue(), e);
            }
        }

        if (accessLogsEnabled) {
            System.setProperty(HTTP_ACCESS_LOG_ENABLED, "true");
            stdErr.println("ballerina: GRPC access log enabled");
        }
    }

}
