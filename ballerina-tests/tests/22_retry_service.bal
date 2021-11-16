// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

int TIMEOUT = 5000;
int requestCount = 0;

string clientName = "";

listener grpc:Listener  retryListener = new (9112);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_22_RETRY_SERVICE,
    descMap: getDescriptorMap22RetryService()
}
service "RetryService" on retryListener {
    remote function getResult(string value) returns string|error {
        // Identifying the client to maintain state to track retry attempts.
        if clientName != value {
            requestCount = 0;
            clientName = value;
        }
        requestCount += 1;
        log:printInfo(clientName + ": Attempt No. " + requestCount.toString());
        if requestCount < 4 {
            match value {
                "CancelledError" => {
                    return error grpc:CancelledError("Mocking Cancelled grpc:Error");
                }
                "UnKnownError" => {
                    return error grpc:UnKnownError("Mocking UnKnown grpc:Error");
                }
                "InvalidArgumentError" => {
                    return error grpc:InvalidArgumentError("Mocking InvalidArgument grpc:Error");
                }
                "DeadlineExceededError" => {
                    return error grpc:DeadlineExceededError("Mocking DeadlineExceeded grpc:Error");
                }
                "NotFoundError" => {
                    return error grpc:NotFoundError("Mocking NotFound grpc:Error");
                }
                "AlreadyExistsError" => {
                    return error grpc:AlreadyExistsError("Mocking AlreadyExists grpc:Error");
                }
                "PermissionDeniedError" => {
                    return error grpc:PermissionDeniedError("Mocking PermissionDenied grpc:Error");
                }
                "UnauthenticatedError" => {
                    return error grpc:UnauthenticatedError("Mocking Unauthenticated grpc:Error");
                }
                "ResourceExhaustedError" => {
                    return error grpc:UnauthenticatedError("Mocking ResourceExhausted grpc:Error");
                }
                "FailedPreconditionError" => {
                    return error grpc:FailedPreconditionError("Mocking FailedPrecondition grpc:Error");
                }
                "AbortedError" => {
                    return error grpc:AbortedError("Mocking Aborted grpc:Error");
                }
                "OutOfRangeError" => {
                    return error grpc:OutOfRangeError("Mocking OutOfRange grpc:Error");
                }
                "UnimplementedError" => {
                    return error grpc:OutOfRangeError("Mocking Unimplemented grpc:Error");
                }
                "InternalError" => {
                    return error grpc:InternalError("Mocking Internal grpc:Error");
                }
                "DataLossError" => {
                    return error grpc:DataLossError("Mocking DataLoss grpc:Error");
                }
                "UnavailableError" => {
                    return error grpc:UnavailableError("Mocking Unavailable grpc:Error");
                }
                _ => {
                    return error("Mocking Generic grpc:Error");
                }
            }
        } else {
            return "Total Attempts: " + requestCount.toString();
        }
    }
}
