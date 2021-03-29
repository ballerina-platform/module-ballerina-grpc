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
isolated function testBidiStreamingFromReturnRecord() returns Error? {
    HelloWorld34Client helloWorldEp = check new ("http://localhost:9124");
    SayHelloBidiStreamingClientFromReturn streamingClient;
    var res = helloWorldEp->sayHello();
    if (res is Error) {
        test:assertFail("Error from Connector: " + res.message());
        return;
    } else {
        streamingClient = res;
    }
    io:println("Initialized connection sucessfully.");
    SampleMsg34[] requests = [
        {name: "WSO2", id: 0},
        {name: "Microsoft", id: 1},
        {name: "Facebook", id: 2},
        {name: "Google", id: 3}
    ];
    foreach SampleMsg34 r in requests {
        Error? err = streamingClient->sendSampleMsg34(r);
        if (err is Error) {
            test:assertFail("Error from Connector: " + err.message());
        }
    }
    check streamingClient->complete();
    io:println("Completed successfully");
    var result = streamingClient->receiveSampleMsg34();
    int i = 0;
    while !(result is ()) {
        io:println(result);
        if (result is SampleMsg34) {
            test:assertEquals(<SampleMsg34> result, requests[i]);
        } else {
            test:assertFail("Unexpected output in the stream");
        }
        result = streamingClient->receiveSampleMsg34();
        i += 1;
    }
    test:assertEquals(i, 4);
}

public client class SayHelloBidiStreamingClientFromReturn {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendSampleMsg34(SampleMsg34 message) returns Error? {

        return self.sClient->send(message);
    }

    isolated remote function receiveSampleMsg34() returns anydata|Error? {
        var response = check self.sClient->receive();
        if (response is ()) {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return payload;
        }
    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public client class HelloWorld34Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        // initialize client endpoint.
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_34, getDescriptorMap34());
    }

    isolated remote function sayHello() returns (SayHelloBidiStreamingClientFromReturn|Error) {
        StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("HelloWorld34/sayHello");
        return new SayHelloBidiStreamingClientFromReturn(sClient);
    }
}
