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

listener grpc:Listener ep58 = new (9158);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_58_NESTED_MESSAGE_NESTED_ENUM, descMap: getDescriptorMap58NestedMessageNestedEnum()}
service "helloWorldWithNestedMessageNestedEnum" on ep58 {

    remote function hello(HelloRequest58 request) returns HelloResponse58|error {
        HelloResponse58_Bar_Foo fooResponse = {
            i: 2
        };
        HelloResponse58_Bar barResponse = {
            i: 1,
            foo: [fooResponse, fooResponse, fooResponse]
        };
        HelloResponse58 response = {
            message: "Response",
            mode: neutral,
            bars: [barResponse, barResponse, barResponse, barResponse]
        };
        return response;
    }

    remote function bye(ByeRequest58 request) returns ByeResponse58|error {
        FileInfo_Observability_TraceId traceId = {
            id: "1",
            latest_version: "2.0"
        };
        FileInfo_Observability observability = {
            id: "1",
            latest_version: "2.0",
            traceId: traceId
        };
        FileInfo fileInfo = {
            observability: observability
        };
        ByeRequest58 expectedRequest = {
            fileInfo: fileInfo,
            reqPriority: low
        };

        FileType fType = {
            'type: FILE
        };

        ByeResponse58 response = {
            say: "Hey",
            fileType: fType
        };

        if request == expectedRequest {
            return response;
        } else {
            return error grpc:Error("Invalid request data");
        }
    }

}
