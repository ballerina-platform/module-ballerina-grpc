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

StructServiceClient structClient = check new ("http://localhost:9157");

map<anydata> expectedStruct = {
    "q": {
        "a": 1250.0,
        "b": "Hey",
        "c": {
            "p": "Hello",
            "q": 1.245,
            "r": false,
            "s": -200.0,
            "t": [125.0, "WSO2", true]
        }
    },
    "r": -242.214,
    "t": false,
    "u": 123473.0,
    "v": true,
    "w": 12.085,
    "x": "Test String",
    "y": 150.0,
    "z": [10.0, "Test String 2", {"a": 12.45, "b": "Hello"}, true, -102.354, [1.0, "Test String 3", ["Test String 4", false, -1249.124]]]
};

map<anydata> sendingStruct = {
    "q": {
        "a": 1250,
        "b": "Hey",
        "c": {
            "p": "Hello",
            "q": 1.245,
            "r": false,
            "s": -200,
            "t": [125, "WSO2", true]
        }
    },
    "r": -242.214,
    "t": false,
    "u": 123473,
    "v": true,
    "w": 12.085,
    "x": "Test String",
    "y": 150,
    "z": [10, "Test String 2", {"a": 12.45, "b": "Hello"}, true, -102.354, [1, "Test String 3", ["Test String 4", false, -1249.124]]]
};

StructMsg expectedStructMsg = {
    name: "StructMsg",
    struct: expectedStruct
};

StructMsg sendingStructMsg = {
    name: "StructMsg",
    struct: sendingStruct
};

@test:Config{}
function testGetStructType1() returns error? {
    map<anydata> res = check structClient->getStructType1("Hello");
    test:assertEquals(res, expectedStruct);
}

@test:Config{}
function testGetStructType2() returns error? {
    StructMsg res = check structClient->getStructType2("Hello");
    test:assertEquals(res, expectedStructMsg);
}

@test:Config{}
function testSendStructType1() returns error? {
    string res = check structClient->sendStructType1(sendingStruct);
    test:assertEquals(res, "OK");
}

@test:Config{}
function testSendStructType2() returns error? {
    string res = check structClient->sendStructType2(sendingStructMsg);
    test:assertEquals(res, "OK");
}

@test:Config{}
function testExchangeStructType1() returns error? {
    map<anydata> res = check structClient->exchangeStructType1(sendingStruct);
    test:assertEquals(res, expectedStruct);
}

@test:Config{}
function testExchangeStructType2() returns error? {
    StructMsg res = check structClient->exchangeStructType2(sendingStructMsg);
    test:assertEquals(res, expectedStructMsg);
}

@test:Config{}
function testServerStreamStructType1() returns error? {
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
        },
        expectedStruct
    ];

    var result = structClient->serverStreamStructType1(expectedStructArr[3]);
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
function testServerStreamStructType2() returns error? {
    StructMsg exStructmsg1 = {
        name: "SM1",
        struct: {
            "key1": "Hello",
            "key2": 25.0,
            "key3": false
        }
    };
    StructMsg exStructmsg2 = {
        name: "SM2",
        struct: {
            "key1": "WSO2",
            "key2": -25.0,
            "key3": [1.0, "Hello"]
        }
    };
    StructMsg exStructmsg3 = {
        name: "SM3",
        struct: {}
    };
    StructMsg[] exStructArr = [
        exStructmsg2,
        exStructmsg3,
        exStructmsg1,
        expectedStructMsg
    ];

    var result = structClient->serverStreamStructType2(exStructmsg1);
    if result is Error {
        test:assertFail(result.message());
    } else {
        int count = 0;
        StructMsg[] receivedData = [];
        error? e = result.forEach(function(StructMsg value) {
            receivedData[count] = <StructMsg>value;
            count += 1;
        });
        test:assertEquals(receivedData, exStructArr);
    }
}

@test:Config{}
function testClientStreamStructType1() returns error? {
    ClientStreamStructType1StreamingClient streamClient = check structClient->clientStreamStructType1();
    map<anydata>[] requests = [
        {
            "key1": "Hello",
            "key2": 25.0,
            "key3": false
        },
        {
            "key1": "WSO2",
            "key2": -25.0,
            "key3": [101.0, "Hello"]
        },
        {},
        {
            "key": [10.0, ["Hello"], false, ["WSO2"]]
        },
        sendingStruct
    ];
    map<anydata> expectedNestedStruct = {
        "0": requests[0],
        "1": requests[1],
        "2": requests[2],
        "3": requests[3],
        "4": expectedStruct
    };
    foreach map<anydata> r in requests {
        check streamClient->sendStruct(r);
    }
    check streamClient->complete();
    var result = check streamClient->receiveStruct();
    test:assertEquals(<map<anydata>>result, expectedNestedStruct);
}

@test:Config{}
function testClientStreamStructType2() returns error? {
    ClientStreamStructType2StreamingClient streamClient = check structClient->clientStreamStructType2();
    StructMsg exStructmsg1 = {
        name: "SM1",
        struct: {
            "key1": "Hello",
            "key2": 25.0,
            "key3": false
        }
    };
    StructMsg exStructmsg2 = {
        name: "SM2",
        struct: {
            "key1": "WSO2",
            "key2": -25.0,
            "key3": [1.0, "Hello"]
        }
    };
    StructMsg exStructmsg3 = {
        name: "SM3",
        struct: {}
    };
    StructMsg[] requests = [
        exStructmsg1,
        exStructmsg2,
        exStructmsg3,
        sendingStructMsg
    ];
    StructMsg expectedNestedStruct = {
        name: "Response",
        struct: {
            "0": exStructmsg1,
            "1": exStructmsg2,
            "2": exStructmsg3,
            "3": expectedStructMsg
        }
    };
    foreach map<anydata> r in requests {
        check streamClient->sendStructMsg(r);
    }
    check streamClient->complete();
    var result = check streamClient->receiveStructMsg();
    test:assertEquals(<StructMsg>result, expectedNestedStruct);
}

@test:Config{}
function testBidirectionalStreamStructType1() returns error? {
    BidirectionalStreamStructType1StreamingClient streamClient = check structClient->bidirectionalStreamStructType1();
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
        },
        expectedStruct
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

@test:Config{}
function testBidirectionalStreamStructType2() returns error? {
    BidirectionalStreamStructType2StreamingClient streamClient = check structClient->bidirectionalStreamStructType2();
    StructMsg exStructmsg1 = {
        name: "SM1",
        struct: {
            "key1": "Hello",
            "key2": 25.0,
            "key3": false
        }
    };
    StructMsg exStructmsg2 = {
        name: "SM2",
        struct: {
            "key1": "WSO2",
            "key2": -25.0,
            "key3": [1.0, "Hello"]
        }
    };
    StructMsg exStructmsg3 = {
        name: "SM3",
        struct: {}
    };
    StructMsg[] requests = [
        exStructmsg1,
        exStructmsg2,
        exStructmsg3,
        expectedStructMsg
    ];
    foreach map<anydata> r in requests {
        check streamClient->sendStructMsg(r);
    }
    check streamClient->complete();

    int count = 0;
    StructMsg[] receivedData = [];
    error? e = requests.forEach(function(StructMsg value) {
        StructMsg|error? result = streamClient->receiveStructMsg();
        if result is StructMsg {
            receivedData[count] = result;
        } else {
            test:assertFail("Error");
        }
        count += 1;
    });
    test:assertEquals(receivedData, requests);
}
