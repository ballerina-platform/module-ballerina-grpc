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
import ballerina/log;

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_38_BIDI_STREAMING_WITH_CALLER,
    descMap: getDescriptorMap38BidiStreamingWithCaller()
}
service "Chat38" on new grpc:Listener(9128) {
    remote function chat38(Chat38StringCaller caller, stream<ChatMessage38, grpc:Error> clientStream)
                            returns error? {
        log:printInfo("Invoke the chat RPC");
        int i = 0;
        // Read and process each message in the client stream.
        checkpanic clientStream.forEach(function(ChatMessage38 value) {
            // responses[i] = string `${chatMsg.message}: ${chatMsg.name}`;
            checkpanic caller->sendString(string `${value.message}: ${value.name}`);
            i += 1;
        });
        log:printInfo("client messages", count = i);
        // Once the client sends a notification to indicate the end of the stream, 'EOS' is returned by the stream.
        return error grpc:AbortedError("Request Aborted.");
    }
}
