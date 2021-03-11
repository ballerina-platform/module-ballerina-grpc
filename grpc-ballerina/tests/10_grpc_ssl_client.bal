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

import ballerina/io;
import ballerina/test;

@test:Config {
    enable: false
}
isolated function testUnarySecuredBlockingWithCerts() returns Error? {
    grpcMutualSslServiceClient helloWorldBlockingEp = check new ("https://localhost:9100", {
        secureSocket:{
            key: {
                keyFile: PRIVATE_KEY_PATH,
                certFile: PUBLIC_CRT_PATH
            },
            cert: PUBLIC_CRT_PATH
        }
    });

    string|Error unionResp = helloWorldBlockingEp->hello("WSO2");
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertEquals(unionResp, "Hello WSO2");
    }
}

public client class grpcMutualSslServiceClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        // initialize client endpoint.
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_10, getDescriptorMap10());
    }

    isolated remote function hello(string|ContextString req) returns (string|Error) {

        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.grpcMutualSslService/hello", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function helloContext(string|ContextString req) returns (ContextString|Error) {

        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("grpcservices.grpcMutualSslService/hello", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

}
