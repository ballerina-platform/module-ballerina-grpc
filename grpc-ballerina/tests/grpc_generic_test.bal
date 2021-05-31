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

import ballerina/test;

@test:Config {enable: true}
isolated function testCheckErrorForRetry() {
    ErrorType[] errorTypes = [
        CancelledError, 
        UnKnownError, 
        InvalidArgumentError, 
        DeadlineExceededError, 
        NotFoundError, 
        AlreadyExistsError, 
        PermissionDeniedError, 
        UnauthenticatedError, 
        ResourceExhaustedError, 
        FailedPreconditionError, 
        AbortedError, 
        OutOfRangeError, 
        UnimplementedError, 
        InternalError, 
        DataLossError, 
        UnavailableError, 
        ResiliencyError, 
        AllRetryAttemptsFailed

    ];
    ErrorType[] negativeErrorTypes = [
        CancelledError
    ];

    CancelledError cancelledError = error CancelledError("Mocking CancelledError");
    UnKnownError unKnownError = error UnKnownError("Mocking UnKnownError");
    InvalidArgumentError invalidArgumentError = error InvalidArgumentError("Mocking InvalidArgumentError");
    DeadlineExceededError deadlineExceededError = error DeadlineExceededError("Mocking DeadlineExceededError");
    NotFoundError notFoundError = error NotFoundError("Mocking NotFoundError");
    AlreadyExistsError alreadyExistsError = error AlreadyExistsError("Mocking AlreadyExistsError");
    PermissionDeniedError permissionDeniedError = error PermissionDeniedError("Mocking PermissionDeniedError");
    UnauthenticatedError unauthenticatedError = error UnauthenticatedError("Mocking UnauthenticatedError");
    AbortedError abortedError = error AbortedError("Mocking AbortedError");
    OutOfRangeError outOfRangeError = error OutOfRangeError("Mocking OutOfRangeError");
    UnimplementedError unimplementedError = error UnimplementedError("Mocking UnimplementedError");
    InternalError internalError = error InternalError("Mocking InternalError");
    DataLossError dataLossError = error DataLossError("Mocking DataLossError");
    UnavailableError unavailableError = error UnavailableError("Mocking UnavailableError");
    ResiliencyError resiliencyError = error ResiliencyError("Mocking ResiliencyError");
    AllRetryAttemptsFailed allRetryAttemptsFailed = error AllRetryAttemptsFailed("Mocking AllRetryAttemptsFailed");

    test:assertTrue(checkErrorForRetry(cancelledError, errorTypes));
    test:assertTrue(checkErrorForRetry(unKnownError, errorTypes));
    test:assertTrue(checkErrorForRetry(invalidArgumentError, errorTypes));
    test:assertTrue(checkErrorForRetry(deadlineExceededError, errorTypes));
    test:assertTrue(checkErrorForRetry(notFoundError, errorTypes));
    test:assertTrue(checkErrorForRetry(alreadyExistsError, errorTypes));
    test:assertTrue(checkErrorForRetry(permissionDeniedError, errorTypes));
    test:assertTrue(checkErrorForRetry(unauthenticatedError, errorTypes));
    test:assertTrue(checkErrorForRetry(abortedError, errorTypes));
    test:assertTrue(checkErrorForRetry(unimplementedError, errorTypes));
    test:assertTrue(checkErrorForRetry(internalError, errorTypes));
    test:assertTrue(checkErrorForRetry(dataLossError, errorTypes));
    test:assertTrue(checkErrorForRetry(unavailableError, errorTypes));
    test:assertTrue(checkErrorForRetry(resiliencyError, errorTypes));
    test:assertTrue(checkErrorForRetry(allRetryAttemptsFailed, errorTypes));

    test:assertFalse(checkErrorForRetry(allRetryAttemptsFailed, negativeErrorTypes));
}
