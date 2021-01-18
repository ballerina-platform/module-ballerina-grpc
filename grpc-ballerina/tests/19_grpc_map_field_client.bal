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

final NegotiatorClient negotiatorEp = new ("http://localhost:9109");

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
    map<string|string[]> | error publishMetrics = negotiatorEp->publishMetrics(request);
    if (publishMetrics is error) {
        test:assertFail(io:sprintf("Metrics publish failed: %s", publishMetrics.message()));
    }
}

@test:Config {enable:true}
function testOptionalFields() {
    HandshakeRequest request = {};
    [HandshakeResponse, map<string|string[]>] | Error result = negotiatorEp->handshake(request);
    if (result is error) {
        test:assertFail(io:sprintf("Handshake failed: %s", result.message()));
    } else {
        HandshakeResponse handshakeResponse;
        [handshakeResponse, _] = result;
        test:assertEquals(handshakeResponse.id, "123456");
    }
}

public client class NegotiatorClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new (url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_19, getDescriptorMap19());
    }

    isolated remote function handshake(HandshakeRequest req, map<string|string[]> headers = {})
                                                returns ([HandshakeResponse, map<string|string[]>] | Error) {
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/handshake", req, headers);
        map<string|string[]> resHeaders;
        anydata result = ();
        [result, resHeaders] = payload;
        return [<HandshakeResponse>result, resHeaders];
    }

    isolated remote function publishMetrics(MetricsPublishRequest req, map<string|string[]> headers = {})
                                                returns (map<string|string[]> | Error) {
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/publishMetrics", req, headers);
        map<string|string[]> resHeaders;
        [_, resHeaders] = payload;
        return resHeaders;
    }

    isolated remote function publishTraces(TracesPublishRequest req, map<string|string[]> headers = {})
                                                returns (map<string|string[]> | Error) {
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/publishTraces", req, headers);
        map<string|string[]> resHeaders;
        [_, resHeaders] = payload;
        return resHeaders;
    }
}
