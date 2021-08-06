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
isolated function testGetGreeting() returns error? {
    TimestampServiceClient utsClient = check new ("http://localhost:9147");
    Greeting greeting = check utsClient->getGreeting("Hello");
    time:Utc customTime = [1196676930, 0.12];
    Greeting expectedGreeting = {"name": "Hello","time": customTime};
    test:assertEquals(greeting, expectedGreeting);
}

@test:Config {enable: true}
isolated function testExchangeGreeting() returns error? {
    TimestampServiceClient utsClient = check new ("http://localhost:9147");
    time:Utc customTime = [1228302930, 0.12];
    Greeting expectedGreeting = {"name": "Hello", "time": customTime};
    Greeting greeting = check utsClient->exchangeGreeting(expectedGreeting);
    test:assertEquals(greeting, expectedGreeting);
}

@test:Config {enable: true}
isolated function testExchangeTime() returns error? {
    TimestampServiceClient utsClient = check new ("http://localhost:9147");
    time:Utc sendingTime = check time:utcFromString("2008-12-03T11:15:30.120Z");
    time:Utc receivedTime = check utsClient->exchangeTime(sendingTime);
    time:Utc expectedTime = check time:utcFromString("2012-12-03T11:13:30.472Z");
    test:assertEquals(receivedTime, expectedTime);
}

@test:Config {enable: true}
isolated function testExchangeTimeContext() returns error? {
    TimestampServiceClient utsClient = check new ("http://localhost:9147");
    time:Utc sendingTime = check time:utcFromString("2008-12-03T11:15:30.120Z");
    ContextTimestamp result = check utsClient->exchangeTimeContext({
        headers: {},
        content: sendingTime
    });
    time:Utc expectedTime = check time:utcFromString("2012-12-03T11:13:30.472Z");
    test:assertEquals(result.content, expectedTime);
}

@test:Config {enable: true}
function testTimestampServerStream() returns error? {
    TimestampServiceClient utsClient = check new ("http://localhost:9147");
    time:Utc sendingTime = check time:utcFromString("2008-12-03T11:15:30.120Z");

    var result = check utsClient->serverStreamTime(sendingTime);
    int count = 0;
    time:Utc[] receivedData = [];
    error? e = result.forEach(function(time:Utc value) {
        receivedData[count] = value;
        count += 1;
    });
    test:assertEquals(receivedData, [sendingTime, sendingTime, sendingTime, sendingTime]);
}

@test:Config {enable: true}
function testTimestampContextServerStream() returns error? {
    TimestampServiceClient utsClient = check new ("http://localhost:9147");
    time:Utc sendingTime = check time:utcFromString("2008-12-03T11:15:30.120Z");

    ContextTimestampStream result = check utsClient->serverStreamTimeContext({
        headers: {"req-header": ["1234567890", "2233445677"]},
        content: sendingTime
    });
    int count = 0;
    time:Utc[] receivedData = [];
    error? e = result.content.forEach(function(time:Utc value) {
        receivedData[count] = value;
        count += 1;
    });
    test:assertEquals(receivedData, [sendingTime, sendingTime, sendingTime, sendingTime]);
}

@test:Config {enable: true}
isolated function testTimestampClientStream() returns error? {
    TimestampServiceClient utsClient = check new ("http://localhost:9147");
    time:Utc sendingTime = check time:utcFromString("2008-12-03T11:15:30.120Z");
    ClientStreamTimeStreamingClient result = check utsClient->clientStreamTime();
    check result->sendTimestamp(sendingTime);
    check result->complete();
    time:Utc? res = check result->receiveTimestamp();
    test:assertEquals(res, sendingTime);
}

@test:Config {enable: true}
isolated function testTimestampContextClientStream() returns error? {
    TimestampServiceClient utsClient = check new ("http://localhost:9147");
    time:Utc sendingTime = check time:utcFromString("2008-12-03T11:15:30.120Z");
    ClientStreamTimeStreamingClient result = check utsClient->clientStreamTime();
    check result->sendContextTimestamp({
        headers: {"req-header": ["1234567890", "2233445677"]},
        content: sendingTime
    });
    check result->complete();
    ContextTimestamp? res = check result->receiveContextTimestamp();
    if res is ContextTimestamp {
        test:assertEquals(res.content, sendingTime);
    } else {
        test:assertFail(msg = "Expected a context timestamp");
    }
}
