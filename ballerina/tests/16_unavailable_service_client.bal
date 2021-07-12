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

@test:Config {enable:false}
isolated function testInvokeUnavailableService() returns Error? {
    HelloWorld16Client helloWorld16BlockingEp = check new ("http://localhost:9106");
    string name = "WSO2";
    string|Error unionResp16 = helloWorld16BlockingEp->hello(name);
    if (unionResp16 is Error) {
        test:assertTrue(unionResp16.message().startsWith("Connection refused:"), msg = "Failed with error: " +
        unionResp16.message());
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp16);
        test:assertFail(unionResp16);
    }
}
