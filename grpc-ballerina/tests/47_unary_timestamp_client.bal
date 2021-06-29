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
import ballerina/time;

@test:Config {enable: true}
isolated function testUnaryTimestampWithGreeting() returns error? {
    UnaryTimestampServiceClient utsClient = check new ("http://localhost:9147");
    Greeting greeting = check utsClient->getGreeting("Hello");
    [int, decimal] & readonly time = [1196676930, 0.12];
    Greeting expectedGreeting = {"name": "Hello","time": time};
    test:assertEquals(greeting, expectedGreeting);
}

@test:Config {enable: true}
function testUnaryTimestampWithBidiGreeting() returns error? {
    UnaryTimestampServiceClient utsClient = check new ("http://localhost:9147");
    [int, decimal] & readonly time = [1228302930, 0.12];
    Greeting expectedGreeting = {"name": "Hello", "time": time};
    Greeting greeting = check utsClient->getBiGreeting(expectedGreeting);
    test:assertEquals(greeting, expectedGreeting);
}

@test:Config {enable: true}
isolated function testUnaryTimestampWithBidiTime() returns error? {
    UnaryTimestampServiceClient utsClient = check new ("http://localhost:9147");
    time:Utc sendingTime = check time:utcFromString("2008-12-03T11:15:30.120Z");
    time:Utc receivedTime = check utsClient->getBiTime(sendingTime);
    time:Utc expectedTime = check time:utcFromString("2012-12-03T11:13:30.472Z");
    test:assertEquals(receivedTime, expectedTime);
}

@test:Config {enable: true}
isolated function testUnaryTimestampWithBidiTimeContext() returns error? {
    UnaryTimestampServiceClient utsClient = check new ("http://localhost:9147");
    time:Utc sendingTime = check time:utcFromString("2008-12-03T11:15:30.120Z");
    ContextTimestamp result = check utsClient->getBiTimeContext(sendingTime);
    time:Utc expectedTime = check time:utcFromString("2012-12-03T11:13:30.472Z");
    test:assertEquals(result.content, expectedTime);
}
