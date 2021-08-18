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
import ballerina/io;

const string CATALOG_PATH = "resources/products.json";

listener grpc:Listener adListener = new (3550);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR,
    descMap: getDescriptorMap()
}
service "ProductCatalogService" on adListener {

    remote function ListProducts() returns ListProductsResponse|error? {
        ProductUtil utils = check new ();
        ListProductsResponse response = {
            products: check utils.getProducts()
        };
        return response;
    }

    remote function GetProduct(GetProductRequest request) returns Product|error? {
        ProductUtil utils = check new ();
        Product[] products = check utils.getProducts();
        foreach Product product in products {
            if product.id == request.id {
                return product;
            }
        }
        return {};
    }

    remote function SearchProducts(SearchProductsRequest request) returns SearchProductsResponse|error? {
        ProductUtil utils = check new ();
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

class ProductUtil {

    json productCatalog = {};

    function init() returns error? {
        check self.readCatalog();
    }

    function readCatalog() returns error? {
        self.productCatalog = check io:fileReadJson(CATALOG_PATH);
    }

    function getProducts() returns Product[]|error {
        json jsonProducts = check self.productCatalog.products;
        Product[] products = check self.mapJsonListToProductList(jsonProducts);
        return products;
    }

    private function mapJsonListToProductList(json jsonList) returns Product[]|error {
        anydata[] jsonProducts = <anydata[]> jsonList;
        Product[] products = [];
        foreach var jsonProduct in jsonProducts {
            prod mprod = check jsonProduct.cloneWithType(prod);
            Money money = {
                currency_code: mprod.priceUsd.currencyCode,
                nanos: mprod.priceUsd.nanos,
                units: mprod.priceUsd.units
            };
            Product product = {
                id: mprod.id,
                name: mprod.name,
                description: mprod.description,
                picture: mprod.picture,
                price_usd: money,
                categories: mprod.categories
            };
            products.push(product);
        }
        return products;
    }
}

type PriceUsd record {|
    string currencyCode;
    int units = 0;
    int nanos = 0;
|};

type prod record {|
    string id;
    string name;
    string description;
    PriceUsd priceUsd;
    string picture;
    string[] categories;
|};
