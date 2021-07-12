// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# Represents gRPC related errors.
public type Error distinct error;

# Represents the operation canceled(typically by the caller) error.
public type CancelledError distinct Error;

# Represents unknown error.(e.g. Status value received is unknown)
public type UnKnownError distinct Error;

# Represents client specified an invalid argument error.
public type InvalidArgumentError distinct Error;

# Represents operation expired before completion error.
public type DeadlineExceededError distinct Error;

# Represents requested entity (e.g., file or directory) not found error.
public type NotFoundError distinct Error;

# Represents error occur when attempt to create an entity which already exists.
public type AlreadyExistsError distinct Error;

# Represents error occur when the caller does not have permission to execute the specified operation.
public type PermissionDeniedError distinct Error;

# Represents error occur when the request does not have valid authentication credentials for the operation.
public type UnauthenticatedError distinct Error;

# Represents error occur when the resource is exhausted.
public type ResourceExhaustedError distinct Error;

# Represents error occur when operation is rejected because the system is not in a state required for the operation's execution.
public type FailedPreconditionError distinct Error;

# Represents error occur when operation is aborted.
public type AbortedError distinct Error;

# Represents error occur when specified value is out of range.
public type OutOfRangeError distinct Error;

# Represents error occur when operation is not implemented or not supported/enabled in this service.
public type UnimplementedError distinct Error;

# Represents internal error.
public type InternalError distinct Error;

# Represents error occur when the service is currently unavailable.
public type UnavailableError distinct Error;

# Represents unrecoverable data loss or corruption erros.
public type DataLossError distinct Error;

# Represents all the resiliency-related errors.
public type ResiliencyError distinct Error;

# Represents error scenario where the maximum retry attempts are done and still received an error.
public type AllRetryAttemptsFailed distinct ResiliencyError;

# Represents an error when calling next when the stream has closed.
public type StreamClosedError distinct Error;

# Represents an error when expected data type is not available.
public type DataMismatchError distinct Error;

# Represents an error when client authentication error occured.
public type ClientAuthError distinct Error;

# Represents gRPC related error types.
public type ErrorType typedesc<Error>;
