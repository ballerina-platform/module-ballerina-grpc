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
import integration_tests.api;

@test:Config {}
function testServiceInputParamFromAnotherModuleUnary() returns error? {

    api:SeparateModuleServiceClient ep = check new ("http://localhost:9095");
    api:ContextSMReq reqContext = {
        content: {name: "John", id: 11},
        headers: {h1: "H1"}
    };
    api:ContextSMRes res = check ep->unaryContext(reqContext);
    test:assertEquals(res.content, {name: "Anne", id: 12});
    test:assertEquals(res.headers["h1"], "H1");

}

@test:Config {}
function testServiceInputParamFromAnotherModuleServerStreaming() returns error? {

    api:SeparateModuleServiceClient ep = check new ("http://localhost:9095");
    api:ContextSMReq reqContext = {
        content: {name: "John", id: 11},
        headers: {h1: "H1"}
    };
    api:SMRes[] expectedResponses = [
        {name: "Anne", id: 12}, 
        {name: "Nick", id: 13}, 
        {name: "Holand", id: 14}
    ];
    api:ContextSMResStream responses = check ep->serverStreamingContext(reqContext);
    int i = 0;
    error? e = responses.content.forEach(function(api:SMRes m) {
        test:assertEquals(m, expectedResponses[i]);
        i += 1;
    });
    test:assertEquals(i, 3);
    test:assertEquals(responses.headers["h1"], "H1");

}

@test:Config {}
function testServiceInputParamFromAnotherModuleClientStreaming() returns error? {

    api:SeparateModuleServiceClient ep = check new ("http://localhost:9095");
    api:SMReq[] requests = [
        {name: "Anne", id: 12}, 
        {name: "Nick", id: 13}, 
        {name: "Holand", id: 14}
    ];
    api:SMRes[] responses = [
        {name: "Anne", id: 12}, 
        {name: "Nick", id: 13}, 
        {name: "Holand", id: 14}
    ];
    api:ClientStreamingStreamingClient sc = check ep->clientStreaming();
    foreach api:SMReq req in requests {
        check sc->sendSMReq(req);
    }
    check sc->complete();
    int i = 0;
    api:SMRes? response = check sc->receiveSMRes();
    if response is api:SMRes {
        test:assertEquals(response, {name: "Anne", id: 12});
    } else {
        test:assertFail(msg = "Unexpected empty response");
    }
}

@test:Config {}
function testServiceInputParamFromAnotherModuleBidirectional1() returns error? {

    api:SeparateModuleServiceClient ep = check new ("http://localhost:9095");
    api:SMReq[] requests = [
        {name: "Anne", id: 12}, 
        {name: "Nick", id: 13}, 
        {name: "Holand", id: 14}
    ];
    api:SMRes[] responses = [
        {name: "Anne", id: 12}, 
        {name: "Nick", id: 13}, 
        {name: "Holand", id: 14}
    ];
    api:Bidirectional1StreamingClient sc = check ep->bidirectional1();
    foreach api:SMReq req in requests {
        check sc->sendSMReq(req);
    }
    check sc->complete();
    int i = 0;
    api:SMRes? response = check sc->receiveSMRes();
    if response is api:SMRes {
        test:assertEquals(response, responses[i]);
        i += 1;
    }
    while !(response is ()) {
        response = check sc->receiveSMRes();
        if response is api:SMRes {
            test:assertEquals(response, responses[i]);
            i += 1;
        }
    }
    test:assertEquals(i, 3);
}

@test:Config {}
function testServiceInputParamFromAnotherModuleBidirectional2() returns error? {

    api:SeparateModuleServiceClient ep = check new ("http://localhost:9095");
    api:SMReq[] requests = [
        {name: "Anne", id: 12}, 
        {name: "Nick", id: 13}, 
        {name: "Holand", id: 14}
    ];
    api:SMRes[] responses = [
        {name: "Anne", id: 12}, 
        {name: "Nick", id: 13}, 
        {name: "Holand", id: 14}
    ];
    api:Bidirectional2StreamingClient sc = check ep->bidirectional2();
    foreach api:SMReq req in requests {
        check sc->sendSMReq(req);
    }
    check sc->complete();
    int i = 0;
    api:SMRes? response = check sc->receiveSMRes();
    if response is api:SMRes {
        test:assertEquals(response, responses[i]);
        i += 1;
    }
    while !(response is ()) {
        response = check sc->receiveSMRes();
        if response is api:SMRes {
            test:assertEquals(response, responses[i]);
            i += 1;
        }
    }
    test:assertEquals(i, 3);
}
