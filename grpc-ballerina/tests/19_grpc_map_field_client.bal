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

import ballerina/test;

final NegotiatorClient negotiatorEp = check new ("http://localhost:9109");

@test:Config {enable:true}
function testMapFields() {
    MetricsPublishRequest request = {
        id: "xxxxx",
        metrics: [{
            timestamp: 1580966325916,
            name: "ballerina/http/Caller_3XX_requests_total_count",
            value: 0.0,
            tags: [{key: "action", value: "respond"}]
        }]
    };
    Error? publishMetrics = negotiatorEp->publishMetrics(request);
    if (publishMetrics is Error) {
        test:assertFail(string `Metrics publish failed: ${publishMetrics.message()}`);
    }
}

@test:Config {enable:true}
function testOptionalFields() {
    HandshakeRequest request = {};
    HandshakeResponse|Error result = negotiatorEp->handshake(request);
    if (result is Error) {
        test:assertFail(string `Handshake failed: ${result.message()}`);
    } else {
        test:assertEquals(result.id, "123456");
    }
}
