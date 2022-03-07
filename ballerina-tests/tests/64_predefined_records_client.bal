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

PredefinedRecordsClient cl = check new ("http://localhost:9164");

@test:Config
function testCallsWithPredefinedMessageNames() returns error? {

    Any anyRec = check cl->CallAny('any:pack("Any"));
    test:assertEquals(anyRec, {name: "Any"});

    Struct structRec = check cl->CallStruct({name: "Struct"});
    test:assertEquals(structRec, {name: "Struct"});

    Duration durationRec = check cl->CallDuration(12.23d);
    test:assertEquals(durationRec, {name: "Duration"});

    time:Utc utc = check time:utcFromString("2007-12-03T10:15:30.00Z");
    Timestamp timestampRec = check cl->CallTimestamp(utc);
    test:assertEquals(timestampRec, {name: "Timestamp"});

    Empty emptyRec = check cl->CallEmpty();
    test:assertEquals(emptyRec, {});
}

