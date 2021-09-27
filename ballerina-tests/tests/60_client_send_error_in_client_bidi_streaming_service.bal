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
import ballerina/io;

listener grpc:Listener ep60 = new (9160);

boolean receivedClientStreamingError = false;
boolean receivedBidiStreamingError = false;

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_60_CLIENT_SEND_ERROR_IN_CLIENT_BIDI_STREAMING,
    descMap: getDescriptorMap60ClientSendErrorInClientBidiStreaming()
}
service "SendError" on ep60 {
    remote function sendErrorClientStreaming(stream<string, error?> clientStream) returns boolean {
        error? e = clientStream.forEach(isolated function(string val) {
            io:println(val);
        });
        if e is () {
            return receivedClientStreamingError;
        } else {
            io:println("Received a client error : " + e.message());
            receivedClientStreamingError = true;
            return receivedClientStreamingError;
        }
    }

    remote function sendErrorBidiStreaming(stream<string, error?> clientStream) returns stream<boolean, error?> {
        error? e = clientStream.forEach(isolated function(string val) {
            io:println(val);
        });
        if e is () {
            boolean[] errorResult = [receivedBidiStreamingError];
            return errorResult.toStream();
        } else {
            io:println("Received a client error : " + e.message());
            receivedBidiStreamingError = true;
            boolean[] errorResult = [receivedBidiStreamingError];
            return errorResult.toStream();
        }
    }
}
