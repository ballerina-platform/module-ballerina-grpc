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

@test:Config {enable:true}
isolated function testBidiStreamingFromReturnRecord() returns grpc:Error? {
    HelloWorld34Client helloWorldEp = check new ("http://localhost:9124");
    SayHello34StreamingClient streamingClient = check helloWorldEp->sayHello34();

    SampleMsg34[] requests = [
        {name: "WSO2", id: 0},
        {name: "Microsoft", id: 1},
        {name: "Facebook", id: 2},
        {name: "Google", id: 3}
    ];
    foreach SampleMsg34 r in requests {
        grpc:Error? err = streamingClient->sendSampleMsg34(r);
        if err is grpc:Error {
            test:assertFail("Error from Connector: " + err.message());
        }
    }
    check streamingClient->complete();
    SampleMsg34? result = check streamingClient->receiveSampleMsg34();
    int i = 0;
    while !(result is ()) {
        test:assertEquals(<SampleMsg34> result, requests[i]);
        result = check streamingClient->receiveSampleMsg34();
        i += 1;
    }
    test:assertEquals(i, 4);
}
