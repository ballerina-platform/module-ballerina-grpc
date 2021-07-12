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

// @test:Config {enable: true}
// isolated function testIsCancelledPositive() returns error? {
//     HelloWorld50Client hClient = check new ("http://localhost:9150");
//     SendStringStreamingClient strClient = check hClient->sendString();
//     check strClient->sendString("Gemba");
//     check strClient->sendString("Gemba");
//     string|error? val = check strClient->receiveString();
//     val = check strClient->receiveString();
    
//     check strClient->complete();

//     boolean cancellation = check hClient->checkCancellation();
//     test:assertTrue(cancellation);
// }

@test:Config {enable: true}
function testCallerIsCancelled() returns error? {
    HelloWorld50Client hClient = check new ("http://localhost:9150");
    SendStringStreamingClient strClient = check hClient->sendString();
    check strClient->sendString("Test1");
    check strClient->sendString("Test2");
    // string|error? val = check strClient->receiveString();
    // val = check strClient->receiveString();
    // if (val is string) {
    //     io:println(val);
    // }
    check strClient->complete();
    boolean cancellation = check hClient->checkCancellation();
    test:assertFalse(cancellation);
}
