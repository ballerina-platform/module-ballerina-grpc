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
import ballerina/log;

listener grpc:Listener ep67 = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_SIMPLE_SERVICE_WITH_ANNOTATION, descMap: getDescriptorMapSimpleServiceWithAnnotation()}
service "SimpleServiceWithAnnotation" on ep67 {

    remote function unary(SimpleRequestWithAnnotation value) returns SimpleResponseWithAnnotation|error {
        return {name: "Response 01"};
    }
    remote function serverStreaming(SimpleRequestWithAnnotation value) returns stream<SimpleResponseWithAnnotation, error?>|error {
        SimpleResponseWithAnnotation[] responses = [
            {name: "Response 01"},
            {name: "Response 02"},
            {name: "Response 03"}
        ];
        return responses.toStream();
    }
    remote function clientStreaming(stream<SimpleRequestWithAnnotation, grpc:Error?> clientStream) returns SimpleResponseWithAnnotation|error {
        check clientStream.forEach(isolated function(SimpleRequestWithAnnotation value) {
            log:printInfo(value.name);
        });
        return {name: "Response"};
    }
    remote function bidirectionalStreaming(stream<SimpleRequestWithAnnotation, grpc:Error?> clientStream) returns stream<SimpleResponseWithAnnotation, error?>|error {
        SimpleResponseWithAnnotation[] responses = [
            {name: "Response 01"},
            {name: "Response 02"},
            {name: "Response 03"}
        ];
        _ = check clientStream.forEach(isolated function(SimpleRequestWithAnnotation value) {
            log:printInfo(value.name);
        });
        return responses.toStream();
    }
}

