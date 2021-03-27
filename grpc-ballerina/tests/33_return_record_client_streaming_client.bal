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
isolated function testClientStreamingFromReturnRecord() returns Error? {
    HelloWorld33Client helloWorldEp = check new ("http://localhost:9123");
    SayHelloStreamingClientFromReturn streamingClient;
    var res = helloWorldEp->sayHello();
    if (res is Error) {
        test:assertFail("Error from Connector: " + res.message());
        return;
    } else {
        streamingClient = res;
    }
    io:println("Initialized connection sucessfully.");
    SampleMsg33[] requests = [
        {name: "WSO2", id: 0},
        {name: "Microsoft", id: 1},
        {name: "Facebook", id: 2},
        {name: "Google", id: 3}
    ];
    foreach var r in requests {
        Error? err = streamingClient->sendSampleMsg33(r);
        if (err is Error) {
            test:assertFail("Error from Connector: " + err.message());
        }
    }
    checkpanic streamingClient->complete();
    io:println("Completed successfully");
    var response = check streamingClient->receiveContextSampleMsg33();
    if response is ContextSampleMsg33 {
        test:assertEquals(<SampleMsg33>response.content, {name: "WSO2", id: 1});
    }
}

public client class SayHelloStreamingClientFromReturn {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendSampleMsg33(SampleMsg33 message) returns Error? {

        return self.sClient->send(message);
    }

    isolated remote function sendContextSampleMsg33(ContextSampleMsg33 message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveSampleMsg33() returns SampleMsg33|Error? {
        var response = check self.sClient->receive();
        if (response is ()) {
            return ();
        } else {
            [anydata, map<string|string[]>] [result, headers] = response;
            return <SampleMsg33>result;
        }
    }

    isolated remote function receiveContextSampleMsg33() returns ContextSampleMsg33|Error? {
        var response = check self.sClient->receive();
        if (response is ()) {
            return response;
        } else {
            [anydata, map<string|string[]>] [result, headers] = response;
            return {content: <SampleMsg33>result, headers: headers};
        }

    }

    isolated remote function sendError(Error response) returns Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.sClient->complete();
    }
}

public client class HelloWorld33Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        // initialize client endpoint.
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_33, getDescriptorMap33());
    }

    isolated remote function sayHello() returns (SayHelloStreamingClientFromReturn|Error) {
        StreamingClient sClient = check self.grpcClient->executeClientStreaming("HelloWorld33/sayHello");
        return new SayHelloStreamingClientFromReturn(sClient);
    }
}
