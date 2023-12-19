// Copyright (c) 2023 WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
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
import ballerina/protobuf.types.empty;

public const string MULTIPLE_CLIENT_CONFIGURATIONS_DESC = "0A2737395F6D756C7469706C655F636C69656E745F636F6E66696775726174696F6E732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F32580A1D4D756C7469706C65436C69656E74436F6E66696773536572766963653112370A0563616C6C3112162E676F6F676C652E70726F746F6275662E456D7074791A162E676F6F676C652E70726F746F6275662E456D70747932580A1D4D756C7469706C65436C69656E74436F6E66696773536572766963653212370A0563616C6C3112162E676F6F676C652E70726F746F6275662E456D7074791A162E676F6F676C652E70726F746F6275662E456D707479620670726F746F33";

public isolated client class MultipleClientConfigsService1Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, MULTIPLE_CLIENT_CONFIGURATIONS_DESC);
    }

    isolated remote function call1() returns grpc:Error? {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        _ = check self.grpcClient->executeSimpleRPC("MultipleClientConfigsService1/call1", message, headers);
    }

    isolated remote function call1Context() returns empty:ContextNil|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("MultipleClientConfigsService1/call1", message, headers);
        [anydata, map<string|string[]>] [_, respHeaders] = payload;
        return {headers: respHeaders};
    }
}

public isolated client class MultipleClientConfigsService2Client {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, MULTIPLE_CLIENT_CONFIGURATIONS_DESC);
    }

    isolated remote function call1() returns grpc:Error? {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        _ = check self.grpcClient->executeSimpleRPC("MultipleClientConfigsService2/call1", message, headers);
    }

    isolated remote function call1Context() returns empty:ContextNil|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("MultipleClientConfigsService2/call1", message, headers);
        [anydata, map<string|string[]>] [_, respHeaders] = payload;
        return {headers: respHeaders};
    }
}

