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
import ballerina/protobuf.types.wrappers;

public isolated client class ByteServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_11_GRPC_BYTE_SERVICE, getDescriptorMap11GrpcByteService());
    }

    isolated remote function checkBytes(byte[]|wrappers:ContextBytes req) returns byte[]|grpc:Error {
        map<string|string[]> headers = {};
        byte[] message;
        if req is wrappers:ContextBytes {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.ByteService/checkBytes", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <byte[]>result;
    }

    isolated remote function checkBytesContext(byte[]|wrappers:ContextBytes req) returns wrappers:ContextBytes|grpc:Error {
        map<string|string[]> headers = {};
        byte[] message;
        if req is wrappers:ContextBytes {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.ByteService/checkBytes", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <byte[]>result, headers: respHeaders};
    }
}

public client class ByteServiceByteCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBytes(byte[] response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBytes(wrappers:ContextBytes response) returns grpc:Error? {
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

const string ROOT_DESCRIPTOR_11_GRPC_BYTE_SERVICE = "0A1A31315F677270635F627974655F736572766963652E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32550A0B427974655365727669636512460A0A636865636B4279746573121B2E676F6F676C652E70726F746F6275662E427974657356616C75651A1B2E676F6F676C652E70726F746F6275662E427974657356616C7565620670726F746F33";

public isolated function getDescriptorMap11GrpcByteService() returns map<string> {
    return {"11_grpc_byte_service.proto": "0A1A31315F677270635F627974655F736572766963652E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32550A0B427974655365727669636512460A0A636865636B4279746573121B2E676F6F676C652E70726F746F6275662E427974657356616C75651A1B2E676F6F676C652E70726F746F6275662E427974657356616C7565620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

