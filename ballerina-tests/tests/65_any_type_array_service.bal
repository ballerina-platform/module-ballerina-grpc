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
import ballerina/protobuf.types.'any;

listener grpc:Listener ep65 = new (9165);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_65_ANY_TYPE_ARRAY, descMap: getDescriptorMap65AnyTypeArray()}
service "AnyTypeArray" on ep65 {

    remote function unaryCall1(AnyTypeArrayRequest value) returns AnyTypeArrayResponse|error {
        AnyTypeArrayMsg msg = {name: "Ballerina", code: 71};
        'any:Any[] details = [
            'any:pack("Hello Ballerina"),
            'any:pack(71),
            'any:pack(msg)
        ];
        return {name: "Ballerina", details: details};
    }
}
