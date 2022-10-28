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
function testNumberTypes() returns error? {
    TypesServiceClient 'client = check new ("http://localhost:9176");
    TypesMessage request = {
        int32Value: 2147483647,
        int64Value: 9223372036854775807,
        uint32Value: 4294967295,
        uint64Value: 18446744073709551615,
        sint32Value: 0,
        sint64Value: 0,
        fixed32Value: 0,
        fixed64Value: 0,
        sfixed32Value: 0,
        sfixed64Value: 0
    };
    TypesMessage response = check 'client->getTypes(request);
    test:assertEquals(response, request);
}
