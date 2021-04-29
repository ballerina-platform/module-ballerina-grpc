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

@test:Config {enable:true}
isolated function testClientStreaming() returns Error? {
    string[] requests = ["Hi Sam", "Hey Sam", "GM Sam"];
    // Client endpoint configuration
    HelloWorld7Client helloWorldEp = check new ("http://localhost:9094");

    LotsOfGreetingsStreamingClient ep;
    // Executing unary non-blocking call registering server message listener.
    var res = helloWorldEp->lotsOfGreetings();
    if (res is Error) {
        test:assertFail("Error from Connector: " + res.message());
        return;
    } else {
        ep = res;
    }
    io:println("Initialized connection sucessfully.");

    foreach var greet in requests {
        Error? err = ep->sendString(greet);
        if (err is Error) {
            test:assertFail("Error from Connector: " + err.message());
        }
    }
    check ep->complete();
    io:println("completed successfully");
    anydata response = checkpanic ep->receiveString();
    test:assertEquals(<string> response, "Ack");
}
