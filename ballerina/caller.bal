// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/jballerina.java;

# The base client used in the generated client code to provide remote functions for interacting with the caller.
#
# + instanceId - The connection ID
public isolated client class Caller {

    private int instanceId = -1;

    # Returns the unique identification of the caller.
    # ```ballerina
    # int result = caller.getId();
    # ```
    #
    # + return - caller ID
    public isolated function getId() returns int {
        lock {
            return self.instanceId;
        }
    }

    # Sends the outbound response to the caller.
    # ```ballerina
    # grpc:Error? err = caller->send(message);
    # ```
    #
    # + res - - The outbound response message
    # + return - - A `grpc:Error` if an error occurs while sending the response or else `()`
    isolated remote function send(anydata res) returns Error? {
        return externSend(self, res);
    }

    # Informs the caller, when the server has sent all the messages.
    # ```ballerina
    # grpc:Error? result = caller->complete();
    # ```
    #
    # + return - A `grpc:Error` if an error occurs while sending the response or else `()`
    isolated remote function complete() returns Error? {
        return externComplete(self);
    }

    # Checks whether the connection is closed by the caller.
    # ```ballerina
    # boolean result = caller.isCancelled();
    # ```
    #
    # + return - True if the caller has already closed the connection or else false
    public isolated function isCancelled() returns boolean {
        return externIsCancelled(self);
    }

    # Sends a server error to the caller.
    # ```ballerina
    # grpc:Error? result = caller->sendError(error grpc:AbortedError("Operation aborted"));
    # ```
    #
    # + err - Error instance.
    # + return - A `grpc:Error` if an error occurs while sending the response or else `()`
    isolated remote function sendError(Error err) returns Error? {
        return externSendError(self, err);
    }
}

isolated function externSend(Caller endpointClient, anydata res) returns Error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.caller.FunctionUtils"
} external;

isolated function externComplete(Caller endpointClient) returns Error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.caller.FunctionUtils"
} external;

isolated function externIsCancelled(Caller endpointClient) returns boolean =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.caller.FunctionUtils"
} external;

isolated function externSendError(Caller endpointClient, Error err) returns Error? =
@java:Method {
    'class: "io.ballerina.stdlib.grpc.nativeimpl.caller.FunctionUtils"
} external;
