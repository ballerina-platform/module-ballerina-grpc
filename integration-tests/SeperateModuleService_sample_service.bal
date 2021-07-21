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
import integration_tests.api;

listener grpc:Listener ep = new (9095);

@grpc:ServiceDescriptor {descriptor: api:ROOT_DESCRIPTOR, descMap: api:getDescriptorMap()}
service "SeperateModuleService" on ep {

    remote function unary(api:ContextSMReq req) returns api:ContextSMRes|error {
        return {content: {name: "Anne", id: 12}, headers: req.headers};
    }

    remote function serverStreaming(api:ContextSMReq req) returns api:ContextSMResStream|error {
        api:SMRes[] responses = [
            {name: "Anne", id: 12}, 
            {name: "Nick", id: 13}, 
            {name: "Holand", id: 14}
        ];
        return {content: responses.toStream(), headers: req.headers};
    }

    remote function clientStreaming(api:ContextSMReqStream req) returns api:ContextSMRes|error {
        return {content: {name: "Anne", id: 12}, headers: req.headers};
    }

    remote function bidirectional1(api:ContextSMReqStream req) returns api:ContextSMResStream|error {
        api:SMRes[] responses = [
            {name: "Anne", id: 12}, 
            {name: "Nick", id: 13}, 
            {name: "Holand", id: 14}
        ];
        return {content: responses.toStream(), headers: req.headers};
    }
    remote function bidirectional2(stream<api:SMReq, error?> req) returns api:ContextSMResStream|error {
        api:SMRes[] responses = [
            {name: "Anne", id: 12}, 
            {name: "Nick", id: 13}, 
            {name: "Holand", id: 14}
        ];
        return {content: responses.toStream(), headers: {"h1": "H1"}};
    }
}

