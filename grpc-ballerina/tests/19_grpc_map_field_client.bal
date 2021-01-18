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
    Error? publishMetrics = negotiatorEp->publishMetrics(request);
    if (publishMetrics is Error) {
        test:assertFail(io:sprintf("Metrics publish failed: %s", publishMetrics.message()));
    }
}

@test:Config {enable:true}
function testOptionalFields() {
    HandshakeRequest request = {};
    HandshakeResponse|Error result = negotiatorEp->handshake(request);
    if (result is Error) {
        test:assertFail(io:sprintf("Handshake failed: %s", result.message()));
    } else {
        test:assertEquals(result.id, "123456");
    }
}

public client class NegotiatorClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_19, getDescriptorMap19());
    }

    isolated remote function handshake(HandshakeRequest|ContextHandshakeRequest req) returns (HandshakeResponse|Error) {
        
        map<string|string[]> headers = {};
        HandshakeRequest message;
        if (req is ContextHandshakeRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/handshake", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <HandshakeResponse>result;
        
    }
    isolated remote function handshakeContext(HandshakeRequest|ContextHandshakeRequest req) returns (ContextHandshakeResponse|Error) {
        
        map<string|string[]> headers = {};
        HandshakeRequest message;
        if (req is ContextHandshakeRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/handshake", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <HandshakeResponse>result, headers: respHeaders};
    }

    isolated remote function publishMetrics(MetricsPublishRequest|ContextMetricsPublishRequest req) returns (Error?) {
        
        map<string|string[]> headers = {};
        MetricsPublishRequest message;
        if (req is ContextMetricsPublishRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/publishMetrics", message, headers);
        
    }
    isolated remote function publishMetricsContext(MetricsPublishRequest|ContextMetricsPublishRequest req) returns (ContextNil|Error) {
        
        map<string|string[]> headers = {};
        MetricsPublishRequest message;
        if (req is ContextMetricsPublishRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/publishMetrics", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {headers: respHeaders};
    }

    isolated remote function publishTraces(TracesPublishRequest|ContextTracesPublishRequest req) returns (Error?) {
        
        map<string|string[]> headers = {};
        TracesPublishRequest message;
        if (req is ContextTracesPublishRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/publishTraces", message, headers);
        
    }
    isolated remote function publishTracesContext(TracesPublishRequest|ContextTracesPublishRequest req) returns (ContextNil|Error) {
        
        map<string|string[]> headers = {};
        TracesPublishRequest message;
        if (req is ContextTracesPublishRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/publishTraces", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {headers: respHeaders};
    }

}
