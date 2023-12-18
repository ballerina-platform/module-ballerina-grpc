// Copyright (c) 2023 WSO2 LLC. (http://www.wso2.com) All Rights Reserved.

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/grpc;

listener grpc:Listener multiConfigListener1 = new (9165, secureSocket = {
    key: {
        certFile: "tests/resources/public.crt",
        keyFile: "tests/resources/private.key"
    }
});

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_65_MULTIPLE_CLIENT_CONFIGURATIONS, descMap: getDescriptorMap65MultipleClientConfigurations()}
service "MultipleClientConfigsService1" on multiConfigListener1 {

    remote function call1() returns error? {
    }
}

listener grpc:Listener multiConfigListener2 = new (9265, secureSocket = {
    key: {
        certFile: "tests/resources/public2.crt",
        keyFile: "tests/resources/private2.key"
    }
});

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_65_MULTIPLE_CLIENT_CONFIGURATIONS, descMap: getDescriptorMap65MultipleClientConfigurations()}
service "MultipleClientConfigsService2" on multiConfigListener2 {

    remote function call1() returns error? {
    }
}
