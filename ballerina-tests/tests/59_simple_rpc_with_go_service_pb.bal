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

public isolated client class ProductInfoClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_59_SIMPLE_RPC_WITH_GO_SERVICE, getDescriptorMap59SimpleRpcWithGoService());
    }

    isolated remote function addProduct(ProductDetail|ContextProductDetail req) returns ProductID|grpc:Error {
        map<string|string[]> headers = {};
        ProductDetail message;
        if req is ContextProductDetail {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.ProductInfo/addProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductID>result;
    }

    isolated remote function addProductContext(ProductDetail|ContextProductDetail req) returns ContextProductID|grpc:Error {
        map<string|string[]> headers = {};
        ProductDetail message;
        if req is ContextProductDetail {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.ProductInfo/addProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductID>result, headers: respHeaders};
    }

    isolated remote function getProduct(ProductID|ContextProductID req) returns ProductDetail|grpc:Error {
        map<string|string[]> headers = {};
        ProductID message;
        if req is ContextProductID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.ProductInfo/getProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductDetail>result;
    }

    isolated remote function getProductContext(ProductID|ContextProductID req) returns ContextProductDetail|grpc:Error {
        map<string|string[]> headers = {};
        ProductID message;
        if req is ContextProductID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.ProductInfo/getProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductDetail>result, headers: respHeaders};
    }
}

public client class ProductInfoProductIDCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProductID(ProductID response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProductID(ContextProductID response) returns grpc:Error? {
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

public client class ProductInfoProductDetailCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProductDetail(ProductDetail response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProductDetail(ContextProductDetail response) returns grpc:Error? {
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

public type ContextProductDetail record {|
    ProductDetail content;
    map<string|string[]> headers;
|};

public type ContextProductID record {|
    ProductID content;
    map<string|string[]> headers;
|};

public type ProductDetail record {|
    string id = "";
    string name = "";
    string description = "";
    float price = 0.0;
|};

public type ProductID record {|
    string value = "";
|};

const string ROOT_DESCRIPTOR_59_SIMPLE_RPC_WITH_GO_SERVICE = "0A2335395F73696D706C655F7270635F776974685F676F5F736572766963652E70726F746F120965636F6D6D65726365226B0A0D50726F6475637444657461696C120E0A0269641801200128095202696412120A046E616D6518022001280952046E616D6512200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12140A0570726963651804200128025205707269636522210A0950726F64756374494412140A0576616C7565180120012809520576616C75653289010A0B50726F64756374496E666F123C0A0A61646450726F6475637412182E65636F6D6D657263652E50726F6475637444657461696C1A142E65636F6D6D657263652E50726F647563744944123C0A0A67657450726F6475637412142E65636F6D6D657263652E50726F6475637449441A182E65636F6D6D657263652E50726F6475637444657461696C620670726F746F33";

public isolated function getDescriptorMap59SimpleRpcWithGoService() returns map<string> {
    return {"59_simple_rpc_with_go_service.proto": "0A2335395F73696D706C655F7270635F776974685F676F5F736572766963652E70726F746F120965636F6D6D65726365226B0A0D50726F6475637444657461696C120E0A0269641801200128095202696412120A046E616D6518022001280952046E616D6512200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12140A0570726963651804200128025205707269636522210A0950726F64756374494412140A0576616C7565180120012809520576616C75653289010A0B50726F64756374496E666F123C0A0A61646450726F6475637412182E65636F6D6D657263652E50726F6475637444657461696C1A142E65636F6D6D657263652E50726F647563744944123C0A0A67657450726F6475637412142E65636F6D6D657263652E50726F6475637449441A182E65636F6D6D657263652E50726F6475637444657461696C620670726F746F33"};
}

