// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/log;
import ballerina/test;

@test:Config {enable:true}
isolated function testOptionalFieldMessage() returns Error? {
    CheckoutServiceClient checkoutServiceBlockingEp = check new("http://localhost:9108");

    PlaceOrderRequest orderRequest = {
        user_id: "2e8f27b9-b966-45b0-b51f-dcccea697d01",
        user_currency: "USD",
        address: {
            zip_code: 94043
        },
        email: "someone@example.com",
        credit_card: {
            credit_card_number: "1"
        }
    };
    var result = checkoutServiceBlockingEp->PlaceOrder(orderRequest);
    if (result is error) {
        log:printError("Error response.", 'error = result);
        test:assertFail("Error occurred while calling remote method, placeorder");
    } else {
        test:assertEquals(result.'order, "This is a address");
    }
}

public client class CheckoutServiceClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        // initialize client endpoint.
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_18, getDescriptorMap18());
    }

    isolated remote function PlaceOrder(PlaceOrderRequest|ContextPlaceOrderRequest req) returns (PlaceOrderResponse|Error) {
        
        map<string|string[]> headers = {};
        PlaceOrderRequest message;
        if (req is ContextPlaceOrderRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.CheckoutService/PlaceOrder", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        
        return <PlaceOrderResponse>result;
        
    }
    isolated remote function PlaceOrderContext(PlaceOrderRequest|ContextPlaceOrderRequest req) returns (ContextPlaceOrderResponse|Error) {
        
        map<string|string[]> headers = {};
        PlaceOrderRequest message;
        if (req is ContextPlaceOrderRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.CheckoutService/PlaceOrder", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        
        return {content: <PlaceOrderResponse>result, headers: respHeaders};
    }

}
