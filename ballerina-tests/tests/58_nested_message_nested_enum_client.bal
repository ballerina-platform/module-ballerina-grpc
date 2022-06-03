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

helloWorldWithNestedMessageNestedEnumClient nestedClient = check new ("http://localhost:9158");

@test:Config {enable: true}
function testNestedMessageNestedEnumHello() returns error? {
    HelloRequest58 request = {
        name: "WSO2"
    };

    HelloResponse58_Bar_Foo foo = {
        i: 2
    };
    HelloResponse58_Bar bar = {
        i: 1,
        foo: [foo, foo, foo]
    };
    HelloResponse58 expectedResponse = {
        message: "Response",
        mode: neutral,
        bars: [bar, bar, bar, bar]
    };

    HelloResponse58 actualResponse = check nestedClient->hello(request);
    test:assertEquals(actualResponse, expectedResponse);
}

@test:Config {enable: true}
function testNestedMessageNestedEnumBye() returns error? {
    FileInfo_Observability_TraceId traceId = {
        id: "1",
        latest_version: "2.0"
    };
    FileInfo_Observability observability = {
        id: "1",
        latest_version: "2.0",
        traceId: traceId
    };
    FileInfo fileInfo = {
        observability: observability
    };
    ByeRequest58 request = {
        fileInfo: fileInfo,
        reqPriority: low
    };

    FileType fType = {
        'type: FILE
    };

    ByeResponse58 expectedResponse = {
        say: "Hey",
        fileType: fType
    };

    ByeResponse58 actualResponse = check nestedClient->bye(request);
    test:assertEquals(actualResponse, expectedResponse);
}
