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
import ballerina/io;

listener grpc:Listener ordermgtep = new (9111);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_21_GRPC_GZIP_ENCODING_SERVICE,
    descMap: getDescriptorMap21GrpcGzipEncodingService()
}
service "OrderManagement" on ordermgtep {

    isolated remote function addOrder(OrderManagementStringCaller caller, Order value) returns grpc:Error? {
        io:println(value);
        check caller->sendString("Order is added " + value.id);
        check caller->complete();
    }

    isolated remote function getOrder(OrderManagementOrderCaller caller, string value) returns grpc:Error? {
        Order 'order = {id: "101", items: ["xyz", "abc"], destination: "LK", price: 2300.00};
        map<string|string[]> headers = {};
        headers = grpc:setCompression(grpc:GZIP);
        check caller->sendContextOrder({content: 'order, headers: headers});
        check caller->complete();
    }
}
