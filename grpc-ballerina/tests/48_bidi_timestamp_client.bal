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
isolated function testBidiTimestampWithGreeting() returns error? {
    BidiStreamingTimestampServiceClient btsClient = check new ("http://localhost:9148");
    BidiStreamingGreetServerStreamingClient streamingClient = check btsClient->bidiStreamingGreetServer();
    string[] messages = ["Hi", "Hey", "Hello"];
    foreach string msg in messages {
        check streamingClient->sendString(msg);
    }
    check streamingClient->complete();
    foreach string msg in messages {
        BiDiGreeting? greeting = check streamingClient->receiveBiDiGreeting();
        if (greeting is BiDiGreeting) {
            time:Utc customTime = [1354533210, 0.472];
            BiDiGreeting expectedGreeting = {"name": msg,"time": customTime};
            test:assertEquals(greeting, expectedGreeting);
        } else {
            test:assertFail("Invalid message type");
        }
    }
}

@test:Config {enable: true}
function testBiDiTimestampWithBidiGreeting() returns error? {
    BidiStreamingTimestampServiceClient utsClient = check new ("http://localhost:9148");
    BidiStreamingGreetBothStreamingClient streamingClient = check utsClient->bidiStreamingGreetBoth();
    
    string[] messages = ["Hi", "Hey", "Hello"];
    foreach string msg in messages {
        BiDiGreeting greeting = {
            name: msg,
            time: [1354533210, 0.472]
        };
        check streamingClient->sendBiDiGreeting(greeting);
    }
    check streamingClient->complete();
    foreach string msg in messages {
        BiDiGreeting? greeting = check streamingClient->receiveBiDiGreeting();
        if (greeting is BiDiGreeting) {
            time:Utc customTime = [1354533210, 0.472];
            BiDiGreeting expectedGreeting = {"name": msg,"time": customTime};
            test:assertEquals(greeting, expectedGreeting);
        } else {
            test:assertFail("Invalid message type");
        }
    }
}

@test:Config {enable: true}
isolated function testBidiTimestampWithBidiTime() returns error? {
    BidiStreamingTimestampServiceClient utsClient = check new ("http://localhost:9148");
    BidiStreamingExchangeTimeStreamingClient streamingClient = check utsClient->bidiStreamingExchangeTime();
    
    time:Utc testTime = check time:utcFromString("2012-12-03T11:13:30.472Z");
    check streamingClient->sendTimestamp(testTime);
    check streamingClient->sendTimestamp(testTime);
    check streamingClient->sendTimestamp(testTime);
    
    check streamingClient->complete();

    time:Utc expectedTime = check time:utcFromString("2021-12-03T11:13:30.472Z");
    time:Utc? result = check streamingClient->receiveTimestamp();
    if (result is time:Utc) {
        test:assertEquals(result, expectedTime);
    } else {
        test:assertFail("Invalid time received");
    }
}

@test:Config {enable: true}
isolated function testBiDiTimestampWithBidiTimeContext() returns error? {

    BidiStreamingTimestampServiceClient utsClient = check new ("http://localhost:9148");
    BidiStreamingExchangeTimeStreamingClient streamingClient = check utsClient->bidiStreamingExchangeTime();
    
    time:Utc testTime = check time:utcFromString("2012-12-03T11:13:30.472Z");
    ContextTimestamp ctxtTimestamp = {
        content: testTime,
        headers: {
            "test": "test"
        }
    };
    check streamingClient->sendContextTimestamp(ctxtTimestamp);
    check streamingClient->sendContextTimestamp(ctxtTimestamp);
    check streamingClient->sendContextTimestamp(ctxtTimestamp);
    
    check streamingClient->complete();

    time:Utc expectedTime = check time:utcFromString("2021-12-03T11:13:30.472Z");
    ContextTimestamp? result = check streamingClient->receiveContextTimestamp();
    if (result is ContextTimestamp) {
        test:assertEquals(result.content, expectedTime);
    } else {
        test:assertFail("Invalid time received");
    }
}
