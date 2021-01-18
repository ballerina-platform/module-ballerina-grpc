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
isolated function testUnarySecuredBlockingWithCerts() {
    grpcMutualSslServiceClient helloWorldBlockingEp = new ("https://localhost:9100", {
        secureSocket:{
            keyFile: PRIVATE_KEY_PATH,
            certFile: PUBLIC_CRT_PATH,
            trustedCertFile: PUBLIC_CRT_PATH
        }
    });

    [string, map<string[]>]|Error unionResp = helloWorldBlockingEp->hello("WSO2");
    if (unionResp is Error) {
        test:assertFail(io:sprintf("Error from Connector: %s", unionResp.message()));
    } else {
        string result;
        [result, _] = unionResp;
        io:println("Client Got Response : ");
        io:println(result);
        test:assertEquals(result, "Hello WSO2");
    }
}

public client class grpcMutualSslServiceClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_10, getDescriptorMap10());
    }

    isolated remote function hello (string req, map<string[]> headers = {}) returns ([string, map<string[]>]|Error) {
        var unionResp = check self.grpcClient->executeSimpleRPC("grpcservices.grpcMutualSslService/hello", req, headers);
        map<string[]> resHeaders;
        any result = ();
        [result, resHeaders] = unionResp;
        return [result.toString(), resHeaders];
    }
}
