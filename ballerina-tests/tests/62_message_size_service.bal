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

listener grpc:Listener msgSizeService = new (9162, maxInboundMessageSize = 1024);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_62_MESSAGE_SIZE,
    descMap: getDescriptorMap62MessageSize()
}
service "HelloWorld62" on msgSizeService {

    remote function msgSizeUnary(string value) returns string|error {
        if value == "small" {
            return "Hello Client";
        }
        return LARGE_PAYLOAD;
    }

    remote function msgSizeServerStreaming(string value) returns stream<string, error?>|error? {
        string[] response;
        if value == "small" {
            response = ["Hello Client"];
        } else {
            response = [LARGE_PAYLOAD];
        }
        return response.toStream();
    }

    remote function msgSizeClientStreaming(stream<string, error?> clientStream) returns string|error? {
        boolean sendLargePayload = false;
        check clientStream.forEach(function(string val) {
            if val == "large" {
                sendLargePayload = true;
            }
        });
        if sendLargePayload {
            return LARGE_PAYLOAD;
        }
        return "Hello Client";
    }

    remote function msgSizeBidiStreaming(HelloWorld62StringCaller caller, stream<string, error?> clientStream) returns error? {
        checkpanic clientStream.forEach(function(string val) {
            if val == "large" {
                checkpanic caller->sendString(LARGE_PAYLOAD);
            } else {
                checkpanic caller->sendString(val);
            }
        });
        checkpanic caller->complete();
    }
}
