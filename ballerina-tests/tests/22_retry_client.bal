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

import ballerina/grpc;
import ballerina/test;

grpc:RetryConfiguration retryConfig = {
    retryCount: 3,
    interval: 0.002,
    maxInterval: 0.01,
    backoffFactor: 2,
    errorTypes: [grpc:UnavailableError, grpc:InternalError]
};

grpc:RetryConfiguration failingRetryConfig = {
    retryCount: 2,
    interval: 0.002,
    maxInterval: 0.01,
    backoffFactor: 2,
    errorTypes: [grpc:UnavailableError, grpc:InternalError]
};

final RetryServiceClient retryClient = check new ("http://localhost:9112", timeout = 1, retryConfiguration = retryConfig);
final RetryServiceClient failingRetryClient = check new ("http://localhost:9112", timeout = 1, retryConfiguration = failingRetryConfig);

@test:Config {enable: true}
function testRetry() returns grpc:Error? {
    string result = check retryClient->getResult("UnavailableError");
    test:assertEquals(result, "Total Attempts: 4");

    result = check retryClient->getResult("InternalError");
    test:assertEquals(result, "Total Attempts: 4");
}

@test:Config {enable: true}
function testRetryFailingClient() {
    string|grpc:Error result = failingRetryClient->getResult("FailingRetryClient");
    test:assertTrue(result is grpc:Error);
    test:assertEquals((<grpc:Error>result).message(), "Maximum retry attempts completed without getting a result");
}
