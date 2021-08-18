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

// gRPC server for this testcase is written in Golang and running as a docker image(go_grpc_simple_server).
// Please refer to https://github.com/daneshk/grpc-test-samples/tree/master/go-product-info-service for source code.

import ballerina/test;

@test:Config{}
public function testServerErrorWithGoService() returns error? {
    ProductInfoClient productClient = check new ("http://localhost:50051");

    map<string|string[]> headers = {"userId": "app:system"};

    ProductDetail product1 = {name: "Samsung S10",
                          description: "Samsung Galaxy S10 is the latest smart phone, launched in February 2019",
                          price: 700.0f};

    ProductID|error productId = productClient->addProduct({content: product1, headers: headers});
    if (productId is InternalError) {
        test:assertEquals(productId.message(), "product Id is empty");
    } else {
        test:assertFail(msg = "Expected an internal error");
    }
}