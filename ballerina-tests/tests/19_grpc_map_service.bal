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
import ballerina/log;

listener grpc:Listener negotiatorep = new (9109);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_19_GRPC_MAP_SERVICE,
    descMap: getDescriptorMap19GrpcMapService()
}
service "Negotiator" on negotiatorep {

    isolated remote function handshake(NegotiatorHandshakeResponseCaller caller, HandshakeRequest value) {
        log:printInfo(string `Handshake request: ${value.toString()}`);

        if value.jsonStr != "" {
            checkpanic caller->sendError(error grpc:InvalidArgumentError("jsonStr should be an empty string."));
            return;
        }
        if value.programHash != "" {
            checkpanic caller->sendError(error grpc:InvalidArgumentError("programHash should be an empty string."));
            return;
        }
        if value.userId != "" {
            checkpanic caller->sendError(error grpc:InvalidArgumentError("userId should be an empty string."));
            return;
        }
        if value.instanceId != "" {
            checkpanic caller->sendError(error grpc:InvalidArgumentError("instanceId should be an empty string."));
            return;
        }
        if value.applicationId != "" {
            checkpanic caller->sendError(error grpc:InvalidArgumentError("applicationId should be an empty string."));
            return;
        }
        HandshakeResponse response = {id: "123456", protocols: ["http", "https"]};
        checkpanic caller->sendHandshakeResponse(response);
        checkpanic caller->complete();
    }

    isolated remote function publishMetrics(NegotiatorNilCaller caller, MetricsPublishRequest value) {
        log:printInfo(string `publishMetrics request: ${value.toString()}`);

        if value.metrics.length() < 0 {
            checkpanic caller->sendError(error grpc:InvalidArgumentError("metrics cannot be an empty array."));
            return;
        }
        foreach var metric in value.metrics {
            log:printInfo(string `metric value: ${metric.toString()}`);
            if metric.tags.length() < 0 {
                checkpanic caller->sendError(error grpc:InvalidArgumentError("tags cannot be an empty array."));
                return;
            }
        }
        checkpanic caller->complete();
    }

    isolated remote function publishTraces(NegotiatorNilCaller caller, TracesPublishRequest value) {
        log:printInfo(string `publishTraces request: ${value.toString()}`);
        checkpanic caller->complete();
    }
}
