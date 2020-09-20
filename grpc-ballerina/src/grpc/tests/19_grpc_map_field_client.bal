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

NegotiatorBlockingClient negotiatorEp = new ("http://localhost:9109");

@test:Config {}
public function testMapFields() {
    MetricsPublishRequest request = {
        id: "xxxxx",
        metrics: [{
            timestamp: 1580966325916,
            name: "ballerina/http/Caller_3XX_requests_total_count",
            value: 0.0,
            tags: [{key: "action", value: "respond"}]
        }]
    };
    Headers | error publishMetrics = negotiatorEp->publishMetrics(request);
    if (publishMetrics is error) {
        test:assertFail(io:sprintf("Metrics publish failed: %s", publishMetrics.message()));
    }
}

@test:Config {}
public function testOptionalFields() {
    HandshakeRequest request = {};
    [HandshakeResponse, Headers] | Error result = negotiatorEp->handshake(request);
    if (result is error) {
        test:assertFail(io:sprintf("Handshake failed: %s", result.message()));
    } else {
        HandshakeResponse handshakeResponse;
        [handshakeResponse, _] = result;
        test:assertEquals(handshakeResponse.id, "123456");
    }
}

public client class NegotiatorBlockingClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new (url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR_19, getDescriptorMap19());
    }

    public isolated remote function handshake(HandshakeRequest req, Headers? headers = ())
                                                returns ([HandshakeResponse, Headers] | Error) {
        var payload = check self.grpcClient->blockingExecute("Negotiator/handshake", req, headers);
        Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        return [<HandshakeResponse>result, resHeaders];
    }

    public isolated remote function publishMetrics(MetricsPublishRequest req, Headers? headers = ())
                                                returns (Headers | Error) {
        var payload = check self.grpcClient->blockingExecute("Negotiator/publishMetrics", req, headers);
        Headers resHeaders = new;
        [_, resHeaders] = payload;
        return resHeaders;
    }

    public isolated remote function publishTraces(TracesPublishRequest req, Headers? headers = ())
                                                returns (Headers | Error) {
        var payload = check self.grpcClient->blockingExecute("Negotiator/publishTraces", req, headers);
        Headers resHeaders = new;
        [_, resHeaders] = payload;
        return resHeaders;
    }
}

public client class NegotiatorClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new (url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_19, getDescriptorMap19());
    }

    public isolated remote function handshake(HandshakeRequest req, service msgListener, Headers? headers = ())
                                                                                        returns (Error?) {
        return self.grpcClient->nonBlockingExecute("Negotiator/handshake", req, msgListener, headers);
    }

    public isolated remote function publishMetrics(MetricsPublishRequest req, service msgListener, Headers? headers = ())
                                                                                        returns (Error?) {
        return self.grpcClient->nonBlockingExecute("Negotiator/publishMetrics", req, msgListener, headers);
    }

    public isolated remote function publishTraces(TracesPublishRequest req, service msgListener, Headers? headers = ())
                                                                                        returns (Error?) {
        return self.grpcClient->nonBlockingExecute("Negotiator/publishTraces", req, msgListener, headers);
    }
}
