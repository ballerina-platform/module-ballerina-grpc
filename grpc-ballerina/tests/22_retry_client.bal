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
    interval: 0.002,
    maxInterval: 0.01,
    backoffFactor: 2,
    errorTypes: [UnavailableError, InternalError]
};
ClientConfiguration clientConfig = {
    timeout: 1,
    retryConfiguration: retryConfig
};

RetryConfiguration failingRetryConfig = {
    retryCount: 2,
    interval: 0.002,
    maxInterval: 0.01,
    backoffFactor: 2,
    errorTypes: [UnavailableError, InternalError]
};
ClientConfiguration failingClientConfig = {
    timeout: 1,
    retryConfiguration: failingRetryConfig
};

final RetryServiceClient retryClient = check new("http://localhost:9112", timeout = 1, retryConfiguration = retryConfig);
final RetryServiceClient failingRetryClient = check new("http://localhost:9112", timeout = 1, retryConfiguration = failingRetryConfig);

@test:Config {enable:true}
function testRetry() {
    var result = retryClient->getResult("RetryClient");
    if (result is Error) {
        io:println(result);
        test:assertFail(result.toString());
    } else {
        test:assertEquals(result, "Total Attempts: 4");
    }
}

@test:Config {enable:true}
function testRetryFailingClient() {
    var result = failingRetryClient->getResult("FailingRetryClient");
    if (result is Error) {
        io:println(result);
        test:assertEquals(result.message(), "Maximum retry attempts completed without getting a result");
    } else {
        test:assertFail(result);
    }
}

public client class RetryServiceClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_22, getDescriptorMap22());
    }

    isolated remote function getResult(string|ContextString req) returns (string|Error) {

        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RetryService/getResult", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function getResultContext(string|ContextString req) returns (ContextString|Error) {

        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RetryService/getResult", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

}
