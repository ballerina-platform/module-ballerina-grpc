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
import ballerina/log;

@test:Config {enable: true}
function testAnonymousService() returns error? {
    log:printInfo("Starting the AnonService");
    check ep20.attach(AnonService, "AnonService");
    check ep20.'start();

    AnonServiceClient annonServiceClient = check new ("http://localhost:9110");
    string resp = check annonServiceClient->hello("WSO2");
    test:assertEquals(resp, "Hello Ballerina");
    check ep20.immediateStop();
}

@test:Config {dependsOn: [testAnonymousService], enable: true}
function testAnonymousServiceMultipleTimes() returns error? {
    log:printInfo("Starting the AnonService");
    check ep20.attach(AnonService, "AnonService");
    check ep20.'start();
    check ep20.'start();

    AnonServiceClient annonServiceClient = check new ("http://localhost:9110");
    string resp = check annonServiceClient->hello("WSO2");
    test:assertEquals(resp, "Hello Ballerina");
    check ep20.immediateStop();
}
