// Copyright (c) 2022 WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
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

listener grpc:Listener ep76 = new (9176);

@grpc:Descriptor {value: NUMBER_TYPES_DESC}
service "TypesService" on ep76 {
    remote function getTypes(TypesMessage request) returns TypesMessage|error {
        log:printInfo(request.toString());
        return {
            int32Value: 2147483647,
            int64Value: 9223372036854775807,
            uint32Value: 0,
            uint64Value: 0,
            sint32Value: 0,
            sint64Value: 0,
            fixed32Value: 0,
            fixed64Value: 0,
            sfixed32Value: 0,
            sfixed64Value: 0
        };
    }
}
