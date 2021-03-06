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

import ballerina/time;

listener Listener ep47 = new (9147);

@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_47, descMap: getDescriptorMap_47()}
service "UnaryTimestampService" on ep47 {

    remote function getGreeting(UnaryTimestampServiceGreetingCaller caller, string value) returns error? {
        Greeting greeting = {
            name: value,
            time: check time:utcFromString("2007-12-03T10:15:30.120Z")
        };
        check caller->sendGreeting(greeting);
        check caller->complete();
    }

    remote function getBiGreeting(UnaryTimestampServiceGreetingCaller caller, Greeting value) returns error? {
        Greeting greeting = {
            name: value.name,
            time: check time:utcFromString("2008-12-03T11:15:30.120Z")
        };
        check caller->sendGreeting(greeting);
        check caller->complete();
    }
    
    remote function getBiTime(UnaryTimestampServiceTimestampCaller caller, time:Utc value) returns time:Utc|error? {
        time:Utc expectedTime = check time:utcFromString("2008-12-03T11:15:30.120Z");
        if expectedTime == value {
            time:Utc sendingTime = check time:utcFromString("2012-12-03T11:13:30.472Z");
            check caller->sendTimestamp(sendingTime);
            check caller->complete();
        } else {
            check caller->sendError(error Error("Timestamp does not match"));
            check caller->complete();
        }
    }
}
