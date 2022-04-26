// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

@test:Config {enable: true}
function testServerStreamingWithRecord() returns error? {
    string name = "WSO2";
    HelloWorldServerStreamingClient helloWorldEp = check new ("http://localhost:9113");
    HelloRequest newreq = {name: name};
    stream<HelloResponse, grpc:Error?> result = check helloWorldEp->lotsOfReplies(newreq);
    string[] expectedResults = ["Hi WSO2", "Hey WSO2", "GM WSO2"];
    int waitCount = 0;

    check result.forEach(function(anydata response) {
        HelloResponse helloResponse = <HelloResponse>response;
        test:assertEquals(helloResponse.message, expectedResults[waitCount]);
        waitCount += 1;
    });
}
