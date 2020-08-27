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
function testUnarySecuredBlockingWithCerts() {
    grpcMutualSslServiceBlockingClient helloWorldBlockingEp = new ("https://localhost:9100", {
        secureSocket:{
            keyFile: PRIVATE_KEY_PATH,
            certFile: PUBLIC_CRT_PATH,
            trustedCertFile: PUBLIC_CRT_PATH
        }
    });

    [string, Headers]|Error unionResp = helloWorldBlockingEp->hello("WSO2");
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

public type grpcMutualSslServiceBlockingClient client object {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR_10, getDescriptorMap10());
    }

    public remote function hello (string req, Headers? headers = ()) returns ([string, Headers]|Error) {
        var unionResp = check self.grpcClient->blockingExecute("grpcservices.grpcMutualSslService/hello", req, headers);
        Headers resHeaders = new;
        any result = ();
        [result, resHeaders] = unionResp;
        return [result.toString(), resHeaders];
    }
};

public type grpcMutualSslServiceClient client object {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_10, getDescriptorMap10());
    }

    public remote function hello (string req, service msgListener, Headers? headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.grpcMutualSslService/hello", req, msgListener, headers);
    }
};
