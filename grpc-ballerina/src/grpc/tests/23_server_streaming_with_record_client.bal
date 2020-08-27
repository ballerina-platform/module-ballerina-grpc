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
import ballerina/runtime;
import ballerina/test;

int count = 0;
boolean eos = false;

@test:Config {}
public function testServerStreamingWithRecord() {
    string name = "WSO2";
    helloWorldServerStreamingClient helloWorldEp = new("http://localhost:9113");
    HelloRequest newreq = {name: name};
    Error? result = helloWorldEp->lotsOfReplies(newreq,
                                                    HelloWorldServerStreamingMessageListener);
    if (result is Error) {
        test:assertFail("Error from Connector: " + result.message());
    } else {
        io:println("Connected successfully");
    }

    int waitCount = 0;
    while(count < 3 || !eos) {
        runtime:sleep(1000);
        io:println("msg count: " + count.toString());
        if (waitCount > 10) {
            break;
        }
        waitCount += 1;
    }
    io:println("Client got response successfully.");
    io:println("responses count: " + count.toString());
    test:assertEquals(count, 3);
}

service HelloWorldServerStreamingMessageListener = service {

    // The `resource` registered to receive server messages
    function onMessage(HelloResponse message) {
        io:println("Response received from server: " + message.toString());
        count = count + 1;
    }

    // The `resource` registered to receive server error messages
    function onError(error err) {
        io:println("Error from Connector: " + err.message());
    }

    // The `resource` registered to receive server completed messages.
    function onComplete() {
        io:println("Server Complete Sending Responses.");
        eos = true;
    }
};

public type helloWorldServerStreamingClient client object {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_23, getDescriptorMap23());
    }

    public remote function lotsOfReplies(HelloRequest req, service msgListener, Headers? headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("helloWorldServerStreaming/lotsOfReplies", req, msgListener, headers);
    }

};
