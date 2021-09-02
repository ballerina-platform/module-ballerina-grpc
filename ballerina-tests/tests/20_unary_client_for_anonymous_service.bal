// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
listener grpc:Listener  ep20 = new (9110);

service object {} AnonService1 = @grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_20_UNARY_CLIENT_FOR_ANONYMOUS_SERVICE, descMap: getDescriptorMap20UnaryClientForAnonymousService()} 
service object {
    remote isolated function hello1(string value) returns string|error {
        return "Hello Ballerina";
    }
    remote isolated function hello2(string value) returns string|error {
        return "Hello Ballerina";
    }
};

service object {} IncompleteService = @grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_20_UNARY_CLIENT_FOR_ANONYMOUS_SERVICE, descMap: getDescriptorMap20UnaryClientForAnonymousService()} 
service object {
    remote isolated function hello1(string value) returns string|error {
        return "Hello Ballerina";
    }
};

service object {} unregisteredService = @grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_20_UNARY_CLIENT_FOR_ANONYMOUS_SERVICE, descMap: getDescriptorMap20UnaryClientForAnonymousService()} 
service object {
    remote isolated function hello1(string value) returns string|error {
        return "Hello Ballerina";
    }
};

