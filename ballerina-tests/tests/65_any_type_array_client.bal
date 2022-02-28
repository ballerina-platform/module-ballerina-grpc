// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/protobuf.types.'any;

@test:Config {enable: true}
function testAnyTypedArrayPassing() returns error? {
    AnyTypeArrayClient anyClient = check new ("http://localhost:9165");
    AnyTypeArrayMsg msg = {name: "Ballerina", code: 71};
    'any:Any[] requestDetails = [
        'any:pack("Hello Ballerina"),
        'any:pack(71),
        'any:pack(msg)
    ];
    AnyTypeArrayRequest request = {name: "WSO2", details: requestDetails};
    AnyTypeArrayResponse response = check anyClient->unaryCall1(request);
    'any:Any[] responseDetails = response.details;

    string response0 = check 'any:unpack(responseDetails[0], string);
    test:assertEquals(response0, "Hello Ballerina");

    int response1 = check 'any:unpack(responseDetails[1], int);
    test:assertEquals(response1, 71);

    AnyTypeArrayMsg response2 = check 'any:unpack(responseDetails[2], AnyTypeArrayMsg);
    test:assertEquals(response2, msg);
}
