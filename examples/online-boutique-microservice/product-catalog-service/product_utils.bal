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

import ballerina/io;

const string CATALOG_PATH = "resources/products.json";

class ProductUtils {

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
            CatalogProduct catProduct = check jsonProduct.cloneWithType(CatalogProduct);
            Money money = {
                currency_code: catProduct.priceUsd.currencyCode,
                nanos: catProduct.priceUsd.nanos,
                units: catProduct.priceUsd.units
            };
            Product product = {
                id: catProduct.id,
                name: catProduct.name,
                description: catProduct.description,
                picture: catProduct.picture,
                price_usd: money,
                categories: catProduct.categories
            };
            products.push(product);
        }
        return products;
    }
}

type ProductPrice record {|
    string currencyCode;
    int units = 0;
    int nanos = 0;
|};

type CatalogProduct record {|
    string id;
    string name;
    string description;
    ProductPrice priceUsd;
    string picture;
    string[] categories;
|};
