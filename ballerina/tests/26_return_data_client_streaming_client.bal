// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
isolated function testClientStreamingFromReturn() returns Error? {
    string[] requests = ["Hi Sam", "Hey Sam", "GM Sam"];
    HelloWorld26Client helloWorldEp = check new ("http://localhost:9116");

    LotsOfGreetingsStreamingClient streamingClient;
    var res = helloWorldEp->lotsOfGreetings();
    if (res is Error) {
        test:assertFail("Error from Connector: " + res.message());
        return;
    } else {
        streamingClient = res;
    }
    io:println("Initialized connection sucessfully.");

    foreach var greet in requests {
        Error? err = streamingClient->sendString(greet);
        if (err is Error) {
            test:assertFail("Error from Connector: " + err.message());
        }
    }
    checkpanic streamingClient->complete();
    io:println("completed successfully");
    string? response = check streamingClient->receiveString();
    if response is string {
        test:assertEquals(response, "Ack");
    }
}
