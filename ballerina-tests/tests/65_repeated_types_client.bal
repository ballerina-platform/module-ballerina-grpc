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
import ballerina/protobuf.types.'any;
import ballerina/time;

@test:Config {enable: true}
function testPredefinedTypesAsRepeatedValues() returns error? {
    RepeatedTypesServiceClient repeatedClient = check new ("http://localhost:9165");

    AnyTypeMsg msg = {name: "Ballerina", code: 71};
    'any:Any[] anyDetails = [
        check 'any:pack("Hello Ballerina"),
        check 'any:pack(71),
        check 'any:pack(msg)
    ];
    AnyArrayResponse anyResponse = check repeatedClient->anyCall({name: "Ballerina", details: anyDetails});
    test:assertEquals(anyResponse, <AnyArrayResponse>{name: "Ballerina", details: anyDetails});

    map<anydata>[] structDetails = [
        {"key1": "Hello", "key2": 25.0, "key3": false},
        {"key1": "WSO2", "key2": -25.0, "key3": [1.0, "Hello"]},
        {}
    ];
    StructArrayResponse structResponse = check repeatedClient->structCall({name: "Ballerina", details: structDetails});
    test:assertEquals(structResponse, <StructArrayResponse>{name: "Ballerina", details: structDetails});

    time:Utc t1 = check time:utcFromString("2008-12-03T11:15:30.120Z");
    time:Utc t2 = check time:utcFromString("2008-12-03T11:16:30.120Z");
    time:Utc t3 = check time:utcFromString("2008-12-03T11:17:30.120Z");
    time:Utc[] timestampDetails = [t1, t2, t3];
    TimestampArrayResponse timestampResponse = check repeatedClient->timestampCall({name: "Ballerina", details: timestampDetails});
    test:assertEquals(timestampResponse, <TimestampArrayResponse>{name: "Ballerina", details: timestampDetails});

    time:Seconds[] durationDetails = [1.11d, 2.22d, 3.33d, 4.44d];
    DurationArrayResponse durationResponse = check repeatedClient->durationCall({name: "Ballerina", details: durationDetails});
    test:assertEquals(durationResponse, <DurationArrayResponse>{name: "Ballerina", details: durationDetails});
}
