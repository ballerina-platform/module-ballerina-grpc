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

@test:Config {enable:true}
function testCallWithingDeadline() {
    HelloWorld35Client helloWorldClient = checkpanic new ("http://localhost:9125");
    time:Duration duration = {
        minutes: 5
    };
    time:Time deadline = checkpanic time:addDuration(time:currentTime(), duration);
    map<string|string[]> headers = checkpanic setDeadline(deadline);
    var context = helloWorldClient->callWithingDeadlineContext({content: "WSO2", headers: headers});
    if (context is ContextString) {
        test:assertEquals(context.content, "Ack");
    } else {
        test:assertFail(context.message());
    }
}

@test:Config {enable:true}
function testCallExceededDeadline() {
    HelloWorld35Client helloWorldClient = checkpanic new ("http://localhost:9125");
    time:Duration duration = {
        minutes: 5
    };
    time:Time deadline = checkpanic time:subtractDuration(time:currentTime(), duration);
    map<string|string[]> headers = checkpanic setDeadline(deadline);
    var context = helloWorldClient->callExceededDeadlineContext({content: "WSO2", headers: headers});
    if (context is DeadlineExceededError) {
        test:assertEquals(context.message(), "Exceeded the configured deadline");
    } else {
        test:assertFail("Expected DeadlineExceededError not found");
    }
}

public client class HelloWorld35Client {

    *AbstractClientEndpoint;

    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) returns Error? {
        // initialize client endpoint.
        self.grpcClient = check new(url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_35, getDescriptorMap35());
    }

    isolated remote function callWithingDeadline(string|ContextString req) returns (string|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld35/callWithingDeadline", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function callWithingDeadlineContext(string|ContextString req) returns (ContextString|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld35/callWithingDeadline", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

    isolated remote function callExceededDeadline(string|ContextString req) returns (string|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld35/callExceededDeadline", message, headers);
        [anydata, map<string|string[]>][result, _] = payload;
        return result.toString();
    }
    isolated remote function callExceededDeadlineContext(string|ContextString req) returns (ContextString|Error) {
        
        map<string|string[]> headers = {};
        string message;
        if (req is ContextString) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld35/callExceededDeadline", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: result.toString(), headers: respHeaders};
    }

}

