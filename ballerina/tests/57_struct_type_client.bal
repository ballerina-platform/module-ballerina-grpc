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
import ballerina/io;

StructServiceClient structClient = check new ("http://localhost:9157");

 @test:Config{}
 function testGetStruct() returns error? {
     map<anydata> res = check structClient->getStruct("Hello");
     map<anydata> expected = {
         "r": -242.214,
         "t": false,
         "u": 123473623.0,
         "v": true,
         "w": 12.085,
         "x": "Test String",
         "y": 150.0,
         "z": [10.0, "Test String 2", true, -102.354, [1.0, "Test String 3", ["Test String 4", false, -1249.124]]]
     };
     test:assertEquals(res, expected);
 }

 @test:Config{}
 function testSendStruct() returns error? {
     map<anydata> sending = {
         "r": -242.214,
         "t": false,
         "u": 123473623,
         "v": true,
         "w": 12.085,
         "x": "Test String",
         "y": 150,
         "z": [10, "Test String 2", true, -102.354, [1, "Test String 3", ["Test String 4", false, -1249.124]]]
     };
     string res = check structClient->sendStruct(sending);
     test:assertEquals(res, "OK");
 }

 @test:Config{}
 function testExchangeStruct() returns error? {
     map<anydata> sending = {
         "r": -242.214,
         "t": false,
         "u": 123473623,
         "v": true,
         "w": 12.085,
         "x": "Test String",
         "y": 150,
         "z": [10, "Test String 2", true, -102.354, [1, "Test String 3", ["Test String 4", false, -1249.124]]]
     };
     map<anydata> expected = {
         "r": -242.214,
         "t": false,
         "u": 123473623.0,
         "v": true,
         "w": 12.085,
         "x": "Test String",
         "y": 150.0,
         "z": [10.0, "Test String 2", true, -102.354, [1.0, "Test String 3", ["Test String 4", false, -1249.124]]]
     };
     map<anydata> res = check structClient->exchangeStruct(sending);
     test:assertEquals(res, expected);
 }

@test:Config{}
function testServerStreamStruct() returns error? {
    map<anydata>[] expectedStructArr = [
        {
            "key1": "Hello",
            "key2": 25.0,
            "key3": false
        },
        {
            "key1": "WSO2",
            "key2": -25.0,
            "key3": [1.0, "Hello"]
        },
        {},
        {
            "key": [1.0, ["Hello"], false, ["WSO2"]]
        }
    ];
    
    var result = structClient->serverStreamStruct(expectedStructArr[3]);
    if result is Error {
        test:assertFail(result.message());
    } else {
        int count = 0;
        map<anydata>[] receivedData = [];
        error? e = result.forEach(function(map<anydata> value) {
            receivedData[count] = <map<anydata>>value;
            count += 1;
        });
        test:assertEquals(receivedData, expectedStructArr);
    }
}

@test:Config{}
function testClientStreamStruct() returns error? {
    ClientStreamStructStreamingClient streamClient = check structClient->clientStreamStruct();
    map<anydata>[] requests = [
        {
            "key1": "Hello",
            "key2": 25.0,
            "key3": false
        },
        {
            "key1": "WSO2",
            "key2": -25.0,
            "key3": [1.0, "Hello"]
        },
        {},
        {
            "key": [1.0, ["Hello"], false, ["WSO2"]]
        }
    ];
    foreach map<anydata> r in requests {
        check streamClient->sendStruct(r);
    }
    check streamClient->complete();
    var result = check streamClient->receiveStruct();
    test:assertEquals(<map<anydata>>result, requests[0]);
}

 @test:Config{}
 function testBidirectionalStreamStruct() returns error? {
     BidirectionalStreamStructStreamingClient streamClient = check structClient->bidirectionalStreamStruct();
     map<anydata>[] requests = [
         {
             "key1": "Hello",
             "key2": 25.0,
             "key3": false
         },
         {
             "key1": "WSO2",
             "key2": -25.0,
             "key3": [1.0, "Hello"]
         },
         {},
         {
             "key": [1.0, ["Hello"], false, ["WSO2"]]
         }
     ];
     foreach map<anydata> r in requests {
         check streamClient->sendStruct(r);
     }
     check streamClient->complete();

     int count = 0;
     map<anydata>[] receivedData = [];
     error? e = requests.forEach(function(map<anydata> value) {
         map<anydata>|error? result = streamClient->receiveStruct();
         if result is map<anydata> {
             receivedData[count] = result;
         } else {
             test:assertFail("Error");
         }
         count += 1;
     });
     test:assertEquals(receivedData, requests);
 }
