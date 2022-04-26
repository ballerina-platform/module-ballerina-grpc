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

import ballerina/grpc;

listener grpc:Listener ep12 = new (9102, {
    host: "localhost"
});

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_12_GRPC_ENUM_TEST_SERVICE,
    descMap: getDescriptorMap12GrpcEnumTestService()
}
service "TestEnumService" on ep12 {
    isolated remote function testEnum(TestEnumServiceStringCaller caller, OrderInfo orderReq) {
        string permission = "";
        if orderReq.mode == r {
            permission = "r";
        }
        checkpanic caller->sendString(permission);
        checkpanic caller->complete();
    }
}
