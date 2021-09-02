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

public isolated client class ProductCatalogClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_54_BACKWARD_COMPATIBLE_CLIENT_PROTO, getDescriptorMap54BackwardCompatibleClientProto());
    }

    isolated remote function getProduct(string|wrappers:ContextString req) returns Product|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.ProductCatalog/getProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Product>result;
    }

    isolated remote function getProductContext(string|wrappers:ContextString req) returns ContextProduct|grpc:Error {
        map<string|string[]> headers = {};
        string message;
        if req is wrappers:ContextString {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.ProductCatalog/getProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Product>result, headers: respHeaders};
    }

    isolated remote function sendCustomer(ChangedCustomer|ContextChangedCustomer req) returns string|grpc:Error {
        map<string|string[]> headers = {};
        ChangedCustomer message;
        if req is ContextChangedCustomer {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.ProductCatalog/sendCustomer", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return result.toString();
    }

    isolated remote function sendCustomerContext(ChangedCustomer|ContextChangedCustomer req) returns wrappers:ContextString|grpc:Error {
        map<string|string[]> headers = {};
        ChangedCustomer message;
        if req is ContextChangedCustomer {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.ProductCatalog/sendCustomer", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }
}

public client class ProductCatalogStringCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendString(string response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextString(wrappers:ContextString response) returns grpc:Error? {
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

public client class ProductCatalogProductCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProduct(Product response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProduct(ContextProduct response) returns grpc:Error? {
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

public type ContextCustomer record {|
    Customer content;
    map<string|string[]> headers;
|};

public type ContextChangedProduct record {|
    ChangedProduct content;
    map<string|string[]> headers;
|};

public type ContextChangedCustomer record {|
    ChangedCustomer content;
    map<string|string[]> headers;
|};

public type ContextProduct record {|
    Product content;
    map<string|string[]> headers;
|};

public type Customer record {|
    string name = "";
    int id = 0;
|};

public type ChangedProduct record {|
    string name = "";
    int id = 0;
    string additional = "";
|};

public type ChangedCustomer record {|
    string name = "";
    int id = 0;
    string additional = "";
|};

public type Product record {|
    string name = "";
    int id = 0;
|};

const string ROOT_DESCRIPTOR_54_SERVER = "0A2935345F6261636B776172645F636F6D70617469626C655F7365727665725F70726F746F2E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22540A0E4368616E67656450726F6475637412120A046E616D6518012001280952046E616D65120E0A02696418022001280552026964121E0A0A6164646974696F6E616C180320012809520A6164646974696F6E616C222E0A08437573746F6D657212120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696432A0010A0E50726F64756374436174616C6F6712480A0A67657450726F64756374121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E6772706373657276696365732E4368616E67656450726F6475637412440A0C73656E64437573746F6D657212162E6772706373657276696365732E437573746F6D65721A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33";

isolated function getDescriptorMap54Server() returns map<string> {
    return {"54_backward_compatible_server_proto.proto": "0A2935345F6261636B776172645F636F6D70617469626C655F7365727665725F70726F746F2E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22540A0E4368616E67656450726F6475637412120A046E616D6518012001280952046E616D65120E0A02696418022001280552026964121E0A0A6164646974696F6E616C180320012809520A6164646974696F6E616C222E0A08437573746F6D657212120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696432A0010A0E50726F64756374436174616C6F6712480A0A67657450726F64756374121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E6772706373657276696365732E4368616E67656450726F6475637412440A0C73656E64437573746F6D657212162E6772706373657276696365732E437573746F6D65721A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

const string ROOT_DESCRIPTOR_54_BACKWARD_COMPATIBLE_CLIENT_PROTO = "0A2935345F6261636B776172645F636F6D70617469626C655F636C69656E745F70726F746F2E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F222D0A0750726F6475637412120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696422550A0F4368616E676564437573746F6D657212120A046E616D6518012001280952046E616D65120E0A02696418022001280552026964121E0A0A6164646974696F6E616C180320012809520A6164646974696F6E616C32A0010A0E50726F64756374436174616C6F6712410A0A67657450726F64756374121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A152E6772706373657276696365732E50726F64756374124B0A0C73656E64437573746F6D6572121D2E6772706373657276696365732E4368616E676564437573746F6D65721A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33";

public isolated function getDescriptorMap54BackwardCompatibleClientProto() returns map<string> {
    return {"54_backward_compatible_client_proto.proto": "0A2935345F6261636B776172645F636F6D70617469626C655F636C69656E745F70726F746F2E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F222D0A0750726F6475637412120A046E616D6518012001280952046E616D65120E0A0269641802200128055202696422550A0F4368616E676564437573746F6D657212120A046E616D6518012001280952046E616D65120E0A02696418022001280552026964121E0A0A6164646974696F6E616C180320012809520A6164646974696F6E616C32A0010A0E50726F64756374436174616C6F6712410A0A67657450726F64756374121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A152E6772706373657276696365732E50726F64756374124B0A0C73656E64437573746F6D6572121D2E6772706373657276696365732E4368616E676564437573746F6D65721A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33", "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"};
}

