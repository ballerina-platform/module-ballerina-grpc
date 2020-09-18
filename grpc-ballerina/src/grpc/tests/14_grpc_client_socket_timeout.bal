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

@test:Config {}
public function testClientSocketTimeout() {
    // Client endpoint configuration
    HelloWorld14BlockingClient helloWorldBlockingEp = new("http://localhost:9104", {
                                        timeoutInMillis : 1000});

    // Executes unary blocking call.
    var unionResp = helloWorldBlockingEp->hello("WSO2");

    // Reads message from response.
    if (unionResp is Error) {
        test:assertEquals(unionResp.message(), "Idle timeout triggered before initiating inbound response");
    } else {
        string result;
        [result, _] = unionResp;
        test:assertFail(result);
    }
}

public client class HelloWorld14BlockingClient {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR_14, getDescriptorMap14());
    }

    public isolated remote function hello(string req, Headers? headers = ()) returns ([string, Headers]|Error) {
        var payload = check self.grpcClient->blockingExecute("HelloWorld14/hello", req, headers);
        Headers resHeaders = new;
        any result = ();
        [result, resHeaders] = payload;
        return [result.toString(), resHeaders];
    }

}

public client class HelloWorld14Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_14, getDescriptorMap14());
    }

    public isolated remote function hello(string req, service msgListener, Headers? headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("HelloWorld14/hello", req, msgListener, headers);
    }

}
