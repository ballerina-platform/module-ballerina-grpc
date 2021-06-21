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
function testUnaryWithHeadersContext() returns error? {
    HeadersServiceClient ep = check new ("http://localhost:9145");
    HSReq reqMsg = {name: "Ann", message: "Hey"};
    map<string|string[]> headers = {"unary-req-header": ["1234567890", "2233445677"]};

    ContextHSRes res = check ep->unaryContext({content: reqMsg, headers: headers});
    test:assertEquals(res.content, reqMsg);
    test:assertEquals(res.headers["unary-res-header"], ["abcde", "fgh"]);
}

@test:Config {enable: true}
function testServerStreamingWithHeadersContext() returns error? {
    HeadersServiceClient ep = check new ("http://localhost:9145");
    HSReq reqMsg = {name: "Ann", message: "Hey"};
    map<string|string[]> headers = {"server-steaming-req-header": ["1234567890", "2233445677"]};

    ContextHSResStream res = check ep->serverStrContext({content: reqMsg, headers: headers});
    test:assertEquals(res.headers["server-steaming-res-header"], ["1234567890","2233445677"]);

}

@test:Config {enable: true}
function testClientStreamingWithContextHeaders() returns error? {
    HeadersServiceClient ep = check new ("http://localhost:9145");
    ClientStrStreamingClient streamingClient = check ep->clientStr();

    HSRes[] responses = [
        {name: "Ann", message: "Hey"}
    ];
    int i = 0;
    map<string|string[]> headers = {"client-steaming-req-header": ["1234567890", "2233445677"]};
    foreach HSRes res in responses {
        if i == 0 {
            check streamingClient->sendContextHSReq({content: res, headers: headers});
        } else {
            check streamingClient->sendHSReq(res);
        }
        i += 1;
    }
    check streamingClient->complete();
    ContextHSRes? res = check streamingClient->receiveContextHSRes();
    if res is ContextHSRes {
        test:assertEquals(res.content, {name: "Ann", message: "Hey"});
        test:assertEquals(res.headers["client-steaming-res-header"], ["1234567890","2233445677"]);
    } else {
        test:assertFail(msg = "Expected output not found");
    }
}

@test:Config {enable: true}
function testBidirectionalStreamingWithContextHeaders() returns error? {
    HeadersServiceClient ep = check new ("http://localhost:9145");
    BidirectionalStrStreamingClient streamingClient = check ep->bidirectionalStr();

    HSRes[] responses = [
        {name: "Ann", message: "Hey"}
    ];
    int i = 0;
    map<string|string[]> headers = {"bidi-steaming-req-header": ["1234567890", "2233445677"]};
    foreach HSRes res in responses {
        if i == 0 {
            check streamingClient->sendContextHSReq({content: res, headers: headers});
        } else {
            check streamingClient->sendHSReq(res);
        }
        i += 1;
    }
    check streamingClient->complete();
    ContextHSRes? res = check streamingClient->receiveContextHSRes();
    if res is ContextHSRes {
        test:assertEquals(res.content, {name: "Ann", message: "Hey"});
        test:assertEquals(res.headers["bidi-steaming-res-header"], ["1234567890","2233445677"]);
    } else {
        test:assertFail(msg = "Expected output not found");
    }
}
