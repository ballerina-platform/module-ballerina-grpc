// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/test;

@test:Config {enable:true}
isolated function testSendAndReceiveEnum() {
    testEnumServiceClient blockingEp = new ("http://localhost:9102");

    OrderInfo orderReq = { id:"100500", mode:r };
    var addResponse = blockingEp->testEnum(orderReq);
    if (addResponse is Error) {
        test:assertFail(string `Error from Connector: ${addResponse.message()}`);
    } else {
        test:assertEquals(addResponse, "r");
    }
}

public client class testEnumServiceClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_12, getDescriptorMap12());
    }

    isolated remote function testEnum(OrderInfo|ContextOrderInfo req) returns (string|Error) {
        
        map<string|string[]> headers = {};
        OrderInfo message;
        if (req is ContextOrderInfo) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.testEnumService/testEnum", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function testEnumContext(OrderInfo|ContextOrderInfo req) returns (ContextString|Error) {
        
        map<string|string[]> headers = {};
        OrderInfo message;
        if (req is ContextOrderInfo) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.testEnumService/testEnum", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

}
