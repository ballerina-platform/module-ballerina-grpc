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

import ballerina/test;

@test:Config {enable:true}
public function testStringValueReturnWithJwt() {
    HelloWorld29BlockingClient helloWorldEp = new ("http://localhost:9119");
    map<string|string[]> requestHeaders = {};

    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "write" },
        keyStoreConfig: {
            keyStore: {
                path: KEYSTORE_PATH,
                password: "ballerina"
            },
            keyAlias: "ballerina",
            keyPassword: "ballerina"
        }
    };
    ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]>|ClientAuthError result = handler.enrich(requestHeaders);
    if (result is ClientAuthError) {
        test:assertFail(msg = "Test Failed! " + result.message());
    } else {
        requestHeaders = result;
    }

    requestHeaders["x-id"] = ["0987654321"];
    ContextString requestMessage = {content: "WSO2", headers: requestHeaders};
    var unionResp = helloWorldEp->testStringValueReturn(requestMessage);
    if (unionResp is Error) {
        test:assertFail(msg = unionResp.message());
    } else {
        test:assertEquals(unionResp.content, "Hello WSO2");
    }
}

public client class HelloWorld29BlockingClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_29, getDescriptorMap29());
    }

    isolated remote function testStringValueReturn(string|ContextString req) returns ContextString|Error {
        string message;
        map<string|string[]> headers = {};
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        [anydata, map<string|string[]>][result, requestHeaders] = check self.grpcClient->executeSimpleRPC("HelloWorld29/testStringValueReturn", message, headers);
        return  {content: result.toString(), headers: requestHeaders};
    }

}
