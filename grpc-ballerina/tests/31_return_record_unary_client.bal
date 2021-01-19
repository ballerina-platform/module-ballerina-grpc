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
public function testUnaryRecordValueReturn() {
    HelloWorld31Client ep = new ("http://localhost:9121");
    SampleMsg31 reqMsg = {name: "WSO2", id: 8};
    var unionResp = ep->sayHello(reqMsg);
    if (unionResp is Error) {
        test:assertFail(msg = io:sprintf(ERROR_MSG_FORMAT, unionResp.message()));
    } else {
        io:println(unionResp);
    }
}


public client class HelloWorld31Client {
    *AbstractClientEndpoint;
    private Client grpcClient;

    public isolated function init(string url, ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = checkpanic new(url, config);
        checkpanic self.grpcClient.initStub(self, ROOT_DESCRIPTOR_31, getDescriptorMap31());
    }

    isolated remote function sayHello(SampleMsg31|ContextSampleMsg31 req) returns (ContextSampleMsg31|Error) {
        map<string|string[]> headers = {};
        SampleMsg31 message;
        if (req is ContextSampleMsg31) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("HelloWorld31/sayHello", message, headers);
        [anydata, map<string|string[]>][result, respHeaders] = payload;
        return {content: <SampleMsg31>result, headers: respHeaders};
    }

}




