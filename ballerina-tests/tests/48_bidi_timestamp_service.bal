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

listener grpc:Listener ep48 = new (9148);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_48_BIDI_TIMESTAMP, descMap: getDescriptorMap48BidiTimestamp()}
service "BidiStreamingTimestampService" on ep48 {

    remote function bidiStreamingGreetServer(BidiStreamingTimestampServiceBiDiGreetingCaller caller,
     stream<string, error?> clientStream) returns error? {
        error? e = clientStream.forEach(function(string value) {
            BiDiGreeting greeting = {
                name: value,
                time: checkpanic time:utcFromString("2012-12-03T11:13:30.472Z")
            };
            checkpanic caller->sendBiDiGreeting(greeting);
        });
    }

    remote function bidiStreamingGreetBoth(BidiStreamingTimestampServiceBiDiGreetingCaller caller,
     stream<BiDiGreeting, grpc:Error?> clientStream) returns error? {
        error? e = clientStream.forEach(function(BiDiGreeting value) {
            BiDiGreeting greeting = {
                name: value.name,
                time: checkpanic time:utcFromString("2012-12-03T11:13:30.472Z")
            };
            checkpanic caller->sendBiDiGreeting(greeting);
        });
    }
    
    remote function bidiStreamingExchangeTime(BidiStreamingTimestampServiceTimestampCaller caller,
     stream<time:Utc, grpc:Error?> clientStream) returns error? {
        time:Utc responseTime = check time:utcFromString("2021-12-03T11:13:30.472Z");
        error? e = clientStream.forEach(function(time:Utc value) {
            checkpanic caller->sendTimestamp(responseTime);
        });
    }
}
