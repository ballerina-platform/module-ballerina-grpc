// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/test;

grpc:ClientConfiguration config1 = {
   secureSocket: {
       cert: "tests/resources/public.crt"
   }
};

grpc:ClientConfiguration config2 = {
    secureSocket: {
        cert: "tests/resources/public2.crt"
    }
};

@test:Config {enable: true}
function testMultipleConfigurationsInMultiClientScenario() returns error? {
    MultipleClientConfigsService1Client ep1 = check new ("https://localhost:9179", config1);
    MultipleClientConfigsService2Client ep2 = check new ("https://localhost:9279", config2);
    check ep1->call1();
    check ep2->call1();
}
