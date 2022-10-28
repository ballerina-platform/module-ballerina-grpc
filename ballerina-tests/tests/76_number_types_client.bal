// Copyright (c) 2022 WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
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

@test:Config {enable: true}
function testNumberTypesMaxValues() returns error? {
    TypesServiceClient 'client = check new ("http://localhost:9176");
    TypesMessage request = {
        int32Value: int:SIGNED32_MAX_VALUE,
        int64Value: int:MAX_VALUE,
        uint32Value: 4294967295,
        uint64Value: int:MAX_VALUE,
        sint32Value: int:SIGNED32_MAX_VALUE,
        sint64Value: int:MAX_VALUE,
        fixed32Value: int:SIGNED32_MAX_VALUE,
        fixed64Value: int:MAX_VALUE,
        sfixed32Value: int:SIGNED32_MAX_VALUE,
        sfixed64Value: int:MAX_VALUE
    };
    TypesMessage response = check 'client->getTypes(request);
    test:assertEquals(response, request);
}

@test:Config {enable: true}
function testNumberTypesMinValues() returns error? {
    TypesServiceClient 'client = check new ("http://localhost:9176");
    TypesMessage request = {
        int32Value: int:SIGNED32_MIN_VALUE,
        int64Value: int:MIN_VALUE,
        uint32Value: 0,
        uint64Value: int:MIN_VALUE,
        sint32Value: int:SIGNED32_MIN_VALUE,
        sint64Value: int:MIN_VALUE,
        fixed32Value: int:SIGNED32_MIN_VALUE,
        fixed64Value: int:MIN_VALUE,
        sfixed32Value: int:SIGNED32_MIN_VALUE,
        sfixed64Value: int:MIN_VALUE
    };
    TypesMessage response = check 'client->getTypes(request);
    test:assertEquals(response, request);
}

@test:Config {enable: true}
function testNumberTypesRegularValues() returns error? {
    TypesServiceClient 'client = check new ("http://localhost:9176");
    TypesMessage request = {
        int32Value: 122004,
        int64Value: 2453783783,
        uint32Value: 452783738,
        uint64Value: 14253783783,
        sint32Value: 427378378,
        sint64Value: 738787,
        fixed32Value: 676453784,
        fixed64Value: 4538367837,
        sfixed32Value: 2045374834,
        sfixed64Value: 537837893
    };
    TypesMessage response = check 'client->getTypes(request);
    test:assertEquals(response, request);
}
