// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/protobuf;
import ballerina/protobuf.types.empty;

const string GRPC_MAP_SERVICE_DESC = "0A1931395F677270635F6D61705F736572766963652E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22410A1148616E647368616B65526573706F6E7365120E0A02696418012001280952026964121C0A0970726F746F636F6C73180220032809520970726F746F636F6C73224A0A154D6574726963735075626C69736852657175657374120E0A0269641801200128095202696412210A076D65747269637318022003280B32072E4D657472696352076D65747269637322B0010A064D6574726963121C0A0974696D657374616D70180120012803520974696D657374616D7012120A046E616D6518022001280952046E616D6512140A0576616C7565180320012801520576616C756512250A047461677318042003280B32112E4D65747269632E54616773456E7472795204746167731A370A0954616773456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A02380122480A145472616365735075626C69736852657175657374120E0A0269641801200128095202696412200A057370616E7318022003280B320A2E54726163655370616E52057370616E7322C6020A0954726163655370616E12180A077472616365496418012001280952077472616365496412160A067370616E496418022001280952067370616E496412220A0C706172656E745370616E4964180320012809520C706172656E745370616E496412200A0B736572766963654E616D65180420012809520B736572766963654E616D6512240A0D6F7065726174696F6E4E616D65180520012809520D6F7065726174696F6E4E616D65121C0A0974696D657374616D70180620012803520974696D657374616D70121A0A086475726174696F6E18072001280352086475726174696F6E12280A047461677318082003280B32142E54726163655370616E2E54616773456E7472795204746167731A370A0954616773456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A02380122AC010A1048616E647368616B655265717565737412180A076A736F6E53747218012001280952076A736F6E53747212200A0B70726F6772616D48617368180220012809520B70726F6772616D4861736812160A067573657249641803200128095206757365724964121E0A0A696E7374616E63654964180420012809520A696E7374616E6365496412240A0D6170706C69636174696F6E4964180520012809520D6170706C69636174696F6E496432C2010A0A4E65676F746961746F7212320A0968616E647368616B6512112E48616E647368616B65526571756573741A122E48616E647368616B65526573706F6E736512400A0E7075626C6973684D65747269637312162E4D6574726963735075626C697368526571756573741A162E676F6F676C652E70726F746F6275662E456D707479123E0A0D7075626C69736854726163657312152E5472616365735075626C697368526571756573741A162E676F6F676C652E70726F746F6275662E456D707479620670726F746F33";

public isolated client class NegotiatorClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, GRPC_MAP_SERVICE_DESC);
    }

    isolated remote function handshake(HandshakeRequest|ContextHandshakeRequest req) returns HandshakeResponse|grpc:Error {
        map<string|string[]> headers = {};
        HandshakeRequest message;
        if req is ContextHandshakeRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/handshake", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <HandshakeResponse>result;
    }

    isolated remote function handshakeContext(HandshakeRequest|ContextHandshakeRequest req) returns ContextHandshakeResponse|grpc:Error {
        map<string|string[]> headers = {};
        HandshakeRequest message;
        if req is ContextHandshakeRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/handshake", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <HandshakeResponse>result, headers: respHeaders};
    }

    isolated remote function publishMetrics(MetricsPublishRequest|ContextMetricsPublishRequest req) returns grpc:Error? {
        map<string|string[]> headers = {};
        MetricsPublishRequest message;
        if req is ContextMetricsPublishRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        _ = check self.grpcClient->executeSimpleRPC("Negotiator/publishMetrics", message, headers);
    }

    isolated remote function publishMetricsContext(MetricsPublishRequest|ContextMetricsPublishRequest req) returns empty:ContextNil|grpc:Error {
        map<string|string[]> headers = {};
        MetricsPublishRequest message;
        if req is ContextMetricsPublishRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/publishMetrics", message, headers);
        [anydata, map<string|string[]>] [_, respHeaders] = payload;
        return {headers: respHeaders};
    }

    isolated remote function publishTraces(TracesPublishRequest|ContextTracesPublishRequest req) returns grpc:Error? {
        map<string|string[]> headers = {};
        TracesPublishRequest message;
        if req is ContextTracesPublishRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        _ = check self.grpcClient->executeSimpleRPC("Negotiator/publishTraces", message, headers);
    }

    isolated remote function publishTracesContext(TracesPublishRequest|ContextTracesPublishRequest req) returns empty:ContextNil|grpc:Error {
        map<string|string[]> headers = {};
        TracesPublishRequest message;
        if req is ContextTracesPublishRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Negotiator/publishTraces", message, headers);
        [anydata, map<string|string[]>] [_, respHeaders] = payload;
        return {headers: respHeaders};
    }
}

public client class NegotiatorNilCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class NegotiatorHandshakeResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendHandshakeResponse(HandshakeResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextHandshakeResponse(ContextHandshakeResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextHandshakeResponse record {|
    HandshakeResponse content;
    map<string|string[]> headers;
|};

public type ContextTracesPublishRequest record {|
    TracesPublishRequest content;
    map<string|string[]> headers;
|};

public type ContextMetricsPublishRequest record {|
    MetricsPublishRequest content;
    map<string|string[]> headers;
|};

public type ContextHandshakeRequest record {|
    HandshakeRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: GRPC_MAP_SERVICE_DESC}
public type HandshakeResponse record {|
    string id = "";
    string[] protocols = [];
|};

@protobuf:Descriptor {value: GRPC_MAP_SERVICE_DESC}
public type TraceSpan record {|
    string traceId = "";
    string spanId = "";
    string parentSpanId = "";
    string serviceName = "";
    string operationName = "";
    int timestamp = 0;
    int duration = 0;
    record {|string key; string value;|}[] tags = [];
|};

@protobuf:Descriptor {value: GRPC_MAP_SERVICE_DESC}
public type TracesPublishRequest record {|
    string id = "";
    TraceSpan[] spans = [];
|};

@protobuf:Descriptor {value: GRPC_MAP_SERVICE_DESC}
public type Metric record {|
    int timestamp = 0;
    string name = "";
    float value = 0.0;
    record {|string key; string value;|}[] tags = [];
|};

@protobuf:Descriptor {value: GRPC_MAP_SERVICE_DESC}
public type MetricsPublishRequest record {|
    string id = "";
    Metric[] metrics = [];
|};

@protobuf:Descriptor {value: GRPC_MAP_SERVICE_DESC}
public type HandshakeRequest record {|
    string jsonStr = "";
    string programHash = "";
    string userId = "";
    string instanceId = "";
    string applicationId = "";
|};

