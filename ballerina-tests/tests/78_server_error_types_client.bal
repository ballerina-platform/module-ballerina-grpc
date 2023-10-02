// Copyright (c) 2023 WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
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

import ballerina/io;
import ballerina/grpc;
import ballerina/test;

@test:Config {enable: true}
function testErrorTypesCancelledError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(1);
    io:println(response);
    if response is grpc:CancelledError {
        test:assertEquals(response.message(), "Cancelled execution");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesUnKnownError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(2);
    io:println(response);
    if response is grpc:UnKnownError {
        test:assertEquals(response.message(), "Unknown request");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesInvalidArgumentError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(3);
    io:println(response);
    if response is grpc:InvalidArgumentError {
        test:assertEquals(response.message(), "Invalid argument");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesDeadlineExceededError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(4);
    io:println(response);
    if response is grpc:DeadlineExceededError {
        test:assertEquals(response.message(), "Deadline exceeded");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesNotFoundError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(5);
    io:println(response);
    if response is grpc:NotFoundError {
        test:assertEquals(response.message(), "Not found");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesAlreadyExistsError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(6);
    io:println(response);
    if response is grpc:AlreadyExistsError {
        test:assertEquals(response.message(), "Already exists");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesPermissionDeniedError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(7);
    io:println(response);
    if response is grpc:PermissionDeniedError {
        test:assertEquals(response.message(), "Permission denied");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesUnauthenticatedError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(8);
    io:println(response);
    if response is grpc:UnauthenticatedError {
        test:assertEquals(response.message(), "Unauthenticated");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesResourceExhaustedError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(9);
    io:println(response);
    if response is grpc:ResourceExhaustedError {
        test:assertEquals(response.message(), "Resource exhausted");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesFailedPreconditionError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(10);
    io:println(response);
    if response is grpc:FailedPreconditionError {
        test:assertEquals(response.message(), "Failed precondition");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesAbortedError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(11);
    io:println(response);
    if response is grpc:AbortedError {
        test:assertEquals(response.message(), "Aborted execution");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesOutOfRangeError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(12);
    io:println(response);
    if response is grpc:OutOfRangeError {
        test:assertEquals(response.message(), "Out of range");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesUnimplementedError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(13);
    io:println(response);
    if response is grpc:UnimplementedError {
        test:assertEquals(response.message(), "Unimplemented");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesInternalError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(14);
    io:println(response);
    if response is grpc:InternalError {
        test:assertEquals(response.message(), "Internal error");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesUnavailableError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(15);
    io:println(response);
    if response is grpc:UnavailableError {
        test:assertEquals(response.message(), "Unavailable");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesDataLossError() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(16);
    io:println(response);
    if response is grpc:DataLossError {
        test:assertEquals(response.message(), "Data loss");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}

@test:Config {enable: true}
function testErrorTypesUnknownErrorType() returns error? {
    ServerErrorTypesServiceClient errorClient = check new ("http://localhost:9178");
    error? response = errorClient->GetServerError(22);
    io:println(response);
    if response is error {
        test:assertEquals(response.message(), "Unknown error type");
    } else {
        test:assertFail("Expected error type is not returned");
    }
}


