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
isolated function testUnaryWithEmptyValues() returns error? {
    EmptyHandlerClient ep = check new ("http://localhost:9146");
    var res = check ep->unaryWithEmpty();
    test:assertEquals(res, ());
}

@test:Config {enable: true}
function testServerStreamingWithEmptyValues() returns error? {
    EmptyHandlerClient ep = check new ("http://localhost:9146");
    stream<string, Error?> strm = check ep->serverStrWithEmpty();
    int i = 0;
    string[] arr = ["WSO2", "Ballerina", "Microsoft", "Azure"];
    error? e = strm.forEach(function(string s) {
        test:assertEquals(s, arr[i]);
        i += 1;
    });
    test:assertEquals(i, 4);
}

@test:Config {enable: true}
isolated function testClientStreamingWithEmptyValues() returns error? {
    EmptyHandlerClient ep = check new ("http://localhost:9146");
    ClientStrWithEmptyStreamingClient sc = check ep->clientStrWithEmpty();
    string[] arr = ["WSO2", "Ballerina", "Microsoft", "Azure"];
    foreach string s in arr {
        check sc->sendString(s);
    }
    check sc->complete();
    var res = check sc->receive();
    test:assertEquals(res, ());
}

