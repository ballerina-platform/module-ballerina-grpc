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

@test:Config {enable: true}
public isolated function testBidiStreamingWithCustomError() returns Error? {
    ChatWithCallerClient chatClient = check new ("http://localhost:9140");
    CallStreamingClient streamingCaller = check chatClient->call();
    check streamingCaller->sendChatMessage40({
        name: "John",
        message: "Hello Lisa"
    });
    string|Error? content = streamingCaller->receiveString();
    if content is string || content is () {
        test:assertFail(msg = "Expected grpc:Error not found.");
    } else {
        test:assertEquals(content.message(), "Unknown gRPC error occured.");
    }
}
