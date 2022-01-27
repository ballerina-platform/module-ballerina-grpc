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

listener grpc:Listener adListener = new (3550);
ProductUtils utils = check new();

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR,
    descMap: getDescriptorMap()
}
service "ProductCatalogService" on adListener {

    remote function ListProducts() returns ListProductsResponse|error? {
        ListProductsResponse response = {
            products: check utils.getProducts()
        };
        return response;
    }

    remote function GetProduct(GetProductRequest request) returns Product|error? {
        Product[] products = check utils.getProducts();
        foreach Product product in products {
            if product.id == request.id {
                return product;
            }
        }
        return {};
    }

    remote function SearchProducts(SearchProductsRequest request) returns SearchProductsResponse|error? {
        Product[] productResults = [];
        Product[] products = check utils.getProducts();
        foreach Product product in products {
            if product.name.toLowerAscii().includes(request.query.toLowerAscii()) || product.description.toLowerAscii().includes(request.query.toLowerAscii()) {
                productResults.push(product);
            }
        }
        return {
            results: productResults
        };
    }

}
