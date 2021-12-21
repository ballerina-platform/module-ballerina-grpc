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

import ballerina/grpc;
import ballerina/test;

@test:Config {enable: true}
function testReceiveStreamingResponseFromReturnWithBasicAuth() returns error? {
    SampleMsg32 reqMsg = {name: "WSO2", id: 2};
    HelloWorld32Client helloWorldEp = check new ("http://localhost:9122");

    stream<SampleMsg32, grpc:Error?> result = check helloWorldEp->sayHello(reqMsg);
    SampleMsg32[] expectedResults = [
        {name: "WSO2", id: 0},
        {name: "Microsoft", id: 1},
        {name: "Facebook", id: 2},
        {name: "Google", id: 3}
    ];
    int count = 0;
    check result.forEach(function(anydata value) {
        test:assertEquals(<SampleMsg32>value, expectedResults[count]);
        count += 1;
    });
    test:assertEquals(count, 4);
}

@test:Config {enable: true}
function testReceiveStreamingResponseWithHeaders() returns error? {
    SampleMsg32 reqMsg = {name: "WSO2", id: 2};
    HelloWorld32Client helloWorldEp = check new ("http://localhost:9222");

    ContextSampleMsg32Stream result = check helloWorldEp->sayHelloContext(reqMsg);
    SampleMsg32[] expectedResults = [
        {name: "WSO2", id: 0},
        {name: "Microsoft", id: 1},
        {name: "Facebook", id: 2},
        {name: "Google", id: 3}
    ];
    int count = 0;
    check result.content.forEach(function(SampleMsg32 value) {
        test:assertEquals(value, expectedResults[count]);
        count += 1;
    });
    test:assertEquals(count, 4);
    string resHeaderValue = check grpc:getHeader(result.headers, "zzz");
    test:assertEquals(resHeaderValue, "yyy");
}
