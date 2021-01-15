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
import ballerina/test;

@test:Config {enable:true}
isolated function testGzipEncoding() {
    OrderManagementClient OrderMgtBlockingEp = new("http://localhost:9111");

    Order 'order = {id: "101", items: ["xyz", "abc"], destination: "LK", price:2300.00};
    map<string[]> headers = {};
    headers["grpc-encoding"] = ["gzip"];
    [string, map<string[]>]|error result = OrderMgtBlockingEp->addOrder('order, headers);
    if (result is error) {
        test:assertFail(io:sprintf("gzip encoding failed: %s", result.message()));
    } else {
        string orderId;
        [orderId, _] = result;
        test:assertEquals(orderId, "Order is added 101");
    }
}

public client class OrderManagementClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_21, getDescriptorMap21());
    }

    isolated remote function addOrder(Order req, map<string[]> headers = {}) returns ([string, map<string[]>]|Error) {
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.OrderManagement/addOrder", req, headers);
        map<string[]> resHeaders;
        anydata result = ();
        [result, resHeaders] = payload;
        return [result.toString(), resHeaders];
    }

    isolated remote function getOrder(string req, map<string[]> headers = {}) returns ([Order,map<string[]>]|Error) {
        var payload = check self.grpcClient->executeSimpleRPC("ecommerce.OrderManagement/getOrder", req, headers);
        map<string[]> resHeaders;
        anydata result = ();
        [result, resHeaders] = payload;
        return [<Order>result, resHeaders];
    }

}
