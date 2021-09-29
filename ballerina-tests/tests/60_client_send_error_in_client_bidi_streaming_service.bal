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

int clientStreamingErrorCount = 0;
int bidiStreamingErrorCount = 0;

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_60_CLIENT_SEND_ERROR_IN_CLIENT_BIDI_STREAMING,
    descMap: getDescriptorMap60ClientSendErrorInClientBidiStreaming()
}
service "ErrorSendService" on ep60 {
    remote function sendErrorClientStreaming(stream<string, error?> clientStream) returns int {
        error? e = clientStream.forEach(isolated function(string val) {
            io:println(val);
        });
        if e is () {
            return clientStreamingErrorCount;
        } else {
            io:println("Received a client error : " + e.message());
            clientStreamingErrorCount += 1;
            return clientStreamingErrorCount;
        }
    }

    remote function sendErrorBidiStreaming(stream<string, error?> clientStream) returns stream<int, error?> {
        error? e = clientStream.forEach(isolated function(string val) {
            io:println(val);
        });
        if e is () {
            int[] errorResult = [bidiStreamingErrorCount];
            return errorResult.toStream();
        } else {
            io:println("Received a client error : " + e.message());
            bidiStreamingErrorCount += 1;
            int[] errorResult = [bidiStreamingErrorCount];
            return errorResult.toStream();
        }
    }
}
