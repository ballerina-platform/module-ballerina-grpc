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
import ballerina/time;

@test:Config {enable: true}
isolated function testBidiStreamingFromReturnRecordWithDeadline() returns grpc:Error? {
    HelloWorld37Client helloWorldCaller = check new ("http://localhost:9127");
    time:Utc current = time:utcNow();
    time:Utc deadline = time:utcAddSeconds(current, 300);
    map<string|string[]> headers = grpc:setDeadline(deadline);

    CallWithDeadlineStreamingClient streamingClient = check helloWorldCaller->callWithDeadline();

    string[] requests = [
        "WSO2",
        "Microsoft",
        "Facebook",
        "Google"
    ];
    foreach string s in requests {
        check streamingClient->sendContextString({content: s, headers: headers});
    }
    check streamingClient->complete();
    string? result = check streamingClient->receiveString();
    int i = 0;
    while !(result is ()) {
        test:assertTrue(result is string);
        test:assertEquals(<string>result, requests[i]);
        result = check streamingClient->receiveString();
        i += 1;
    }
    test:assertEquals(i, 4);
}
