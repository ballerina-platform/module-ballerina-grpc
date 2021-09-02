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
import ballerina/log;
import ballerina/io;
import ballerina/protobuf.types.wrappers;

listener grpc:Listener  ep36 = new (9126);
const string TEST_DEADLINE_HEADER = "testdeadline";

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_36_UNARY_SERVICE_WITH_DEADLINE_PROPAGATION,
    descMap: getDescriptorMap36UnaryServiceWithDeadlinePropagation()
}
service "HelloWorld36S1" on ep36 {
    
    remote isolated function call1(ContextString request) returns wrappers:ContextString|grpc:Error {
        log:printInfo("Invoked call1");
        var cancel = grpc:isCancelled(request.headers);
        if cancel is boolean {
            if cancel {
                return error grpc:DeadlineExceededError("Exceeded the configured deadline");
            } else {
                HelloWorld36S2Client helloWorldClient = checkpanic new ("http://localhost:9126");
                var deadline = grpc:getDeadline(request.headers);
                if deadline is time:Utc {
                    string deadlineStringValue = time:utcToString(deadline);
                    request.headers[TEST_DEADLINE_HEADER] = deadlineStringValue;
                    return helloWorldClient->call2Context({content: "WSO2", headers: request.headers});
                } else if deadline is time:Error {
                    return error grpc:CancelledError(deadline.message());
                } else {
                    return error grpc:CancelledError("Deadline is not specified");
                }
            }
        } else {
            return error grpc:CancelledError(cancel.message());
        }
    }
}

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_36_UNARY_SERVICE_WITH_DEADLINE_PROPAGATION,
    descMap: getDescriptorMap36UnaryServiceWithDeadlinePropagation()
}
service "HelloWorld36S2" on ep36 {
    remote isolated function call2(ContextString request) returns wrappers:ContextString|error {
        log:printInfo("Invoked call2");
        if request.headers[TEST_DEADLINE_HEADER] != () {
            string|string[]? deadlineStringValue = request.headers[TEST_DEADLINE_HEADER];
            if deadlineStringValue is string {
                time:Utc currentTime = time:utcNow();
                var deadline = time:utcFromString(deadlineStringValue);
                if deadline is time:Utc {
                    [int, decimal] [deadlineSeconds, deadlineSecondFraction] = deadline;
                    [int, decimal] [currentSeconds, currentSecondFraction] = currentTime;
                    io:println(deadline);
                    if currentSeconds < deadlineSeconds {
                        return {content: "Ack", headers: {}};
                    } else if currentSeconds == deadlineSeconds && currentSecondFraction <= deadlineSecondFraction{
                        return {content: "Ack", headers: {}};
                    } else {
                        return error grpc:DeadlineExceededError("Exceeded the configured deadline");
                    }
                } else {
                    return error grpc:CancelledError(deadline.message());
                }
            }
        }
        return error grpc:CancelledError("Test deadline header is not specified");
    }
}
