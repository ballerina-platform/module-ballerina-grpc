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
import ballerina/log;
import ballerina/time;

listener grpc:Listener  ep49 = new (9149);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_49_DURATION, descMap: getDescriptorMap49Duration()}
service "DurationHandler" on ep49 {

    remote function unaryCall1(string value) returns time:Seconds|error {
        return 12.34d;
    }
    remote function unaryCall2(DurationHandlerDurationMsgCaller caller, DurationMsg dm) returns grpc:Error? {
        check caller->sendDurationMsg(dm);
    }
    remote function clientStreaming(stream<time:Seconds, grpc:Error?> clientStream) returns string|error {
        check clientStream.forEach(function(time:Seconds d) {
            log:printInfo(d.toString());
        });
        return "Ack";
    }
    remote function serverStreaming(string value) returns stream<time:Seconds, error?>|error {
        time:Seconds[] durations = [1.11d, 2.22d, 3.33d, 4.44d];
        return durations.toStream();
    }
    remote function bidirectionalStreaming(stream<DurationMsg, grpc:Error?> clientStream) returns stream<DurationMsg, error?>|error {
        return clientStream;
    }
}

