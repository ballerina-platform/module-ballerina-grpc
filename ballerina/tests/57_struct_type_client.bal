import ballerina/test;
import ballerina/io;

StructServiceClient structClient = check new ("http://localhost:9157");

 @test:Config{}
 function testGetStruct() returns error? {
    map<anydata> res = check structClient->getStruct("yo");
    map<anydata> expected = {
        "t": false,
        "u": 123473623,
        "v": true,
        "w": 12.085,
        "x": "first",
        "y": 150
        // "z": [1,2,3]
    };
    test:assertEquals(res, expected);
 }

@test:Config{}
function testSendStruct() returns error? {
    map<anydata> sending = {
        "t": false,
        "u": 123473623,
        "v": true,
        "w": 12.085,
        "x": "first",
        "y": 150
        // "z": [1,2,3]
    };
    string res = check structClient->sendStruct(sending);
    test:assertEquals(res, "OK");
    io:println(res);
}

@test:Config{}
function testExchangeStruct() returns error? {
    map<anydata> sending = {
        "t": false,
        "u": 123473623,
        "v": true,
        "w": 12.085,
        "x": "first",
        "y": 150
        // "z": [1,2,3]
    };
    map<anydata> expected = {
        "a": true,
        "b": -15245,
        "c": false,
        "d": -12.085,
        "e": "second",
        "f": -150
        // "z": [1,2,3]
    };
    map<anydata> res = check structClient->exchangeStruct(sending);
    test:assertEquals(res, expected);
    io:println(res);
}
