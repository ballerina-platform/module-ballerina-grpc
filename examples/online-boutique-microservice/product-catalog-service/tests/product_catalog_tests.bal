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

import ballerina/test;

Product[] actualProducts = [
    {
        id: "OLJCESPC7Z",
        name: "Vintage Typewriter",
        description: "This typewriter looks good in your living room.",
        picture: "/static/img/products/typewriter.jpg",
        price_usd: {
            currency_code: "USD",
            units: 67,
            nanos: 990000000
        },
        "categories": ["vintage"]
    },
    {
        id: "66VCHSJNUP",
        name: "Antique Camera",
        description: "It probably doesn't work anyway.",
        picture: "/static/img/products/camera-lens.jpg",
        price_usd: {
            currency_code: "USD",
            units: 12,
            nanos: 490000000
        },
        "categories": ["photography", "vintage"]
    },
    {
        id: "1YMWWN1N4O",
        name: "Home Barista Kit",
        description: "Always wanted to brew coffee with Chemex and Aeropress at home?",
        picture: "/static/img/products/barista-kit.jpg",
        price_usd: {
            currency_code: "USD",
            units: 124
        },
        "categories": ["cookware"]
    },
    {
        id: "L9ECAV7KIM",
        name: "Terrarium",
        description: "This terrarium will looks great in your white painted living room.",
        picture: "/static/img/products/terrarium.jpg",
        price_usd: {
            currency_code: "USD",
            units: 36,
            nanos: 450000000
        },
        "categories": ["gardening"]
    },
    {
        id: "2ZYFJ3GM2N",
        name: "Film Camera",
        description: "This camera looks like it's a film camera, but it's actually digital.",
        picture: "/static/img/products/film-camera.jpg",
        price_usd: {
            currency_code: "USD",
            units: 2245
        },
        "categories": ["photography", "vintage"]
    },
    {
        id: "0PUK6V6EV0",
        name: "Vintage Record Player",
        description: "It still works.",
        picture: "/static/img/products/record-player.jpg",
        price_usd: {
            currency_code: "USD",
            units: 65,
            nanos: 500000000
        },
        "categories": ["music", "vintage"]
    },
    {
        id: "LS4PSXUNUM",
        name: "Metal Camping Mug",
        description: "You probably don't go camping that often but this is better than plastic cups.",
        picture: "/static/img/products/camp-mug.jpg",
        price_usd: {
            currency_code: "USD",
            units: 24,
            nanos: 330000000
        },
        "categories": ["cookware"]
    },
    {
        id: "9SIQT8TOJO",
        name: "City Bike",
        description: "This single gear bike probably cannot climb the hills of San Francisco.",
        picture: "/static/img/products/city-bike.jpg",
        price_usd: {
            currency_code: "USD",
            units: 789,
            nanos: 500000000
        },
        "categories": ["cycling"]
    },
    {
        id: "6E92ZMYYFZ",
        name: "Air Plant",
        description: "Have you ever wondered whether air plants need water? Buy one and figure out.",
        picture: "/static/img/products/air-plant.jpg",
        price_usd: {
            currency_code: "USD",
            units: 12,
            nanos: 300000000
        },
        "categories": ["gardening"]
    }
];

ProductCatalogServiceClient prodCatalogClient = check new ("http://localhost:3550");

@test:Config {enable: true}
function listProductsTest() returns error? {
    ListProductsResponse response = check prodCatalogClient->ListProducts({});
    Product[] productResults = [];
    response.products.forEach(function (Product product) {
        productResults.push(product);
    });
    test:assertEquals(productResults, actualProducts);
}

@test:Config {enable: true}
function getProductTest() returns error? {
    GetProductRequest request = {
        id: "OLJCESPC7Z"
    };
    Product product = check prodCatalogClient->GetProduct(request);
    test:assertEquals(product, actualProducts[0]);
}

@test:Config {enable: true}
function searchProductsTest() returns error? {
    SearchProductsRequest request = {
        query: "terrarium will looks"
    };
    SearchProductsResponse response = check prodCatalogClient->SearchProducts(request);
    Product[] productResults = [];
    response.results.forEach(function (Product product) {
        productResults.push(product);
    });
    test:assertEquals(productResults, [actualProducts[3]]);
}
