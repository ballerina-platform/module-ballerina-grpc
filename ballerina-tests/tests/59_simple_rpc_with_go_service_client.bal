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

import ballerina/grpc;
import ballerina/test;

@test:Config {enable: true}
public function testServerErrorWithGoService() returns error? {
    if !isWindowsEnvironment() {
        ProductInfoClient productClient = check new ("http://localhost:50051");

        map<string|string[]> headers = {"userId": "app:system"};

        ProductDetail product1 = {
            name: "Samsung S10",
            description: "Samsung Galaxy S10 is the latest smart phone, launched in February 2019",
            price: 700.0f
        };

        ProductID|error productId = productClient->addProduct({content: product1, headers: headers});
        test:assertTrue(productId is grpc:InternalError);
        test:assertEquals((<grpc:Error>productId).message(), "product Id is empty");
    }
}

@test:Config {enable: true}
function testRepeatedNumberTypesWithGoService() returns error? {
    if !isWindowsEnvironment() {
        ProductInfoClient productClient = check new ("http://localhost:50051");
        RepeatedTypes request = {
            int32Values: [int:SIGNED32_MIN_VALUE, 122004, int:SIGNED32_MAX_VALUE],
            int64Values: [int:MIN_VALUE, 2453783783, int:MAX_VALUE],
            uint32Values: [0, 452783738, int:UNSIGNED32_MAX_VALUE],
            uint64Values: [0, 14253783783, int:MAX_VALUE],
            sint32Values: [int:SIGNED32_MIN_VALUE, 427378378, int:SIGNED32_MAX_VALUE],
            sint64Values: [int:MIN_VALUE, 738787, int:MAX_VALUE],
            fixed32Values: [int:SIGNED32_MIN_VALUE, 676453784, int:SIGNED32_MAX_VALUE],
            fixed64Values: [int:MIN_VALUE, 4538367837, int:MAX_VALUE],
            sfixed32Values: [int:SIGNED32_MIN_VALUE, 2045374834, int:SIGNED32_MAX_VALUE],
            sfixed64Values: [int:MIN_VALUE, 537837893, int:MAX_VALUE],
            floatValues: [float:max(), 3.140000104904175, float:min()],
            doubleValues: [float:max(), 3.14, float:min()],
            boolValues: [true, false, true]
        };
        RepeatedTypes response = check productClient->getRepeatedTypes(request);
        test:assertEquals(response, request);
    }
}
