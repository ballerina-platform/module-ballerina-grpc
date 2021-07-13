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

import ballerina/log;

int TIMEOUT = 5000;
int requestCount = 0;

string clientName = "";

listener Listener retryListener = new (9112);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_22,
    descMap: getDescriptorMap22()
}
service "RetryService" on retryListener {
    remote function getResult(string value) returns string|error {
        // Identifying the client to maintain state to track retry attempts.
        if (clientName != value) {
            requestCount = 0;
            clientName = <@untainted>value;
        }
        requestCount += 1;
        log:printInfo(clientName + ": Attetmpt No. " + requestCount.toString());
        if (requestCount < 4) {
            match value {
                "CancelledError" => {
                    return error CancelledError("Mocking Cancelled Error");
                }
                "UnKnownError" => {
                    return error UnKnownError("Mocking UnKnown Error");
                }
                "InvalidArgumentError" => {
                    return error InvalidArgumentError("Mocking InvalidArgument Error");
                }
                "DeadlineExceededError" => {
                    return error DeadlineExceededError("Mocking DeadlineExceeded Error");
                }
                "NotFoundError" => {
                    return error NotFoundError("Mocking NotFound Error");
                }
                "AlreadyExistsError" => {
                    return error AlreadyExistsError("Mocking AlreadyExists Error");
                }
                "PermissionDeniedError" => {
                    return error PermissionDeniedError("Mocking PermissionDenied Error");
                }
                "UnauthenticatedError" => {
                    return error UnauthenticatedError("Mocking Unauthenticated Error");
                }
                "ResourceExhaustedError" => {
                    return error UnauthenticatedError("Mocking ResourceExhausted Error");
                }
                "FailedPreconditionError" => {
                    return error FailedPreconditionError("Mocking FailedPrecondition Error");
                }
                "AbortedError" => {
                    return error AbortedError("Mocking Aborted Error");
                }
                "OutOfRangeError" => {
                    return error OutOfRangeError("Mocking OutOfRange Error");
                }
                "UnimplementedError" => {
                    return error OutOfRangeError("Mocking Unimplemented Error");
                }
                "InternalError" => {
                    return error InternalError("Mocking Internal Error");
                }
                "DataLossError" => {
                    return error DataLossError("Mocking DataLoss Error");
                }
                "UnavailableError" => {
                    return error UnavailableError("Mocking Unavailable Error");
                }
                _ => {
                    return error("Mocking Generic Error");
                }
            }
        } else {
            return "Total Attempts: " + requestCount.toString();
        }
    }
}
