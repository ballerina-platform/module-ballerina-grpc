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

import ballerina/io;

listener Listener ordermgtep = new (9111);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_21,
    descMap: getDescriptorMap21()
}
service "OrderManagement" on ordermgtep {

    isolated remote function addOrder(OrderManagementStringCaller caller, Order value) {
        io:println(value);
        error? send = caller->sendString("Order is added " + value.id);
        error? complete = caller->complete();
    }

    isolated remote function getOrder(OrderManagementOrderCaller caller, string value) {
        Order 'order = {id: "101", items: ["xyz", "abc"], destination: "LK", price:2300.00};
        error? send = caller->sendOrder('order);
        error? complete = caller->complete();
    }
}
