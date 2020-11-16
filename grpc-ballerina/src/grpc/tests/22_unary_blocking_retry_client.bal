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

import ballerina/io;
import ballerina/test;

RetryConfiguration retryConfig = {
    retryCount: 3,
    intervalInMillis: 2000,
    maxIntervalInMillis: 10000,
    backoffFactor: 2,
    errorTypes: [UnavailableError, InternalError]
};
ClientConfiguration clientConfig = {
    timeoutInMillis: 1000,
    retryConfiguration: retryConfig
};

RetryConfiguration failingRetryConfig = {
    retryCount: 2,
    intervalInMillis: 2000,
    maxIntervalInMillis: 10000,
    backoffFactor: 2,
    errorTypes: [UnavailableError, InternalError]
};
ClientConfiguration failingClientConfig = {
    timeoutInMillis: 1000,
    retryConfiguration: failingRetryConfig
};

final RetryServiceBlockingClient retryClient = new("http://localhost:9112", clientConfig);
final RetryServiceBlockingClient failingRetryClient = new("http://localhost:9112", failingClientConfig);

@test:Config {enable:true}
function testRetry() {
    var result = retryClient->getResult("RetryClient");
    if (result is Error) {
        io:println(result);
        test:assertFail(result.toString());
    } else {
        var [message, headers] = result;
        test:assertEquals(message, "Total Attempts: 4");
    }
}

@test:Config {enable:true}
function testRetryFailingClient() {
    var result = failingRetryClient->getResult("FailingRetryClient");
    if (result is Error) {
        io:println(result);
        test:assertEquals(result.message(), "Maximum retry attempts completed without getting a result");
    } else {
        var [message, headers] = result;
        test:assertFail(message);
    }
}

public client class RetryServiceBlockingClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR_22, getDescriptorMap22());
    }

    public isolated remote function getResult(string req, Headers? headers = ()) returns ([string, Headers]|Error) {
        var payload = check self.grpcClient->blockingExecute("RetryService/getResult", req, headers);
        Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        return [result.toString(), resHeaders];
    }
}
