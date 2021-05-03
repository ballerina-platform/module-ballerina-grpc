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

final HelloWorld98Client helloWorld5BlockingEp = check new ("http://localhost:9095");

@test:Config {enable:true}
function testInvalidRemoteMethod() {
    string name = "WSO2";
    string|Error unionResp = helloWorld5BlockingEp->hello(name);
    if (unionResp is Error) {
        test:assertEquals(unionResp.message(), "No registered method descriptor for " +
                                                               "'grpcservices.HelloWorld98/hello1'");
    } else {
        io:println("Client Got Response : ");
        io:println(unionResp);
        test:assertFail("Client got response: " + unionResp);
    }
}

@test:Config {enable:true}
function testInvalidInputParameter() {
    string age = "";
    int|Error unionResp = helloWorld5BlockingEp->testInt(age);
    if (unionResp is Error) {
        test:assertFail(string `Error from Connector: ${unionResp.message()}`);
    } else {
        io:println("Client got response : ");
        test:assertEquals(unionResp, -1);
    }
}
