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

// This is client implementation for server streaming scenario
import ballerina/io;
import ballerina/runtime;
import ballerina/test;

int msgCount = 0;
boolean eof = false;

@test:Config {enable:true}
function testReceiveStreamingResponse() {
    string name = "WSO2";
    // Client endpoint configuration
    HelloWorld6Client helloWorldEp = new("http://localhost:9096");

    // Executing unary non-blocking call registering server message listener.
    Error? result = helloWorldEp->lotsOfReplies(name, HelloWorld6MessageListener);
    if (result is Error) {
        test:assertFail("Error from Connector: " + result.message());
    } else {
        io:println("Connected successfully");
    }

    int waitCount = 0;
    while(msgCount < 3 || !eof) {
        runtime:sleep(1000);
        io:println("msg count: " + msgCount.toString());
        if (waitCount > 10) {
            break;
        }
        waitCount += 1;
    }

    io:println("responses count: " + msgCount.toString());
    test:assertEquals(msgCount, 3);
}

// Server Message Listener.
service HelloWorld6MessageListener = service {

    // Resource registered to receive server messages
    resource function onMessage(string message) {
        lock {
            io:println("Response received from server: " + message);
            msgCount = msgCount + 1;
        }
    }

    // Resource registered to receive server error messages
    resource function onError(error err) {
        io:println("Error from Connector: " + err.message());
    }

    // Resource registered to receive server completed message.
    resource function onComplete() {
        io:println("Server Complete Sending Response.");
        eof = true;
    }
};

// Non-blocking client endpoint
public client class HelloWorld6Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        Error? result = self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_6, getDescriptorMap6());
    }

    public isolated remote function lotsOfReplies(string req, service msgListener, Headers? headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld45/lotsOfReplies", req, msgListener, headers);
    }
}
