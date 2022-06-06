// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/protobuf.types.'any;

@test:Config
function testPredefinedTypesInMessages() returns error? {
    PredefinedTypesInServiceClient cl = check new ("http://localhost:9166");

    AnyTypeMsgForAnyMessage anyMessage = {name: "Ballerina", code: 71};
    AnyMessageRequest anyRequest = {name: "Ballerina", details: check 'any:pack(anyMessage)};
    AnyMessageResponse anyResponse = check cl->anyCall(anyRequest);
    test:assertEquals(anyResponse, <AnyMessageResponse>{name: "Ballerina", details: check 'any:pack(anyMessage)});

    StructMessageRequest structRequest = {name: "Ballerina", details: {"key1": "Hello", "key2": 25.0, "key3": false}};
    StructMessageResponse structResponse = check cl->structCall(structRequest);
    test:assertEquals(structResponse, <StructMessageResponse>{name: "Ballerina", details: {"key1": "Hello", "key2": 25.0, "key3": false}});

    time:Utc t = check time:utcFromString("2008-12-03T11:15:30.120Z");
    TimestampMessageRequest timestampRequest = {name: "Ballerina", details: t};
    TimestampMessageResponse timestampResponse = check cl->timestampCall(timestampRequest);
    test:assertEquals(timestampResponse, <TimestampMessageResponse>{name: "Ballerina", details: t});

    time:Seconds d = 4.44d;
    DurationMessageRequest durationRequest = {name: "Ballerina", details: d};
    DurationMessageResponse durationResponse = check cl->durationCall(durationRequest);
    test:assertEquals(durationResponse, <DurationMessageResponse>{name: "Ballerina", details: d});

}
