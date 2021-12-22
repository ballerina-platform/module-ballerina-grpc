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
import ballerina/protobuf.types.wrappers;

listener grpc:Listener ep37 = new (9127);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_37_STREAMING_WITH_DEADLINE,
    descMap: getDescriptorMap37StreamingWithDeadline()
}
service "HelloWorld37" on ep37 {

    remote isolated function callWithDeadline(wrappers:ContextStringStream clientStream) returns wrappers:ContextStringStream|error {
        check clientStream.content.forEach(isolated function(string val) {
            io:println(val);
        });
        string[] response = [
            "WSO2",
            "Microsoft",
            "Facebook",
            "Google"
        ];
        var cancel = grpc:isCancelled(clientStream.headers);
        if cancel is boolean {
            if cancel {
                return error grpc:DeadlineExceededError("Exceeded the configured deadline");
            } else {
                return {content: response.toStream(), headers: {}};
            }
        } else {
            return error grpc:CancelledError(cancel.message());
        }
    }
}
