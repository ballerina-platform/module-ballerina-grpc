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

@test:Config {enable: true}
function testAnonymousService() returns error? {
    check ep20.attach(AnonService1, "AnonService1");
    check ep20.'start();

    AnonService1Client annonServiceClient = check new ("http://localhost:9110");
    string resp = check annonServiceClient->hello1("WSO2");
    test:assertEquals(resp, "Hello Ballerina");
    check ep20.immediateStop();
}

@test:Config {dependsOn: [testAnonymousService], enable: true}
function testAnonymousServiceMultipleTimes() returns error? {
    check ep20.attach(AnonService1, "AnonService1");
    check ep20.'start();
    check ep20.'start();

    AnonService1Client annonServiceClient = check new ("http://localhost:9110");
    string resp = check annonServiceClient->hello1("WSO2");
    test:assertEquals(resp, "Hello Ballerina");
    check ep20.immediateStop();
}

@test:Config {dependsOn: [testAnonymousServiceMultipleTimes], enable: true}
function testAnonymousUnregisteredService() returns error? {
    error? err = ep20.attach(unregisteredService);
    test:assertTrue(err is error);
    test:assertEquals((<error>err).message(), "Error while registering the service. Invalid service path. " +
            "Service path cannot be nil");
}

@test:Config {dependsOn: [testAnonymousUnregisteredService], enable: true}
function testAnonymousServiceWithoutRPCImplemented() returns error? {
    string msg1 = "Error while registering the service. " +
    "Simple remote function 'AnonService1.hello2' does not exist.";
    string msg2 = "Error while registering the service. " +
    "Server streaming remote function 'AnonService2.hello2' does not exist.";
    string msg3 = "Error while registering the service. " +
    "Client streaming remote function 'AnonService3.hello2' does not exist.";
    string msg4 = "Error while registering the service. " +
    "Bidirectional streaming remote function 'AnonService4.hello2' does not exist.";

    error? err1 = ep20.attach(IncompleteService, "AnonService1");
    test:assertTrue(err1 is error);
    test:assertEquals((<error>err1).message(), msg1);

    error? err2 = ep20.attach(IncompleteService, "AnonService2");
    test:assertTrue(err2 is error);
    test:assertEquals((<error>err2).message(), msg2);

    var err3 = ep20.attach(IncompleteService, "AnonService3");
    test:assertTrue(err3 is error);
    test:assertEquals((<error>err3).message(), msg3);

    var err4 = ep20.attach(IncompleteService, "AnonService4");
    test:assertTrue(err4 is error);
    test:assertEquals((<error>err4).message(), msg4);
}
