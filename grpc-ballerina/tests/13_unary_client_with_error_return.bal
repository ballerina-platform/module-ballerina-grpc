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

@test:Config {enable:false}
isolated function testErrorResponse() {
    string name = "WSO2";
    // Client endpoint configuration
    HelloWorld13BlockingClient helloWorld13BlockingEp = new("http://localhost:9103");
    var unionResp = helloWorld13BlockingEp->hello(name);

    if (unionResp is Error) {
        test:assertEquals(unionResp.message(), "error(\"Details\")");
    } else {
        string result = "";
        [result, _] = unionResp;
        test:assertFail(result);
    }
}

public client class HelloWorld13BlockingClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR_13, getDescriptorMap13());
    }

    isolated remote function hello(string req, Headers? headers = ()) returns ([string, Headers]|Error) {
        var payload = check self.grpcClient->blockingExecute("HelloWorld13/hello", req, headers);
        Headers resHeaders = new;
        any result = ();
        [result, resHeaders] = payload;
        return [result.toString(), resHeaders];
    }

}

public client class HelloWorld13Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_13, getDescriptorMap13());
    }

    isolated remote function hello(string req, service object {} msgListener, Headers? headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("HelloWorld13/hello", req, msgListener, headers);
    }

}
