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

# Provides the gRPC streaming client actions for interacting with the gRPC server.
public client class StreamingClient {
    stream<anydata, Error?>? serverStream = ();

    # Sends the request message to the server.
    # ```ballerina
    # grpc:Error? err = sClient->send(message);
    # ```
    #
    # + res - The inbound request message
    # + return - A `grpc:Error` if an error occurs while sending the response or else `()`
    isolated remote function send(anydata res) returns Error? {
        return streamSend(self, res);
    }

    # Informs the server when the caller has sent all the messages.
    # ```ballerina
    # grpc:Error? result = sClient->complete();
    # ```
    #
    # + return - A `grpc:Error` if an error occurs while sending the response or else `()`
    isolated remote function complete() returns Error? {
        return streamComplete(self);
    }

    # Sends an error message to the server.
    # ```ballerina
    # grpc:Error? result = sClient->sendError(error grpc:AbortedError("Operation aborted"));
    # ```
    #
    # + err - Error instance
    # + return - A `grpc:Error` if an error occurs while sending the response or else `()`
    isolated remote function sendError(Error err) returns Error? {
        return streamSendError(self, err);
    }

    # Used to receive the server response only in client streaming and bidirectional streaming.
    # ```ballerina
    # anydata|grpc:Error? result = streamingClient->receive();
    # ```
    #
    # + return - An `anydata` value
    isolated remote function receive() returns [anydata, map<string|string[]>]|Error? {
        map<string|string[]> headers = {};
        if (externIsBidirectional(self)) {
            if (self.serverStream is stream<anydata, Error?>) {
                var nextRecord = (<stream<anydata, Error?>>self.serverStream).next();
                var headerMap = externGetHeaderMap(self);
                if (headerMap is map<string|string[]>) {
                    headers = headerMap;
                }
                if (nextRecord is record {|anydata value;|}) {
                    return [nextRecord.value, headers];
                } else {
                    return nextRecord;
                }
            } else {
                var result = externReceive(self);
                if (result is stream<anydata, Error?>) {
                    self.serverStream = result;
                    var nextRecord = (<stream<anydata, Error?>>self.serverStream).next();
                    var headerMap = externGetHeaderMap(self);
                    if (headerMap is map<string|string[]>) {
                        headers = headerMap;
                    }
                    if (nextRecord is record {|anydata value;|}) {
                        return [nextRecord.value, headers];
                    } else {
                        return nextRecord;
                    }
                } else if (result is anydata) {
                   return error DataMismatchError("Expected a stream but found an anydata type.");
                } else {
                    return result;
                }
            }
        } else {
           var result = externReceive(self);
           var headerMap = externGetHeaderMap(self);
           if (headerMap is map<string|string[]>) {
               headers = headerMap;
           }
           if (result is anydata) {
               return [result, headers];
           } else if (result is stream<anydata, Error?>) {
               return error DataMismatchError("Expected an anydata type but found a stream.");
           } else {
               return result;
           }
        }
    }
}

isolated function streamSend(StreamingClient streamConnection, anydata res) returns Error? =
@java:Method {
    'class: "org.ballerinalang.net.grpc.nativeimpl.streamingclient.FunctionUtils"
} external;

isolated function streamComplete(StreamingClient streamConnection) returns Error? =
@java:Method {
    'class: "org.ballerinalang.net.grpc.nativeimpl.streamingclient.FunctionUtils"
} external;

isolated function streamSendError(StreamingClient streamConnection, Error err) returns Error? =
@java:Method {
    'class: "org.ballerinalang.net.grpc.nativeimpl.streamingclient.FunctionUtils"
} external;

isolated function externReceive(StreamingClient streamConnection) returns anydata|stream<anydata, Error>|Error =
@java:Method {
    'class: "org.ballerinalang.net.grpc.nativeimpl.streamingclient.FunctionUtils"
} external;

isolated function externIsBidirectional(StreamingClient streamConnection) returns boolean =
@java:Method {
    'class: "org.ballerinalang.net.grpc.nativeimpl.streamingclient.FunctionUtils"
} external;

isolated function externGetHeaderMap(StreamingClient streamConnection) returns map<string|string[]>? =
@java:Method {
    'class: "org.ballerinalang.net.grpc.nativeimpl.streamingclient.FunctionUtils"
} external;
