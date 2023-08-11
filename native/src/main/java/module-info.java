/*
 * Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

module io.ballerina.stdlib.grpc {
    requires io.netty.codec.http;
    requires org.slf4j;
    requires io.netty.buffer;
    requires org.apache.commons.lang3;
    requires proto.google.common.protos;
    requires io.ballerina.stdlib.http;
    requires io.ballerina.runtime;
    requires java.logging;
    requires io.ballerina.lang;
    requires io.ballerina.tools.api;
    requires io.ballerina.parser;
    requires io.ballerina.formatter.core;
    requires info.picocli;
    requires io.ballerina.cli;
    requires io.ballerina.toml;
    requires io.ballerina.stdlib.protobuf;
    requires com.google.protobuf;
    exports io.ballerina.stdlib.grpc;
    exports io.ballerina.stdlib.grpc.exception;
    exports io.ballerina.stdlib.grpc.nativeimpl;
    exports io.ballerina.stdlib.grpc.nativeimpl.caller;
    exports io.ballerina.stdlib.grpc.nativeimpl.client;
    exports io.ballerina.stdlib.grpc.nativeimpl.serviceendpoint;
    exports io.ballerina.stdlib.grpc.nativeimpl.streamingclient;
}
