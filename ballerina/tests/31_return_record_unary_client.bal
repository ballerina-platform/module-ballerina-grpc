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

@test:Config {enable:true}
public isolated function testUnaryRecordValueReturn() returns Error? {
    HelloWorld31Client ep = check new ("http://localhost:9121");
    SampleMsg31 reqMsg = {name: "WSO2", id: 8};
    var unionResp = ep->sayHello(reqMsg);
    if (unionResp is Error) {
        test:assertFail(msg = string `Error from Connector: ${unionResp.message()}`);
    } else {
        SampleMsg31 resMsg = unionResp;
        test:assertEquals(resMsg.name, "Ballerina Lang");
        test:assertEquals(resMsg.id, 7);
    }
}

@test:Config {enable:true}
public isolated function testUnaryErrorReturn() returns Error? {
    HelloWorld31Client ep = check new ("http://localhost:9121");
    SampleMsg31 reqMsg = {id: 8};
    var unionResp = ep->sayHello(reqMsg);
    if (unionResp is InvalidArgumentError) {
        test:assertEquals(unionResp.message(), "Name must not be empty.");
    } else {
        test:assertFail("RPC call should return an InvalidArgumentError");
    }
}
