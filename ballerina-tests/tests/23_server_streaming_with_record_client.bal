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
import ballerina/io;
import ballerina/test;

@test:Config {enable:true}
function testServerStreamingWithRecord() returns grpc:Error? {
    string name = "WSO2";
    helloWorldServerStreamingClient helloWorldEp = check new("http://localhost:9113");
    HelloRequest newreq = {name: name};
    var result = helloWorldEp->lotsOfReplies(newreq);
    if result is grpc:Error {
        test:assertFail("Error from Connector: " + result.message());
    } else {
        io:println("Connected successfully");
        string[] expectedResults = ["Hi WSO2", "Hey WSO2", "GM WSO2"];
        int waitCount = 0;
        error? e = result.forEach(function(anydata response) {
            HelloResponse helloResponse = <HelloResponse> response;
            test:assertEquals(helloResponse.message, expectedResults[waitCount]);
            waitCount += 1;
        });
    }
}
