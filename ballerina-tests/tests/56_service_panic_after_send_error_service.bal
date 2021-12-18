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

listener grpc:Listener ep56 = new (9156);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_56_SERVICE_PANIC_AFTER_SEND_ERROR, descMap: getDescriptorMap56ServicePanicAfterSendError()}
service "HelloWorld56" on ep56 {

    remote function hello56BiDi(HelloWorld56StringCaller caller,
    stream<string, error?> clientStream) returns error? {
        check caller->sendError(error grpc:Error("Test error from service"));
        panic error grpc:Error("Panic in service");
    }

    remote function hello56Unary(HelloWorld56StringCaller caller, string value) returns error? {
        check caller->sendError(error grpc:Error("Test error from service"));
        panic error grpc:Error("Panic in service");
    }
}
