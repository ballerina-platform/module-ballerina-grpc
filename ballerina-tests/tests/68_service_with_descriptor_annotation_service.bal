// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

listener grpc:Listener ep68 = new (9168);

@grpc:Descriptor {value: SERVICE_WITH_DESCRIPTOR_ANNOTATION_DESC}
service "helloDescriptorAnnotation" on ep68 {

    remote function hello(stream<string, grpc:Error?> clientStream) returns string|error {
        io:println(clientStream.next());
        return "hello client";
    }
}

