// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/jballerina.java;
import ballerina/http as _;

// Above unnecessary HTTP import can remove when one of the following issues are fixed:
// 1. https://github.com/ballerina-platform/ballerina-lang/issues/34357
// 2. https://github.com/netty/netty/issues/11921

function init() {
    setModule();
    _ = initializeGrpcLogs(traceLogConsole, traceLogAdvancedConfig, accessLogConfig);
}

function setModule() = @java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.ModuleUtils"
} external;
