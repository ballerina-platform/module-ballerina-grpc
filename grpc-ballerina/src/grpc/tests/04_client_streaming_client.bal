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
import ballerina/runtime;
import ballerina/test;

string response = "";
int total = 0;

@test:Config {}
function testClientStreaming() {
    string[] requests = ["Hi Sam", "Hey Sam", "GM Sam"];
    // Client endpoint configuration
    HelloWorld4Client helloWorldEp = new ("http://localhost:9094");

    StreamingClient ep = new;
    // Executing unary non-blocking call registering server message listener.
    var res = helloWorldEp->lotsOfGreetings(HelloWorldMessageListener);
    if (res is Error) {
        test:assertFail("Error from Connector: " + res.message());
    } else {
        ep = res;
    }
    io:println("Initialized connection sucessfully.");

    foreach var greet in requests {
        Error? err = ep->send(greet);
        if (err is Error) {
            test:assertFail("Error from Connector: " + err.message());
        }
    }
    checkpanic ep->complete();

    int waitCount = 0;
    while(total < 1) {
        runtime:sleep(1000);
        io:println("msg count: ", total);
        if (waitCount > 10) {
            break;
        }
        waitCount += 1;
    }
    io:println("completed successfully");
    test:assertEquals(response, "Ack");
}

// Server Message Listener.
service HelloWorldMessageListener = service {

    // Resource registered to receive server messages
    function onMessage(string message) {
        response = <@untainted> message;
        io:println("Response received from server: " + response);
        total = 1;
    }

    // Resource registered to receive server error messages
    function onError(error err) {
        io:println("Error from Connector: " + err.message());
    }

    // Resource registered to receive server completed message.
    function onComplete() {
        total = 1;
        io:println("Server Complete Sending Responses.");
    }
};

// Non-blocking client endpoint
public type HelloWorld4Client client object {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_4, getDescriptorMap4());
    }

    public remote function lotsOfGreetings(service msgListener, Headers? headers = ()) returns (StreamingClient|Error) {
        return self.grpcClient->streamingExecute("grpcservices.HelloWorld7/lotsOfGreetings", msgListener, headers);
    }
};
