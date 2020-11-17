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

boolean respReceived = false;
boolean eofReceived = false;

@test:Config {}
function testUnaryNonBlockingClient() {
    // Client endpoint configuration
    HelloWorld7Client helloWorldEp = new ("http://localhost:9097");
    // Executing unary non-blocking call registering server message listener.
    Error? result = helloWorldEp->hello("WSO2", HelloWorld7MessageListener);
    if (result is Error) {
        test:assertFail(io:sprintf(ERROR_MSG_FORMAT, result.message()));
    } else {
        io:println("Connected successfully");
    }

    int waitCount = 0;
    while(true) {
        if (respReceived && eofReceived) {
            break;
        }
        runtime:sleep(1000);
        io:println("response received: ", respReceived);
        io:println("EOF received: ", eofReceived);
        if (waitCount > 10) {
            break;
        }
        waitCount += 1;
    }
    boolean eof = (respReceived && eofReceived);
    io:println("Response received: " + eof.toString());
    test:assertTrue(eof);
}

// Server Message Listener.
service HelloWorld7MessageListener = service {

    // Resource registered to receive server messages
    resource function onMessage(string message) {
        io:println("Response received from server: " + message);
        respReceived = true;
    }

    // Resource registered to receive server error messages
    resource function onError(error err) {
        string msg = io:sprintf(ERROR_MSG_FORMAT, err.message());
        io:println(msg);
    }

    // Resource registered to receive server completed message.
    resource function onComplete() {
        io:println("Server Complete Sending Response.");
        eofReceived = true;
    }
};

public client class HelloWorld7Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR_7, getDescriptorMap7());
    }

    public isolated remote function hello(string req, service msgListener, Headers? headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld100/hello", req, msgListener, headers);
    }

    public isolated remote function testInt(int req, service msgListener, Headers? headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld100/testInt", req, msgListener, headers);
    }

    public isolated remote function testFloat(float req, service msgListener, Headers? headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld100/testFloat", req, msgListener, headers);
    }

    public isolated remote function testBoolean(boolean req, service msgListener, Headers? headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld100/testBoolean", req, msgListener, headers);
    }

    public isolated remote function testStruct(Request req, service msgListener, Headers? headers = ()) returns (Error?) {
        return self.grpcClient->nonBlockingExecute("grpcservices.HelloWorld100/testStruct", req, msgListener, headers);
    }
}
