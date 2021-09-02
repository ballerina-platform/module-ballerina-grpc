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

import ballerina/grpc;import ballerina/auth;

listener grpc:Listener  ep28 = new (9118);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_28_UNARY_BASIC_AUTH,
    descMap: getDescriptorMap28UnaryBasicAuth()
}
service "HelloWorld28" on ep28 {

    isolated remote function testStringValueReturn(ContextString request) returns string|error {
        if !request.headers.hasKey(grpc:AUTH_HEADER) {
            return error grpc:AbortedError("AUTH_HEADER header is missing");
        } else {
            grpc:ListenerFileUserStoreBasicAuthHandler handler = new;
            auth:UserDetails|grpc:UnauthenticatedError authnResult = handler.authenticate(request.headers);
            if authnResult is grpc:UnauthenticatedError {
                return authnResult;
            } else {
                grpc:PermissionDeniedError? authzResult = handler.authorize(<auth:UserDetails>authnResult, "write");
                if authzResult is () {
                    return "Hello WSO2";
                } else {
                    return authzResult;
                }
            }
        }
    }
}
