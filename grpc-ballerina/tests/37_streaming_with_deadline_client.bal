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

import ballerina/test;
import ballerina/time;
import ballerina/io;

@test:Config {enable:true}
isolated function testBidiStreamingFromReturnRecordWithDeadline() returns error? {
    HelloWorld37Client helloWorldCaller = check new ("http://localhost:9127");
    time:Utc current = time:utcNow();
    time:Utc deadline = time:utcAddSeconds(current, 300);
    map<string|string[]> headers = setDeadline(deadline);

    CallWithDeadlineStreamingClient streamingClient;
    var res = helloWorldCaller->callWithDeadline();
    if (res is Error) {
        test:assertFail("Error from Connector: " + res.message());
        return;
    } else {
        streamingClient = res;
    }
    io:println("Initialized connection sucessfully.");
    string[] requests = [
        "WSO2",
        "Microsoft",
        "Facebook",
        "Google"
    ];
    foreach string s in requests {
        Error? err = streamingClient->sendContextString({content: s, headers: headers});
        if (err is Error) {
            test:assertFail("Error from Connector: " + err.message());
        }
    }
    check streamingClient->complete();
    io:println("Completed successfully");
    var result = streamingClient->receiveString();
    int i = 0;
    while !(result is ()) {
        if (result is string) {
            test:assertEquals(result, requests[i]);
        } else {
            test:assertFail("Unexpected output in the stream");
        }
        result = streamingClient->receiveString();
        i += 1;
    }
    test:assertEquals(i, 4);
}

public client class HelloWorld37Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        // initialize client endpoint.
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_37, getDescriptorMap37());
    }

    isolated remote function callWithDeadline() returns (CallWithDeadlineStreamingClient|Error) {
        StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("HelloWorld37/callWithDeadline");
        return new CallWithDeadlineStreamingClient(sClient);
    }
}


public client class CallWithDeadlineStreamingClient {
    private StreamingClient sClient;

    isolated function init(StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendString(string message) returns Error? {
        
        return self.sClient->send(message);
    }

    isolated remote function sendContextString(ContextString message) returns Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveString() returns string|Error? {
        var response = check self.sClient->receive();
        if (response is ()) {
            return ();
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

