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

    LotsOfGreetingsStreamingClientFromReturn streamingClient;
    var res = helloWorldEp->lotsOfGreetings();
    if (res is Error) {
        test:assertFail("Error from Connector: " + res.message());
        return;
    } else {
        streamingClient = res;
    }
    io:println("Initialized connection sucessfully.");

    foreach var greet in requests {
        Error? err = streamingClient->sendstring(greet);
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

public client class LotsOfGreetingsStreamingClientFromReturn {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendstring(string message) returns Error? {
        
        return self.sClient->send(message);
    }

    isolated remote function sendContextString(ContextString message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveString() returns string|Error? {
        var response = check self.sClient->receive();
        if (response is ()) {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return payload.toString();
        }
    }

    isolated remote function receiveContextString() returns ContextString|Error? {
        var response = check self.sClient->receive();
        if (response is ()) {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: payload.toString(), headers: headers};
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public client class HelloWorld26Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        // initialize client endpoint.
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_26, getDescriptorMap26());
    }

    isolated remote function lotsOfGreetings() returns (LotsOfGreetingsStreamingClientFromReturn|Error) {
        StreamingClient sClient = check self.grpcClient->executeClientStreaming("grpcservices.HelloWorld26/lotsOfGreetings");
        return new LotsOfGreetingsStreamingClientFromReturn(sClient);
    }
}
