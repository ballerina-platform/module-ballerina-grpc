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
import ballerina/time;

listener grpc:Listener ep47 = new (9147);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_47_UNARY_TIMESTAMP, descMap: getDescriptorMap47UnaryTimestamp()}
service "TimestampService" on ep47 {

    remote function getGreeting(TimestampServiceGreetingCaller caller, string value) returns error? {
        Greeting greeting = {
            name: value,
            time: check time:utcFromString("2007-12-03T10:15:30.120Z")
        };
        checkpanic caller->sendGreeting(greeting);
        checkpanic caller->complete();
    }

    remote function exchangeGreeting(TimestampServiceGreetingCaller caller, Greeting value) returns error? {
        Greeting greeting = {
            name: value.name,
            time: check time:utcFromString("2008-12-03T11:15:30.120Z")
        };
        checkpanic caller->sendGreeting(greeting);
        checkpanic caller->complete();
    }

    remote function exchangeTime(TimestampServiceTimestampCaller caller, time:Utc value) returns error? {
        time:Utc expectedTime = check time:utcFromString("2008-12-03T11:15:30.120Z");
        if expectedTime == value {
            time:Utc sendingTime = check time:utcFromString("2012-12-03T11:13:30.472Z");
            checkpanic caller->sendTimestamp(sendingTime);
            checkpanic caller->complete();
        } else {
            checkpanic caller->sendError(error grpc:Error("Timestamp does not match"));
            checkpanic caller->complete();
        }
        return;
    }

    remote function serverStreamTime(TimestampServiceTimestampCaller caller, time:Utc value) returns error? {
        time:Utc responseTime = check time:utcFromString("2008-12-03T11:15:30.120Z");
        time:Utc[] timearr = [responseTime, responseTime, responseTime, responseTime];
        _ = timearr.forEach(function(time:Utc val) {
            checkpanic caller->sendContextTimestamp({
                headers: {},
                content: val
            });
        });
    }

    remote function clientStreamTime(TimestampServiceTimestampCaller caller, stream<time:Utc, grpc:Error?> clientStream) returns error? {
        time:Utc[] timearr = [];
        check clientStream.forEach(function(time:Utc value) {
            timearr.push(value.cloneReadOnly());
        });
        checkpanic caller->sendContextTimestamp({
            headers: {},
            content: timearr[0]
        });
    }
}
